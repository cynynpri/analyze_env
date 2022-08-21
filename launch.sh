#!/bin/bash

export SHELL=/bin/bash

/bin/bash -c "PATH=${PATH}:/home/pyenv/.pyenv/versions/3.9.12/bin"

#/home/pyenv/.pyenv/versions/3.9.12/bin/python -m pip freeze > ./requirements.txt

/home/pyenv/.pyenv/versions/3.9.12/bin/jupyter-lab --port 8888 --ip=0.0.0.0
