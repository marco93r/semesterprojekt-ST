# Use a newer Node.js base image
FROM node:18

# Environment variables
ENV METEOR_ALLOW_SUPERUSER=true
ENV ROOT_URL="http://localhost:3000"

# Install necessary dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    libstdc++6 && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Verify the version of libstdc++ to ensure it includes the required GLIBCXX_3.4.26
RUN strings /usr/lib/x86_64-linux-gnu/libstdc++.so.6 | grep GLIBCXX

# Install Meteor
RUN curl "https://install.meteor.com/" | sh

# Create a non-root user and group, set permissions
RUN useradd -m meteoruser && \
    mkdir -p /usr/src/app && \
    chown -R meteoruser:meteoruser /usr/src/app && \
    chown -R meteoruser:meteoruser /root/.meteor

# Switch to the non-root user
USER meteoruser

# Set the working directory
WORKDIR /usr/src/app

# Copy the app's source code into the container
COPY --chown=meteoruser:meteoruser . /usr/src/app

# Copy the private directory to include settings.dev.json
COPY --chown=meteoruser:meteoruser private /usr/src/app/private

# Set permissions for the local Meteor directory
RUN chmod -R 700 /usr/src/app/.meteor/local

# Install app dependencies
RUN meteor npm install

RUN npm install babel-eslint ajv

# Expose the necessary port
EXPOSE 3000

# Start the app with the settings file
CMD ["meteor", "run", "--exclude-archs", "web.browser.legacy,web.cordova", "--settings", "/usr/src/app/private/settings.dev.json"]
