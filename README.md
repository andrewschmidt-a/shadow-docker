# Shadow Docker Image
Docker image for shadow (https://github.com/shadow/shadow). Reason for making my own docker image was that the old one is really old (fedora 22) and the dockerfile used isnt public.

# Build
```
docker build . -t nemcrunchers/shadow
```
# Use 
```
docker run -t -i -u shadow --sysctl kernel.shmmax=1073741824 --tmpfs /dev/shm:rw,nosuid,nodev,exec,size=1g  nemcrunchers/shadow /bin/bash
```
