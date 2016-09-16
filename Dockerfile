FROM ubuntu:14.04

RUN apt-get update && apt-get install -y wget binutils-dev gcc g++ make

RUN cd $HOME && \
    wget http://www.cmake.org/files/v2.8/cmake-2.8.8.tar.gz && \
    tar xvfz cmake-2.8.8.tar.gz && \
    cd cmake-2.8.8 && \
    ./configure --prefix=$HOME/software && \
    make && \
    make install

RUN apt-get install -y git

ADD . /ParaView-src

RUN cd /ParaView-src && \
    git submodule init && \
    git submodule update

RUN mkdir -p /ParaView-bin && \
    cd /ParaView-bin

RUN apt-get install -y libphonon-dev libphonon4 qt4-dev-tools libqt4-core libqt4-gui qt4-qmake libxt-dev g++ gcc cmake-curses-gui libqt4-opengl-dev mesa-common-dev python-dev

RUN apt-get install -y openmpi-bin openmpi-doc libopenmpi-dev

RUN cd /ParaView-bin && \
    $HOME/software/bin/cmake -DBUILD_TESTING=Off -DBUILD_SHARED_LIBS=On -DPARAVIEW_USE_MPI=On -DPARAVIEW_ENABLE_PYTHON=On \
                             -DPYTHON_EXECUTABLE=/usr/bin/python -DPYTHON_LIBRARY=/usr/lib/x86_64-linux-gnu/libpython2.7.so -DPYTHON_INCLUDE_DIR=/usr/include/python2.7/ \
                             /ParaView-src

RUN cd /ParaView-bin && \
    make && make install

RUN cd /ParaView-bin && \
    make && make install

# Replace 1000 with your user / group id
RUN export uid=1000 gid=1000 && \
     mkdir -p /home/developer && \
     echo "developer:x:${uid}:${gid}:Developer,,,:/home/developer:/bin/bash" >> /etc/passwd && \
     echo "developer:x:${uid}:" >> /etc/group && \
     echo "developer ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/developer && \
     chmod 0440 /etc/sudoers.d/developer && \
     chown ${uid}:${gid} -R /home/developer

USER developer
ENV HOME /home/developer
CMD /ParaView-bin/bin/paraview

