FROM pyenv_root

#RUN pyenv install anaconda3-2022.05
RUN pyenv install 3.9.12
RUN mkdir /home/pyenv/env_root
WORKDIR /home/pyenv/env_root
RUN pyenv local 3.9.12

# no conda then.
RUN /home/pyenv/.pyenv/versions/3.9.12/bin/python -m pip install --upgrade pip && rm -rf ${HOME}/.cache/pip
# when you install all package from `requirements.txt` then, this comments in.
#COPY requirements.txt /home/pyenv/requirements.txt
#RUN /home/pyenv/.pyenv/versions/3.9.12/bin/python -m pip install -r /home/pyenv/requirements.txt
RUN /home/pyenv/.pyenv/versions/3.9.12/bin/python -m pip install opencv-python \
    matplotlib \
    pandas \
    scikit-learn \
    umap-learn \
    torch \
    python-lsp-server \
    torchvision \
    torchtext \
    torchaudio --extra-index-url https://download.pytorch.org/whl/cu113

RUN /home/pyenv/.pyenv/versions/3.9.12/bin/python -m pip install jupyterlab
RUN /home/pyenv/.pyenv/versions/3.9.12/bin/python -m pip install 'jupyterlab>=3.0.0,<4.0.0a0' jupyterlab-lsp
RUN /home/pyenv/.pyenv/versions/3.9.12/bin/python -m pip install jupyterlab_code_formatter \
    jupyterlab-git \
    jupyterlab_widgets && \
    rm -rf ${HOME}/.cache/pip

USER root
RUN R -e 'install.packages("languageserver")'
RUN R -e 'install.packages("data.table")'
RUN R -e 'install.packages("tidyverse")'
USER pyenv

RUN mkdir /home/pyenv/work
COPY launch.sh /home/pyenv/work/launch.sh
WORKDIR /home/pyenv/work
RUN pyenv local 3.9.12

USER root
RUN chmod 777 /home/pyenv/work/launch.sh
RUN chown pyenv:pyenv /home/pyenv/work/launch.sh
USER pyenv

# install gcc and lightgbm
USER root
RUN apt-get update && apt-get install -qy cmake \
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
    pandoc
WORKDIR /tmp
RUN curl -sSO http://ftp.tsukuba.wide.ad.jp/software/gcc/releases/gcc-11.1.0/gcc-11.1.0.tar.gz
RUN tar -zxvf /tmp/gcc-11.1.0.tar.gz
RUN mkdir /tmp/gcc-11.1.0/build
WORKDIR /tmp/gcc-11.1.0/build
RUN ../configure --prefix=/usr/local/gcc-11.1.0 --with-gmp --enable-languages=c,c++ --disable-multilib --program-suffix=-11.1
RUN make -j16
RUN make install

WORKDIR /home/pyenv

RUN git clone --recursive https://github.com/microsoft/LightGBM /tmp/LightGBM
RUN mkdir /tmp/LightGBM/build
WORKDIR /tmp/LightGBM/build
ENV LD_LIBRARY_PATH=/usr/local/gcc-11.1.0/lib;/usr/local/gcc-11.1.0/lib64/;${LD_LIBRARY_PATH}
ENV OPENCL_LIBRARY=/usr/local/cuda/lib64/libOpenCL.so
ENV OpenCL_INCLUDE_DIR=/usr/local/cuda/include/CL/
RUN cmake \
    -DUSE_GPU=1 \
    -DUSE_CUDA=1 \
    -DOpenCL_LIBRARY=${OPENCL_LIBRARY} \
    -OpenCL_INCLUDE_DIR=${OpenCL_INCLUDE_DIR} \
    ..
RUN make -j16 ..
WORKDIR /tmp/LightGBM
RUN pyenv local versions 3.9.12
WORKDIR /tmp/LightGBM/python-package
RUN python -m pip install --upgrade pip
RUN python -m pip install wheel setuptools
RUN python setup.py install --precompile
WORKDIR /tmp/LightGBM
RUN Rscript build_r.R -j16 \
    --use-gpu \
    --opencl-library=${OPENCL_LIBRARY} \
    --opencl-include-dir=${OpenCL_INCLUDE_DIR}

# clean dirs.
RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/* \
    /var/cache/apt/*

USER pyenv
WORKDIR /home/pyenv/work

CMD ["./launch.sh"]
