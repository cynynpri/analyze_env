# Cyan's analyze_env
My Jupyter lab environment on Python and R.  
This container is available pytorch, r and opencv.  

## How to use
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

