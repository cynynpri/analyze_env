FROM nvidia/cuda:11.7.1-cudnn8-devel-ubuntu22.04

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

# add gcc.
WORKDIR /usr/local/src
RUN curl -sSO http://ftp.tsukuba.wide.ad.jp/software/gcc/releases/gcc-11.1.0/gcc-11.1.0.tar.gz && \
    tar -zxf /usr/local/src/gcc-11.1.0.tar.gz && \
    mkdir /usr/local/src/gcc-11.1.0/build
WORKDIR /usr/local/src/gcc-11.1.0/build
RUN ../configure --prefix=/usr/local/gcc-11.1.0 --with-gmp --enable-languages=c,c++ --disable-multilib --program-suffix=-11.1 && \
    make -j$(nproc) && \
    make install

# clean dirs.
RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/* \
    /var/cache/apt/*

# add pyenv.
RUN mkdir /home/pyenv && \
    useradd -d /home/pyenv pyenv
WORKDIR /home/pyenv
ENV HOME /home/pyenv
RUN chown pyenv:pyenv -R /home/pyenv
USER pyenv

# add pyenv user.
RUN git clone --depth=1 https://github.com/pyenv/pyenv.git /home/pyenv/.pyenv
ENV PYENV_ROOT /home/pyenv/.pyenv
ENV PATH ${PYENV_ROOT}/bin:${PATH}

RUN echo 'eval "$(pyenv init -)"' >> /home/pyenv/.bashrc
