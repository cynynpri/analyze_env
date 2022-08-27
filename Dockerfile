FROM pyenv_root

# R settings
USER root
RUN R --quiet -e 'update.packages(ask=FALSE)' && \
    R --quiet -e "install.packages('devtools', Ncpus = $(nproc))" && \
    R --quiet -e "install.packages('sf', Ncpus = $(nproc))" && \
    R --quiet -e "install.packages('languageserver', Ncpus = $(nproc))" && \
    R --quiet -e "install.packages('dplyr', Ncpus = $(nproc))" && \
    R --quiet -e "install.packages('data.table', Ncpus = $(nproc))" && \
    R --quiet -e "install.packages('httr', Ncpus = $(nproc))" && \
    R --quiet -e "install.packages('tidyverse', Ncpus = $(nproc))" && \
    R --quiet -e "install.packages('Rcpp', Ncpus = $(nproc))" && \
    R --quiet -e "install.packages('inline', Ncpus = $(nproc))" && \
    R --quiet -e "install.packages('lavaan', Ncpus = $(nproc))" && \
    R --quiet -e "install.packages('semPlot', Ncpus = $(nproc))" && \
    R --quiet -e "install.packages('stringr', Ncpus = $(nproc))" && \
    R --quiet -e "install.packages('purrr', Ncpus = $(nproc))" && \
    R --quiet -e "install.packages('jsonlite', Ncpus = $(nproc))" && \
    R --quiet -e "install.packages('randomForest', Ncpus = $(nproc))" && \
    R --quiet -e "install.packages('ranger', Ncpus = $(nproc))" && \
    R --quiet -e "install.packages('ROCR', Ncpus = $(nproc))" && \
    R --quiet -e "install.packages('car', Ncpus = $(nproc))" && \
    R --quiet -e "install.packages('rstan', Ncpus = $(nproc))" && \
    R --quiet -e "install.packages('ggcorrplot', Ncpus = $(nproc))" && \
    R --quiet -e "install.packages('caret', Ncpus = $(nproc))" && \
    R --quiet -e "install.packages('ggmap', Ncpus = $(nproc))" && \
    R --quiet -e "install.packages('ggvis', Ncpus = $(nproc))" && \
    R --quiet -e "install.packages('DBI', Ncpus = $(nproc))" && \
    R --quiet -e "install.packages('RMySQL', Ncpus = $(nproc))" && \
    R --quiet -e "install.packages('RPostgreSQL', Ncpus = $(nproc))" && \
    R --quiet -e "install.packages('moderndive', Ncpus = $(nproc))" && \
    R --quiet -e "install.packages('rpart', Ncpus = $(nproc))" && \
    R --quiet -e "install.packages('lubridate', Ncpus = $(nproc))" && \
    R --quiet -e "install.packages('foreach', Ncpus = $(nproc))" && \
    R --quiet -e "install.packages('doParallel', Ncpus = $(nproc))" && \
    R --quiet -e "install.packages('sampling', Ncpus = $(nproc))" && \
    R --quiet -e "install.packages('feather', Ncpus = $(nproc))"

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
    feather \
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
RUN mkdir /home/pyenv/.tmp && \
    git clone --recursive --switch stable --depth=1 https://github.com/microsoft/LightGBM /home/pyenv/.tmp/LightGBM && \
    mkdir /home/pyenv/.tmp/LightGBM/build
WORKDIR /home/pyenv/.tmp/LightGBM/build
ENV LD_LIBRARY_PATH=/usr/local/gcc-11.1.0/lib:/usr/local/gcc-11.1.0/lib64/:${LD_LIBRARY_PATH}
ENV OPENCL_LIBRARY=/usr/local/cuda/lib64/libOpenCL.so
ENV OPENCL_INCLUDE_DIR=/usr/local/cuda/include/CL/
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
    --opencl-include-dir=${OPENCL_INCLUDE_DIR} && \
    mkdir -p /etc/OpenCL/vendors && echo "libnvidia-opencl.so.1" > /etc/OpenCL/vendors/nvidia.icd
# FYI: https://www.kaggle.com/code/kirankunapuli/ieee-fraud-lightgbm-with-gpu/notebook
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
