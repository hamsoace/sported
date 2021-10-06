// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
// import 'package:sported_app/constants/constants.dart';
//
// class SelectLevelDialog extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final experienceLevel = GlobalKey<FormState>();
//     bool isCompetitive = false;
//     bool isCompetitiveTrue = true;
//     bool isLeisure = false;
//     bool isLeisureTrue = true;
//     return Dialog(
//       backgroundColor: Color(0xff18181A),
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0.r)),
//       child: Container(
//         height: 400.h,
//         width: 360.w,
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.start,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             //title
//             Container(
//               padding: EdgeInsets.only(top: 24.h, bottom: 24.h),
//               child: Text(
//                 'Select Level',
//                 style: TextStyle(
//                   color: Color(0xffFEFEFE),
//                   fontSize: 15.sp,
//                 ),
//               ),
//             ),
//
//             //divider
//             Divider(height: 0.5.h, thickness: 0.5.h, color: Color(0xff07070a)),
//
//             SizedBox(height: 24.h),
//
//             //level title
//             Padding(
//               padding: EdgeInsets.only(left: 20.0.w, right: 20.w),
//               child: Align(
//                 alignment: Alignment.centerLeft,
//                 child: Text(
//                   'Level',
//                   style: regularStyle,
//                 ),
//               ),
//             ),
//
//             SizedBox(height: 16.h),
//
//             //level dropdown
//             Padding(
//               padding: EdgeInsets.only(left: 20.w, right: 20.w),
//               child: SizedBox(
//                 child: Form(
//                   key: experienceLevel,
//                   child: Column(
//                     children: [
//                       //dropdown
//                       DropdownButtonFormField(
//                         elevation: 0,
//                         iconSize: 23.r,
//                         isDense: true,
//                         isExpanded: true,
//                         hint: Text(
//                           'Select your experience level',
//                           style: labelStyle,
//                         ),
//                         icon: Icon(
//                           MdiIcons.chevronDown,
//                           size: 24.r,
//                           color: Color(0xffC5C6C7),
//                         ),
//                         style: TextStyle(
//                           fontSize: 15.sp,
//                           color: Color(0xff8FD974),
//                         ),
//                         items: [
//                           //TODO: Implement choose level selection
//                           DropdownMenuItem(
//                             child: SizedBox(
//                               width: 246.w,
//                               child: Text(
//                                 "Beginner",
//                                 maxLines: 1,
//                                 softWrap: true,
//                                 overflow: TextOverflow.ellipsis,
//                               ),
//                             ),
//                           ),
//                           DropdownMenuItem(
//                             child: SizedBox(
//                               width: 246.w,
//                               child: Text(
//                                 "Intermediate",
//                                 maxLines: 1,
//                                 softWrap: true,
//                                 overflow: TextOverflow.ellipsis,
//                               ),
//                             ),
//                           ),
//                           DropdownMenuItem(
//                             child: SizedBox(
//                               width: 246.w,
//                               child: Text(
//                                 "Professional",
//                                 maxLines: 1,
//                                 softWrap: true,
//                                 overflow: TextOverflow.ellipsis,
//                               ),
//                             ),
//                           ),
//                         ],
//                         decoration: InputDecoration(
//                           enabled: true,
//                           fillColor: Color(0xff31323B),
//                           filled: true,
//                           border: UnderlineInputBorder(
//                             borderSide: BorderSide.none,
//                             borderRadius: BorderRadius.circular(8.r),
//                           ),
//                           enabledBorder: UnderlineInputBorder(
//                             borderSide: BorderSide.none,
//                             borderRadius: BorderRadius.circular(8.r),
//                           ),
//                         ),
//                         onTap: () {},
//                         onChanged: (_) {},
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//
//             SizedBox(height: 20.h),
//
//             //difficulty title
//             Padding(
//               padding: EdgeInsets.only(left: 20.0.w, right: 20.w),
//               child: Align(
//                 alignment: Alignment.centerLeft,
//                 child: Text(
//                   'Difficulty',
//                   style: regularStyle,
//                 ),
//               ),
//             ),
//
//             SizedBox(height: 16.h),
//
//             //difficulty btns
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 //competitive
//                 MaterialButton(
//                   height: 46.h,
//                   minWidth: 147.w,
//                   color: Color(0xff707070),
//                   padding: EdgeInsets.all(0),
//                   shape: StadiumBorder(),
//                   elevation: 0.0,
//                   hoverElevation: 0,
//                   disabledElevation: 0,
//                   highlightElevation: 0,
//                   focusElevation: 0,
//                   child: Text(
//                     'Competitive',
//                     style: TextStyle(
//                       color: Colors.black,
//                       fontWeight: FontWeight.w400,
//                       fontSize: 15.sp,
//                     ),
//                   ),
//                   onPressed: () {},
//                 ),
//                 SizedBox(width: 12.0.w),
//                 //leisure
//                 MaterialButton(
//                   height: 46.h,
//                   minWidth: 147.w,
//                   color: Color(0xff31323B),
//                   shape: StadiumBorder(
//                     side: BorderSide(
//                       color: Color(0xff3E3E3E),
//                     ),
//                   ),
//                   padding: EdgeInsets.all(0),
//                   elevation: 0.0,
//                   hoverElevation: 0,
//                   disabledElevation: 0,
//                   highlightElevation: 0,
//                   focusElevation: 0,
//                   child: Text(
//                     'Leisure',
//                     style: TextStyle(
//                       color: Color(0xff707070),
//                       fontWeight: FontWeight.w400,
//                       fontSize: 15.sp,
//                     ),
//                   ),
//                   onPressed: () {},
//                 ),
//               ],
//             ),
//
//             SizedBox(height: 48.h),
//
//             //continue btn
//             MaterialButton(
//               height: 46.h,
//               minWidth: 147.w,
//               color: Color(0xff8FD974),
//               padding: EdgeInsets.all(0),
//               shape: StadiumBorder(),
//               elevation: 0.0,
//               hoverElevation: 0,
//               disabledElevation: 0,
//               highlightElevation: 0,
//               focusElevation: 0,
//               child: Text(
//                 'Continue',
//                 style: TextStyle(
//                   color: Colors.black,
//                   fontWeight: FontWeight.w400,
//                   fontSize: 15.sp,
//                 ),
//               ),
//               onPressed: () {
//                 //TODO: Pop with data
//                 Navigator.pop(context);
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
