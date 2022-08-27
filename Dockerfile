FROM pyenv_root

# R settings
USER root
RUN R -e 'update.packages()' && \
    R -e 'install.packages("languageserver")' && \
    R -e 'install.packages("dplyr")' && \
    R -e 'install.packages("data.table")' && \
    R -e 'install.packages("httr")' && \
    R -e 'install.packages("tidyverse")' && \
    R -e 'install.packages("Rcpp")' && \
    R -e 'install.packages("inline")' && \
    R -e 'install.packages("lavaan")' && \
    R -e 'install.packages("semPlot")' && \
    R -e 'install.packages("stringr")' && \
    R -e 'install.packages("purrr")' && \
    R -e 'install.packages("jsonlite")' && \
    R -e 'install.packages("randomForest")' && \
    R -e 'install.packages("car")' && \
    R -e 'install.packages("rstan")' && \
    R -e 'install.packages("ggcorrplot")'

# if you using tensorflow-gpu, then get cudnn first.
# if you have the cudnn tar file then.
#WORKDIR /tmp
#COPY cudnn-linux-x86_64-8.4.1.50_cuda11.6-archive.tar.xz /tmp/cudnn-linux-x86_64-8.4.1.50_cuda11.6-archive.tar.xz
#RUN cp cudnn-*-archive/include/cudnn*.h /usr/local/cuda/include
#RUN cp -P cudnn-*-archive/lib/libcudnn* /usr/local/cuda/lib64 
#RUN chmod a+r /usr/local/cuda/include/cudnn*.h /usr/local/cuda/lib64/libcudnn*

# else if you have the .deb file then.
#RUN curl -sSO https://developer.nvidia.com/compute/cudnn/secure/8.4.1/local_installers/11.6/cudnn-local-repo-ubuntu2004-8.4.1.50_1.0-1_amd64.deb
#RUN apt-get install -y ./tmp/cudnn-local-repo-ubuntu2004-8.4.1.50_1.0-1_amd64.deb
#WORKDIR /home/pyenv

# change user
USER pyenv

# no conda then.
RUN pyenv install 3.9.12 && \
    /home/pyenv/.pyenv/versions/3.9.12/bin/python -m pip install --upgrade pip && \
    /home/pyenv/.pyenv/versions/3.9.12/bin/python -m pip install wheel \
    setuptools \
    numpy \
    cupy-cuda11x \
    #python-rtmidi \
    opencv-python \
    matplotlib \
    japanize_matplotlib \
    pandas \
    fugashi \
    ipadic \
    scikit-learn \
    umap-learn \
    bs4 \
    tab2img \
    shap \
    lime \
    interpret \
    seaborn \
    graphviz \
    semopy \
    python-lsp-server \
    flake8 \
    autopep8 \
    pydocstyle \
    #magenta \
    librosa \
    SpeechRecognition \
    pyaudio \
    optuna \
    econml \
    dowhy \
    ipywidgets \
    xgboost \
    catboost \
    transformers \
    tensorflow \
    tensorflow-gpu \
    tensorflow-addons \
    keras \
    gpyopt \
    #pycaret \
    torch \
    torchvision \
    torchtext \
    pytorch-lightning \
    torchaudio --extra-index-url https://download.pytorch.org/whl/cu113 \
    jupyterlab \
    'jupyterlab>=3.0.0,<4.0.0a0' jupyterlab-lsp \
    jupyterlab_code_formatter \
    jupyterlab-git \
    jupyterlab_widgets && \
    rm -rf ${HOME}/.cache/pip

# install lightgbm
ENV LD_LIBRARY_PATH=/usr/local/gcc-11.1.0/lib:/usr/local/gcc-11.1.0/lib64/:${LD_LIBRARY_PATH}
ENV OPENCL_LIBRARY=/usr/local/cuda/lib64/libOpenCL.so
ENV OPENCL_INCLUDE_DIR=/usr/local/cuda/include/CL/
RUN mkdir /home/pyenv/.tmp && \
    git clone --recursive --branch stable --depth=1 https://github.com/microsoft/LightGBM /home/pyenv/.tmp/LightGBM && \
    mkdir /home/pyenv/.tmp/LightGBM/build
WORKDIR /home/pyenv/.tmp/LightGBM/build
RUN cmake \
    -DUSE_GPU=1 \
    -DUSE_CUDA=1 \
    -DOpenCL_LIBRARY=${OPENCL_LIBRARY} \
    -DOpenCL_INCLUDE_DIR=${OPENCL_INCLUDE_DIR} \
    .. && \
    make -j$(nproc)
WORKDIR /home/pyenv/.tmp/LightGBM
RUN pyenv local 3.9.12
WORKDIR /home/pyenv/.tmp/LightGBM/python-package
RUN /home/pyenv/.pyenv/versions/3.9.12/bin/python setup.py install --precompile
WORKDIR /home/pyenv/.tmp/LightGBM
USER root
# FYI: https://www.kaggle.com/code/kirankunapuli/ieee-fraud-lightgbm-with-gpu/notebook
RUN Rscript build_r.R \
    --use-gpu \
    --opencl-library=${OPENCL_LIBRARY} \
    --opencl-include-dir=${OPENCL_INCLUDE_DIR}
RUN mkdir -p /etc/OpenCL/vendors && \
    echo "libnvidia-opencl.so.1" > /etc/OpenCL/vendors/nvidia.icd
USER pyenv

# add jupyter lab launch script and add workdir.
RUN mkdir /home/pyenv/work
WORKDIR /home/pyenv/work
COPY launch.sh /home/pyenv/work/launch.sh
USER root
RUN chmod 777 /home/pyenv/work/launch.sh && \
    chown pyenv:pyenv /home/pyenv/work/launch.sh && \
    chmod 777 -R /home/pyenv/.cache && \
    chown pyenv:pyenv /home/pyenv/.cache && \
    pyenv local 3.9.12
USER pyenv

CMD ["./launch.sh"]
