FROM amd64/fedora:33
RUN useradd -ms /bin/bash shadow
RUN echo "shadow ALL=(ALL) shadow: ALL" >> /etc/sudoers

RUN dnf install -y \
    wget tar make automake gcc gcc-c++ kernel-devel \
    cmake \
    gcc \
    gcc-c++ \
    glib2 \
    glib2-devel \
    igraph \
    igraph-devel \
    make \
    python3 \
    python3-pyelftools \
    xz \
    xz-devel \
    yum-utils \ 
    debuginfo-install glibc \
    python3-numpy \
    python3-lxml \
    python3-matplotlib \
    python3-networkx \
    python3-scipy \
    dstat \
    git \
    htop \
    screen \
    cmake glib2 glib2-devel igraph igraph-devel
RUN ln -s /usr/bin/python3 /usr/bin/python
WORKDIR /home/shadow
RUN wget https://github.com/shadow/shadow/archive/v1.14.0.tar.gz
RUN tar -xvf v1.14.0.tar.gz shadow-1.14.0  && mv shadow-1.14.0 shadow
WORKDIR /home/shadow/shadow
RUN chmod -R 775 . && chown -R shadow:shadow .
USER shadow
# temporary fix for fedora 32
RUN sed -i s/struct\ timezone/void/ src/preload/shd-preload-defs.h
RUN ./setup build --clean --test
RUN ./setup install
RUN echo 'export PATH="${PATH}:/home/shadow/.shadow/bin"' >> /home/shadow/.bashrc && source /home/shadow/.bashrc
USER root

WORKDIR /home/shadow
RUN wget https://github.com/shadow/tgen/archive/v1.0.0.tar.gz
RUN tar -xf v1.0.0.tar.gz
WORKDIR /home/shadow/tgen-1.0.0
RUN mkdir build && cd build && \
cmake .. -DCMAKE_INSTALL_PREFIX=/home/shadow/.shadow && \
make && make install
RUN chmod -R 775 . && chown -R shadow:shadow .

WORKDIR /home/shadow/shadow/resource/examples
