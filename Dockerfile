# Use a Node.js base image
FROM node:16

# Set working directory in the container
WORKDIR /app

# Copy package.json and package-lock.json first for caching dependencies
COPY package*.json ./

# Set npm registry and increase timeout
RUN npm config set registry https://registry.npm.taobao.org
RUN npm config set fetch-timeout 60000
RUN npm install

# Copy the rest of the project files into the container
COPY . .

# Expose the port the app runs on
EXPOSE 3000

# Command to run your application
CMD ["node", "app.js"]
