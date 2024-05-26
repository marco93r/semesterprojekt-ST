FROM node:18

# Environment variables
ENV METEOR_ALLOW_SUPERUSER=true
ENV ROOT_URL="http://localhost:3000"

# Install necessary dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    libstdc++6

# Verify the version of libstdc++ to ensure it includes the required GLIBCXX_3.4.26
RUN strings /usr/lib/x86_64-linux-gnu/libstdc++.so.6 | grep GLIBCXX

# Install Meteor
RUN curl "https://install.meteor.com/" | sh

# Set the working directory
WORKDIR /usr/src/app

# Copy the app's source code into the container
COPY . /usr/src/app

# Set permissions for the local Meteor directory
RUN chmod -R 700 /usr/src/app/.meteor/local

# Install app dependencies
RUN meteor npm install

RUN npm install babel-eslint ajv

# Expose the necessary port
EXPOSE 3000

# Start the app
CMD ["npm", "start"]
