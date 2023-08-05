# Use the official Node.js image as the base image
FROM timbru31/java-node

# Set a working directory inside the container
WORKDIR /app

# Install Firebase CLI globally
RUN npm install -g firebase-tools

# Expose the ports required by the Firebase Emulator Suite
EXPOSE 9099 5001 8080 9199 4000

# Start the Firebase Emulator Suite
CMD ["sh", "-c", "firebase emulators:start"]
