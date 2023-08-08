// Import the functions from individual population scripts
const populateUsers = require('./src/populate_users');
const populateExercises = require('./src/populate_exercises');
const populateWorkouts = require('./src/populate_workouts');

// Function to populate all data
async function populateAllData() {
  try {
    await populateUsers();
    await populateExercises();
    await populateWorkouts();
    console.log('Data population completed.');
  } catch (error) {
    console.error('Error populating data:', error);
  }
}

// Call the function to start data population
populateAllData();
