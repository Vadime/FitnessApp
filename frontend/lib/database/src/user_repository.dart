part of 'database.dart';

class UserRepository {
  static auth.FirebaseAuth get _authInstance => auth.FirebaseAuth.instance;

  static firestore.FirebaseFirestore get _storeInstance =>
      firestore.FirebaseFirestore.instance;

  static functions.FirebaseFunctions get _functionsInstance =>
      functions.FirebaseFunctions.instance;

  static storage.FirebaseStorage get _storageInstance =>
      storage.FirebaseStorage.instance;

  // loggt den User ein
  static Future<User?> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      await _authInstance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      Logging.log('Versucht Sign In');
    } catch (e) {
      throw e.toString().split('] ').last;
    }

    return currentUser;
  }

  // registriert den User
  static Future<User?> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      var cred = await _authInstance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      // firebase function aufrufen um user role zu setzen
      var value = await _functionsInstance.httpsCallable('addUserRole').call({
        'uid': cred.user!.uid,
      });
      // auf fehler von firebase function prüfen
      if (value.data['error'] != null) throw Exception(value.data['error']);
      Logging.log('Versucht Sign Up');
    } catch (e) {
      throw e.toString().split('] ').last;
    }
    return currentUser;
  }

  // email senden, um das Passwort zurückzusetzen
  static Future<void> sendPasswordResetEmail({
    required String email,
  }) async {
    try {
      return await _authInstance.sendPasswordResetEmail(email: email);
    } catch (e) {
      throw e.toString().split('] ').last;
    }
  }

  // gibt die aktuelle Authentifizierung zurück
  static Stream<User?> get authStateChanges =>
      auth.FirebaseAuth.instance.authStateChanges().map((user) {
        Logging.setUserId(user?.uid);
        return UserRepository.fromFirebaseAuth(user);
      });

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
    if (user == null) {
      return null;
    }
    return User(
      uid: user.uid,
      email: user.email ?? '-',
      displayName: user.displayName ?? '-',
      userRole: UserRole.user,
      imageURL: user.photoURL,
    );
  }

  // gibt den aktuellen User zurück
  static User? get currentUser =>
      UserRepository.fromFirebaseAuth(_authInstance.currentUser);

  // gibt displayName zurück
  static String? get currentUserName => _authInstance.currentUser?.displayName;

  // gibt email zurück
  static String? get currentUserEmail => _authInstance.currentUser?.email;

  // gibt uid zurück
  static String? get currentUserUID => _authInstance.currentUser?.uid;

  static UserRole? _userRole;

  static UserRole? get currentUserRole => _userRole;

  static String? get currentUserImageURL => _authInstance.currentUser?.photoURL;

  // get claims
  static Future<Map<String, dynamic>> getCurrentUserClaims() async {
    var res = await _authInstance.currentUser?.getIdTokenResult();
    return res?.claims ?? {};
  }

  // gibt die Rolle des Users zurück
  static Future<void> refreshUserRole() async {
    var claims = await getCurrentUserClaims();
    _userRole = roleFromString(claims['role']);
  }

  // aktualisiert den displayName und die email
  static Future<void> updateCurrentUserProfile({
    required String? displayName,
    required String email,
  }) async {
    try {
      await _authInstance.currentUser?.updateEmail(email);
      await _authInstance.currentUser?.updateDisplayName(displayName);
    } catch (e) {
      throw e.toString().split('] ').last;
    }
  }

  // aktualisiert imageURL
  static Future<void> updateCurrentUserImage({
    required File image,
  }) async {
    try {
      String imageRef = 'user/${_authInstance.currentUser?.uid}/profileImage';
      var snapshot = await _storageInstance.ref(imageRef).putFile(image);
      var imageURL = await snapshot.ref.getDownloadURL();
      await _authInstance.currentUser?.updatePhotoURL(imageURL);
    } catch (e) {
      throw e.toString().split('] ').last;
    }
  }

  // loggt den User aus
  static Future<void> signOutCurrentUser() async =>
      await _authInstance.signOut();

  static Stream<List<String>> get currentUserFavoriteExercises =>
      _storeInstance.collection('users').doc(currentUserUID).snapshots().map(
            (event) =>
                (event.data()?['favoriteExercises'] as List<dynamic>?)
                    ?.map((e) => e.toString())
                    .toList() ??
                [],
          );

  static Future<List<String>> get currentUserFavoriteExercisesAsFuture async =>
      ((await _storeInstance.collection('users').doc(currentUserUID).get())
              .data()?['favoriteExercises'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList() ??
      [];

  static Stream<List<Workout>> get currentUserCustomWorkouts => firestore
      .FirebaseFirestore.instance
      .collection('users')
      .doc(UserRepository.currentUserUID)
      .collection('workouts')
      .snapshots()
      .map(
        (event) =>
            event.docs.map((e) => Workout.fromJson(e.id, e.data())).toList(),
      );
  static Future<List<Workout>> get currentUserCustomWorkoutsAsFuture async =>
      (await firestore.FirebaseFirestore.instance
              .collection('users')
              .doc(UserRepository.currentUserUID)
              .collection('workouts')
              .get())
          .docs
          .map(
            (e) => Workout.fromJson(e.id, e.data()),
          )
          .toList();

  static Future<void> updateCurrentUserPassword(
    String oldPassword,
    String newPassword,
  ) async {
    try {
      await _authInstance.currentUser?.reauthenticateWithCredential(
        auth.EmailAuthProvider.credential(
          email: currentUserEmail ?? '',
          password: oldPassword,
        ),
      );
      await _authInstance.currentUser?.updatePassword(newPassword);
    } catch (e) {
      throw e.toString().split('] ').last;
    }
  }

  static Future<void> copyToPersonalWorkouts(Workout workout) async {
    await firestore.FirebaseFirestore.instance
        .collection('users')
        .doc(UserRepository.currentUserUID)
        .collection('workouts')
        .add(workout.toJson());
  }

  static Future<void> saveWorkoutStatistics(
    Workout workout,
    WorkoutDifficulty difficulty,
  ) async {
    await firestore.FirebaseFirestore.instance
        .collection('users')
        .doc(UserRepository.currentUserUID)
        .collection('workoutStatistics')
        .add({
      'uid': workout.uid,
      'difficulty': difficulty.name,
      'date': DateTime.now().formattedDate,
    });
  }

  static Future<void> updateUsersWorkout(Workout workout) async {
    await firestore.FirebaseFirestore.instance
        .collection('users')
        .doc(UserRepository.currentUserUID)
        .collection('workouts')
        .doc(workout.uid)
        .update(workout.toJson());
  }

  static Future<void> addUsersWorkout(Workout workout) async {
    await firestore.FirebaseFirestore.instance
        .collection('users')
        .doc(UserRepository.currentUserUID)
        .collection('workouts')
        .add(workout.toJson());
  }

  static deleteUser(String password) async {
    await auth.FirebaseAuth.instance.currentUser?.reauthenticateWithCredential(
      auth.EmailAuthProvider.credential(
        email: currentUserEmail ?? '',
        password: password,
      ),
    );
    await auth.FirebaseAuth.instance.currentUser?.delete();
  }

  static Future<void> deleteUserWorkout(Workout workout) async {
    await firestore.FirebaseFirestore.instance
        .collection('users')
        .doc(UserRepository.currentUserUID)
        .collection('workouts')
        .doc(workout.uid)
        .delete();
  }

  static Future<List<DateTime>> getWorkoutDatesStatistics([String? uid]) async {
    uid ??= currentUserUID;
    var res = await firestore.FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('workoutStatistics')
        .get();
    var dates = res.docs
        .map(
          (e) => (e.data()['date'] ?? DateTime.now().formattedDate)
              .toString()
              .toDateTime(),
        )
        .toList();
    dates.sort((a, b) => a.compareTo(b));
    return dates;
  }

  static Future<void> addFavoriteExercise(String exerciseUID) async {
    await firestore.FirebaseFirestore.instance
        .collection('users')
        .doc(UserRepository.currentUserUID)
        .update({
      'favoriteExercises': firestore.FieldValue.arrayUnion([exerciseUID])
    });
  }

  static Future<void> removeFavoriteExercise(String exerciseUID) async {
    await firestore.FirebaseFirestore.instance
        .collection('users')
        .doc(UserRepository.currentUserUID)
        .update({
      'favoriteExercises': firestore.FieldValue.arrayRemove([exerciseUID])
    });
  }

  static Future<Friend> addFriend(String email) async {
    Friend? friend = await functions.FirebaseFunctions.instance
        .httpsCallable('getFriendByEmail')
        .call({
          'email': email,
        })
        .then((value) => value.data)
        .then(
          (map) => map == null
              ? null
              : Friend(
                  uid: map['uid'],
                  displayName: map['displayName'],
                  email: map['email'],
                  imageURL: map['imageURL'],
                ),
        );

    if (friend == null) throw 'User not found';

    await firestore.FirebaseFirestore.instance
        .collection('users')
        .doc(UserRepository.currentUserUID)
        .set({
      'friends': firestore.FieldValue.arrayUnion([friend.uid])
    });
    return friend;
  }

  static Future<void> removeFriend(String uid) async {
    await firestore.FirebaseFirestore.instance
        .collection('users')
        .doc(UserRepository.currentUserUID)
        .update({
      'friends': firestore.FieldValue.arrayRemove([uid])
    });
  }

  static Future<List<Friend>> getFriends() async {
    var friendStrs = (await firestore.FirebaseFirestore.instance
            .collection('users')
            .doc(UserRepository.currentUserUID)
            .get())
        .data()?['friends'] as List<dynamic>?;

    if (friendStrs == null) return [];

    List<Friend> friends = [];
    for (String uid in friendStrs) {
      Friend? friend;
      try {
        friend = await functions.FirebaseFunctions.instance
            .httpsCallable('getFriendByUID')
            .call({
              'uid': uid,
            })
            .then((value) => value.data)
            .then(
              (map) => Friend(
                uid: map['uid'],
                displayName: map['displayName'],
                email: map['email'],
                imageURL: map['imageURL'],
              ),
            );
      } catch (_) {}

      if (friend != null) friends.add(friend);
    }

    return friends;
  }
}
