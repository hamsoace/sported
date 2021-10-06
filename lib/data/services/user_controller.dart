import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sported_app/data/models/UserProfile.dart';
import 'package:sported_app/data/models/ourUser.dart';
import 'package:sported_app/data/repositories/auth_repo.dart';
import 'package:sported_app/data/repositories/storage_repo.dart';
import 'package:sported_app/locator.dart';

class UserController {
  FirebaseAuth auth = FirebaseAuth.instance;
  final userRef = FirebaseFirestore.instance.collection("users");
  final userProfileRef = FirebaseFirestore.instance.collection("userProfile");
  UserModel userModel = UserModel();
  UserProfile userProfile = UserProfile();
  UserModel _currentUser;

  AuthRepo _authRepo = locator.get<AuthRepo>();
  StorageRepo _storageRepo = locator.get<StorageRepo>();

  Future init;

  UserController() {
    init = initUser();
  }

  Future<UserModel> initUser() async {
    _currentUser = await _authRepo.getUser();
    return _currentUser;
  }

  UserModel get currentUser => _currentUser;

  Future<void> uploadProfilePicture(File image) async {
    print("before | ${auth.currentUser.photoURL}");

    auth.currentUser.updateProfile(photoURL: await locator.get<StorageRepo>().uploadFile(image));

    print("after | ${auth.currentUser.photoURL}");
  }

  Future<String> getDownloadUrl() async {
    return await _storageRepo.getUserProfileImage(currentUser.uid);
  }

  Future<dynamic> signInWithEmailAndPassword({String email, String password}) async {
    try {
      _currentUser = await _authRepo.signInWithEmailAndPassword(email, password);

      return "Logged In Successfully";
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return "User not registered. Sign Up to create a new account.";
      } else if (e.code == 'wrong-password') {
        return "Wrong email or password entered!";
      } else {
        return "Something Went Wrong.";
      }
    }
  }

  // Future<UserModel> getUserFromDB() async {
  //   final DocumentSnapshot doc = await userRef.doc(currentUser.uid).get();
  //
  //   print("doc.data | ${doc.data()}");
  //
  //   print(auth.currentUser.email);
  //   print(auth.currentUser.uid);
  //   print(auth.currentUser.displayName);
  //
  //   // return UserModel.fromMap(doc.data());
  //   return UserModel(
  //     email: auth.currentUser.email,
  //     uid: auth.currentUser.uid,
  //     username: auth.currentUser.displayName,
  //   );
  // }

  // ignore: missing_return
  Future<UserProfile> uploadProfile({
    String uid,
    String fullName,
    String email,
    String age,
    String gender,
    String clubA,
    String clubB,
    String clubC,
    String pasteUrl,
    String buddy,
    String coach,
    List<String> sportsPlayed,
    List<String> verifiedClubs,
  }) async {
    userProfile = UserProfile(
      age: age,
      gender: gender,
      clubA: clubA,
      clubB: clubB,
      sportsPlayed: sportsPlayed,
      verifiedClubs: verifiedClubs,
      clubC: clubC,
      pasteUrl: pasteUrl,
      buddy: buddy,
      coach: coach,
    );
    final userMapData = userProfile.toJson();
    await userProfileRef.doc(_currentUser.uid).set(userMapData).catchError((e) {
      print(e);
    });
  }

  Future<UserProfile> loadUserProfile() async {
    final userProfileRef = FirebaseFirestore.instance.collection("userProfile");
    try {
      final userProfile = await userProfileRef.doc(auth.currentUser.uid).get().then((value) => UserProfile.fromJson(value.data()));
      return userProfile;
    } catch (_) {
      print("load profile error | $_");
      return _;
    }
    // final userProfile = await userProfileRef.doc(auth.currentUser.uid).get().then((value) => UserProfile.fromJson(value.data()));
    // final userProfileFromJson = userProfileRef.get().then((value) => value.docs.map((e) => UserProfile.fromJson(e.data())).toList());
    // final allUsers = await userProfileFromJson;
    // final filteredUsers = allUsers.where((element) => element.uid == auth.currentUser.uid).toList();
    // final userProfile = filteredUsers[0];
  }
}
