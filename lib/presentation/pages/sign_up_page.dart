import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:keyboard_avoider/keyboard_avoider.dart';
import 'package:provider/provider.dart';
import 'package:sported_app/business_logic/cubits/edit_profile_cubit/edit_profile_cubit.dart';
import 'package:sported_app/constants/constants.dart';
import 'package:sported_app/data/repositories/auth_repo.dart';
import 'package:sported_app/data/services/authentication_service.dart';
import 'package:sported_app/data/services/database.dart';
import 'package:sported_app/data/services/user_controller.dart';
import 'package:sported_app/locator.dart';
import 'package:sported_app/presentation/screens/edit_profile_screen.dart';
import 'package:sported_app/presentation/shared/authenticate.dart';
import 'package:sported_app/presentation/shared/custom_snackbar.dart';
import 'package:sported_app/presentation/shared/form_input_decoration.dart';

class SignUpPage extends StatefulWidget {
  final Function toggle;
  SignUpPage({this.toggle});
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool isLoading = false;
  bool _isSubmitting;
  bool _isLoading = false;

  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    print(googleUser.id);
    print(googleUser.email);
    print(googleUser.displayName);
    print(googleUser.photoUrl);

    // Create a new credential
    final GoogleAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  FirebaseAuth auth = FirebaseAuth.instance;
  AuthRepo authMethods = new AuthRepo();
  DatabaseMethods databaseMethods = new DatabaseMethods();

  final formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController userNameTextEditingController = new TextEditingController();
  TextEditingController emailTextEditingController = new TextEditingController();
  TextEditingController passWordTextEditingController = new TextEditingController();
  TextEditingController confirmPassWordTextEditingController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);

    Widget loadingIndicator = _isLoading
        ? new Container(
            color: Color(0xff18181A),
            width: 70.0,
            height: 70.0,
            child: new Padding(
              padding: const EdgeInsets.all(5.0),
              child: new Center(
                child: new LinearProgressIndicator(
                  backgroundColor: Color(0xff8FD974),
                ),
              ),
            ),
          )
        : new Container();
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomInset: false,
        body: isLoading
            ? Container(
                child: Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Color(0xff8FD974),
                  ),
                ),
              )
            : GestureDetector(
                onTap: () {
                  FocusScopeNode currentFocus = FocusScope.of(context);
                  if (!currentFocus.hasPrimaryFocus) {
                    currentFocus.unfocus();
                  }
                },
                child: KeyboardAvoider(
                  focusPadding: 40.h,
                  autoScroll: true,
                  duration: Duration(microseconds: 100),
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.only(top: 20.0.h, left: 20.0.w, right: 20.0.w, bottom: 20.0.h),
                      child: Column(
                        children: [
                          //sign in
                          Text(
                            'Sign Up',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          SizedBox(height: 40.h),

                          //welcome
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Welcome to Sported!',
                              style: TextStyle(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w500,
                                color: Color(0xff8FD974),
                              ),
                            ),
                          ),

                          SizedBox(height: 25.h),

                          //form
                          Form(
                            key: formKey,
                            child: Column(
                              children: [
                                //full name title
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'Full Name',
                                    style: TextStyle(
                                      color: Color(0xffBBBBBC),
                                      fontSize: 15.0.sp,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 10.0.h),

                                //full name field
                                TextFormField(
                                  controller: userNameTextEditingController,
                                  style: TextStyle(
                                    fontSize: 15.sp,
                                    color: Colors.white,
                                  ),
                                  decoration: formInputDecoration(
                                    hintText: "Full Name",
                                    prefixIcon: Icons.person_outlined,
                                  ),
                                  validator: (val) {
                                    return val.isEmpty || val.length < 2 ? "Try another Username" : null;
                                  },
                                ),
                                SizedBox(height: 20.0.h),

                                //email title
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'Email',
                                    style: TextStyle(
                                      color: Color(0xffBBBBBC),
                                      fontSize: 15.0.sp,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 10.0.h),

                                //email field
                                TextFormField(
                                  controller: emailTextEditingController,
                                  style: TextStyle(
                                    fontSize: 15.sp,
                                    color: Colors.white,
                                  ),
                                  decoration: formInputDecoration(
                                    hintText: "Email",
                                    prefixIcon: Icons.mail_outlined,
                                  ),
                                  validator: (val) {
                                    return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(val) ? null : "Enter a valid Email";
                                  },
                                ),
                                SizedBox(height: 20.0.h),

                                //password title
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'Password',
                                    style: TextStyle(
                                      color: Color(0xffBBBBBC),
                                      fontSize: 15.0.sp,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 10.0.h),

                                //password field
                                TextFormField(
                                  obscureText: true,
                                  style: TextStyle(
                                    fontSize: 15.sp,
                                    color: Colors.white,
                                  ),
                                  decoration: formInputDecoration(
                                    hintText: "Password",
                                    prefixIcon: Icons.lock_outlined,
                                  ),
                                  validator: (val) {
                                    return val.length > 6 ? null : "Password must have 6+ characters";
                                  },
                                  controller: passWordTextEditingController,
                                ),
                                SizedBox(height: 20.0.h),

                                //confirm password title
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'Confirm Password',
                                    style: TextStyle(
                                      color: Color(0xffBBBBBC),
                                      fontSize: 15.0.sp,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 10.0.h),

                                //confirm password field
                                TextFormField(
                                  obscureText: true,
                                  controller: confirmPassWordTextEditingController,
                                  style: TextStyle(
                                    fontSize: 15.sp,
                                    color: Colors.white,
                                  ),
                                  decoration: formInputDecoration(
                                    hintText: "Confirm Password",
                                    prefixIcon: Icons.lock_outlined,
                                  ),
                                  validator: (val) {
                                    if (val != passWordTextEditingController.text) {
                                      return "Passwords do not match";
                                    } else {
                                      return null;
                                    }
                                  },
                                ),
                                SizedBox(height: 20.0.h),
                              ],
                            ),
                          ),

                          SizedBox(height: 50.h),
                          new Align(
                            child: loadingIndicator,
                            alignment: FractionalOffset.topCenter,
                          ),

                          //sign up btn
                          MaterialButton(
                            color: Color(0xff8FD974),
                            shape: StadiumBorder(),
                            minWidth: 1.sw,
                            height: 50.h,
                            onPressed: () {
                              if (!currentFocus.hasPrimaryFocus) {
                                currentFocus.unfocus();
                              }
                              signMeUp();
                            },
                            child: Text(
                              'Sign Up',
                              style: TextStyle(
                                fontSize: 18.sp,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),

                          SizedBox(height: 20.0.h),

                          Text(
                            'Or Sign Up using',
                            style: regularStyle,
                          ),

                          SizedBox(height: 15.h),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              //facebook
                              // MaterialButton(
                              //   onPressed: () {
                              //     _login();
                              //   },
                              //   padding: EdgeInsets.symmetric(horizontal: 8.r),
                              //   splashColor: Colors.transparent,
                              //   child: Row(
                              //     mainAxisAlignment: MainAxisAlignment.start,
                              //     crossAxisAlignment: CrossAxisAlignment.center,
                              //     children: [
                              //       CircleAvatar(
                              //         radius: 19.r,
                              //         backgroundColor: Colors.transparent,
                              //         child: Image.asset(
                              //           'assets/icons/facebook_icon.png',
                              //           height: 19.r,
                              //           width: 19.r,
                              //         ),
                              //       ),
                              //       SizedBox(width: 4.w),
                              //       Text('Facebook', style: regularStyle),
                              //     ],
                              //   ),
                              // ),

                              //google
                              MaterialButton(
                                onPressed: () async {
                                  await signInWithGoogle();
                                  await BlocProvider.of<EditProfileCubit>(context).updateUserProfile(
                                    uid: auth.currentUser.uid,
                                    email: auth.currentUser.email,
                                    fullName: userNameTextEditingController.text,
                                    sportsPlayed: [],
                                    verifiedClubs: [],
                                  );
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => BlocProvider<EditProfileCubit>(
                                        create: (context) => EditProfileCubit()..getUserProfile(),
                                        child: EditProfileScreen(),
                                      ),
                                    ),
                                  );
                                },
                                padding: EdgeInsets.symmetric(horizontal: 8.r),
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      backgroundColor: Colors.transparent,
                                      child: Image.asset(
                                        'assets/icons/google_icon.png',
                                        height: 19.r,
                                        width: 19.r,
                                      ),
                                    ),
                                    SizedBox(width: 4.w),
                                    Text('Google', style: regularStyle),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: 10.h),

                          //sign in cta
                          RichText(
                            text: TextSpan(
                              text: 'Already have an account? ',
                              style: TextStyle(
                                fontSize: 13.sp,
                                color: Color(0xff707070),
                              ),
                              children: [
                                TextSpan(
                                  recognizer: TapGestureRecognizer()..onTap = () async => await widget.toggle(),
                                  text: 'Sign In',
                                  style: TextStyle(
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.underline,
                                    color: Color(0xff8FD974),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
      ),
    );
  }

  signMeUp() {
    if (formKey.currentState.validate()) {
      _registerUser();
    }
  }

  void _registerUser() async {
    setState(() {
      _isSubmitting = true;
      _isLoading = true;
    });
    final logMessage = await context.read<AuthenticationService>().signUp(email: emailTextEditingController.text, password: passWordTextEditingController.text, fullName: userNameTextEditingController.text);

    // ignore: unnecessary_statements
    logMessage == "Registered Successfully" ? null : showCustomSnackbar(logMessage, _scaffoldKey);

    print("LogMessage:" + logMessage);

    if (logMessage == "Registered Successfully") {
      createUserProfile();
      await BlocProvider.of<EditProfileCubit>(context).updateUserProfile(
        uid: auth.currentUser.uid,
        email: auth.currentUser.email,
        fullName: userNameTextEditingController.text,
        sportsPlayed: [],
        verifiedClubs: [],
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => BlocProvider<EditProfileCubit>(
            create: (context) => EditProfileCubit()..getUserProfile(),
            child: Authenticate(),
          ),
        ),
      );
    } else {
      setState(() {
        _isSubmitting = false;
        _isLoading = false;
      });
    }
  }

  //When User "Signed Up", success snack will display.
  // _showSuccessSnack(String message) {
  //   final snackbar = SnackBar(
  //     behavior: SnackBarBehavior.floating,
  //     backgroundColor: Color(0xffd0e9c8),
  //     duration: Duration(milliseconds: 2000),
  //     content: Text(
  //       "$message",
  //       style: TextStyle(
  //         color: Colors.black,
  //         fontWeight: FontWeight.w600,
  //       ),
  //     ),
  //   );
  //   // ignore: deprecated_member_use
  //   _scaffoldKey.currentState.hideCurrentSnackBar();
  //   // ignore: deprecated_member_use
  //   _scaffoldKey.currentState.showSnackBar(snackbar);
  //   formKey.currentState.reset();
  // }

  // //When FirebaseAuth Catches error, error snack will display.
  // _showErrorSnack(String message) {
  //   final snackbar = SnackBar(
  //     backgroundColor: Colors.black,
  //     content: Text(
  //       "$message",
  //       style: TextStyle(color: Colors.red),
  //     ),
  //   );
  //   _scaffoldKey.currentState.showSnackBar(snackbar);
  // }

  createUserProfile() async {
    try {
      await locator.get<UserController>().uploadProfile(
        fullName: userNameTextEditingController.text,
        email: emailTextEditingController.text,
        uid: auth.currentUser.uid,
        sportsPlayed: [],
        verifiedClubs: [],
      );
    } catch (e) {
      print("Error:" + e.toString());
    }
  }
}
