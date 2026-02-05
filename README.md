# inception

#### What is Docker ?

Docker is an open platform for developing, shipping, and running applications. Docker enables you to separate your applications from your infrastructure so you can deliver software quickly. With Docker, you can manage your infrastructure in the same ways you manage your applications. By taking advantage of Docker's methodologies for shipping, testing, and deploying code, you can significantly reduce the delay between writing code and running it in production.

#### What is Docker Engine ?

Docker Engine is an open source containerization technology for building and containerizing your applications. Docker Engine acts as a client-server application with:

- A server with a long-running daemon process dockerd.
- APIs which specify interfaces that programs can use to talk to and instruct the Docker daemon.
- A command line interface (CLI) client docker.

#### What is Image ?

#### What is Container ?

#### What is Volume ?

## Commands:

`docker run hello-world`

- Create a container from image hello-world and run it

`docker container ls`

- Shows only running containers

`docker container ls -l`

- -l = last created container

`docker container ls -a or -la`

- -a = all containers (running or stopped)

`docker run --name dahani hello-world`

- --name = Rename the container

`docker rm dahani`

- rm = Remove a container

`docker rmi image-dahani`

- rmi = Remove a image

`docker ps`

- is like docker container ls with all flags (the diff between them is docker ps is older than docker container ls)

`docker image ls`

- show all images

`docker images`

- is like docker image ls with all flags (the diff between them is docker images is older than docker image ls)

`docker pull ubuntu`

- clone the image ubuntu from docker hub

`docker start my-ubuntu`

- start a container all ready build

`docker stop my-ubuntu`

- stop a container all ready urn

`docker run -p 8080:80 nginx`

- -p = publish ports (Take a port from the container and expose it on my host machine) this concept called Port Mapping

`docker run -d nginx`

- -d = detached mode (run the container in the background, The container keeps running, but your terminal does not get attached to it)
