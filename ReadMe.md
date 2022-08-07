# Cyan's analytical_env
My Jupyter lab docker container environment on Python and R.  
This container is available pytorch, r and opencv.  

## Requirement
Get cudnn tar file first.  
The cudnn tar files should be placed in the cloned directory of this repository.  
This Dockerfile has been tested on Windows WSL2 and Ubuntu(20.04 and 22.04).  
  
## How to use
### Installation.  
1. Execute build root environment command.   
```bash
 $ make root-build
```
  
2. Execute build jupyter lab environment command.
```bash
 $ make build
```
  
3. Execute run jupyter lab environment command.
```bash
 $ make run
```
  
Finally. Execute jupyter-lab R enable setting.
``` bash
 # here is jupyter lab terminal.
 $ R
 > install.packages('IRkernel')
 > IRkernel::installspec()
```
### How to run/start this container.
When you using this container for the first time, please execute the following command.  
  
```bash
 $ sudo make run  # this command is similar to docker run.
```
  
At other times, please execute the following commands.  
  
```bash
 $ sudo make start  # this command is similar to docker start.
 $ sudo make logs  # please, check running container logs and get the jupyter-lab entering urls.
```
  
### How to stop this container.
Please executre the following command.  
  
```bash
 $ sudo make stop
```
  
### How to remove this container and container images.
Please execute the following command.  
  
```bash
 $ sudo make clean  # Not docker like. `docker rmi ~~~`
```
  
