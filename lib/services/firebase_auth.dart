import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ghost_vpn/models/firestore_user.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Users {
  final String uid;
  final String name;
  final String email;

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
  Future<void> resetPasswordUsingEmail(String email);
  Future<void> signOut();
  Future<void> sendVerificationEmail();
  Future<UserCredential> signInWithGoogle();
}

class Auth implements AuthBase {
  final _firebaseAuth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  Users _userFromFirebase(User user) {
    // ignore: unnecessary_null_comparison
    if (user == null) {
      print('There is no users with uid');
      return null;
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
    await user.sendEmailVerification();
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
    await _firebaseAuth.currentUser.reload();
    final newUser = FirestoreUser(
      idUser: _firebaseAuth.currentUser.uid,
      email: _firebaseAuth.currentUser.email,
      isPaid: false,
      isPromo: false,
      lastCreationTime: DateTime.now(),
    );
    await _firestore.collection('users').add(newUser.toMap());
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
  Future<UserCredential> signInWithGoogle() async {
    final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser?.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }
}
