const admin = require('firebase-admin');
const serviceAccount = require('../../../serviceAccountKey.json');
const faker = require('faker');
const path = require('path');
const fs = require('fs');
const tmp = require('tmp');

// Set the environment variable for Firestore Emulator host
process.env.FIRESTORE_EMULATOR_HOST = 'localhost:8080';
process.env.FIREBASE_STORAGE_EMULATOR_HOST = 'localhost:9199';

// Initialize Firebase Admin SDK with the local Firebase Emulator configuration
if (!admin.apps.length) {
  admin.initializeApp({
    credential: admin.credential.cert(serviceAccount),
    databaseURL: 'http://localhost:4000', // Firebase Realtime Database Emulator URL
    storageBucket: 'gs://fitnessapp-9dd39.appspot.com/', // Replace this with your Firebase Storage bucket name
  });
}

// Access Firestore using admin.firestore()
const firestore = admin.firestore();
const storage = admin.storage();

// Function to generate a random integer between min (inclusive) and max (inclusive)
function getRandomInt(min, max) {
  return Math.floor(Math.random() * (max - min + 1)) + min;
}

// Function to generate a black and white noise image
function generateBlackAndWhiteNoiseImage(width, height) {
  const imageData = Buffer.alloc(width * height * 3);

  for (let i = 0; i < width * height; i++) {
    const pixelIndex = i * 3;
    const color = Math.random() > 0.5 ? 255 : 0; // Randomly set pixel color to either black (0) or white (255)

    // Set the red, green, and blue channels of the pixel to the same color value
    imageData[pixelIndex] = color;
    imageData[pixelIndex + 1] = color;
    imageData[pixelIndex + 2] = color;
  }

  return imageData;
}

// Function to populate the Firestore "exercises" collection
module.exports = async function populateExercises() {
  try {
    const numExercises = 10; // Number of exercises to create

    for (let i = 0; i < numExercises; i++) {
      const exercise = {
        name: faker.lorem.words(2), // Generate a random name with two words
        description: faker.lorem.sentence(),
        imageURL: null, // Placeholder for the image URL, we'll set it later
        muscles: Array.from({ length: getRandomInt(0, 8) }, () => getRandomInt(0, 8)),
        difficulty: getRandomInt(0, 2),
      };

      const docRef = await firestore.collection('exercises').add(exercise);
      exercise.uid = docRef.id; // Save the document ID as the UID for the image path

      console.log('Exercise added:', exercise);

      // Upload image for the exercise
      const imagePath = await uploadImage(exercise.uid);

      // Update the exercise with the image URL
      exercise.imageURL = imagePath;
      await docRef.update({ imageURL: imagePath });
      console.log('Exercise image URL updated:', exercise);
    }

    console.log('Exercises population completed.');
  } catch (error) {
    console.error('Error populating exercises:', error);
  }
};

// Function to upload image to Firebase Storage
async function uploadImage(exerciseId) {
  const bucket = storage.bucket(); // Use the default bucket

  // Create a temporary file with the sample image data using the tmp package
  const { name: tempFilePath } = tmp.fileSync({ postfix: '.png' }); // Replace '.jpg' with the appropriate file extension

  // Generate a black and white noise image with 100x100 pixels (you can adjust the width and height)
  // const sampleImageWidth = 100;
  // const sampleImageHeight = 100;
  // const sampleImage = generateBlackAndWhiteNoiseImage(sampleImageWidth, sampleImageHeight);

  // upload image from local on random image from images folder
  const sampleImage = fs.readFileSync(path.join(__dirname, '../images', `image${getRandomInt(1, 3)}.png`));


  // Write the sample image to the temporary file
  fs.writeFileSync(tempFilePath, sampleImage);

  const destinationPath = `exercises/${exerciseId}`; // Destination path in Firebase Storage

  try {
    // Upload the temporary file to Firebase Storage
    const resp = await bucket.upload(tempFilePath, {
      destination: destinationPath,
      metadata: {
        contentType: 'image/png', // Adjust the content type based on your image type
      },
    });
    // Get the uploaded file object
    const uploadedFile = resp[0];

     // Generate a public URL for the uploaded image
     const imageURL = `https://storage.googleapis.com/${bucket.name}/${destinationPath}`;


    // Delete the temporary file
    fs.unlinkSync(tempFilePath);

    return imageURL;
  } catch (error) {
    // Ensure the temporary file is deleted even if an error occurs during the upload
    fs.unlinkSync(tempFilePath);
    throw error;
  }
}
