import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:ghost_vpn/models/firestore_user.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:path_provider/path_provider.dart';
// import 'package:google_sign_in/google_sign_in.dart';

class Users {
  String? uid;
  String? name;
  String? email;

  Users({
    this.uid,
    this.name,
    this.email,
  });
}

abstract class AuthBase {
  Stream<Users> get authStateChanges;
  Future<Users> currentUser();
  Future<Users> signInWithEmailAndPassword(String email, String password);
  Future<Users> createUserWithEmailAndPassword(
    String email,
    String password,
  );
  Future<void> completePayment(String descr);
  Future<void> resetPasswordUsingEmail(String email);
  Future<void> signOut();
  Future<Users> signInWithGoogle();
  Future<void> sendVerificationEmail();
  Future<String> getFirebaseDocuments(String configName, String type, String nameOfDoc);
}

class Auth implements AuthBase {
  final _firebaseAuth = FirebaseAuth.instance;
  final _firebaseStorage = FirebaseStorage.instance;
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  dynamic chatDocId;

  Users _userFromFirebase(User? user) {
    if (user == null) {
      print('There is no users with uid');
      return Users();
    } else {
      return Users(
        uid: user.uid,
        name: user.displayName,
        email: user.email,
      );
    }
  }

  @override
  Future<void> sendVerificationEmail() async {
    final user = _firebaseAuth.currentUser;
    await user!.sendEmailVerification();
  }

  @override
  Stream<Users> get authStateChanges {
    return _firebaseAuth.authStateChanges().map(_userFromFirebase);
  }

  @override
  Future<Users> currentUser() async {
    final user = _firebaseAuth.currentUser;
    return _userFromFirebase(user);
  }

  @override
  Future<Users> signInWithEmailAndPassword(
      String email, String password) async {
    final authResult = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    return _userFromFirebase(authResult.user);
  }

  @override
  Future<Users> createUserWithEmailAndPassword(
      String email, String password) async {
    final authResult = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    await _firebaseAuth.currentUser!.reload();
    final newUser = FirestoreUser(
      idUser: _firebaseAuth.currentUser!.uid,
      email: _firebaseAuth.currentUser!.email!,
      isPromo: '-1',
      lastCreationTime: DateTime.now(),
    );
    await users.add(newUser.toMap());
    return _userFromFirebase(authResult.user);
  }

  @override
  Future<void> resetPasswordUsingEmail(String email) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  @override
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  @override
  Future<Users> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser!.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    final authResult =
        await FirebaseAuth.instance.signInWithCredential(credential);

    await users
        .where('email', isEqualTo: authResult.user!.email)
        .limit(1)
        .get()
        .then((snapshot) async {
      if (snapshot.docs.isNotEmpty) {
        chatDocId = snapshot.docs.single.id;
        print('-------chatDocId google: $chatDocId');
      } else {
        await _firebaseAuth.currentUser!.reload();
        final newUser = FirestoreUser(
          idUser: _firebaseAuth.currentUser!.uid,
          email: _firebaseAuth.currentUser!.email!,
          isPromo: '-1',
          lastCreationTime: DateTime.now(),
        );
        await users.add(newUser.toMap()).then((value) {
          chatDocId = value;
        });
      }
    }).catchError((error) {
      print(error);
    });
    return _userFromFirebase(authResult.user);
  }

  @override
  Future<void> completePayment(String descr) async {
    try {
      DateTime promoTime = DateTime.now();
      int expDay = promoTime.day;
      int expMonth = promoTime.month;
      int expYear = promoTime.year;
      switch (descr) {
        case 'Подписка на месяц':
          expDay = promoTime.day + 31;
          break;
        case 'Подписка на полгода':
          expMonth = promoTime.month + 6;
          break;
        case 'Подписка на год':
          expYear = promoTime.year + 1;
          break;
      }
      DateTime expTime = DateTime(expYear, expMonth, expDay);
      await users
          .where('email', isEqualTo: _firebaseAuth.currentUser!.email)
          .limit(1)
          .get()
          .then((snapshot) async {
        if (snapshot.docs.isNotEmpty) {
          chatDocId = snapshot.docs.single.id;
          await users.doc(chatDocId).update({
            'isPromo': "2",
            'promoStartedTime': Utils.fromDateTimeToJson(promoTime),
            'promoExpirationTime': Utils.fromDateTimeToJson(expTime),
          });
        }
      });
    } catch (error) {
      print(error);
    }
  }

  @override
  Future<String> getFirebaseDocuments(String configName, String type, String nameOfDoc) async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/${configName}.$type');
    await _firebaseStorage.ref('$nameOfDoc/${configName}.$type').writeToFile(file);
    return file.path;
  }
}
