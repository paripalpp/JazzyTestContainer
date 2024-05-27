FROM docker.io/osrf/ros:jazzy-desktop-full

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    git bash-completion curl build-essential \
    libpython3-dev python3-vcstool python3-pip \
    git nano iputils-ping net-tools dnsutils wget \
    python3-colcon-common-extensions python3-rosdep \
    python3-bloom fakeroot dh-make \
    usbutils \
    can-utils udev libudev-dev libserial-dev \
    libboost-all-dev libwebsocketpp-dev \
    ros-jazzy-tf-transformations  ros-jazzy-image-tools \
    ros-jazzy-filters ros-jazzy-rqt-tf-tree \
    && rm -rf /var/lib/apt/lists/*

RUN curl -fsSL https://code-server.dev/install.sh | sh

RUN pip3 install -U --break-system-packages \
    transforms3d pandas

# install raylib
RUN git clone https://github.com/raysan5/raylib.git raylib \
    && cd raylib && mkdir build && cd build \
    && cmake .. && make && sudo make install

RUN echo ". /opt/ros/jazzy/setup.bash" >> /etc/bash.bashrc
RUN echo ". /ros_ws/install/setup.bash" >> /etc/bash.bashrc
