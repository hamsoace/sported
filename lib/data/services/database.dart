import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  getUserByUid(String username) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .where("name", isEqualTo: username)
        .get();
  }

  getUserByUserEmail(String userEmail) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .where("email", isEqualTo: userEmail)
        .get();
  }

  uploadUserInfo(userMap) {
    FirebaseFirestore.instance.collection("users").add(userMap).catchError((e) {
      print(e.toString());
    });
  }

  createUserProfile(String userId, userInfoMap) {
    FirebaseFirestore.instance
        .collection("UserProfiles")
        .doc(userId)
        .set(userInfoMap)
        .catchError((e) {
      print(e.toString());
    });
  }

  getProfileByUid(String uid) async {
    return await FirebaseFirestore.instance
        .collection("UserProfiles")
        .where("uid", isEqualTo: uid)
        .get();
  }
}
