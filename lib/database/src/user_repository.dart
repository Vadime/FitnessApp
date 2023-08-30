part of 'database.dart';

extension on auth.FirebaseAuthException {
  String readable() {
    switch (code) {
      case 'invalid-email':
        return 'Die E-Mail-Adresse ist ungültig.';
      case 'wrong-password':
        return 'Das Passwort ist falsch.';
      case 'user-not-found':
        return 'Es wurde kein Benutzer mit dieser E-Mail-Adresse gefunden.';
      case 'user-disabled':
        return 'Dieser Benutzer wurde deaktiviert.';
      case 'too-many-requests':
        return 'Zu viele Anfragen. Versuchen Sie es später erneut.';
      case 'operation-not-allowed':
        return 'Diese Operation ist nicht erlaubt.';
      case 'email-already-in-use':
        return 'Es existiert bereits ein Benutzer mit dieser E-Mail-Adresse.';
      case 'weak-password':
        return 'Das Passwort ist zu schwach.';
      case 'invalid-phone-number':
        return 'Die Telefonnummer ist ungültig.';
      case 'invalid-verification-code':
        return 'Der Verifizierungscode ist ungültig.';
      case 'network-request-failed':
        return 'Netzwerkfehler. Versuchen Sie es später erneut.';
      default:
        return 'Ein unbekannter Fehler ist aufgetreten.';
    }
  }
}

// firestore Exceptions
extension on core.FirebaseException {
  String readable() {
    switch (code) {
      case 'permission-denied':
        return 'Keine Berechtigung.';
      case 'unavailable':
        return 'Nicht verfügbar.';
      case 'cancelled':
        return 'Abgebrochen.';
      case 'unknown':
        return 'Ein unbekannter Fehler ist aufgetreten.';
      default:
        return 'Ein unbekannter Fehler ist aufgetreten.';
    }
  }
}

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
      checkAuthenticationState();
    } on auth.FirebaseAuthException catch (e) {
      throw e.readable();
    } catch (_) {}

    return currentUser;
  }

  static Future<void> loginWithPhoneNumber({
    required String phoneNumber,
    required Function(String verificationId, int? token) onCodeSent,
    required Function(String error) onFailed,
  }) async {
    try {
      await _authInstance.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (credential) async {
          await _authInstance.signInWithCredential(credential);
          checkAuthenticationState();
        },
        verificationFailed: (e) {
          Logging.log(e.toString());
          onFailed(e.message ?? 'Unknown error');
        },
        codeSent: onCodeSent,
        codeAutoRetrievalTimeout: (_) {},
      );
    } on auth.FirebaseAuthException catch (e) {
      throw e.readable();
    } catch (_) {}
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
      await _authInstance.signInWithCredential(credential);
      checkAuthenticationState();
    } on auth.FirebaseAuthException catch (e) {
      throw e.readable();
    } catch (_) {}
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
      checkAuthenticationState();
    } on auth.FirebaseAuthException catch (e) {
      throw e.readable();
    } catch (_) {}

    return currentUser;
  }

  // email senden, um das Passwort zurückzusetzen
  static Future<void> sendPasswordResetEmail({
    required String email,
  }) async {
    try {
      return await _authInstance.sendPasswordResetEmail(email: email);
    } on auth.FirebaseAuthException catch (e) {
      throw e.readable();
    } catch (_) {}
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
    if (user == null) {
      return null;
    }
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
      UserRepository.fromFirebaseAuth(_authInstance.currentUser);

  // gibt displayName zurück
  static String? get currentUserName => _authInstance.currentUser?.displayName;

  // gibt email zurück
  static ContactMethod? get currentUserContact => currentUser?.contactAdress;

  // gibt email zurück
  static String? get currentUserEmail => _authInstance.currentUser?.email;

  // gibt phone zurück
  static String? get currentUserPhone => _authInstance.currentUser?.phoneNumber;

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
    required ContactType contactType,
    required String contactValue,
  }) async {
    try {
      if (contactType == ContactType.email) {
        await _authInstance.currentUser?.updateEmail(contactValue);
      }
      await _authInstance.currentUser?.updateDisplayName(displayName);
      await _authInstance.currentUser?.reload();
    } on auth.FirebaseAuthException catch (e) {
      throw e.readable();
    } catch (_) {}
  }

  // aktualisiert imageURL
  static Future<void> updateCurrentUserImage({
    required Uint8List image,
  }) async {
    try {
      String imageRef = 'user/${_authInstance.currentUser?.uid}/profileImage';
      var snapshot = await _storageInstance.ref(imageRef).putData(image);
      var imageURL = await snapshot.ref.getDownloadURL();
      await _authInstance.currentUser?.updatePhotoURL(imageURL);
      await _authInstance.currentUser?.reload();
    } catch (e) {
      throw e.toString().split('] ').last;
    }
  }

  // loggt den User aus
  static Future<void> signOutCurrentUser() async {
    await _authInstance.signOut();
    checkAuthenticationState();
  }

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

  static Future<List<Exercise>> get currentUserCustomExercisesAsFuture async =>
      (await firestore.FirebaseFirestore.instance
              .collection('users')
              .doc(UserRepository.currentUserUID)
              .collection('exercises')
              .get())
          .docs
          .map(
            (e) => Exercise.fromJson(e.id, e.data()),
          )
          .toList();

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
    WorkoutStatistic statistic,
  ) async {
    await firestore.FirebaseFirestore.instance
        .collection('users')
        .doc(UserRepository.currentUserUID)
        .collection('workoutStatistics')
        .add(statistic.toJson());
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
    checkAuthenticationState();
  }

  static Future<void> deleteUserWorkout(Workout workout) async {
    await firestore.FirebaseFirestore.instance
        .collection('users')
        .doc(UserRepository.currentUserUID)
        .collection('workouts')
        .doc(workout.uid)
        .delete();
  }

  static Future<List<WorkoutStatistic>> getWorkoutDatesStatistics([
    String? uid,
  ]) async {
    uid ??= currentUserUID;
    var res = await firestore.FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('workoutStatistics')
        .get();
    var workouts =
        res.docs.map((e) => WorkoutStatistic.fromJson(e.id, e.data())).toList();
    workouts.sort((a, b) => a.dateTime.compareTo(b.dateTime));
    return workouts;
  }

  static Future<void> addFavoriteExercise(String exerciseUID) async {
    await firestore.FirebaseFirestore.instance
        .collection('users')
        .doc(UserRepository.currentUserUID)
        .update({
      'favoriteExercises': firestore.FieldValue.arrayUnion([exerciseUID]),
    });
  }

  static Future<void> removeFavoriteExercise(String exerciseUID) async {
    await firestore.FirebaseFirestore.instance
        .collection('users')
        .doc(UserRepository.currentUserUID)
        .update({
      'favoriteExercises': firestore.FieldValue.arrayRemove([exerciseUID]),
    });
  }

  static Future<Friend> addFriendByEmail(String email) async {
    Friend? friend = await functions.FirebaseFunctions.instance
        .httpsCallable('getFriendByEmail')
        .call({
          'email': email,
        })
        .then((value) => value.data)
        .then((map) => map == null ? null : Friend.fromJson(map));

    if (friend == null) throw 'User with $email not found 😢';

    await addFriend(friend);

    return friend;
  }

  static Future<Friend> addFriendByPhone(String phone) async {
    Friend? friend = await functions.FirebaseFunctions.instance
        .httpsCallable('getFriendByPhone')
        .call({
          'phone': phone,
        })
        .then((value) => value.data)
        .then((map) => map == null ? null : Friend.fromJson(map));

    if (friend == null) throw 'User with $phone not found 😢';

    await addFriend(friend);

    return friend;
  }

  static Future<void> addFriend(Friend friend) async {
    await firestore.FirebaseFirestore.instance
        .collection('users')
        .doc(UserRepository.currentUserUID)
        .set(
      {
        'friends': firestore.FieldValue.arrayUnion([friend.uid]),
      },
      firestore.SetOptions(mergeFields: ['friends']),
    );
  }

  static Future<void> removeFriend(Friend friend) async {
    await firestore.FirebaseFirestore.instance
        .collection('users')
        .doc(UserRepository.currentUserUID)
        .update({
      'friends': firestore.FieldValue.arrayRemove([friend.uid]),
    });
  }

  static Future<List<Friend>> getFriends() async {
    var friendStrs = (await firestore.FirebaseFirestore.instance
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
        friend = await functions.FirebaseFunctions.instance
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
  }

  static Future<void> checkAuthenticationState() async {
    if (UserRepository.currentUser != null) {
      await UserRepository.refreshUserRole();
      AuthenticationController().login();
    } else {
      AuthenticationController().logout();
    }
  }

  static Future<void> uploadUsersExercise(Exercise exercise) async {
    await firestore.FirebaseFirestore.instance
        .collection('users')
        .doc(UserRepository.currentUserUID)
        .collection('exercises')
        .doc(exercise.uid)
        .set(exercise.toJson());
  }

  static Future<void> deleteUsersExercise(Exercise exercise) async {
    await firestore.FirebaseFirestore.instance
        .collection('users')
        .doc(UserRepository.currentUserUID)
        .collection('exercises')
        .doc(exercise.uid)
        .delete();
  }
}
