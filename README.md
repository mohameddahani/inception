# inception

#### What is Docker ?

Docker is an open platform for developing, shipping, and running applications. Docker enables you to separate your applications from your infrastructure so you can deliver software quickly. With Docker, you can manage your infrastructure in the same ways you manage your applications. By taking advantage of Docker's methodologies for shipping, testing, and deploying code, you can significantly reduce the delay between writing code and running it in production.

#### What is Docker Engine ?

The Docker engine is the core sofware that runs and manages containers. Docker Engine acts as a client-server application with:

- A server with a long-running daemon process dockerd.
- APIs which specify interfaces that programs can use to talk to and instruct the Docker daemon.
- A command line interface (CLI) client docker.

#### What is Docker daemon (dockerd) ?

need a definition pls :(

#### What is containerd ?

(pronounced container-dee). Its sole purpose in life was to manage container lifecycle operations — start | stop | pause | rm....

#### What is runc ?

runc has a single purpose in life — create containers. And it’s damn good at it.

#### What is Image ?

A Docker Image is a lightweight, standalone, and executable software package that includes everything needed to run an application: the code, a runtime, system tools, libraries, and settings.

The docker image includes the following to run a piece of software. Docker images are specific to both the operating system (OS) and the CPU architecture for which they were built.

#### What is Container ?

Containers are lightweight piece of software that contains all the code, libraries, and dependencies that the application needs to run. Containers do not have their own operating system, they get resources from the host operating system. Because they do not have an operating system of their own they are lightweight. They are also easily portable as they contain all the libraries and the dependencies to run the application.

#### What is Volume ?

Docker Volumes are a way to store data outside of a container’s filesystem so that the data isn’t lost when the container stops or is deleted. By default, anything you create inside a container is temporary, but with volumes, you can keep files (like databases, logs, or configs) in a safe and reusable location managed by Docker.

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

`docker rmi $(docker images -q) -f`

- remove all images
- $(docker images -q) = show id of all images
- -f = force

`docker rm $(docker ps -aq) -f`

- remove all containers
- $(docker ps -aq) = show id of all containers
- -f = force

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

- stop a container all ready run

`docker restart my-ubuntu`

- restart a container all ready run

`docker run -p 8080:80 nginx`

- -p = publish ports (Take a port from the container and expose it on my host machine) this concept called Port Mapping

`docker run -d nginx`

- -d = detached mode (run the container in the background, The container keeps running, but your terminal does not get attached to it)

`docker image build -t test_image:latest .`

- this command build an image from Dockerfile it use buildx that also use buildKit
- -t = is use to name the image that you build
- . is mean the path of Dockerfile

`docker build -t test_image:latest .`

- this command build is like docker image build -t test_image:latest .

`docker search ubuntu`

- this command lets you search Docker Hub from the CLI


## difference between a VM and a container

- the big difference between a
VM and a container is that containers are faster and more lightweight — instead of running a full-blown OS like
a VM, containers share the OS/kernel with the host they’re running on. It’s also common for containers to be
based on minimalist images that only include software and dependencies required by the application.
