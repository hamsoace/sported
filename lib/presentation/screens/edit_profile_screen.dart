import 'dart:collection';
import 'dart:io';

import 'package:chips_choice/chips_choice.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "package:firebase_auth/firebase_auth.dart" as firebase_auth;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:keyboard_avoider/keyboard_avoider.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:sported_app/business_logic/blocs/nav_bloc/nav_bloc.dart';
import 'package:sported_app/business_logic/cubits/edit_profile_cubit/edit_profile_cubit.dart';
import 'package:sported_app/constants/constants.dart';
import 'package:sported_app/data/models/UserProfile.dart';
import 'package:sported_app/data/models/venue/venue_members_model.dart';
import 'package:sported_app/data/repositories/storage_repo.dart';
import 'package:sported_app/data/services/user_controller.dart';
import 'package:sported_app/presentation/shared/filter_chips/custom_chip_content.dart';
import 'package:sported_app/presentation/shared/form_input_decoration.dart';
import 'package:sported_app/presentation/shared/pages_switcher.dart';

import '../../locator.dart';
import '../shared/custom_snackbar.dart';

class EditProfileScreen extends StatefulWidget {
  static String route = "profile-view";

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  //vars
  File _image;

  //updated
  String updatedAvatarUrl;
  String updatedFullName;
  bool isLoggingOut = false;
  String empty = "";

  //new Data
  String newAge;
  String newGender;
  String newClubA;
  String newClubB;
  String newClubC;
  String newBuddy;
  String newCoach;
  String newCertLink;
  String newMemberID;
  List<String> newSports = [];

  //upload Data
  String uploadAge;
  String uploadClubA;
  String uploadClubB;
  String uploadClubC;
  String uploadCertLink;
  String uploadGender;
  String uploadMemberID;
  String uploadBuddy;
  String uploadCoach;
  Iterable<String> uploadSports;

  //firebase data;
  String firestoreAge;
  String firestoreGender;
  String firestoreCertLink;
  String firestoreClubA;
  String firestoreClubB;
  String firestoreClubC;
  String firestoreBuddy;
  String firestoreCoach;

  String firestoreMemberID;
  List<String> firestoreSports = [];
  List<String> uploadVerifiedClubs = [];
  List<String> firestoreVerifiedClubs = [];

  String isCompetitive;
  String isLeisure;
  TextEditingController fullNameTextEditingController;
  TextEditingController memberIDTextEditingController;
  TextEditingController emailTextEditingController;
  TextEditingController pasteUrlTextEditingController;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final editProfileFormKey = GlobalKey<FormState>();
  final ageFormKey = GlobalKey<FormState>();
  final genderFormKey = GlobalKey<FormState>();

  final currentUser = firebase_auth.FirebaseAuth.instance.currentUser;

  //selected sports
  final sportsClubKey = GlobalKey<FormState>();
  final experienceLevel = GlobalKey<FormState>();

  // options
  List<String> options = [
    'assets/icons/football_icon.png',
    'assets/icons/cricket_icon.png',
    'assets/icons/badminton_icon.png',
    'assets/icons/basketball_icon.png',
    'assets/icons/tennis_icon.png',
    'assets/icons/swimming_icon.png',
    'assets/icons/volleyball_icon.png',
    'assets/icons/rugby_icon.png',
    'assets/icons/table_tennis_icon.png',
    'assets/icons/handball_icon.png',
  ];

  //clubs
  List<String> clubs = [
    'None',
    'Aga Khan Sports Club',
    'Nairobi Jaffery Sports Club',
  ];

  //functions
  void getUpdatedAvatarUrl() async {
    final uid = FirebaseAuth.instance.currentUser.uid;
    String downloadUrl = await locator.get<StorageRepo>().getUserProfileImage(uid);
    setState(() {
      updatedAvatarUrl = downloadUrl;
    });
  }

  @override
  void initState() {
    getUpdatedAvatarUrl();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: Color(0xff18181A),
          elevation: 0.0,
          centerTitle: true,
          leading: BlocBuilder<EditProfileCubit, EditProfileState>(
            builder: (context, state) {
              if (state is EditProfileLoadSuccess) {
                firestoreAge = state.userProfile.age;
                firestoreGender = state.userProfile.gender;
                firestoreClubA = state.userProfile.clubA;
                firestoreClubB = state.userProfile.clubB;
                firestoreClubC = state.userProfile.clubC;
                firestoreBuddy = state.userProfile.buddy;
                firestoreCoach = state.userProfile.coach;
                firestoreCertLink = state.userProfile.pasteUrl;
                firestoreSports = state.userProfile.sportsPlayed;

                return IconButton(
                  onPressed: () async {
                    await currentUser.updateProfile(
                      photoURL: updatedAvatarUrl,
                      displayName: updatedFullName,
                    );

                    final userProfileRef = FirebaseFirestore.instance.collection("userProfile");
                    final userProfile =
                        await userProfileRef.doc(firebase_auth.FirebaseAuth.instance.currentUser.uid).get().then((value) => UserProfile.fromJson(value.data()));
                    firestoreVerifiedClubs = userProfile.verifiedClubs;

                    if (uploadSports != null) {
                      final dlist = firestoreSports.toList(growable: true);
                      dlist.insertAll(dlist.length, uploadSports);
                      List<String> firestoreSportsList = LinkedHashSet<String>.from(dlist).toList();
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (_) => MultiBlocProvider(
                            providers: [
                              BlocProvider<NavBloc>(
                                create: (_) => NavBloc()..add(LoadPageOne()),
                              ),
                              BlocProvider<EditProfileCubit>(
                                create: (_) => EditProfileCubit()
                                  ..updateUserProfile(
                                    age: uploadAge ??= firestoreAge,
                                    clubA: uploadClubA ??= firestoreClubA,
                                    clubB: uploadClubB ??= firestoreClubB,
                                    clubC: uploadClubC ??= firestoreClubC,
                                    coach: uploadCoach ??= firestoreCoach,
                                    buddy: uploadBuddy ??= firestoreBuddy,
                                    gender: uploadGender ??= firestoreGender,
                                    pasteUrl: uploadCertLink ??= firestoreCertLink,
                                    uid: currentUser.uid,
                                    email: currentUser.email,
                                    fullName: updatedFullName ??= currentUser.displayName,
                                    sportsPlayed: firestoreSportsList,
                                    verifiedClubs: uploadVerifiedClubs.isNotEmpty ? uploadVerifiedClubs : firestoreVerifiedClubs,
                                  ),
                              ),
                            ],
                            child: PagesSwitcher(),
                          ),
                        ),
                      );
                    } else if (uploadSports == null) {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (_) => MultiBlocProvider(
                            providers: [
                              BlocProvider<NavBloc>(
                                create: (_) => NavBloc()..add(LoadPageOne()),
                              ),
                              BlocProvider<EditProfileCubit>(
                                create: (_) => EditProfileCubit()
                                  ..updateUserProfile(
                                    age: uploadAge ??= firestoreAge,
                                    clubA: uploadClubA ??= firestoreClubA,
                                    clubB: uploadClubB ??= firestoreClubB,
                                    clubC: uploadClubC ??= firestoreClubC,
                                    coach: uploadCoach ??= firestoreCoach,
                                    buddy: uploadBuddy ??= firestoreBuddy,
                                    gender: uploadGender ??= firestoreGender,
                                    pasteUrl: uploadCertLink ??= firestoreCertLink,
                                    uid: currentUser.uid,
                                    email: currentUser.email,
                                    fullName: updatedFullName ??= currentUser.displayName,
                                    sportsPlayed: state.userProfile.sportsPlayed,
                                    verifiedClubs: uploadVerifiedClubs.isNotEmpty ? uploadVerifiedClubs : firestoreVerifiedClubs,
                                  ),
                              ),
                            ],
                            child: PagesSwitcher(),
                          ),
                        ),
                      );
                    }
                  },
                  icon: Icon(Icons.arrow_back),
                );
              }
              return Container();
            },
          ),
          title: Text(
            'Edit Profile',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: GestureDetector(
          onTap: () {
            FocusScopeNode currentFocus = FocusScope.of(context);
            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();
            }
          },
          child: KeyboardAvoider(
            autoScroll: true,
            focusPadding: 40.h,
            duration: Duration(milliseconds: 100),
            curve: Curves.fastLinearToSlowEaseIn,
            child: Column(
              children: [
                //avatar
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    SizedBox(width: 129.w),

                    //avi
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                        height: 117.h,
                        width: 155.w,
                        color: Colors.transparent,
                        child: _image == null
                            ? Center(
                                child: updatedAvatarUrl == null
                                    ? Icon(
                                        Icons.person_rounded,
                                        color: Color(0xff31323B),
                                        size: 155.0.r,
                                      )
                                    : CircleAvatar(
                                        radius: 155.0.r,
                                        backgroundColor: Colors.transparent,
                                        backgroundImage: NetworkImage(updatedAvatarUrl),
                                      ),
                              )
                            : CircleAvatar(
                                radius: 155.0.r,
                                backgroundColor: Colors.transparent,
                                backgroundImage: FileImage(_image),
                              ),
                      ),
                    ),

                    SizedBox(width: 18.w),

                    //pick image
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: IconButton(
                        padding: EdgeInsets.all(0),
                        constraints: BoxConstraints(
                          minWidth: 20.w,
                          maxWidth: 20.w,
                          maxHeight: 20.h,
                          minHeight: 20.h,
                        ),
                        icon: Icon(
                          Icons.camera_alt_outlined,
                          size: 20.r,
                          color: Colors.white,
                        ),
                        onPressed: () async {
                          // ignore: deprecated_member_use
                          File image = await ImagePicker.pickImage(source: ImageSource.gallery);
                          setState(() {
                            if (image != null) {
                              _image = File(image.path);
                            } else {
                              print('No image selected.');
                            }
                          });
                          await locator.get<UserController>().uploadProfilePicture(_image);
                          getUpdatedAvatarUrl();
                          print("avatarURl | $updatedAvatarUrl");
                        },
                      ),
                    ),

                    SizedBox(width: 90.w),
                  ],
                ),

                //forms
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0.w),
                  child: Form(
                    key: editProfileFormKey,
                    child: Column(
                      children: [
                        SizedBox(height: 10.0.h),
                        //full name title
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Full Name',
                            style: regularStyle,
                          ),
                        ),
                        SizedBox(height: 10.0.h),
                        //full name field
                        TextFormField(
                          readOnly: false,
                          initialValue: currentUser.displayName ?? empty,
                          style: regularStyle.copyWith(color: Colors.white),
                          controller: fullNameTextEditingController,
                          decoration: formInputDecoration(
                            hintText: 'Enter full name',
                            isDense: true,
                            prefixIcon: Icons.person_outline,
                          ),
                          validator: (val) {
                            return val.isEmpty || val.length < 2 ? "Full name cannot be less than 2 characters" : null;
                          },
                          onChanged: (val) {
                            setState(() {
                              updatedFullName = val;
                            });
                          },
                        ),
                        SizedBox(height: 20.0.h),
                        //email title
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Email',
                            style: regularStyle,
                          ),
                        ),
                        SizedBox(height: 10.0.h),
                        //email field
                        TextFormField(
                          readOnly: true,
                          initialValue: currentUser.email ?? empty,
                          style: regularStyle.copyWith(color: Colors.white),
                          controller: emailTextEditingController,
                          decoration: formInputDecoration(
                            isDense: true,
                            hintText: "Enter email",
                            prefixIcon: Icons.email_outlined,
                          ),
                          validator: (val) {
                            return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(val) ? null : "Enter a valid Email";
                          },
                        ),
                        SizedBox(height: 20.0.h),
                      ],
                    ),
                  ),
                ),

                //age & gender
                BlocBuilder<EditProfileCubit, EditProfileState>(
                  builder: (context, state) {
                    if (state is EditProfileLoadSuccess) {
                      //check if newData is null(must be null) then
                      //show 'age' & no color on gender
                      //on changed, set age and gender to uploadData & newData
                      //if firestore data has data show firestore age & firestore gender
                      //set age & gender to uploadData & newData then
                      //check if newData is null(not null) then
                      //show newData
                      //set age & gender to uploaData

                      //if firestore data is null show 'age' & no color on gender
                      //show 'age' & no color on gender
                      //on changed, set age and gender to uploadData & newData

                      //on save pass upload Data
                      final firestoreAge = state.userProfile.age;
                      final firestoreGender = state.userProfile.gender;

                      return Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.0.w),
                        child: Row(
                          children: <Widget>[
                            //age
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  //age title
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      'Age',
                                      style: regularStyle,
                                    ),
                                  ),

                                  //age range dropdown
                                  SizedBox(height: 10.0.h),
                                  Form(
                                    key: ageFormKey,
                                    child: Container(
                                      width: 170.w,
                                      child: DropdownButtonFormField(
                                        elevation: 0,
                                        iconSize: 1.r,
                                        isDense: true,
                                        style: TextStyle(
                                          fontSize: 15.sp,
                                          color: Color(0xff8FD974),
                                        ),
                                        items: [
                                          '10-15',
                                          '15-20',
                                          '20-25',
                                          '25-30',
                                          '30-40',
                                          'above 40',
                                        ].map(
                                          (val) {
                                            return DropdownMenuItem<String>(
                                              value: val,
                                              child: Text(val),
                                            );
                                          },
                                        ).toList(),
                                        hint: newAge == null
                                            ? firestoreAge == null
                                                ? Text(
                                                    'Age',
                                                    style: TextStyle(
                                                      fontSize: 15.sp,
                                                      color: Color(0xff8FD974),
                                                    ),
                                                  )
                                                : Text(
                                                    firestoreAge,
                                                    style: TextStyle(
                                                      fontSize: 15.sp,
                                                      color: Color(0xff8FD974),
                                                    ),
                                                  )
                                            : Text(
                                                newAge,
                                                style: TextStyle(
                                                  fontSize: 15.sp,
                                                  color: Color(0xff8FD974),
                                                ),
                                              ),
                                        icon: Icon(
                                          MdiIcons.chevronDown,
                                          size: 15.r,
                                          color: Color(0xffC5C6C7),
                                        ),
                                        decoration: InputDecoration(
                                          alignLabelWithHint: true,
                                          enabled: true,
                                          fillColor: Color(0xff31323B),
                                          filled: true,
                                          border: UnderlineInputBorder(
                                            borderSide: BorderSide.none,
                                            borderRadius: BorderRadius.circular(8.r),
                                          ),
                                          enabledBorder: UnderlineInputBorder(
                                            borderSide: BorderSide.none,
                                            borderRadius: BorderRadius.circular(8.r),
                                          ),
                                        ),
                                        onChanged: (val) {
                                          setState(() {
                                            newAge = val;
                                            uploadAge = val;
                                          });
                                        },
                                      ),
                                    ),
                                  ),

                                  SizedBox(height: 20.0.h),
                                ],
                              ),
                            ),

                            //gender
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  //age title
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      'Gender',
                                      style: regularStyle,
                                    ),
                                  ),

                                  SizedBox(height: 10.0.h),

                                  //gender selection
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      //male
                                      Column(
                                        children: [
                                          Text("Male", style: regularStyle),
                                          IconButton(
                                            onPressed: () {
                                              setState(() {
                                                newGender = 'Male';
                                                uploadGender = 'Male';
                                              });
                                            },
                                            padding: EdgeInsets.all(0),
                                            icon: Icon(
                                              MdiIcons.genderMale,
                                              color: newGender == 'Male'
                                                  ? Color(0xffD9F2D0)
                                                  : firestoreGender == "Male"
                                                      ? Color(0xff8FD974)
                                                      : Color(0xff31323B),
                                            ),
                                          ),
                                        ],
                                      ),
                                      //female
                                      Column(
                                        children: [
                                          Text("Female", style: regularStyle),
                                          IconButton(
                                            onPressed: () {
                                              setState(() {
                                                newGender = 'Female';
                                                uploadGender = 'Female';
                                              });
                                            },
                                            padding: EdgeInsets.all(0),
                                            icon: Icon(
                                              MdiIcons.genderFemale,
                                              color: newGender == 'Female'
                                                  ? Color(0xffD9F2D0)
                                                  : firestoreGender == "Female"
                                                      ? Color(0xff8FD974)
                                                      : Color(0xff31323B),
                                            ),
                                          ),
                                        ],
                                      ),
                                      //non-binary
                                      Column(
                                        children: [
                                          Text("Others", style: regularStyle),
                                          IconButton(
                                            onPressed: () {
                                              setState(() {
                                                newGender = 'Non-binary';
                                                uploadGender = 'Non-binary';
                                              });
                                            },
                                            padding: EdgeInsets.all(0),
                                            icon: Icon(
                                              MdiIcons.genderNonBinary,
                                              color: newGender == 'Non-binary'
                                                  ? Color(0xffD9F2D0)
                                                  : firestoreGender == "Non-binary"
                                                      ? Color(0xff8FD974)
                                                      : Color(0xff31323B),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),

                                  SizedBox(height: 20.0.h),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                    if (state is EditProfileLoadFailure) {
                      return Container();
                    }

                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.0.w),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                //age title
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'Age',
                                    style: regularStyle,
                                  ),
                                ),

                                //age range dropdown
                                SizedBox(height: 10.0.h),
                                Form(
                                  key: ageFormKey,
                                  child: Container(
                                    width: 170.w,
                                    child: DropdownButtonFormField(
                                      elevation: 0,
                                      iconSize: 1.r,
                                      isDense: true,
                                      style: TextStyle(
                                        fontSize: 15.sp,
                                        color: Color(0xff8FD974),
                                      ),
                                      items: [
                                        '10-15',
                                        '15-20',
                                        '20-25',
                                        '25-30',
                                        '30-40',
                                        'above 40',
                                      ].map(
                                        (val) {
                                          return DropdownMenuItem<String>(
                                            value: val,
                                            child: Text(val),
                                          );
                                        },
                                      ).toList(),
                                      hint: Text(
                                        'Age',
                                        style: TextStyle(
                                          fontSize: 15.sp,
                                          color: Color(0xff8FD974),
                                        ),
                                      ),
                                      icon: Icon(
                                        MdiIcons.chevronDown,
                                        size: 15.r,
                                        color: Color(0xffC5C6C7),
                                      ),
                                      decoration: InputDecoration(
                                        alignLabelWithHint: true,
                                        enabled: true,
                                        fillColor: Color(0xff31323B),
                                        filled: true,
                                        border: UnderlineInputBorder(
                                          borderSide: BorderSide.none,
                                          borderRadius: BorderRadius.circular(8.r),
                                        ),
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide.none,
                                          borderRadius: BorderRadius.circular(8.r),
                                        ),
                                      ),
                                      onChanged: (val) {},
                                    ),
                                  ),
                                ),

                                SizedBox(height: 20.0.h),
                              ],
                            ),
                          ),

                          //gender
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                //age title
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'Gender',
                                    style: regularStyle,
                                  ),
                                ),

                                //age range dropdown
                                SizedBox(height: 10.0.h),

                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    //male
                                    IconButton(
                                      onPressed: () {},
                                      padding: EdgeInsets.all(0),
                                      icon: Icon(
                                        MdiIcons.genderMale,
                                        color: Color(0xff31323B),
                                      ),
                                    ),
                                    //female
                                    IconButton(
                                      onPressed: () {},
                                      padding: EdgeInsets.all(0),
                                      icon: Icon(
                                        MdiIcons.genderFemale,
                                        color: Color(0xff31323B),
                                      ),
                                    ),

                                    //non-binary
                                    IconButton(
                                      onPressed: () {},
                                      padding: EdgeInsets.all(0),
                                      icon: Icon(
                                        MdiIcons.genderNonBinary,
                                        color: Color(0xff31323B),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 20.0.h),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),

                //sports clubs
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Column(
                    children: [
                      //title
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Are you a member of a sports club?',
                          style: regularStyle,
                        ),
                      ),
                      SizedBox(height: 10.h),

                      //forms
                      BlocBuilder<EditProfileCubit, EditProfileState>(
                        builder: (context, state) {
                          if (state is EditProfileLoadSuccess) {
                            final firestoreClubA = state.userProfile.clubA;
                            final firestoreClubB = state.userProfile.clubB;
                            final firestoreClubC = state.userProfile.clubC;
                            return Form(
                              key: sportsClubKey,
                              child: Column(
                                children: [
                                  //club A
                                  DropdownButtonFormField(
                                    elevation: 0,
                                    iconSize: 23.r,
                                    isDense: true,
                                    isExpanded: false,
                                    hint: newClubA == null
                                        ? firestoreClubA == null
                                            ? Text(
                                                'Please select a sports club',
                                                style: labelStyle,
                                              )
                                            : firestoreClubA == ''
                                                ? Text(
                                                    'Please select a sports club',
                                                    style: labelStyle,
                                                  )
                                                : Text(
                                                    firestoreClubA,
                                                    style: TextStyle(
                                                      fontSize: 15.sp,
                                                      color: Color(0xff8FD974),
                                                    ),
                                                  )
                                        : Text(
                                            newClubA,
                                            style: TextStyle(
                                              fontSize: 15.sp,
                                              color: Color(0xff8FD974),
                                            ),
                                          ),
                                    icon: Icon(
                                      MdiIcons.chevronDown,
                                      color: Color(0xffC5C6C7),
                                    ),
                                    style: TextStyle(
                                      fontSize: 15.sp,
                                      color: Color(0xff8FD974),
                                    ),
                                    items: [
                                      'None',
                                      'Aga Khan Sports Club',
                                      'Nairobi Jaffery Sports Club',
                                    ].map((val) {
                                      return DropdownMenuItem<String>(
                                        value: val,
                                        child: Text(val),
                                      );
                                    }).toList(),
                                    decoration: InputDecoration(
                                      enabled: true,
                                      fillColor: Color(0xff31323B),
                                      filled: true,
                                      border: UnderlineInputBorder(
                                        borderSide: BorderSide.none,
                                        borderRadius: BorderRadius.circular(8.r),
                                      ),
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide.none,
                                        borderRadius: BorderRadius.circular(8.r),
                                      ),
                                    ),
                                    onChanged: (clubText) {
                                      //change club
                                      setState(() {
                                        newClubA = clubText == 'None' ? "" : clubText;
                                        uploadClubA = clubText == 'None' ? "" : clubText;
                                      });
                                      //show dialog
                                      if (clubText != null && clubText != 'None') {
                                        return showDialog(
                                          context: context,
                                          barrierDismissible: false,
                                          builder: (context) {
                                            return StatefulBuilder(
                                              builder: (context, setDialogState) {
                                                return Dialog(
                                                  backgroundColor: Color(0xff18181A),
                                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0.r)),
                                                  child: Container(
                                                    height: 314.h,
                                                    width: 360.w,
                                                    child: Column(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      children: [
                                                        //title
                                                        Container(
                                                          padding: EdgeInsets.only(top: 24.h, bottom: 24.h),
                                                          child: Text(
                                                            'Verify Membership',
                                                            style: TextStyle(
                                                              color: Color(0xffFEFEFE),
                                                              fontSize: 15.sp,
                                                            ),
                                                          ),
                                                        ),

                                                        //divider
                                                        Divider(height: 0.5.h, thickness: 0.5.h, color: Color(0xff07070a)),

                                                        SizedBox(height: 16.h),
                                                        Container(
                                                          padding: EdgeInsets.only(top: 24.h, bottom: 24.h, left: 20.w, right: 20.w),
                                                          child: Text(
                                                            'Verify Membership for $clubText',
                                                            maxLines: 2,
                                                            textAlign: TextAlign.center,
                                                            softWrap: true,
                                                            style: TextStyle(
                                                              color: Color(0xffFEFEFE),
                                                              fontSize: 15.sp,
                                                            ),
                                                          ),
                                                        ),

                                                        SizedBox(height: 16.h),

                                                        Padding(
                                                          padding: EdgeInsets.only(left: 20.w, right: 20.w),
                                                          child: TextFormField(
                                                            maxLines: 1,
                                                            style: TextStyle(
                                                              color: Colors.white,
                                                              fontSize: 15.sp,
                                                            ),
                                                            controller: memberIDTextEditingController,
                                                            onChanged: (memberIDText) {
                                                              setDialogState(() {
                                                                newMemberID = memberIDText;
                                                                uploadMemberID = memberIDText;
                                                              });
                                                            },
                                                            decoration: formInputDecoration(
                                                              isDense: true,
                                                              hintText: newMemberID == null
                                                                  ? firestoreMemberID == null
                                                                      ? 'Enter Membership ID'
                                                                      : firestoreMemberID
                                                                  : newMemberID,
                                                              prefixIcon: MdiIcons.idCard,
                                                            ),
                                                          ),
                                                        ),

                                                        SizedBox(height: 28.h),

                                                        //continue btn
                                                        MaterialButton(
                                                          height: 46.h,
                                                          minWidth: 147.w,
                                                          color: Color(0xff8FD974),
                                                          padding: EdgeInsets.all(0),
                                                          shape: StadiumBorder(),
                                                          elevation: 0.0,
                                                          hoverElevation: 0,
                                                          disabledElevation: 0,
                                                          highlightElevation: 0,
                                                          focusElevation: 0,
                                                          child: Text(
                                                            'Continue',
                                                            style: TextStyle(
                                                              color: Colors.black,
                                                              fontWeight: FontWeight.w400,
                                                              fontSize: 15.sp,
                                                            ),
                                                          ),
                                                          onPressed: () async {
                                                            try {
                                                              CollectionReference membersIDsRef = FirebaseFirestore.instance.collection('MembershipIds');
                                                              final venueMembersModel = await membersIDsRef
                                                                  .where('venueName', isEqualTo: clubText)
                                                                  .get()
                                                                  .then((value) => value.docs.map((e) => VenueMembersModel.fromJson(e.data())).toList()[0]);
                                                              if (venueMembersModel.memberIDs.contains(newMemberID)) {
                                                                Navigator.pop(context);
                                                                final userProfileRef = FirebaseFirestore.instance.collection("userProfile");
                                                                final userProfile = await userProfileRef
                                                                    .doc(firebase_auth.FirebaseAuth.instance.currentUser.uid)
                                                                    .get()
                                                                    .then((value) => UserProfile.fromJson(value.data()));
                                                                firestoreVerifiedClubs = userProfile.verifiedClubs;
                                                                if (firestoreVerifiedClubs.contains(clubText)) {
                                                                  print('contains');
                                                                  uploadVerifiedClubs = firestoreVerifiedClubs;
                                                                  await Future.delayed(Duration(milliseconds: 500));
                                                                  showCustomSnackbar('You are already verified as club member at $clubText', _scaffoldKey);
                                                                } else {
                                                                  print('doesnt contain');
                                                                  uploadVerifiedClubs.add(clubText);

                                                                  await Future.delayed(Duration(milliseconds: 500));
                                                                  showCustomSnackbar('Member ID verified', _scaffoldKey);
                                                                }
                                                                return true;
                                                              } else {
                                                                Navigator.pop(context);
                                                                await Future.delayed(Duration(milliseconds: 500));
                                                                showCustomSnackbar('Member ID not verified. Try again', _scaffoldKey);
                                                                return false;
                                                              }
                                                            } catch (_) {
                                                              print("venue members error | $_");
                                                            }
                                                          },
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              },
                                            );
                                          },
                                        );
                                      }
                                    },
                                  ),
                                  SizedBox(height: 10),
                                  //club B
                                  DropdownButtonFormField(
                                    elevation: 0,
                                    iconSize: 23.r,
                                    isDense: true,
                                    isExpanded: false,
                                    hint: newClubB == null
                                        ? firestoreClubB == null
                                            ? Text(
                                                'Please select a sports club',
                                                style: labelStyle,
                                              )
                                            : firestoreClubB == ''
                                                ? Text(
                                                    'Please select a sports club',
                                                    style: labelStyle,
                                                  )
                                                : Text(
                                                    firestoreClubB,
                                                    style: TextStyle(
                                                      fontSize: 15.sp,
                                                      color: Color(0xff8FD974),
                                                    ),
                                                  )
                                        : Text(
                                            newClubB,
                                            style: TextStyle(
                                              fontSize: 15.sp,
                                              color: Color(0xff8FD974),
                                            ),
                                          ),
                                    icon: Icon(
                                      MdiIcons.chevronDown,
                                      color: Color(0xffC5C6C7),
                                    ),
                                    style: TextStyle(
                                      fontSize: 15.sp,
                                      color: Color(0xff8FD974),
                                    ),
                                    items: [
                                      'None',
                                      'Aga Khan Sports Club',
                                      'Nairobi Jaffery Sports Club',
                                    ].map(
                                      (val) {
                                        return DropdownMenuItem<String>(
                                          value: val,
                                          child: Text(val),
                                        );
                                      },
                                    ).toList(),
                                    decoration: InputDecoration(
                                      enabled: true,
                                      fillColor: Color(0xff31323B),
                                      filled: true,
                                      border: UnderlineInputBorder(
                                        borderSide: BorderSide.none,
                                        borderRadius: BorderRadius.circular(8.r),
                                      ),
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide.none,
                                        borderRadius: BorderRadius.circular(8.r),
                                      ),
                                    ),
                                    onChanged: (clubText) {
                                      setState(() {
                                        newClubB = clubText == 'None' ? "" : clubText;
                                        uploadClubB = clubText == 'None' ? "" : clubText;
                                      });
                                      if (clubText != null && clubText != 'None') {
                                        return showDialog(
                                          context: context,
                                          barrierDismissible: false,
                                          builder: (context) {
                                            return StatefulBuilder(
                                              builder: (context, setDialogState) {
                                                return Dialog(
                                                  backgroundColor: Color(0xff18181A),
                                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0.r)),
                                                  child: Container(
                                                    height: 314.h,
                                                    width: 360.w,
                                                    child: Column(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      children: [
                                                        //title
                                                        Container(
                                                          padding: EdgeInsets.only(top: 24.h, bottom: 24.h),
                                                          child: Text(
                                                            'Verify Membership',
                                                            style: TextStyle(
                                                              color: Color(0xffFEFEFE),
                                                              fontSize: 15.sp,
                                                            ),
                                                          ),
                                                        ),

                                                        //divider
                                                        Divider(height: 0.5.h, thickness: 0.5.h, color: Color(0xff07070a)),

                                                        SizedBox(height: 16.h),
                                                        Container(
                                                          padding: EdgeInsets.only(top: 24.h, bottom: 24.h, left: 20.w, right: 20.w),
                                                          child: Text(
                                                            'Verify Membership for $clubText',
                                                            maxLines: 2,
                                                            textAlign: TextAlign.center,
                                                            softWrap: true,
                                                            style: TextStyle(
                                                              color: Color(0xffFEFEFE),
                                                              fontSize: 15.sp,
                                                            ),
                                                          ),
                                                        ),

                                                        SizedBox(height: 16.h),

                                                        Padding(
                                                          padding: EdgeInsets.only(left: 20.w, right: 20.w),
                                                          child: TextFormField(
                                                            maxLines: 1,
                                                            style: TextStyle(
                                                              color: Colors.white,
                                                              fontSize: 15.sp,
                                                            ),
                                                            controller: memberIDTextEditingController,
                                                            onChanged: (memberIDText) {
                                                              setDialogState(() {
                                                                newMemberID = memberIDText;
                                                                uploadMemberID = memberIDText;
                                                              });
                                                            },
                                                            decoration: formInputDecoration(
                                                              isDense: true,
                                                              hintText: newMemberID == null
                                                                  ? firestoreMemberID == null
                                                                      ? 'Enter Membership ID'
                                                                      : firestoreMemberID
                                                                  : newMemberID,
                                                              prefixIcon: MdiIcons.idCard,
                                                            ),
                                                          ),
                                                        ),

                                                        SizedBox(height: 28.h),

                                                        //continue btn
                                                        MaterialButton(
                                                          height: 46.h,
                                                          minWidth: 147.w,
                                                          color: Color(0xff8FD974),
                                                          padding: EdgeInsets.all(0),
                                                          shape: StadiumBorder(),
                                                          elevation: 0.0,
                                                          hoverElevation: 0,
                                                          disabledElevation: 0,
                                                          highlightElevation: 0,
                                                          focusElevation: 0,
                                                          child: Text(
                                                            'Continue',
                                                            style: TextStyle(
                                                              color: Colors.black,
                                                              fontWeight: FontWeight.w400,
                                                              fontSize: 15.sp,
                                                            ),
                                                          ),
                                                          onPressed: () async {
                                                            try {
                                                              CollectionReference membersIDsRef = FirebaseFirestore.instance.collection('MembershipIds');
                                                              final venueMembersModel = await membersIDsRef
                                                                  .where('venueName', isEqualTo: clubText)
                                                                  .get()
                                                                  .then((value) => value.docs.map((e) => VenueMembersModel.fromJson(e.data())).toList()[0]);
                                                              if (venueMembersModel.memberIDs.contains(newMemberID)) {
                                                                Navigator.pop(context);
                                                                final userProfileRef = FirebaseFirestore.instance.collection("userProfile");
                                                                final userProfile = await userProfileRef
                                                                    .doc(firebase_auth.FirebaseAuth.instance.currentUser.uid)
                                                                    .get()
                                                                    .then((value) => UserProfile.fromJson(value.data()));
                                                                firestoreVerifiedClubs = userProfile.verifiedClubs;
                                                                if (firestoreVerifiedClubs.contains(clubText)) {
                                                                  print('contains');
                                                                  uploadVerifiedClubs = firestoreVerifiedClubs;
                                                                  await Future.delayed(Duration(milliseconds: 500));
                                                                  showCustomSnackbar('You are already verified as club member at $clubText', _scaffoldKey);
                                                                } else {
                                                                  print('doesnt contain');
                                                                  uploadVerifiedClubs.add(clubText);

                                                                  await Future.delayed(Duration(milliseconds: 500));
                                                                  showCustomSnackbar('Member ID verified', _scaffoldKey);
                                                                }
                                                                return true;
                                                              } else {
                                                                Navigator.pop(context);
                                                                await Future.delayed(Duration(milliseconds: 500));
                                                                showCustomSnackbar('Member ID not verified. Try again', _scaffoldKey);
                                                                return false;
                                                              }
                                                            } catch (_) {
                                                              print("venue members error | $_");
                                                            }
                                                          },
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              },
                                            );
                                          },
                                        );
                                      }
                                    },
                                  ),
                                  SizedBox(height: 10),
                                  //club C
                                  DropdownButtonFormField(
                                    elevation: 0,
                                    iconSize: 23.r,
                                    isDense: true,
                                    isExpanded: false,
                                    hint: newClubC == null
                                        ? firestoreClubC == null
                                            ? Text(
                                                'Please select a sports club',
                                                style: labelStyle,
                                              )
                                            : firestoreClubC == ''
                                                ? Text(
                                                    'Please select a sports club',
                                                    style: labelStyle,
                                                  )
                                                : Text(
                                                    firestoreClubC,
                                                    style: TextStyle(
                                                      fontSize: 15.sp,
                                                      color: Color(0xff8FD974),
                                                    ),
                                                  )
                                        : Text(
                                            newClubC,
                                            style: TextStyle(
                                              fontSize: 15.sp,
                                              color: Color(0xff8FD974),
                                            ),
                                          ),
                                    icon: Icon(
                                      MdiIcons.chevronDown,
                                      color: Color(0xffC5C6C7),
                                    ),
                                    style: TextStyle(
                                      fontSize: 15.sp,
                                      color: Color(0xff8FD974),
                                    ),
                                    items: [
                                      'None',
                                      'Aga Khan Sports Club',
                                      'Nairobi Jaffery Sports Club',
                                    ].map(
                                      (val) {
                                        return DropdownMenuItem<String>(
                                          value: val,
                                          child: Text(val),
                                        );
                                      },
                                    ).toList(),
                                    decoration: InputDecoration(
                                      enabled: true,
                                      fillColor: Color(0xff31323B),
                                      filled: true,
                                      border: UnderlineInputBorder(
                                        borderSide: BorderSide.none,
                                        borderRadius: BorderRadius.circular(8.r),
                                      ),
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide.none,
                                        borderRadius: BorderRadius.circular(8.r),
                                      ),
                                    ),
                                    onChanged: (clubText) {
                                      setState(() {
                                        newClubC = clubText == 'None' ? '' : clubText;
                                        uploadClubC = clubText == 'None' ? '' : clubText;
                                      });
                                      if (clubText != null && clubText != 'None') {
                                        return showDialog(
                                          context: context,
                                          barrierDismissible: false,
                                          builder: (context) {
                                            return StatefulBuilder(
                                              builder: (context, setDialogState) {
                                                return Dialog(
                                                  backgroundColor: Color(0xff18181A),
                                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0.r)),
                                                  child: Container(
                                                    height: 314.h,
                                                    width: 360.w,
                                                    child: Column(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      children: [
                                                        //title
                                                        Container(
                                                          padding: EdgeInsets.only(top: 24.h, bottom: 24.h),
                                                          child: Text(
                                                            'Verify Membership',
                                                            style: TextStyle(
                                                              color: Color(0xffFEFEFE),
                                                              fontSize: 15.sp,
                                                            ),
                                                          ),
                                                        ),

                                                        //divider
                                                        Divider(height: 0.5.h, thickness: 0.5.h, color: Color(0xff07070a)),

                                                        SizedBox(height: 16.h),
                                                        Container(
                                                          padding: EdgeInsets.only(top: 24.h, bottom: 24.h, left: 20.w, right: 20.w),
                                                          child: Text(
                                                            'Verify Membership for $clubText',
                                                            maxLines: 2,
                                                            textAlign: TextAlign.center,
                                                            softWrap: true,
                                                            style: TextStyle(
                                                              color: Color(0xffFEFEFE),
                                                              fontSize: 15.sp,
                                                            ),
                                                          ),
                                                        ),

                                                        SizedBox(height: 16.h),

                                                        Padding(
                                                          padding: EdgeInsets.only(left: 20.w, right: 20.w),
                                                          child: TextFormField(
                                                            maxLines: 1,
                                                            style: TextStyle(
                                                              color: Colors.white,
                                                              fontSize: 15.sp,
                                                            ),
                                                            controller: memberIDTextEditingController,
                                                            onChanged: (memberIDText) {
                                                              setDialogState(() {
                                                                newMemberID = memberIDText;
                                                                uploadMemberID = memberIDText;
                                                              });
                                                            },
                                                            decoration: formInputDecoration(
                                                              isDense: true,
                                                              hintText: newMemberID == null
                                                                  ? firestoreMemberID == null
                                                                      ? 'Enter Membership ID'
                                                                      : firestoreMemberID
                                                                  : newMemberID,
                                                              prefixIcon: MdiIcons.idCard,
                                                            ),
                                                          ),
                                                        ),

                                                        SizedBox(height: 28.h),

                                                        //continue btn
                                                        MaterialButton(
                                                          height: 46.h,
                                                          minWidth: 147.w,
                                                          color: Color(0xff8FD974),
                                                          padding: EdgeInsets.all(0),
                                                          shape: StadiumBorder(),
                                                          elevation: 0.0,
                                                          hoverElevation: 0,
                                                          disabledElevation: 0,
                                                          highlightElevation: 0,
                                                          focusElevation: 0,
                                                          child: Text(
                                                            'Continue',
                                                            style: TextStyle(
                                                              color: Colors.black,
                                                              fontWeight: FontWeight.w400,
                                                              fontSize: 15.sp,
                                                            ),
                                                          ),
                                                          onPressed: () async {
                                                            try {
                                                              CollectionReference membersIDsRef = FirebaseFirestore.instance.collection('MembershipIds');
                                                              final venueMembersModel = await membersIDsRef
                                                                  .where('venueName', isEqualTo: clubText)
                                                                  .get()
                                                                  .then((value) => value.docs.map((e) => VenueMembersModel.fromJson(e.data())).toList()[0]);
                                                              if (venueMembersModel.memberIDs.contains(newMemberID)) {
                                                                Navigator.pop(context);
                                                                final userProfileRef = FirebaseFirestore.instance.collection("userProfile");
                                                                final userProfile = await userProfileRef
                                                                    .doc(firebase_auth.FirebaseAuth.instance.currentUser.uid)
                                                                    .get()
                                                                    .then((value) => UserProfile.fromJson(value.data()));
                                                                firestoreVerifiedClubs = userProfile.verifiedClubs;
                                                                if (firestoreVerifiedClubs.contains(clubText)) {
                                                                  print('contains');
                                                                  uploadVerifiedClubs = firestoreVerifiedClubs;
                                                                  await Future.delayed(Duration(milliseconds: 500));
                                                                  showCustomSnackbar('You are already verified as club member at $clubText', _scaffoldKey);
                                                                } else {
                                                                  print('doesnt contain');

                                                                  uploadVerifiedClubs.add(clubText);

                                                                  await Future.delayed(Duration(milliseconds: 500));
                                                                  showCustomSnackbar('Member ID verified', _scaffoldKey);
                                                                }
                                                                return true;
                                                              } else {
                                                                Navigator.pop(context);
                                                                await Future.delayed(Duration(milliseconds: 500));
                                                                showCustomSnackbar('Member ID not verified. Try again', _scaffoldKey);
                                                                return false;
                                                              }
                                                            } catch (_) {
                                                              print("venue members error | $_");
                                                            }
                                                          },
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              },
                                            );
                                          },
                                        );
                                      }
                                    },
                                  ),
                                  SizedBox(height: 20),
                                  //divider
                                  Divider(height: 1.h, thickness: 1.0.h, color: Color(0xff2E2D2D)),
                                  SizedBox(height: 20.h),
                                ],
                              ),
                            );
                          }

                          if (state is EditProfileLoadFailure) {
                            return Container();
                          }
                          return Form(
                            key: sportsClubKey,
                            child: Column(
                              children: [
                                //club A
                                DropdownButtonFormField(
                                  elevation: 0,
                                  iconSize: 23.r,
                                  isDense: true,
                                  isExpanded: false,
                                  hint: Text(
                                    'Please select a sports club',
                                    style: labelStyle,
                                  ),
                                  icon: Icon(
                                    MdiIcons.chevronDown,
                                    color: Color(0xffC5C6C7),
                                  ),
                                  style: TextStyle(
                                    fontSize: 15.sp,
                                    color: Color(0xff8FD974),
                                  ),
                                  items: [
                                    'None',
                                    'Aga Khan Sports Club',
                                    'Nairobi Jaffery Sports Club',
                                  ].map(
                                    (val) {
                                      return DropdownMenuItem<String>(
                                        value: val,
                                        child: Text(val),
                                      );
                                    },
                                  ).toList(),
                                  decoration: InputDecoration(
                                    enabled: true,
                                    fillColor: Color(0xff31323B),
                                    filled: true,
                                    border: UnderlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius: BorderRadius.circular(8.r),
                                    ),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius: BorderRadius.circular(8.r),
                                    ),
                                  ),
                                  onChanged: (val) {},
                                ),
                                SizedBox(height: 10),
                                DropdownButtonFormField(
                                  elevation: 0,
                                  iconSize: 23.r,
                                  isDense: true,
                                  isExpanded: false,
                                  hint: Text(
                                    'Please select a sports club',
                                    style: labelStyle,
                                  ),
                                  icon: Icon(
                                    MdiIcons.chevronDown,
                                    color: Color(0xffC5C6C7),
                                  ),
                                  style: TextStyle(
                                    fontSize: 15.sp,
                                    color: Color(0xff8FD974),
                                  ),
                                  items: [
                                    'None',
                                    'Aga Khan Sports Club',
                                    'Nairobi Jaffery Sports Club',
                                  ].map(
                                    (val) {
                                      return DropdownMenuItem<String>(
                                        value: val,
                                        child: Text(val),
                                      );
                                    },
                                  ).toList(),
                                  decoration: InputDecoration(
                                    enabled: true,
                                    fillColor: Color(0xff31323B),
                                    filled: true,
                                    border: UnderlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius: BorderRadius.circular(8.r),
                                    ),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius: BorderRadius.circular(8.r),
                                    ),
                                  ),
                                  onChanged: (val) {},
                                ),

                                SizedBox(height: 10),
                                DropdownButtonFormField(
                                  elevation: 0,
                                  iconSize: 23.r,
                                  isDense: true,
                                  isExpanded: false,
                                  hint: Text(
                                    'Please select a sports club',
                                    style: labelStyle,
                                  ),
                                  icon: Icon(
                                    MdiIcons.chevronDown,
                                    color: Color(0xffC5C6C7),
                                  ),
                                  style: TextStyle(
                                    fontSize: 15.sp,
                                    color: Color(0xff8FD974),
                                  ),
                                  items: [
                                    'None',
                                    'Aga Khan Sports Club',
                                    'Nairobi Jaffery Sports Club',
                                  ].map(
                                    (val) {
                                      return DropdownMenuItem<String>(
                                        value: val,
                                        child: Text(val),
                                      );
                                    },
                                  ).toList(),
                                  decoration: InputDecoration(
                                    enabled: true,
                                    fillColor: Color(0xff31323B),
                                    filled: true,
                                    border: UnderlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius: BorderRadius.circular(8.r),
                                    ),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius: BorderRadius.circular(8.r),
                                    ),
                                  ),
                                  onChanged: (val) {},
                                ),

                                SizedBox(height: 20),
                                //divider
                                Divider(height: 1.h, thickness: 1.0.h, color: Color(0xff2E2D2D)),
                                SizedBox(height: 20.h),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),

                //select sports
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      //title
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'What sports do you play?',
                          style: regularStyle,
                        ),
                      ),

                      SizedBox(height: 20.h),

                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.0.w),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Hint: Long press a previously saved sport to remove it from sports you play!',
                            style: TextStyle(
                              fontSize: 11.sp,
                              color: Color(0xff8FD974),
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 10.h),

                      BlocBuilder<EditProfileCubit, EditProfileState>(
                        builder: (_, state) {
                          if (state is EditProfileLoadSuccess) {
                            firestoreSports = state.userProfile.sportsPlayed;
                            return Column(
                              children: [
                                CustomChipContent(
                                  child: ChipsChoice<String>.multiple(
                                    wrapped: true,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    runSpacing: 20.h,
                                    value: newSports == null
                                        ? firestoreSports == null
                                            ? newSports
                                            : firestoreSports
                                        : newSports,
                                    onChanged: (val) {
                                      setState(() {
                                        newSports = val;
                                        uploadSports = val;
                                      });
                                    },
                                    choiceItems: C2Choice.listFrom<String, String>(
                                      source: options,
                                      value: (i, v) => v,
                                      label: (i, v) => v,
                                    ),
                                    choiceBuilder: (item) {
                                      return Column(
                                        children: [
                                          //icon

                                          AnimatedContainer(
                                            width: 42.h,
                                            height: 42.h,
                                            margin: EdgeInsets.only(right: 10.w),
                                            duration: const Duration(milliseconds: 150),
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: item.selected
                                                  ? Color(0xff8FD974)
                                                  : firestoreSports != null
                                                      ? firestoreSports.contains(item.value)
                                                          ? Color(0xff8FD974)
                                                          : Color(0xff31323B)
                                                      : Color(0xff31323B),
                                            ),
                                            child: InkWell(
                                              onLongPress: firestoreSports.contains(item.value)
                                                  ? () {
                                                      final index = firestoreSports.indexWhere((element) => element == item.value);
                                                      firestoreSports.removeAt(index);
                                                      print('removed');
                                                      setState(() {});
                                                    }
                                                  : () {},
                                              onTap: () {
                                                item.select(!item.selected);
                                                if (!item.selected) {
                                                  return showDialog(
                                                    context: context,
                                                    useRootNavigator: false,
                                                    barrierDismissible: false,
                                                    builder: (context) => StatefulBuilder(
                                                      builder: (context, setState) {
                                                        return Dialog(
                                                          backgroundColor: Color(0xff18181A),
                                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0.r)),
                                                          child: Container(
                                                            height: 400.h,
                                                            width: 360.w,
                                                            child: Column(
                                                              mainAxisAlignment: MainAxisAlignment.start,
                                                              crossAxisAlignment: CrossAxisAlignment.center,
                                                              children: [
                                                                //title
                                                                Container(
                                                                  padding: EdgeInsets.only(top: 24.h, bottom: 24.h),
                                                                  child: Text(
                                                                    'Select Level',
                                                                    style: TextStyle(
                                                                      color: Color(0xffFEFEFE),
                                                                      fontSize: 15.sp,
                                                                    ),
                                                                  ),
                                                                ),

                                                                //divider
                                                                Divider(height: 0.5.h, thickness: 0.5.h, color: Color(0xff07070a)),

                                                                SizedBox(height: 24.h),

                                                                //level title
                                                                Padding(
                                                                  padding: EdgeInsets.only(left: 20.0.w, right: 20.w),
                                                                  child: Align(
                                                                    alignment: Alignment.centerLeft,
                                                                    child: Text(
                                                                      'Level',
                                                                      style: regularStyle,
                                                                    ),
                                                                  ),
                                                                ),

                                                                SizedBox(height: 16.h),

                                                                //level dropdown
                                                                Padding(
                                                                  padding: EdgeInsets.only(left: 20.w, right: 20.w),
                                                                  child: SizedBox(
                                                                    child: Form(
                                                                      key: experienceLevel,
                                                                      child: Column(
                                                                        children: [
                                                                          //dropdown
                                                                          DropdownButtonFormField(
                                                                            elevation: 0,
                                                                            iconSize: 23.r,
                                                                            isDense: true,
                                                                            isExpanded: true,
                                                                            hint: Text(
                                                                              'Select your experience level',
                                                                              style: labelStyle,
                                                                            ),
                                                                            icon: Icon(
                                                                              MdiIcons.chevronDown,
                                                                              size: 24.r,
                                                                              color: Color(0xffC5C6C7),
                                                                            ),
                                                                            style: TextStyle(
                                                                              fontSize: 15.sp,
                                                                              color: Color(0xff8FD974),
                                                                            ),
                                                                            items:
                                                                                //TODO: Implement choose level selection
                                                                                [
                                                                              'Beginner',
                                                                              'Intermediate',
                                                                              'Proffesional',
                                                                            ].map((val) {
                                                                              return DropdownMenuItem<String>(
                                                                                value: val,
                                                                                child: SizedBox(
                                                                                  width: 246.w,
                                                                                  child: Text(
                                                                                    val,
                                                                                    maxLines: 1,
                                                                                    softWrap: true,
                                                                                    overflow: TextOverflow.ellipsis,
                                                                                  ),
                                                                                ),
                                                                              );
                                                                            }).toList(),
                                                                            decoration: InputDecoration(
                                                                              enabled: true,
                                                                              fillColor: Color(0xff31323B),
                                                                              filled: true,
                                                                              border: UnderlineInputBorder(
                                                                                borderSide: BorderSide.none,
                                                                                borderRadius: BorderRadius.circular(8.r),
                                                                              ),
                                                                              enabledBorder: UnderlineInputBorder(
                                                                                borderSide: BorderSide.none,
                                                                                borderRadius: BorderRadius.circular(8.r),
                                                                              ),
                                                                            ),
                                                                            onChanged: (val) {
                                                                              // newExperience = val;
                                                                              // uploadExperience = val;
                                                                            },
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),

                                                                SizedBox(height: 20.h),

                                                                //difficulty title
                                                                Padding(
                                                                  padding: EdgeInsets.only(left: 20.0.w, right: 20.w),
                                                                  child: Align(
                                                                    alignment: Alignment.centerLeft,
                                                                    child: Text(
                                                                      'Difficulty',
                                                                      style: regularStyle,
                                                                    ),
                                                                  ),
                                                                ),

                                                                SizedBox(height: 16.h),

                                                                //difficulty btns
                                                                Row(
                                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                                  children: [
                                                                    //competitive
                                                                    MaterialButton(
                                                                      height: 46.h,
                                                                      minWidth: 147.w,
                                                                      color: isCompetitive == 'Yes' ? Color(0xff8FD974) : Color(0xff31323B),
                                                                      padding: EdgeInsets.all(0),
                                                                      shape: StadiumBorder(),
                                                                      elevation: 0.0,
                                                                      hoverElevation: 0,
                                                                      disabledElevation: 0,
                                                                      highlightElevation: 0,
                                                                      focusElevation: 0,
                                                                      child: Text(
                                                                        'Competitive',
                                                                        style: TextStyle(
                                                                          color: isCompetitive == 'Yes' ? Colors.black : Color(0xff707070),
                                                                          fontWeight: FontWeight.w400,
                                                                          fontSize: 15.sp,
                                                                        ),
                                                                      ),
                                                                      onPressed: () {
                                                                        setState(() {
                                                                          isCompetitive = 'Yes';
                                                                        });
                                                                      },
                                                                    ),

                                                                    SizedBox(width: 12.0.w),

                                                                    //leisure
                                                                    MaterialButton(
                                                                      height: 46.h,
                                                                      minWidth: 147.w,
                                                                      color: isCompetitive == 'Yes' ? Color(0xff31323B) : Color(0xff8FD974),
                                                                      shape: StadiumBorder(),
                                                                      padding: EdgeInsets.all(0),
                                                                      elevation: 0.0,
                                                                      hoverElevation: 0,
                                                                      disabledElevation: 0,
                                                                      highlightElevation: 0,
                                                                      focusElevation: 0,
                                                                      child: Text(
                                                                        'Leisure',
                                                                        style: TextStyle(
                                                                          color: isCompetitive == "Yes" ? Color(0xff707070) : Colors.black,
                                                                          fontWeight: FontWeight.w400,
                                                                          fontSize: 15.sp,
                                                                        ),
                                                                      ),
                                                                      onPressed: () {
                                                                        setState(() {
                                                                          isCompetitive = "No";
                                                                        });
                                                                      },
                                                                    ),
                                                                  ],
                                                                ),

                                                                SizedBox(height: 48.h),

                                                                //continue btn
                                                                MaterialButton(
                                                                  height: 46.h,
                                                                  minWidth: 147.w,
                                                                  color: Color(0xff8FD974),
                                                                  padding: EdgeInsets.all(0),
                                                                  shape: StadiumBorder(),
                                                                  elevation: 0.0,
                                                                  hoverElevation: 0,
                                                                  disabledElevation: 0,
                                                                  highlightElevation: 0,
                                                                  focusElevation: 0,
                                                                  child: Text(
                                                                    'Continue',
                                                                    style: TextStyle(
                                                                      color: Colors.black,
                                                                      fontWeight: FontWeight.w400,
                                                                      fontSize: 15.sp,
                                                                    ),
                                                                  ),
                                                                  onPressed: () {
                                                                    //TODO: Pop with data
                                                                    Navigator.pop(context);
                                                                  },
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                  );
                                                }
                                              },
                                              child: Stack(
                                                alignment: Alignment.center,
                                                children: <Widget>[
                                                  Visibility(
                                                    visible: item.selected,
                                                    child: ImageIcon(
                                                      AssetImage(item.label),
                                                      size: 24.r,
                                                      color: item.selected
                                                          ? Color(0xff28282B)
                                                          : firestoreSports.contains(item.value)
                                                              ? Color(0xff28282B)
                                                              : Colors.white,
                                                    ),
                                                  ),
                                                  ImageIcon(
                                                    AssetImage(item.label),
                                                    size: 24.r,
                                                    color: item.selected
                                                        ? Color(0xff28282B)
                                                        : firestoreSports.contains(item.value)
                                                            ? Color(0xff28282B)
                                                            : Colors.white,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 4.h),

                                          //name
                                          Text(
                                            item.label == 'assets/icons/football_icon.png'
                                                ? "Football"
                                                : item.label == 'assets/icons/table_tennis_icon.png'
                                                    ? "Table Tennis"
                                                    : item.label == 'assets/icons/badminton_icon.png'
                                                        ? "Badminton"
                                                        : item.label == 'assets/icons/volleyball_icon.png'
                                                            ? "Volleyball"
                                                            : item.label == 'assets/icons/handball_icon.png'
                                                                ? "Netball"
                                                                : item.label == 'assets/icons/swimming_icon.png'
                                                                    ? "Swimming"
                                                                    : item.label == 'assets/icons/tennis_icon.png'
                                                                        ? "Tennis"
                                                                        : item.label == 'assets/icons/rugby_icon.png'
                                                                            ? "Rugby"
                                                                            : item.label == 'assets/icons/cricket_icon.png'
                                                                                ? "Cricket"
                                                                                : item.label == 'assets/icons/basketball_icon.png'
                                                                                    ? "Basketball"
                                                                                    : '',
                                            style: TextStyle(
                                              fontSize: 12.sp,
                                              color: item.selected
                                                  ? Color(0xff8FD974)
                                                  : firestoreSports != null
                                                      ? firestoreSports.contains(item.value)
                                                          ? Color(0xff8FD974)
                                                          : Color(0xffBBBBBC)
                                                      : Color(0xffBBBBBC),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                ),
                              ],
                            );
                          }
                          return CustomChipContent(
                            child: ChipsChoice<String>.multiple(
                              wrapped: true,
                              mainAxisAlignment: MainAxisAlignment.center,
                              runSpacing: 20.h,
                              value: newSports,
                              onChanged: (val) => setState(() => newSports = val),
                              choiceItems: C2Choice.listFrom<String, String>(
                                source: options,
                                value: (i, v) => v,
                                label: (i, v) => v,
                              ),
                              choiceBuilder: (item) {
                                return Column(
                                  children: [
                                    //icon
                                    AnimatedContainer(
                                      width: 42.h,
                                      height: 42.h,
                                      margin: EdgeInsets.only(right: 10.w),
                                      duration: const Duration(milliseconds: 150),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Color(0xff31323B),
                                      ),
                                      child: InkWell(
                                        onTap: () {},
                                        child: Stack(
                                          alignment: Alignment.center,
                                          children: <Widget>[
                                            Visibility(
                                              visible: item.selected,
                                              child: ImageIcon(
                                                AssetImage(item.label),
                                                size: 24.r,
                                                color: item.selected ? Color(0xff28282B) : Colors.white,
                                              ),
                                            ),
                                            ImageIcon(
                                              AssetImage(item.label),
                                              size: 24.r,
                                              color: Colors.white,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),

                                    SizedBox(height: 4.h),

                                    //name
                                    Text(
                                      item.label == 'assets/icons/football_icon.png'
                                          ? "Football"
                                          : item.label == 'assets/icons/table_tennis_icon.png'
                                              ? "Table Tennis"
                                              : item.label == 'assets/icons/badminton_icon.png'
                                                  ? "Badminton"
                                                  : item.label == 'assets/icons/volleyball_icon.png'
                                                      ? "Volleyball"
                                                      : item.label == 'assets/icons/handball_icon.png'
                                                          ? "Netball"
                                                          : item.label == 'assets/icons/swimming_icon.png'
                                                              ? "Swimming"
                                                              : item.label == 'assets/icons/tennis_icon.png'
                                                                  ? "Tennis"
                                                                  : item.label == 'assets/icons/rugby_icon.png'
                                                                      ? "Rugby"
                                                                      : item.label == 'assets/icons/cricket_icon.png'
                                                                          ? "Cricket"
                                                                          : item.label == 'assets/icons/basketball_icon.png'
                                                                              ? "Basketball"
                                                                              : '',
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        color: Color(0xff31323B),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          );
                        },
                      ),

                      SizedBox(height: 20.0.h),

                      //divider
                      Divider(height: 1.h, thickness: 1.0.h, color: Color(0xff2E2D2D)),

                      SizedBox(height: 20.0.h),
                    ],
                  ),
                ),

                //willing
                BlocBuilder<EditProfileCubit, EditProfileState>(
                  builder: (context, state) {
                    if (state is EditProfileLoadSuccess) {
                      firestoreBuddy = state.userProfile.buddy;
                      return Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        child: Column(
                          children: [
                            //padded content
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20.w),
                              child: Column(
                                children: [
                                  //title
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      'Are you willing to sport with others?',
                                      style: regularStyle,
                                    ),
                                  ),
                                  SizedBox(height: 10.0.h),
                                  //sub
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      'Sported is platform that can help you find players to sport with!',
                                      style: TextStyle(
                                        fontSize: 11.sp,
                                        color: Color(0xff8FD974),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 10.0.h),
                                  //btns
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      //yes
                                      MaterialButton(
                                        height: 30.h,
                                        color: newBuddy == "Yes"
                                            ? Color(0xff8FD974)
                                            : firestoreBuddy == "Yes"
                                                ? Color(0xff8FD974)
                                                : Color(0xff31323B),
                                        minWidth: 56.w,
                                        padding: EdgeInsets.all(0),
                                        shape: StadiumBorder(),
                                        elevation: 0.0,
                                        hoverElevation: 0,
                                        disabledElevation: 0,
                                        highlightElevation: 0,
                                        focusElevation: 0,
                                        child: Text(
                                          'Yes',
                                          style: TextStyle(
                                            color: newBuddy == "Yes"
                                                ? Colors.black
                                                : firestoreBuddy == "Yes"
                                                    ? Colors.white
                                                    : Colors.white,
                                            fontWeight: FontWeight.w400,
                                            fontSize: 15.sp,
                                          ),
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            newBuddy = "Yes";
                                            uploadBuddy = "Yes";
                                          });
                                        },
                                      ),
                                      SizedBox(width: 12.0.w),
                                      //no
                                      MaterialButton(
                                        height: 30.h,
                                        color: newBuddy == "No"
                                            ? Color(0xff8FD974)
                                            : firestoreBuddy == "No"
                                                ? Color(0xff8FD974)
                                                : Color(0xff31323B),
                                        minWidth: 56.w,
                                        shape: StadiumBorder(),
                                        padding: EdgeInsets.all(0),
                                        elevation: 0.0,
                                        hoverElevation: 0,
                                        disabledElevation: 0,
                                        highlightElevation: 0,
                                        focusElevation: 0,
                                        child: Text(
                                          'No',
                                          style: TextStyle(
                                            color: newBuddy == "No"
                                                ? Colors.black
                                                : firestoreBuddy == "No"
                                                    ? Colors.white
                                                    : Colors.white,
                                            fontWeight: FontWeight.w400,
                                            fontSize: 15.sp,
                                          ),
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            newBuddy = "No";
                                            uploadBuddy = "No";
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10.0.h),
                                  //etc
                                  Text(
                                    'We will only let other Sported users find you if you are willing to be found and matched according to sporting interests',
                                    style: hintStyle.copyWith(fontSize: 11.sp),
                                  ),
                                  SizedBox(height: 20.0.h),
                                ],
                              ),
                            ),
                            //divider
                            Divider(height: 1.h, thickness: 1.0.h, color: Color(0xff2E2D2D)),
                            SizedBox(height: 20.0.h),
                          ],
                        ),
                      );
                    }

                    if (state is EditProfileLoadFailure) {
                      return Container();
                    }
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: Column(
                        children: [
                          //padded content
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20.w),
                            child: Column(
                              children: [
                                //title
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'Are you willing to sport with others?',
                                    style: regularStyle,
                                  ),
                                ),
                                SizedBox(height: 10.0.h),
                                //sub
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'Sported is platform that can help you find players to sport with!',
                                    style: TextStyle(
                                      fontSize: 11.sp,
                                      color: Color(0xff8FD974),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 10.0.h),
                                //btns
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    //yes
                                    MaterialButton(
                                      height: 30.h,
                                      color: Color(0xff31323B),
                                      minWidth: 56.w,
                                      padding: EdgeInsets.all(0),
                                      shape: StadiumBorder(),
                                      elevation: 0.0,
                                      hoverElevation: 0,
                                      disabledElevation: 0,
                                      highlightElevation: 0,
                                      focusElevation: 0,
                                      child: Text(
                                        'Yes',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 15.sp,
                                        ),
                                      ),
                                      onPressed: () {},
                                    ),
                                    SizedBox(width: 12.0.w),
                                    MaterialButton(
                                      height: 30.h,
                                      color: Color(0xff31323B),
                                      minWidth: 56.w,
                                      shape: StadiumBorder(),
                                      padding: EdgeInsets.all(0),
                                      elevation: 0.0,
                                      hoverElevation: 0,
                                      disabledElevation: 0,
                                      highlightElevation: 0,
                                      focusElevation: 0,
                                      child: Text(
                                        'No',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 15.sp,
                                        ),
                                      ),
                                      onPressed: () {},
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10.0.h),
                                //etc
                                Text(
                                  'We will only let other Sported users find you if you are willing to be found and matched according to sporting interests',
                                  style: hintStyle.copyWith(fontSize: 11.sp),
                                ),
                                SizedBox(height: 20.0.h),
                              ],
                            ),
                          ),
                          //divider
                          Divider(height: 1.h, thickness: 1.0.h, color: Color(0xff2E2D2D)),
                          SizedBox(height: 20.0.h),
                        ],
                      ),
                    );
                  },
                ),

                //coaching
                BlocBuilder<EditProfileCubit, EditProfileState>(
                  builder: (context, state) {
                    if (state is EditProfileLoadSuccess) {
                      firestoreCoach = state.userProfile.coach;
                      return Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            //padded content
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20.w),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  //title
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      'Are you able to train someone who is looking to learn?',
                                      style: regularStyle,
                                    ),
                                  ),
                                  SizedBox(height: 10.0.h),
                                  //btns
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      //yes
                                      MaterialButton(
                                        height: 30.h,
                                        color: newCoach == "Yes"
                                            ? Color(0xff8FD974)
                                            : firestoreCoach == "Yes"
                                                ? Color(0xff8FD974)
                                                : Color(0xff31323B),
                                        minWidth: 56.w,
                                        padding: EdgeInsets.all(0),
                                        shape: StadiumBorder(),
                                        elevation: 0.0,
                                        hoverElevation: 0,
                                        disabledElevation: 0,
                                        highlightElevation: 0,
                                        focusElevation: 0,
                                        child: Text(
                                          'Yes',
                                          style: TextStyle(
                                            color: newCoach == "Yes"
                                                ? Colors.black
                                                : firestoreCoach == "Yes"
                                                    ? Colors.white
                                                    : Colors.white,
                                            fontWeight: FontWeight.w400,
                                            fontSize: 15.sp,
                                          ),
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            newCoach = "Yes";
                                            uploadCoach = "Yes";
                                          });
                                        },
                                      ),

                                      SizedBox(width: 12.0.w),
                                      //no
                                      MaterialButton(
                                        height: 30.h,
                                        color: newCoach == "No"
                                            ? Color(0xff8FD974)
                                            : firestoreCoach == "No"
                                                ? Color(0xff8FD974)
                                                : Color(0xff31323B),
                                        minWidth: 56.w,
                                        shape: StadiumBorder(),
                                        padding: EdgeInsets.all(0),
                                        elevation: 0.0,
                                        hoverElevation: 0,
                                        disabledElevation: 0,
                                        highlightElevation: 0,
                                        focusElevation: 0,
                                        child: Text(
                                          'No',
                                          style: TextStyle(
                                            color: newCoach == "No"
                                                ? Colors.black
                                                : firestoreCoach == "No"
                                                    ? Colors.white
                                                    : Colors.white,
                                            fontWeight: FontWeight.w400,
                                            fontSize: 15.sp,
                                          ),
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            newCoach = "No";
                                            pasteUrlTextEditingController == null ? null : pasteUrlTextEditingController?.clear();
                                            uploadCertLink = '';
                                            uploadCoach = "No";
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10.0.h),
                                  //etc
                                  newCoach == 'Yes'
                                      ? RichText(
                                          text: TextSpan(
                                            text: 'Do you hold any certifications or credentials to be able to coach?',
                                            style: TextStyle(
                                              fontSize: 11.sp,
                                              color: Color(0xff8FD974),
                                            ),
                                            children: [
                                              TextSpan(
                                                text: ' If you do, please share a link to your portfolio.',
                                                style: hintStyle.copyWith(fontSize: 11.sp),
                                              ),
                                            ],
                                          ),
                                        )
                                      : Container(),
                                  SizedBox(height: 10.0.h),
                                  //certs
                                  newCoach == 'Yes'
                                      ? Container(
                                          child: Padding(
                                            padding: MediaQuery.of(context).viewInsets,
                                            child: BlocBuilder<EditProfileCubit, EditProfileState>(
                                              builder: (context, state) {
                                                if (state is EditProfileLoadSuccess) {
                                                  final firestoreCertLink = state.userProfile.pasteUrl;
                                                  return TextFormField(
                                                    maxLines: 1,
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 15.sp,
                                                    ),
                                                    initialValue: firestoreCertLink ?? empty,
                                                    controller: pasteUrlTextEditingController,
                                                    onChanged: (val) {
                                                      setState(() {
                                                        newCertLink = val;
                                                        uploadCertLink = val;
                                                      });
                                                    },
                                                    decoration: formInputDecoration(
                                                      isDense: true,
                                                      hintText: newCertLink == null
                                                          ? firestoreCertLink == null
                                                              ? 'Paste URL'
                                                              : firestoreCertLink
                                                          : newCertLink,
                                                      prefixIcon: Icons.link,
                                                    ),
                                                  );
                                                }

                                                if (state is EditProfileLoadFailure) {
                                                  return Container();
                                                }
                                                return TextFormField(
                                                  maxLines: 1,
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 15.sp,
                                                  ),
                                                  controller: pasteUrlTextEditingController,
                                                  decoration: formInputDecoration(
                                                    isDense: true,
                                                    hintText: 'Paste URL',
                                                    prefixIcon: Icons.link,
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                        )
                                      : Container(),
                                  newCoach == 'Yes' || firestoreCoach == 'Yes' ? SizedBox(height: 20.0.h) : SizedBox.shrink(),
                                ],
                              ),
                            ),
                            //divider
                            Divider(height: 1.h, thickness: 1.0.h, color: Color(0xff2E2D2D)),
                            SizedBox(height: 20.0.h),
                          ],
                        ),
                      );
                    }
                    if (state is EditProfileLoadFailure) {
                      return Container();
                    }
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //padded content
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20.w),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                //title
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'Are you able to train someone who is looking to learn?',
                                    style: regularStyle,
                                  ),
                                ),
                                SizedBox(height: 10.0.h),
                                //btns
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    //yes
                                    MaterialButton(
                                      height: 30.h,
                                      color: Color(0xff31323B),
                                      minWidth: 56.w,
                                      padding: EdgeInsets.all(0),
                                      shape: StadiumBorder(),
                                      elevation: 0.0,
                                      hoverElevation: 0,
                                      disabledElevation: 0,
                                      highlightElevation: 0,
                                      focusElevation: 0,
                                      child: Text(
                                        'Yes',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 15.sp,
                                        ),
                                      ),
                                      onPressed: () {},
                                    ),
                                    SizedBox(width: 12.0.w),
                                    MaterialButton(
                                      height: 30.h,
                                      color: Color(0xff31323B),
                                      minWidth: 56.w,
                                      shape: StadiumBorder(),
                                      padding: EdgeInsets.all(0),
                                      elevation: 0.0,
                                      hoverElevation: 0,
                                      disabledElevation: 0,
                                      highlightElevation: 0,
                                      focusElevation: 0,
                                      child: Text(
                                        'No',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 15.sp,
                                        ),
                                      ),
                                      onPressed: () {},
                                    ),
                                  ],
                                ),

                                SizedBox(height: 10.0.h),
                                //etc
                                RichText(
                                  text: TextSpan(
                                    text: 'Do you hold any certifications or credentials to be able to coach?',
                                    style: TextStyle(
                                      fontSize: 11.sp,
                                      color: Color(0xff8FD974),
                                    ),
                                    children: [
                                      TextSpan(
                                        text: ' If you do, please share a link to your portfolio.',
                                        style: hintStyle.copyWith(fontSize: 11.sp),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 10.0.h),

                                //certs
                                Container(
                                  child: Padding(
                                    padding: MediaQuery.of(context).viewInsets,
                                    child: BlocBuilder<EditProfileCubit, EditProfileState>(
                                      builder: (context, state) {
                                        if (state is EditProfileLoadSuccess) {
                                          final firestoreCertLink = state.userProfile.pasteUrl;
                                          return TextFormField(
                                            maxLines: 1,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 15.sp,
                                            ),
                                            controller: pasteUrlTextEditingController,
                                            onChanged: (val) {
                                              setState(() {
                                                newCertLink = val;
                                                uploadCertLink = val;
                                              });
                                            },
                                            decoration: formInputDecoration(
                                              isDense: true,
                                              hintText: newCertLink == null
                                                  ? firestoreCertLink == null
                                                      ? 'Paste URL'
                                                      : firestoreCertLink
                                                  : newCertLink,
                                              prefixIcon: Icons.link,
                                            ),
                                          );
                                        }

                                        if (state is EditProfileLoadFailure) {
                                          return Container();
                                        }
                                        return TextFormField(
                                          maxLines: 1,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 15.sp,
                                          ),
                                          controller: pasteUrlTextEditingController,
                                          decoration: formInputDecoration(
                                            isDense: true,
                                            hintText: 'Loading...',
                                            prefixIcon: Icons.link,
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                                SizedBox(height: 20.0.h),
                              ],
                            ),
                          ),
                          //divider
                          Divider(height: 1.h, thickness: 1.0.h, color: Color(0xff2E2D2D)),
                          SizedBox(height: 20.0.h),
                        ],
                      ),
                    );
                  },
                ),

                //save & logout
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    BlocBuilder<EditProfileCubit, EditProfileState>(
                      builder: (context, state) {
                        if (state is EditProfileLoadSuccess) {
                          firestoreAge = state.userProfile.age;
                          firestoreGender = state.userProfile.gender;
                          firestoreClubA = state.userProfile.clubA;
                          firestoreClubB = state.userProfile.clubB;
                          firestoreClubC = state.userProfile.clubC;
                          firestoreBuddy = state.userProfile.buddy;
                          firestoreCoach = state.userProfile.coach;
                          firestoreCertLink = state.userProfile.pasteUrl;
                          firestoreSports = state.userProfile.sportsPlayed;

                          return MaterialButton(
                            height: 40.h,
                            color: Color(0xff8FD974),
                            minWidth: 112.w,
                            padding: EdgeInsets.all(0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            elevation: 0.0,
                            hoverElevation: 0,
                            disabledElevation: 0,
                            highlightElevation: 0,
                            focusElevation: 0,
                            child: Text(
                              'Save',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 15.sp,
                              ),
                            ),
                            onPressed: () async {
                              await currentUser.updateProfile(
                                photoURL: updatedAvatarUrl,
                                displayName: updatedFullName,
                              );

                              final userProfileRef = FirebaseFirestore.instance.collection("userProfile");
                              final userProfile = await userProfileRef
                                  .doc(firebase_auth.FirebaseAuth.instance.currentUser.uid)
                                  .get()
                                  .then((value) => UserProfile.fromJson(value.data()));
                              firestoreVerifiedClubs = userProfile.verifiedClubs;

                              if (uploadSports != null) {
                                final dlist = firestoreSports.toList(growable: true);
                                dlist.insertAll(dlist.length, uploadSports);
                                List<String> firestoreSportsList = LinkedHashSet<String>.from(dlist).toList();
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                    builder: (_) => MultiBlocProvider(
                                      providers: [
                                        BlocProvider<NavBloc>(
                                          create: (_) => NavBloc()..add(LoadPageThree()),
                                        ),
                                        BlocProvider<EditProfileCubit>(
                                          create: (_) => EditProfileCubit()
                                            ..updateUserProfile(
                                              age: uploadAge ??= firestoreAge,
                                              clubA: uploadClubA ??= firestoreClubA,
                                              clubB: uploadClubB ??= firestoreClubB,
                                              clubC: uploadClubC ??= firestoreClubC,
                                              coach: uploadCoach ??= firestoreCoach,
                                              buddy: uploadBuddy ??= firestoreBuddy,
                                              gender: uploadGender ??= firestoreGender,
                                              pasteUrl: uploadCertLink ??= firestoreCertLink,
                                              uid: currentUser.uid,
                                              email: currentUser.email,
                                              fullName: updatedFullName ??= currentUser.displayName,
                                              sportsPlayed: firestoreSportsList,
                                              verifiedClubs: [
                                                uploadClubA ??= firestoreClubA,
                                                uploadClubB ??= firestoreClubB,
                                                uploadClubC ??= firestoreClubC,
                                              ],
                                            ),
                                        ),
                                      ],
                                      child: PagesSwitcher(),
                                    ),
                                  ),
                                );
                              } else if (uploadSports == null) {
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                    builder: (_) => MultiBlocProvider(
                                      providers: [
                                        BlocProvider<NavBloc>(
                                          create: (_) => NavBloc()..add(LoadPageThree()),
                                        ),
                                        BlocProvider<EditProfileCubit>(
                                          create: (_) => EditProfileCubit()
                                            ..updateUserProfile(
                                              age: uploadAge ??= firestoreAge,
                                              clubA: uploadClubA ??= firestoreClubA,
                                              clubB: uploadClubB ??= firestoreClubB,
                                              clubC: uploadClubC ??= firestoreClubC,
                                              coach: uploadCoach ??= firestoreCoach,
                                              buddy: uploadBuddy ??= firestoreBuddy,
                                              gender: uploadGender ??= firestoreGender,
                                              pasteUrl: uploadCertLink ??= firestoreCertLink,
                                              uid: currentUser.uid,
                                              email: currentUser.email,
                                              fullName: updatedFullName ??= currentUser.displayName,
                                              sportsPlayed: state.userProfile.sportsPlayed,
                                              verifiedClubs: [
                                                uploadClubA ??= firestoreClubA,
                                                uploadClubB ??= firestoreClubB,
                                                uploadClubC ??= firestoreClubC,
                                              ],
                                            ),
                                        ),
                                      ],
                                      child: PagesSwitcher(),
                                    ),
                                  ),
                                );
                              }
                            },
                          );
                        }
                        if (state is EditProfileLoadFailure) {
                          return Container();
                        }
                        return Container();
                      },
                    ),
                  ],
                ),

                SizedBox(height: 20.0.h)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
