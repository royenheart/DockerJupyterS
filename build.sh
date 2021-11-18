/bin/bash -c "nohup jupyter-notebook >> /home/$USER_NAME/pythonSLOG/log$(date | awk '//{printf("%s-%s",$3,$2)}').log 2>&1 &"
