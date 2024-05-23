FROM zodern/meteor:latest

# Set path for meteor cli 
ENV PATH=$PATH:$HOME/.meteor

# Create a user
USER default

# Installation of meteor cli
RUN curl "https://install.meteor.com/" | sh

# Set the working directory to /opt/app-root/src/app
WORKDIR /opt/app-root/src/app

# Add application files in container with permissions
COPY --chown=default:0 . .

# Install all Meteor dependacies
RUN meteor npm install

# Set permission of files in container
USER root
RUN chmod -R 775 /opt/app-root/src/.meteor
RUN chown -R default:0 /opt/app-root/src/.meteor
RUN chmod -R 775 /opt/app-root/src/app/.meteor
RUN chown -R default:0 /opt/app-root/src/app/.meteor
RUN chmod -R 775 /opt/app-root/src/.npm/
RUN chown -R default:0 /opt/app-root/src/.npm/
USER default

# Open port to allow traffic in container
EXPOSE 3000

# Run start script using npm command
CMD ["npm", "start"]
