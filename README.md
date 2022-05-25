## Docker

#### Docker vs Virtual Machine
Operating system contains two layers i.e. Kernal and Application layer. Kernal layer communicates with Hardware and the Application runs on Kernal layer. For example, Linux OS - there are lot of distributions of Linux that are available with different UI. All of those distributions use same Linux Kernal, but they implement different application(layer) on top of Kernal layer.

Both Docker and VM's are virtualization tools.

**Differences**
**Docker**
- It virtualizes only application layer. So, when we download docker image, it contains the application layer of OS and uses the kernal of the Host machine because Docker doen't have it's own Kernal.
- Size of the docker image is small (MB's) as it virtualizes application layer.
- Docker containers start and run much fast as it doen't require to boot OS kernal everytime.
- Docker Container can run only on Host machine OS  (Less compatibility)

**VM**
- It virtualizes both Application and Kernal layers. So, when we download VM image on our host, it doesn't use our host machine kernal as it boots up it's own.
- Size of the VM image is large (GB's) as it virtualizes both kernal and application layers.
- VM start and run much slower than Docker containers as it requires to boot OS kernal everytime it starts.
- VM of any OS can run on any OS Host (More compatibility)

#### What is a Container?
- A way to package application with all the necessary dependencies and configuration
- Portable artifact, easily shared and moved around b/w dev and dev ops team

Portability of containers and everything packaged in one isolated environment gives some advantages that makes developement and deployment more efficient.

Technically, Container has different layers of images with bottom/base layer as Linux Image(small in size) and stacked up with intermediate image layers that lead up to the actual application/top image layer that is going to run on docker container.

#### Where do containers live?
As mentioned containers are portable, there must be some kind of storage for those containers so that we can share them and move them around. 
- Container Repository
- Private Repositories
- Public Repository for Docker - DockerHub

#### Application Development
**Before Containers**
- Installation process different on each OS environment
- Many steps where something could go wrong

**After Containers**
- Own isolated environment
- Packaged with all needed configuration
- One command to install the app
- Run same app with 2 different versions

#### Application Deployement
**Before Containers**
- Development team will produce artifacts together with a set of instructions how to install and configure that artifacts on the server. In addition, team will also provide a database service or other services with set of instructions of how to install and setting up in the server.
- After sending artifacts and instructions to Operations team, they will handle setting up the environment to deploy those applications.
- **Problems:**
    - Needed configuration on the server - might leads to dependency version conflicts
    - Textual guide of deployement - Mistunderstandings b/w dev and ops teams. May be dev team might forgot some instructions or ops team may misinterpret some instructions.

**After Containers**
- Developers and Operations work together to package the application in a container
- As it is encapsulated in one container, No environmental configuration needed on server - except Docker Runtime

#### Docker Image vs Docker Container
**Docker Image**
- It is the actual package (application + configuration + dependencies). It is actually an Artifact, that can be moved around. 

**Docker Container**
- When we pull the image into local machine, it actually starts the application. That creates an container environment.
- It contains Application Image + Environment Configs + File System

CONTAINER is a running environment for IMAGE

## Demo app - Developing with Docker

This demo app shows a simple user profile app set up using 
- index.html with pure js and css styles
- nodejs backend with express module
- mongodb for data storage

All components are docker-based

### With Docker

#### Real-time Workflow
![Docker Workflow](https://github.com/harshakoneru98/docker-starter/blob/main/app/images/docker-workflow.png)

#### To start the application

Step 1: Create docker network

    docker network create mongo-network 

Step 2: start mongodb 

    docker run -d -p 27017:27017 -e MONGO_INITDB_ROOT_USERNAME=admin -e MONGO_INITDB_ROOT_PASSWORD=password --name mongodb --net mongo-network mongo    

Step 3: start mongo-express
    
    docker run -d -p 8081:8081 -e ME_CONFIG_MONGODB_ADMINUSERNAME=admin -e ME_CONFIG_MONGODB_ADMINPASSWORD=password --net mongo-network --name mongo-express -e ME_CONFIG_MONGODB_SERVER=mongodb mongo-express   

_NOTE: creating docker-network in optional. You can start both containers in a default network. In this case, just emit `--net` flag in `docker run` command_

Step 4: open mongo-express from browser

    http://localhost:8081

Step 5: create `user-account` _db_ and `users` _collection_ in mongo-express

Step 6: Start your nodejs application locally - go to `app` directory of project 

    npm install 
    node server.js
    
Step 7: Access you nodejs application UI from browser

    http://localhost:3000

### With Docker Compose

Docker Compose will create a default separate network. No need to include network options in yaml file.

#### To start the application

Step 1: start mongodb and mongo-express

    docker-compose -f docker-compose.yaml up
    
_You can access the mongo-express under localhost:8080 from your browser_
    
Step 2: in mongo-express UI - create a new database "my-db"

Step 3: in mongo-express UI - create a new collection "users" in the database "my-db"       
    
Step 4: start node server 

    npm install
    node server.js
    
Step 5: access the nodejs application from browser 

    http://localhost:3000

Step 6: Stop and remove containers

    docker-compose -f docker-compose.yaml down

This will automatically removes created network.

#### To build a docker image from the application

    docker build -t my-app:1.0 .       
    
The dot "." at the end of the command denotes location of the Dockerfile.

#### Check the docker container terminal

    docker exec -it <container_id> /bin/sh

    docker exec -it <container_id> /bin/bash

Either one of the above will work, as sometimes some containers won't have bash installed.
