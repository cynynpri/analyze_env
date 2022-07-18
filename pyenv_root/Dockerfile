FROM nvidia/cuda:11.0.3-base-ubuntu20.04

EXPOSE 8888

# initialize
USER root

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
    git

# install R
RUN apt-get install -qy wget
RUN apt-get install -qy --no-install-recommends \
    software-properties-common dirmngr

RUN wget -qO- https://cloud.r-project.org/bin/linux/ubuntu/marutter_pubkey.asc | tee -a /etc/apt/trusted.gpg.d/cran_ubuntu_key.asc
RUN add-apt-repository "deb https://cloud.r-project.org/bin/linux/ubuntu $(lsb_release -cs)-cran40/"
RUN apt install -qy --no-install-recommends r-base

# clean dirs.
RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/* \
    /var/cache/apt/* \
    /tmp/*

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

