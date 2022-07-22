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
USER pyenv

RUN mkdir /home/pyenv/work
COPY launch.sh /home/pyenv/work/launch.sh
WORKDIR /home/pyenv/work
RUN pyenv local 3.9.12

USER root
RUN chmod 777 /home/pyenv/work/launch.sh
RUN chown pyenv:pyenv /home/pyenv/work/launch.sh
USER pyenv

# install lightgbm
# TODO: Fix
USER root
RUN apt-get update && apt-get install -qy cmake \
    ocl-icd-opencl-dev \
    libboost-dev \
    libboost-system-dev \
    libboost-filesystem-dev
RUN git clone --recursive https://github.com/microsoft/LightGBM /tmp/LightGBM
RUN mkdir /tmp/LightGBM/build
RUN cp /tmp/LightGBM/CMakeLists.txt /tmp/LightGBM/build/
WORKDIR /tmp/LightGBM/build
# FIXME: This line is error.
#RUN ls -al /usr/local/cuda/include/CL/opencl.h
RUN cmake \
    -DUSE_GPU=1 \
    -DUSE_CUDA=1 \
    -DOpenCL_LIBRARY=/usr/local/cuda/lib64/libOpenCL.so \
    -OpenCL_INCLUDE_DIR=/usr/local/cuda/include/CL/
RUN make -j4

# clean dirs.
RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/* \
    /var/cache/apt/*

USER pyenv
WORKDIR /home/pyenv/work

CMD ["./launch.sh"]
