const admin = require('firebase-admin');
const serviceAccount = require('../../serviceAccountKey.json');
const faker = require('faker');

// Set the environment variable for Firestore Emulator host
process.env.FIRESTORE_EMULATOR_HOST = 'localhost:8080';

// Check if the app is already initialized
if (!admin.apps.length) {
// Initialize Firebase Admin SDK with the local Firebase Emulator configuration
admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  databaseURL: 'http://localhost:4000', // Firebase Realtime Database Emulator URL
  storageBucket: 'gs://fitnessapp-9dd39.appspot.com/'
});
}
// Access Firestore using admin.firestore()
const firestore = admin.firestore();

// Function to generate a random integer between min (inclusive) and max (inclusive)
function getRandomInt(min, max) {
  return Math.floor(Math.random() * (max - min + 1)) + min;
}

// Function to generate random workout data
function generateRandomWorkout(exercisesData) {
  const numExercises = getRandomInt(1, 5); // Number of exercises in a workout
  const workoutExercises = [];

  for (let i = 0; i < numExercises; i++) {
    const exercise = exercisesData[getRandomInt(0, exercisesData.length - 1)];
    const workoutExercise = {
      exerciseUID: exercise.id,
      recommendedSets: getRandomInt(2, 5),
      recommendedReps: getRandomInt(8, 15),
    };
    workoutExercises.push(workoutExercise);
  }

  return {
    name: faker.lorem.words(2), // Generate a random name with two words
    description: faker.lorem.sentence(),
    schedule: getRandomInt(0, 6),
    workoutExercises,
  };
}

// Function to populate the Firestore "workouts" collection
module.exports = async function populateWorkouts() {
  try {
    // Get all exercises from Firestore "exercises" collection
    const exercisesSnapshot = await firestore.collection('exercises').get();
    const exercisesData = exercisesSnapshot.docs.map((doc) => ({
      id: doc.id,
      ...doc.data(),
    }));

    const numWorkouts = 5; // Number of workouts to create

    for (let i = 0; i < numWorkouts; i++) {
      const workout = generateRandomWorkout(exercisesData);

      await firestore.collection('workouts').add(workout);
      console.log('Workout added:', workout);
    }

    console.log('Workouts population completed.');
  } catch (error) {
    console.error('Error populating workouts:', error);
  }
}
