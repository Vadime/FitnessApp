const admin = require('firebase-admin');
const serviceAccount = require('../serviceAccountKey.json');

// Check if the app is already initialized
if (!admin.apps.length) {
// Initialize Firebase Admin SDK with the local Firebase Emulator configuration
admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
});
}
// Get a reference to the Auth service
const auth = admin.auth();

// Example user data
const users = [
  { email: 'admin@email.com', password: '123456', role: 'admin', name: 'Dr. Felix Weber' },
];

// Create users in Firebase Authentication
async function populateUsers() {
  try {
    for (const user of users) {
      const { email, password, role, name } = user;
      const userRecord = await auth.createUser({
        email,
        password,
      });
      
      //  Set custom user claims
      await auth.setCustomUserClaims(userRecord.uid, { role: role });
      
      // update displayName
      await auth.updateUser(userRecord.uid, {
        displayName: name,
      });
      
      console.log(`User created successfully: ${email}`);
    }
  } catch (error) {
    console.error('Error creating users:', error);
  }
}

populateUsers();
