# Use the official Node.js image as the base image
FROM timbru31/java-node

# Set a working directory inside the container
WORKDIR /app

# Install Firebase CLI globally
RUN npm install -g firebase-tools

# Expose the ports required by the Firebase Emulator Suite
EXPOSE 9099 5001 8080 9199 4000

# Copy your application files to the working directory
COPY . .

# Install dependencies (if you have any)
RUN npm install

# Use start.sh as the CMD
CMD ["sh", "-c", "firebase emulators:start --import ./cache --export-on-exit ./cache"]
