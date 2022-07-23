FROM nvidia/cuda:11.0.3-devel-ubuntu20.04

EXPOSE 8888

# initialize
USER root

RUN perl -p -i.bak -e 's%(deb(?:-src|)\s+)https?://(?!archive\.canonical\.com|security\.ubuntu\.com)[^\s]+%$1http://ftp.jaist.ac.jp/pub/Linux/ubuntu/%' /etc/apt/sources.list 

ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=Asia/Tokyo
RUN apt-get update
RUN apt-get upgrade -qy
RUN apt-get autoremove -qy

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
    gcc \
    g++ \
    make \
    bison \
    binutils \
    gcc-multilib \
    tar \
    libmpc-dev \
    pandoc \
    wget

# install R
RUN apt-get install -qy --no-install-recommends \
    software-properties-common \
    dirmngr

RUN wget -qO- https://cloud.r-project.org/bin/linux/ubuntu/marutter_pubkey.asc | tee -a /etc/apt/trusted.gpg.d/cran_ubuntu_key.asc
RUN add-apt-repository "deb https://cloud.r-project.org/bin/linux/ubuntu $(lsb_release -cs)-cran40/"
RUN apt install -qy --no-install-recommends r-base

# add gcc.
WORKDIR /tmp
RUN curl -sSO http://ftp.tsukuba.wide.ad.jp/software/gcc/releases/gcc-11.1.0/gcc-11.1.0.tar.gz
RUN tar -zxvf /tmp/gcc-11.1.0.tar.gz
RUN mkdir /tmp/gcc-11.1.0/build
WORKDIR /tmp/gcc-11.1.0/build
RUN ../configure --prefix=/usr/local/gcc-11.1.0 --with-gmp --enable-languages=c,c++ --disable-multilib --program-suffix=-11.1
RUN make -j16
RUN make install

# clean dirs.
RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/* \
    /var/cache/apt/*

# add pyenv.
RUN mkdir /home/pyenv
RUN useradd -d /home/pyenv pyenv
WORKDIR /home/pyenv
ENV HOME /home/pyenv
RUN chown pyenv:pyenv -R /home/pyenv
USER pyenv

# add pyenv user.
RUN git clone --depth=1 https://github.com/pyenv/pyenv.git /home/pyenv/.pyenv
ENV PYENV_ROOT /home/pyenv/.pyenv
ENV PATH ${PYENV_ROOT}/bin:${PATH}

RUN echo 'eval "$(pyenv init -)"' >> /home/pyenv/.bashrc
