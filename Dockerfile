FROM pyenv_root

#RUN pyenv install anaconda3-2022.05
RUN pyenv install 3.9.12
RUN mkdir /home/pyenv/env_root
WORKDIR /home/pyenv/env_root
RUN pyenv local 3.9.12

# no conda then.
RUN /home/pyenv/.pyenv/versions/3.9.12/bin/python -m pip install --upgrade pip && rm -rf ${HOME}/.cache/pip
RUN /home/pyenv/.pyenv/versions/3.9.12/bin/python -m pip install opencv-python \
    matplotlib \
    torch \
    torchvision \
    torchaudio --extra-index-url https://download.pytorch.org/whl/cu113
RUN /home/pyenv/.pyenv/versions/3.9.12/bin/python -m pip install jupyterlab \
    jupyterlab_code_formatter \
    jupyterlab-git \
    jupyterlab_widgets && \
    rm -rf ${HOME}/.cache/pip

RUN mkdir /home/pyenv/work
COPY launch.sh /home/pyenv/work/launch.sh
WORKDIR /home/pyenv/work
RUN pyenv local 3.9.12

USER root
RUN chmod 777 /home/pyenv/work/launch.sh
RUN chown pyenv:pyenv /home/pyenv/work/launch.sh
USER pyenv

CMD ["./launch.sh"]
