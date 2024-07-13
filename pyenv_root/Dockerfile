FROM nvidia/cuda:12.4.1-cudnn-devel-ubuntu22.04

EXPOSE 8888

# initialize
USER root

ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=Asia/Tokyo
RUN perl -p -i.bak -e 's%(deb(?:-src|)\s+)https?://(?!archive\.canonical\.com|security\.ubuntu\.com)[^\s]+%$1http://ftp.jaist.ac.jp/pub/Linux/ubuntu/%' /etc/apt/sources.list && \
    apt-get update && \
    apt-get upgrade -qy && \
    apt-get autoremove -qy

# add settings pyenv exec env
RUN apt-get install -qy \
    build-essential \
    cmake \
    libssl-dev \
    zlib1g-dev \
    libbz2-dev \
    libreadline-dev \
    libsqlite3-dev \
    libharfbuzz-dev \
    libfribidi-dev \
    libudunits2-dev \
    libgdal-dev \
    curl \
    llvm \
    libncursesw5-dev \
    tk-dev \
    libxml2-dev \
    libxmlsec1-dev \
    libffi-dev \
    liblzma-dev \
    libopencv-dev \
    nodejs \
    git \
    cmake \
    ocl-icd-opencl-dev \
    libboost-dev \
    libboost-system-dev \
    libboost-filesystem-dev \
    libboost-all-dev \
    clinfo \
    opencl-headers \
    gcc \
    g++ \
    make \
    bison \
    binutils \
    gcc-multilib \
    tar \
    libmpc-dev \
    pandoc \
    wget \
    libxml2-dev \
    libssl-dev \
    libcurl4-openssl-dev \
    libv8-dev \
    ffmpeg \
    libasound2-dev \
    libjack-dev \
    portaudio19-dev \
    graphviz

# install R
RUN apt-get install -qy --no-install-recommends \
    software-properties-common \
    dirmngr && \
    wget -qO- https://cloud.r-project.org/bin/linux/ubuntu/marutter_pubkey.asc | tee -a /etc/apt/trusted.gpg.d/cran_ubuntu_key.asc && \
    add-apt-repository "deb https://cloud.r-project.org/bin/linux/ubuntu $(lsb_release -cs)-cran40/" && \
    apt-get install -qy --no-install-recommends r-base r-base-dev

# clean dirs.
RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/* \
    /var/cache/apt/*

# add pyenv.
RUN mkdir /home/pyenv && useradd -d /home/pyenv pyenv
WORKDIR /home/pyenv
ENV HOME /home/pyenv
RUN chown pyenv:pyenv -R /home/pyenv
USER pyenv

# add pyenv user.
RUN git clone --depth=1 https://github.com/pyenv/pyenv.git /home/pyenv/.pyenv && \
    echo 'eval "$(pyenv init -)"' >> /home/pyenv/.bashrc
ENV PYENV_ROOT /home/pyenv/.pyenv
ENV PATH ${PYENV_ROOT}/bin:${PATH}
