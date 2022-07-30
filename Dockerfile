FROM pyenv_root

# R settings
USER root
RUN R -e 'update.packages()'
RUN R -e 'install.packages("languageserver")'
RUN R -e 'install.packages("dplyr")'
RUN R -e 'install.packages("data.table")'
RUN R -e 'install.packages("httr")'
RUN R -e 'install.packages("tidyverse")'
RUN R -e 'install.packages("Rcpp")'
RUN R -e 'install.packages("inline")'
RUN R -e 'install.packages("lavaan")'
RUN R -e 'install.packages("semPlot")'
RUN R -e 'install.packages("stringr")'
RUN R -e 'install.packages("purrr)"'
RUN R -e 'install.packages("jsonlite")'
RUN R -e 'install.packages("randomForest")'
RUN R -e 'install.packages("car")'
USER pyenv

# no conda then.
RUN pyenv install 3.9.12
RUN /home/pyenv/.pyenv/versions/3.9.12/bin/python -m pip install --upgrade pip
RUN rm -rf ${HOME}/.cache/pip
RUN /home/pyenv/.pyenv/versions/3.9.12/bin/python -m pip install wheel \
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
    keras \
    torch \
    torchvision \
    torchtext \
    torchaudio --extra-index-url https://download.pytorch.org/whl/cu113

RUN /home/pyenv/.pyenv/versions/3.9.12/bin/python -m pip install jupyterlab
RUN /home/pyenv/.pyenv/versions/3.9.12/bin/python -m pip install 'jupyterlab>=3.0.0,<4.0.0a0' jupyterlab-lsp
RUN /home/pyenv/.pyenv/versions/3.9.12/bin/python -m pip install jupyterlab_code_formatter \
    jupyterlab-git \
    jupyterlab_widgets && \
    rm -rf ${HOME}/.cache/pip

# install lightgbm
RUN mkdir /home/pyenv/.tmp
RUN git clone --recursive https://github.com/microsoft/LightGBM /home/pyenv/.tmp/LightGBM
RUN mkdir /home/pyenv/.tmp/LightGBM/build
WORKDIR /home/pyenv/.tmp/LightGBM/build
ENV LD_LIBRARY_PATH=/usr/local/gcc-11.1.0/lib:/usr/local/gcc-11.1.0/lib64/:${LD_LIBRARY_PATH}
ENV OPENCL_LIBRARY=/usr/local/cuda/lib64/libOpenCL.so
ENV OPENCL_INCLUDE_DIR=/usr/local/cuda/include/CL/
RUN cmake \
    -DUSE_GPU=1 \
    -DUSE_CUDA=1 \
    -DOpenCL_LIBRARY=${OPENCL_LIBRARY} \
    -DOpenCL_INCLUDE_DIR=${OPENCL_INCLUDE_DIR} \
    ..
RUN make -j16
WORKDIR /home/pyenv/.tmp/LightGBM
RUN pyenv local 3.9.12
WORKDIR /home/pyenv/.tmp/LightGBM/python-package
RUN /home/pyenv/.pyenv/versions/3.9.12/bin/python setup.py install --precompile
WORKDIR /home/pyenv/.tmp/LightGBM
USER root
RUN Rscript build_r.R -j16 \
    --use-gpu \
    --opencl-library=${OPENCL_LIBRARY} \
    --opencl-include-dir=${OPENCL_INCLUDE_DIR}
USER pyenv

# add jupyter lab launch script and add workdir.
RUN mkdir /home/pyenv/work
WORKDIR /home/pyenv/work
COPY launch.sh /home/pyenv/work/launch.sh
USER root
RUN chmod 777 /home/pyenv/work/launch.sh
RUN chown pyenv:pyenv /home/pyenv/work/launch.sh
RUN chmod 777 -R /home/pyenv/.cache
RUN chown pyenv:pyenv /home/pyenv/.cache
RUN pyenv local 3.9.12
USER pyenv

CMD ["./launch.sh"]
