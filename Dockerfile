# Use official Node.js image as a base
FROM node:16

# Set the working directory in the container
WORKDIR /usr/src/app

# Copy package.json and package-lock.json first to leverage Docker cache
COPY package*.json ./

# Install project dependencies
RUN npm install

# Copy the rest of the project files into the container
COPY . .

# Expose the port your Node.js app listens on (replace with actual port if different)
EXPOSE 3000

# Command to run the app (replace with your start command)
CMD ["npm", "start"]
