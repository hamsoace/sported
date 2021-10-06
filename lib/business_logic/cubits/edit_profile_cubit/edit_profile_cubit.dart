import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:sported_app/data/models/UserProfile.dart';
import 'package:sported_app/data/services/user_controller.dart';

import '../../../locator.dart';

part 'edit_profile_state.dart';

class EditProfileCubit extends Cubit<EditProfileState> {
  EditProfileCubit() : super(EditProfileInitial());

  //load
  Future<void> getUserProfile() async {
    try {
      emit(EditProfileLoadInProgress());
      final userProfile = await locator.get<UserController>().loadUserProfile();
      print("user | ${userProfile.fullName} ");
      emit(EditProfileLoadSuccess(userProfile: userProfile));
    } catch (_) {
      emit(EditProfileLoadFailure());
      print("get User Profile Error | $_");
    }
  }

  //update / upload
  Future<void> updateUserProfile({
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
    try {
      emit(EditProfileLoadInProgress());
      uid = firebase_auth.FirebaseAuth.instance.currentUser.uid;
      UserProfile uploadProfile = UserProfile();
      final userProfileRef = FirebaseFirestore.instance.collection("userProfile");
      uploadProfile = UserProfile(
        fullName: fullName,
        age: age,
        gender: gender,
        clubA: clubA,
        clubB: clubB,
        clubC: clubC,
        pasteUrl: pasteUrl,
        buddy: buddy,
        coach: coach,
        email: email,
        uid: uid,
        sportsPlayed: sportsPlayed,
        verifiedClubs: verifiedClubs,
      );
      final profileMapData = uploadProfile.toJson();
      await userProfileRef.doc(uid).set(profileMapData).catchError((e) => print("error uploading Profile | $e"));
      final userProfile = await locator.get<UserController>().loadUserProfile();
      emit(EditProfileLoadSuccess(userProfile: userProfile));
      print("updatedUser | ${userProfile.fullName} ");
    } catch (_) {
      emit(EditProfileLoadFailure());
      print("get updated profile error | $_");
    }
  }
}
