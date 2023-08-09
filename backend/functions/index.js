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

// Friend Data structure
// class Friend {
//     constructor(uid, email, displayName, imageURL) {
//         this.uid = uid;
//         this.email = email;
//         this.displayName = displayName;
//         this.imageURL = imageURL;
//     }

//     // to json
//     toJSON() {
//         return {
//             uid: this.uid,
//             email: this.email,
//             displayName: this.displayName,
//             imageURL: this.imageURL,
//         };
//     }
// }

exports.getFriendByEmail = functions.https.onCall(async (data, context) => {
    try {
        const user = await admin.auth().getUserByEmail(data.email);
        return {
            uid: user.uid,
            email: user.email,
            displayName: user.displayName,
            imageURL: user.photoURL,
        };
    } catch (error) {
        return null;
    }
});



exports.getFriendByUID = functions.https.onCall(async (data, context) => {
    try {
        const user = await admin.auth().getUser(data.uid);
        return {
            uid: user.uid,
            email: user.email,
            displayName: user.displayName,
            imageURL: user.photoURL,
        };
    } catch (error) {
        return null;
    }
});
