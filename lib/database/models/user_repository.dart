part of '../modules/database.dart';

class UserRepository {
  // loggt den User ein
  static Future<User?> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      await Auth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      await checkAuthenticationState();
      return currentUser;
    } catch (e, s) {
      throw handleException(e, s);
    }
  }

  static Future<void> loginWithPhoneNumber({
    required String phoneNumber,
    required Function(String verificationId, int? token) onCodeSent,
    required Function(String error) onFailed,
  }) async {
    try {
      await Auth.instance.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (credential) async {
          await Auth.instance.signInWithCredential(credential);
          await checkAuthenticationState();
        },
        verificationFailed: (e) => onFailed(handleException(e)),
        codeSent: onCodeSent,
        codeAutoRetrievalTimeout: (_) {},
      );
    } catch (e, s) {
      throw handleException(e, s);
    }
  }

  static Future<void> verifyPhoneCode({
    required String verificationId,
    required String smsCode,
  }) async {
    try {
      var credential = auth.PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );
      await Auth.instance.signInWithCredential(credential);
      await checkAuthenticationState();
    } catch (e, s) {
      throw handleException(e, s);
    }
  }

  static Future<void> verifyUpdatedPhoneCode({
    required String verificationId,
    required String smsCode,
  }) async {
    try {
      var credential = auth.PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );
      await Auth.instance.currentUser?.updatePhoneNumber(credential);
    } catch (e, s) {
      throw handleException(e, s);
    }
  }

  // registriert den User
  static Future<User?> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      var cred = await Auth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      // firebase function aufrufen um user role zu setzen
      var value = await Functions.instance.httpsCallable('addUserRole').call({
        'uid': cred.user!.uid,
      });
      // auf fehler von firebase function prüfen
      if (value.data['error'] != null) throw Exception(value.data['error']);
      await checkAuthenticationState();
      return currentUser;
    } catch (e, s) {
      throw handleException(e, s);
    }
  }

  // email senden, um das Passwort zurückzusetzen
  static Future<void> sendPasswordResetEmail({
    required String email,
  }) async {
    try {
      return await Auth.instance.sendPasswordResetEmail(email: email);
    } catch (e, s) {
      throw handleException(e, s);
    }
  }

  // macht die role zum lesbaren String
  static UserRole roleFromString(String? str) {
    switch (str) {
      case 'Admin':
        return UserRole.admin;
      case 'admin':
        return UserRole.admin;
      case 'User':
        return UserRole.user;
      case 'user':
        return UserRole.user;
      default:
        return UserRole.user;
    }
  }

  // from firebaseauth
  static User? fromFirebaseAuth(auth.User? user) {
    if (user == null) return null;

    ContactMethod method;
    if (user.email != null) {
      method = ContactMethod.email(user.email!);
    } else if (user.phoneNumber != null) {
      method = ContactMethod.phone(user.phoneNumber!);
    } else {
      method = const ContactMethod.unknown();
    }
    return User(
      uid: user.uid,
      contactAdress: method,
      displayName: user.displayName ?? '-',
      userRole: UserRole.user,
      imageURL: user.photoURL,
    );
  }

  // gibt den aktuellen User zurück
  static User? get currentUser =>
      UserRepository.fromFirebaseAuth(Auth.instance.currentUser);

  // gibt displayName zurück
  static String? get currentUserName => Auth.instance.currentUser?.displayName;

  // gibt email zurück
  static ContactMethod? get currentUserContact => currentUser?.contactAdress;

  // gibt email zurück
  static String? get currentUserEmail => Auth.instance.currentUser?.email;

  // gibt phone zurück
  static String? get currentUserPhone => Auth.instance.currentUser?.phoneNumber;

  // gibt uid zurück
  static String? get currentUserUID => Auth.instance.currentUser?.uid;

  static UserRole? _userRole;

  static UserRole? get currentUserRole => _userRole;

  static String? get currentUserImageURL => Auth.instance.currentUser?.photoURL;

  // get claims
  static Future<Map<String, dynamic>> getCurrentUserClaims() async {
    if (currentUser == null) return {};
    try {
      var res = await Auth.instance.currentUser!.getIdTokenResult();
      return res.claims ?? {};
    } catch (e, s) {
      throw handleException(e, s);
    }
  }

  // gibt die Rolle des Users zurück
  static Future<void> refreshUserRole() async {
    if (currentUser == null) return;
    try {
      var claims = await getCurrentUserClaims();
      _userRole = roleFromString(claims['role']);
    } catch (e, s) {
      throw handleException(e, s);
    }
  }

  static Future<void> updateCurrentUserEmail(String email) async {
    try {
      await Auth.instance.currentUser?.updateEmail(email);
    } catch (e, s) {
      throw handleException(e, s);
    }
  }

  static Future<void> updateCurrentUserPhone({
    required String phoneNumber,
    required Function(String verificationId, int? token) onCodeSent,
    required Function() onCompletion,
    required Function(String error) onFailed,
  }) async {
    try {
      await Auth.instance.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (credential) async {
          await Auth.instance.currentUser?.updatePhoneNumber(credential);
          await onCompletion();
        },
        verificationFailed: (e) => onFailed(handleException(e)),
        codeSent: onCodeSent,
        codeAutoRetrievalTimeout: (_) {},
      );
    } catch (e, s) {
      throw handleException(e, s);
    }
  }

  static Future<void> updateCurrentUserName(String? displayName) async {
    try {
      await Auth.instance.currentUser?.updateDisplayName(displayName);
    } catch (e, s) {
      throw handleException(e, s);
    }
  }

  static Future<void> reloadCurrentUser() async {
    try {
      await Auth.instance.currentUser?.reload();
    } catch (e, s) {
      throw handleException(e, s);
    }
  }

  // aktualisiert imageURL
  static Future<void> updateCurrentUserImage({
    required Uint8List image,
  }) async {
    try {
      String imageRef = 'user/${Auth.instance.currentUser?.uid}/profileImage';
      var snapshot = await Storage.instance.ref(imageRef).putData(image);
      var imageURL = await snapshot.ref.getDownloadURL();
      await Auth.instance.currentUser?.updatePhotoURL(imageURL);
      await Auth.instance.currentUser?.reload();
    } catch (e, s) {
      throw handleException(e, s);
    }
  }

  // loggt den User aus
  static Future<void> signOutCurrentUser() async {
    try {
      await Auth.instance.signOut();
      await checkAuthenticationState();
    } catch (e, s) {
      throw handleException(e, s);
    }
  }

  static Stream<List<String>> get currentUserFavoriteExercises {
    try {
      return Store.instance
          .collection('users')
          .doc(currentUserUID)
          .snapshots()
          .map(
            (event) =>
                (event.data()?['favoriteExercises'] as List<dynamic>?)
                    ?.map((e) => e.toString())
                    .toList() ??
                [],
          );
    } catch (e, s) {
      throw handleException(e, s);
    }
  }

  static Future<List<String>> get currentUserFavoriteExercisesAsFuture async {
    try {
      return ((await Store.instance
                      .collection('users')
                      .doc(currentUserUID)
                      .get())
                  .data()?['favoriteExercises'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [];
    } catch (e, s) {
      throw handleException(e, s);
    }
  }

  static Future<List<Exercise>> get currentUserCustomExercisesAsFuture async {
    try {
      return (await Store.instance
              .collection('users')
              .doc(UserRepository.currentUserUID)
              .collection('exercises')
              .get())
          .docs
          .map(
            (e) => Exercise.fromJson(e.id, e.data()),
          )
          .toList();
    } catch (e, s) {
      throw handleException(e, s);
    }
  }

  static Future<List<Workout>> get currentUserCustomWorkoutsAsFuture async {
    try {
      return (await Store.instance
              .collection('users')
              .doc(UserRepository.currentUserUID)
              .collection('workouts')
              .get())
          .docs
          .map(
            (e) => Workout.fromJson(e.id, e.data()),
          )
          .toList();
    } catch (e, s) {
      throw handleException(e, s);
    }
  }

  static Future<void> updateCurrentUserPassword(
    String oldPassword,
    String newPassword,
  ) async {
    try {
      await Auth.instance.currentUser?.reauthenticateWithCredential(
        auth.EmailAuthProvider.credential(
          email: currentUserEmail ?? '',
          password: oldPassword,
        ),
      );
      await Auth.instance.currentUser?.updatePassword(newPassword);
    } catch (e, s) {
      throw handleException(e, s);
    }
  }

  static Future<void> copyToPersonalWorkouts(Workout workout) async {
    try {
      await Store.instance
          .collection('users')
          .doc(UserRepository.currentUserUID)
          .collection('workouts')
          .add(workout.toJson());
    } catch (e, s) {
      throw handleException(e, s);
    }
  }

  static Future<void> saveWorkoutStatistics(
    WorkoutStatistic statistic,
  ) async {
    try {
      await Store.instance
          .collection('users')
          .doc(UserRepository.currentUserUID)
          .collection('workoutStatistics')
          .add(statistic.toJson());
    } catch (e, s) {
      throw handleException(e, s);
    }
  }

  static Future<void> uploadUsersWorkout(Workout workout) async {
    try {
      await Store.instance
          .collection('users')
          .doc(UserRepository.currentUserUID)
          .collection('workouts')
          .doc(workout.uid)
          .set(workout.toJson(), firestore.SetOptions(merge: true));
    } catch (e, s) {
      throw handleException(e, s);
    }
  }

  static deleteUser(String password) async {
    try {
      await Auth.instance.currentUser?.reauthenticateWithCredential(
        auth.EmailAuthProvider.credential(
          email: currentUserEmail ?? '',
          password: password,
        ),
      );
      await Auth.instance.currentUser?.delete();
      await checkAuthenticationState();
    } catch (e, s) {
      throw handleException(e, s);
    }
  }

  static Future<void> deleteUserWorkout(Workout workout) async {
    try {
      await Store.instance
          .collection('users')
          .doc(UserRepository.currentUserUID)
          .collection('workouts')
          .doc(workout.uid)
          .delete();
    } catch (e, s) {
      throw handleException(e, s);
    }
  }

  static Future<List<WorkoutStatistic>> getWorkoutDatesStatistics([
    String? uid,
  ]) async {
    try {
      uid ??= currentUserUID;
      var res = await Store.instance
          .collection('users')
          .doc(uid)
          .collection('workoutStatistics')
          .orderBy('startTime', descending: true)
          .limit(14)
          .get();
      var workouts = res.docs
          .map((e) => WorkoutStatistic.fromJson(e.id, e.data()))
          .toList();

      return workouts;
    } catch (e, s) {
      throw handleException(e, s);
    }
  }

  static Future<void> addFavoriteExercise(String exerciseUID) async {
    try {
      await Store.instance
          .collection('users')
          .doc(UserRepository.currentUserUID)
          .update({
        'favoriteExercises': firestore.FieldValue.arrayUnion([exerciseUID]),
      });
    } catch (e, s) {
      throw handleException(e, s);
    }
  }

  static Future<void> removeFavoriteExercise(String exerciseUID) async {
    try {
      await Store.instance
          .collection('users')
          .doc(UserRepository.currentUserUID)
          .update({
        'favoriteExercises': firestore.FieldValue.arrayRemove([exerciseUID]),
      });
    } catch (e, s) {
      throw handleException(e, s);
    }
  }

  static Future<Friend> addFriendByEmail(String email) async {
    try {
      Friend? friend = await Functions.instance
          .httpsCallable('getFriendByEmail')
          .call({
            'email': email,
          })
          .then((value) => value.data)
          .then((map) => map == null ? null : Friend.fromJson(map));

      if (friend == null) throw 'User with $email not found 😢';

      await addFriend(friend);

      return friend;
    } catch (e, s) {
      throw handleException(e, s);
    }
  }

  static Future<Friend> addFriendByPhone(String phone) async {
    try {
      Friend? friend = await Functions.instance
          .httpsCallable('getFriendByPhone')
          .call({
            'phone': phone,
          })
          .then((value) => value.data)
          .then((map) => map == null ? null : Friend.fromJson(map));

      if (friend == null) throw 'User with $phone not found 😢';

      await addFriend(friend);

      return friend;
    } catch (e, s) {
      throw handleException(e, s);
    }
  }

  static Future<void> addFriend(Friend friend) async {
    try {
      var list = (await Store.instance
              .collection('users')
              .doc(UserRepository.currentUserUID)
              .get())
          .data()?['friends'] as List<dynamic>?;
      if (list != null) {
        for (var fUid in list) {
          if (friend.uid == UserRepository.currentUserUID) {
            throw 'You can\'t befriend yourself';
          }
          if (fUid == friend.uid) {
            throw 'You already added ${friend.displayName} as a friend';
          }
        }
      }

      await Store.instance
          .collection('users')
          .doc(UserRepository.currentUserUID)
          .set(
        {
          'friends': firestore.FieldValue.arrayUnion([friend.uid]),
        },
        firestore.SetOptions(merge: true),
      );
    } catch (e, s) {
      throw handleException(e, s);
    }
  }

  static Future<void> removeFriend(Friend friend) async {
    try {
      await Store.instance
          .collection('users')
          .doc(UserRepository.currentUserUID)
          .update({
        'friends': firestore.FieldValue.arrayRemove([friend.uid]),
      });
    } catch (e, s) {
      throw handleException(e, s);
    }
  }

  static Future<List<Friend>> getFriends() async {
    try {
      var friendStrs = (await Store.instance
              .collection('users')
              .doc(UserRepository.currentUserUID)
              .get())
          .data()?['friends'] as List<dynamic>?;
      Logging.log(friendStrs);
      if (friendStrs == null) return [];
      List<Friend> friends = [];
      for (String uid in friendStrs) {
        Friend? friend;
        try {
          friend = await Functions.instance
              .httpsCallable('getFriendByUID')
              .call({
                'uid': uid,
              })
              .then((value) => value.data)
              .then((map) => Friend.fromJson(map));
        } catch (e, s) {
          Logging.logDetails('Error loading Friend', e, s);
        }

        if (friend != null) friends.add(friend);
      }

      return friends;
    } catch (e, s) {
      throw handleException(e, s);
    }
  }

  static Future<void> checkAuthenticationState() async {
    try {
      if (UserRepository.currentUser != null) {
        await UserRepository.refreshUserRole();
        AuthenticationController().login();
      } else {
        AuthenticationController().logout();
      }
    } catch (e, s) {
      throw handleException(e, s);
    }
  }

  static Future<Exercise?> getUsersExercise(String uid) async {
    try {
      var e = await Store.instance
          .collection('users')
          .doc(UserRepository.currentUserUID)
          .collection('exercises')
          .doc(uid)
          .get();
      if (e.data() != null) return Exercise.fromJson(uid, e.data()!);
    } catch (e, s) {
      throw handleException(e, s);
    }
    return null;
  }

  static Future<void> uploadUsersExercise(Exercise exercise) async {
    try {
      await Store.instance
          .collection('users')
          .doc(UserRepository.currentUserUID)
          .collection('exercises')
          .doc(exercise.uid)
          .set(exercise.toJson());
    } catch (e, s) {
      throw handleException(e, s);
    }
  }

  static Future<void> deleteUsersExercise(Exercise exercise) async {
    try {
      await Store.instance
          .collection('users')
          .doc(UserRepository.currentUserUID)
          .collection('exercises')
          .doc(exercise.uid)
          .delete();
    } catch (e, s) {
      throw handleException(e, s);
    }
  }
}
