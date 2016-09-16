How to build the image
======================
.. code-block:: shell

    git clone https://github.com/Kitware/ParaView .
    docker build -t paraview . 2>&1 | tee _log_build

Run
===
This runs ParaView directly::

    docker run -ti -e DISPLAY=unix$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix paraview

You can also mount your ``HOME`` directory into the docker::

    docker run -ti -e DISPLAY=unix$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix -v $HOME:/home/developer paraview
