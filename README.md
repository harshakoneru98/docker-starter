## Docker

### Docker vs Virtual Machine
The operating system contains two layers i.e. Kernal and Application layer. The Kernal layer communicates with Hardware and the Application runs on the Kernal layer. For example, Linux OS - there are a lot of distributions of Linux that are available with different UI. All of those distributions use the same Linux Kernal, but they implement different application(layer) on top of the Kernal layer.

Both Docker and VM are virtualization tools.

#### Differences
**Docker**
- It virtualizes only the application layer. So, when we download the docker image, it contains the application layer of OS and uses the kernel of the Host machine because Docker doesn't have Kernal.
- Size of the docker image is small (MB's) as it virtualizes the application layer.
- Docker containers start and run much fast as they don't require booting the OS kernel every time.
- Docker Container can run only on Host machine OS  (Less compatibility)

**VM**
- It virtualizes both Application and Kernal layers. So, when we download the VM image on our host, it doesn't use our host machine kernel as it boots up on its own.
- Size of the VM image is large (GB) as it virtualizes both kernel and application layers.
- VM starts and runs much slower than Docker containers as it requires to boot OS kernel every time it starts.
- VM of any OS can run on any OS Host (More compatibility)

### What is a Container?
- A way to package an application with all the necessary dependencies and configuration
- Portable artifact, easily shared and moved around b/w dev and dev-ops team

The portability of containers and everything packaged in one isolated environment gives some advantages that make development and deployment more efficient.

Technically, Container has different layers of images with the bottom/base layer as Linux Image(small in size) and stacked up with intermediate image layers that lead up to the actual application/top image layer that is going to run on the docker container.

### Where do containers live?
As mentioned containers are portable, there must be some kind of storage for those containers so that we can share them and move them around. 
- Container Repository
- Private Repositories
- Public Repository for Docker - DockerHub

### Application Development
#### Before Containers
- The installation process is different in each OS environment
- Many steps where something could go wrong

#### After Containers
- Own isolated environment
- Packaged with all needed configuration
- One command to install the app
- Run the same app with 2 different versions

### Application Deployement
#### Before Containers
- Development team will produce artifacts together with a set of instructions on how to install and configure those artifacts on the server. In addition, the team will also provide a database service or other services with a set of instructions on how to install and set up the server.
- After sending artifacts and instructions to the Operations team, they will handle setting up the environment to deploy those applications.
- **Problems:**
    - Needed configuration on the server - might leads to dependency version conflicts
    - Textual guide of deployment - Mistunderstandings b/w dev and ops teams. May be dev team might forget some instructions or the ops team may misinterpret some instructions.

#### After Containers
- Developers and Operations work together to package the application in a container
- As it is encapsulated in one container, No environmental configuration is needed on the server - except Docker Runtime

### Docker Image vs Docker Container
#### Docker Image
- It is the actual package (application + configuration + dependencies). It is actually an Artifact, that can be moved around. 

#### Docker Container
- When we pull the image into the local machine, it starts the application. That creates a container environment.
- It contains Application Image + Environment Configs + File System

CONTAINER is a running environment for IMAGE

### Docker Volumes
Generally, Docker containers don't persist the data i.e. data is gone when restarting or removing the container and starts from a fresh state. To persist data, we need Docker Volumes. Some of the use cases are Databases and Stateful Applications.

#### What is Docker Volume?
The folder in the physical host file system is mounted into the virtual file system of Docker. So, when a container writes to its file system, then the data is automatically replicated to the host file system and vice-versa. So, when we restart the container, data will be automatically replicated to the virtual file system of Docker.

## Demo app - Developing with Docker

This demo app shows a simple user profile app set up using 
- index.html with pure js and CSS styles
- Nodejs backend with express module
- MongoDB for data storage

All components are Docker-based

### With Docker

#### Real-time Workflow
![Docker Workflow](https://github.com/harshakoneru98/docker-starter/blob/main/app/images/docker-workflow.png)

#### To start the application

Step 1: Create a docker network

    docker network create mongo-network 

Step 2: start mongodb 

    docker run -d -p 27017:27017 -e MONGO_INITDB_ROOT_USERNAME=admin -e MONGO_INITDB_ROOT_PASSWORD=password --name mongodb --net mongo-network mongo    

Step 3: start mongo-express
    
    docker run -d -p 8081:8081 -e ME_CONFIG_MONGODB_ADMINUSERNAME=admin -e ME_CONFIG_MONGODB_ADMINPASSWORD=password --net mongo-network --name mongo-express -e ME_CONFIG_MONGODB_SERVER=mongodb mongo-express   

_NOTE: creating docker-network is optional. You can start both containers in a default network. In this case, just emit the `--net` flag in the `docker run` command_

Step 4: open mongo-express from the browser

    http://localhost:8081

Step 5: create `user-account` _db_ and `users` _collection_ in mongo-express

Step 6: Start your Nodejs application locally - go-to `app` directory of the project 

    npm install 
    node server.js
    
Step 7: Access your Nodejs application UI from the browser

    http://localhost:3000

### With Docker Compose

Docker Compose will create a default separate network. No need to include network options in the YAML file.

#### To start the application

Step 1: Start mongodb and mongo-express

    docker-compose -f docker-compose.yaml up
    
_You can access the mongo-express under localhost:8080 from your browser_
    
Step 2: in mongo-express UI - create a new database "user-account"

Step 3: in mongo-express UI - create a new collection of "users" in the database "user-account"       
    
Step 4: start the node server 

    npm install
    node server.js
    
Step 5: Access the Node.js application from the browser 

    http://localhost:3000

Step 6: Stop and remove containers

    docker-compose -f docker-compose.yaml down

This will automatically remove created network.

### With Docker Compose and Dockerfile
Step 1: Change mongoUrlLocal to mongoUrlDocker on lines 41, and 71 in app/server.js 

Step 2: Build a docker image from the application

    docker build -t my-app:1.0 .       
    
The dot "." at the end of the command denotes the location of the Dockerfile.

Step 1: Run the docker-compose file which includes the application image

    docker-compose -f docker-compose-dockerfile.yaml up

#### Check the docker container terminal

    docker exec -it <container_id> /bin/sh

    docker exec -it <container_id> /bin/bash

Either one of the above will work, as sometimes some containers won't have bash installed.

### Next steps
Now we can develop 10's or 100's complex containers. These containers would need to be deployed across multiple servers in a distributive way. Manually managing those containers is a hectic task. As a next step, we can learn about **Container Orchestration tools** and **Kubernetes** to automate these tasks.

### Resources
https://www.youtube.com/watch?v=3c-iBn73dDE