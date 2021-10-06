import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:sported_app/data/models/ourUser.dart';

class AuthRepo {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  AuthRepo();

  Future<UserModel> getUser() async {
    var firebaseUser = await _auth.currentUser;
    return UserModel(uid: firebaseUser.uid);
  }

  Stream<UserModel> get user {
    return _auth.authStateChanges().map((firebaseUser) {
      return firebaseUser == null ? UserModel.empty : firebaseUser.toUser;
    });
  }

  UserModel _userFromFirebaseUser(User user) {
    return user != null ? UserModel(uid: user.uid) : null;
  }

  Future<UserModel> signInWithEmailAndPassword(String email, String password) async {
    var authResult = await _auth.signInWithEmailAndPassword(email: email, password: password);
    return UserModel(uid: authResult.user.uid, username: authResult.user.displayName);
  }

  Future signUpWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User firebaseUser = result.user;
      return _userFromFirebaseUser(firebaseUser);
    } catch (e) {
      print(e.toString());
    }
  }

  Future resetPassword(String email) async {
    try {
      return await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      print(e.toString());
    }
  }

  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<String> deleteAccountAndProfileData() async {
    try {
      final userProfileRef = FirebaseFirestore.instance.collection("userProfile");
      await userProfileRef.doc(_auth.currentUser.uid).delete();
      await _auth.currentUser.delete();

      return "Deleted Successfully";
    } catch (_) {
      print("delete account error | $_");
      return _;
    }
  }
}

//user details to firebase User
extension on firebase_auth.User {
  UserModel get toUser {
    return UserModel(uid: uid, email: email, username: displayName, avatarUrl: photoURL);
  }
}
