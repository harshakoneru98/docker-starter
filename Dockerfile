# Start by basing it on another image
FROM node:13-alpine

# Define environment variables - Optional, better to define it externally in Docker compose file. 
# Because if something changes, we can overwrite docker-compose file instead of rebuilding the image.
ENV MONGO_DB_USERNAME=admin \
    MONGO_DB_PWD=password

# RUN - execute any Linux Command
# Create a directory inside the container
RUN mkdir -p /home/app

# COPY - executes on the HOST machine
COPY ./app /home/app

# set default dir so that next commands executes in /home/app dir
WORKDIR /home/app

# will execute npm install in /home/app because of WORKDIR
RUN npm install

# no need for /home/app/server.js because of WORKDIR
# CMD - Executes as the entry point - translates to node server.js
CMD ["node", "server.js"]

