const functions = require("firebase-functions");
const admin = require("firebase-admin");

admin.initializeApp();

const Roles = {
    ADMIN: "admin",
    USER: "user",
}

// create https callable function
exports.addAdminRole = functions.https.onCall(async (data, context) => {
    // get user and add custom claim (admin)
    try {
        await admin.auth().setCustomUserClaims(data.uid, {
            role: Roles.ADMIN,
        });
        return {
            message: `Success! ${data.email} has been made an admin.`,
        };
    } catch (error) {
        return {
            error: "[Server] " + error.message,
        };
    }
});

exports.addUserRole = functions.https.onCall(async (data, context) => {
    // get user and add custom claim (admin)
    try {
        await admin.auth().setCustomUserClaims(data.uid, {
            role: Roles.USER,
        });
        console.log("Success! ${data.email} has been made a user.");
        return {
            message: `Success! ${data.email} has been made a user.`,
        };
    } catch (error) {
        console.log("Error setting custom claims: ", error);
        return {
            error: "[Server] " + error.message,
        };
    }
});