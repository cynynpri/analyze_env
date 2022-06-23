ROOT_NAME=pyenv_root
NAME=jupyter
VERSION="0.1"
LOCALHOST=127.0.0.1
HOST_PORT=8888
CONTAINER_PORT=8888
PWD=`pwd`

root_build:
	docker build -t $(ROOT_NAME) ./pyenv_root

build:
	docker build -t $(NAME) .
 
run:
	docker run --gpus all --name $(NAME) -i -p $(localhost):$(host_port):$(container_port) -v $(PWD):/home/pyenv/myapp $(NAME)

start:
	docker start $(NAME)

stop:
	docker stop $(NAME)

logs:
	docker logs $(NAME)

clean:
	docker rm $(NAME) && docker rmi $(ROOT_NAME) && docker rmi $(NAME)
 