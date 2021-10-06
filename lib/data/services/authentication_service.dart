import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sported_app/data/models/UserProfile.dart';
import 'package:sported_app/data/models/ourUser.dart';
import 'package:sported_app/data/repositories/auth_repo.dart';
import 'package:sported_app/locator.dart';

class AuthenticationService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  AuthRepo _authRepo = locator.get<AuthRepo>();
  UserModel userModel = UserModel();
  UserProfile userProfile = UserProfile();

  UserModel _currentUser;

  final userRef = FirebaseFirestore.instance.collection("users");
  final userProfileRef = FirebaseFirestore.instance.collection("userProfile");

  Stream<User> get authStateChanges => _auth.authStateChanges();

  //1
  Future<dynamic> signIn({String email, String password}) async {
    try {
      _currentUser = await _authRepo.signInWithEmailAndPassword(email, password);

      return "Logged In Successfully";
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return "No user found for that email.";
      } else if (e.code == 'wrong-password') {
        return "Wrong password provided for that user.";
      } else {
        return "Something Went Wrong.";
      }
    }
  }

  //2
  // ignore: missing_return
  Future<String> signUp({String email, String password, String fullName}) async {
    try {
      await _auth.createUserWithEmailAndPassword(email: email, password: password);
      await _auth.currentUser.updateProfile(displayName: fullName);
      await _auth.currentUser.sendEmailVerification();
      return "Registered Successfully";
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return "The password provided is too weak.";
      } else if (e.code == 'email-already-in-use') {
        return "The account already exists for that email.";
      } else {
        return "Something Went Wrong.";
      }
    } catch (e) {
      print(e);
    }
  }

  //3
  // Future<void> addUserToDB({String uid, String username, String email}) async {
  //   userProfile = UserProfile(uid: uid, fullName: username, email: email);
  //   await userProfileRef.doc(uid).set(userProfile.toMap(userProfile)).catchError((e) {
  //     print(e);
  //   });
  // }

  //4
  Future<UserModel> getUserFromDB({String uid}) async {
    final DocumentSnapshot doc = await userRef.doc(uid).get();

    print(doc.data());

    // return UserModel.fromMap(doc.data());
    return UserModel(
      email: _auth.currentUser.email,
      uid: _auth.currentUser.uid,
      username: _auth.currentUser.displayName,
      avatarUrl: _auth.currentUser.photoURL,
    );
  }

  Future<String> deleteAccount() async {
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

  Future<String> signOut() async {
    try {
      await _auth.signOut();
      return "Signed Out Successfully";
    } catch (_) {
      return _;
    }
  }
}
