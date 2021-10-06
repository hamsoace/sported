import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sported_app/business_logic/blocs/nav_bloc/nav_bloc.dart';

class HomeCarousel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 20.h,
      child: Container(
        height: 110.h,
        width: 1.sw,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: [
            //venues
            Padding(
              padding: EdgeInsets.only(left: 12.w, right: 12.w),
              child: GestureDetector(
                onTap: () {
                  //nav
                  BlocProvider.of<NavBloc>(context).add(LoadVenuesPage());
                },
                child: Container(
                  height: 94.h,
                  padding: EdgeInsets.all(16.r),
                  width: 171.w,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24.r),
                    color: Color(0xff31323B),
                  ),
                  child: Column(
                    children: [
                      //title
                      Text(
                        'Find More Venues',
                        style: TextStyle(
                          fontSize: 15.sp,
                          color: Color(0xffD9EFD2),
                        ),
                      ),

                      SizedBox(height: 16.h),

                      //imgs
                      Container(
                        width: 94.w,
                        child: Stack(
                          alignment: Alignment.centerLeft,
                          textDirection: TextDirection.ltr,
                          children: [
                            //first
                            Container(
                              height: 33.h,
                              width: 38.w,
                              clipBehavior: Clip.hardEdge,
                              foregroundDecoration: BoxDecoration(
                                border: Border.all(
                                  style: BorderStyle.solid,
                                  width: 1.5.w,
                                  color: Color(0xffF5F5F5),
                                ),
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Color(0xffEFF2ED),
                                    blurRadius: 10.r,
                                    spreadRadius: 1.r,
                                  ),
                                ],
                                border: Border.all(
                                  style: BorderStyle.solid,
                                  width: 1.5.w,
                                  color: Color(0xffF5F5F5),
                                ),
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              child: Image.network(
                                'https://fastly.4sqi.net/img/general/600x600/407721430_DGyytCXxHEvZ8ECmP_-tfAeZakOPEHb4q7pZB9imNdk.jpg',
                                fit: BoxFit.fitHeight,
                                filterQuality: FilterQuality.medium,
                              ),
                            ),
                            //second
                            Positioned(
                              left: 28.w,
                              child: Container(
                                height: 33.h,
                                width: 38.w,
                                clipBehavior: Clip.hardEdge,
                                foregroundDecoration: BoxDecoration(
                                  border: Border.all(
                                    style: BorderStyle.solid,
                                    width: 1.5.w,
                                    color: Color(0xffF5F5F5),
                                  ),
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Color(0xffEFF2ED),
                                      blurRadius: 10.r,
                                      spreadRadius: 1.r,
                                    ),
                                  ],
                                  border: Border.all(
                                    style: BorderStyle.solid,
                                    width: 1.5.w,
                                    color: Color(0xffF5F5F5),
                                  ),
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                                child: Image.network(
                                  'https://lh3.googleusercontent.com/p/AF1QipPkGabgYnFBS7eaDZSh_dXh0xZ1NphZBIXL-VjF=s1600-w400',
                                  fit: BoxFit.fitHeight,
                                  filterQuality: FilterQuality.medium,
                                ),
                              ),
                            ),
                            //third
                            Positioned(
                              left: 56.w,
                              child: Container(
                                height: 33.h,
                                width: 38.w,
                                clipBehavior: Clip.hardEdge,
                                foregroundDecoration: BoxDecoration(
                                  border: Border.all(
                                    style: BorderStyle.solid,
                                    width: 1.5.w,
                                    color: Color(0xffF5F5F5),
                                  ),
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Color(0xffEFF2ED),
                                      blurRadius: 10.r,
                                      spreadRadius: 1.r,
                                    ),
                                  ],
                                  border: Border.all(
                                    style: BorderStyle.solid,
                                    width: 1.5.w,
                                    color: Color(0xffF5F5F5),
                                  ),
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                                child: Image.network(
                                  'https://mapio.net/images-p/98041323.jpg',
                                  fit: BoxFit.fitHeight,
                                  filterQuality: FilterQuality.medium,
                                ),
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

            //players
            Padding(
              padding: EdgeInsets.only(left: 12.w, right: 12.w),
              child: GestureDetector(
                onTap: () {},
                child: Container(
                  height: 94.h,
                  padding: EdgeInsets.all(16.r),
                  width: 171.w,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24.r),
                    color: Color(0xff31323B),
                  ),
                  child: Column(
                    children: [
                      //title
                      Text(
                        'Find More Players',
                        style: TextStyle(
                          fontSize: 15.sp,
                          color: Color(0xffD9EFD2),
                        ),
                      ),

                      SizedBox(height: 16.h),

                      //imgs
                      Container(
                        width: 94.w,
                        child: Stack(
                          alignment: Alignment.centerLeft,
                          textDirection: TextDirection.ltr,
                          children: [
                            //first
                            Container(
                              height: 33.h,
                              width: 38.w,
                              clipBehavior: Clip.hardEdge,
                              foregroundDecoration: BoxDecoration(
                                border: Border.all(
                                  style: BorderStyle.solid,
                                  width: 1.5.w,
                                  color: Color(0xffF5F5F5),
                                ),
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Color(0xffEFF2ED),
                                    blurRadius: 10.r,
                                    spreadRadius: 1.r,
                                  ),
                                ],
                                border: Border.all(
                                  style: BorderStyle.solid,
                                  width: 1.5.w,
                                  color: Color(0xffF5F5F5),
                                ),
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              child: Image.asset(
                                'assets/images/stadium.png',
                                fit: BoxFit.fitHeight,
                              ),
                            ),
                            //second
                            Positioned(
                              left: 28.w,
                              child: Container(
                                height: 33.h,
                                width: 38.w,
                                clipBehavior: Clip.hardEdge,
                                foregroundDecoration: BoxDecoration(
                                  border: Border.all(
                                    style: BorderStyle.solid,
                                    width: 1.5.w,
                                    color: Color(0xffF5F5F5),
                                  ),
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Color(0xffEFF2ED),
                                      blurRadius: 10.r,
                                      spreadRadius: 1.r,
                                    ),
                                  ],
                                  border: Border.all(
                                    style: BorderStyle.solid,
                                    width: 1.5.w,
                                    color: Color(0xffF5F5F5),
                                  ),
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                                child: Image.asset(
                                  'assets/images/stadium.png',
                                  fit: BoxFit.fitHeight,
                                ),
                              ),
                            ),
                            //third
                            Positioned(
                              left: 56.w,
                              child: Container(
                                height: 33.h,
                                width: 38.w,
                                clipBehavior: Clip.hardEdge,
                                foregroundDecoration: BoxDecoration(
                                  border: Border.all(
                                    style: BorderStyle.solid,
                                    width: 1.5.w,
                                    color: Color(0xffF5F5F5),
                                  ),
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Color(0xffEFF2ED),
                                      blurRadius: 10.r,
                                      spreadRadius: 1.r,
                                    ),
                                  ],
                                  border: Border.all(
                                    style: BorderStyle.solid,
                                    width: 1.5.w,
                                    color: Color(0xffF5F5F5),
                                  ),
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                                child: Image.asset(
                                  'assets/images/stadium.png',
                                  fit: BoxFit.fitHeight,
                                ),
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

            //coaches
            Padding(
              padding: EdgeInsets.only(left: 12.w, right: 12.w),
              child: GestureDetector(
                onTap: () {},
                child: Container(
                  height: 94.h,
                  padding: EdgeInsets.all(16.r),
                  width: 171.w,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24.r),
                    color: Color(0xff31323B),
                  ),
                  child: Column(
                    children: [
                      //title
                      Text(
                        'Find More Coaches',
                        style: TextStyle(
                          fontSize: 15.sp,
                          color: Color(0xffD9EFD2),
                        ),
                      ),

                      SizedBox(height: 16.h),

                      //imgs
                      Container(
                        width: 94.w,
                        child: Stack(
                          alignment: Alignment.centerLeft,
                          textDirection: TextDirection.ltr,
                          children: [
                            //first
                            Container(
                              height: 33.h,
                              width: 38.w,
                              clipBehavior: Clip.hardEdge,
                              foregroundDecoration: BoxDecoration(
                                border: Border.all(
                                  style: BorderStyle.solid,
                                  width: 1.5.w,
                                  color: Color(0xffF5F5F5),
                                ),
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Color(0xffEFF2ED),
                                    blurRadius: 10.r,
                                    spreadRadius: 1.r,
                                  ),
                                ],
                                border: Border.all(
                                  style: BorderStyle.solid,
                                  width: 1.5.w,
                                  color: Color(0xffF5F5F5),
                                ),
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              child: Image.asset(
                                'assets/images/stadium.png',
                                fit: BoxFit.fitHeight,
                              ),
                            ),
                            //second
                            Positioned(
                              left: 28.w,
                              child: Container(
                                height: 33.h,
                                width: 38.w,
                                clipBehavior: Clip.hardEdge,
                                foregroundDecoration: BoxDecoration(
                                  border: Border.all(
                                    style: BorderStyle.solid,
                                    width: 1.5.w,
                                    color: Color(0xffF5F5F5),
                                  ),
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Color(0xffEFF2ED),
                                      blurRadius: 10.r,
                                      spreadRadius: 1.r,
                                    ),
                                  ],
                                  border: Border.all(
                                    style: BorderStyle.solid,
                                    width: 1.5.w,
                                    color: Color(0xffF5F5F5),
                                  ),
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                                child: Image.asset(
                                  'assets/images/stadium.png',
                                  fit: BoxFit.fitHeight,
                                ),
                              ),
                            ),
                            //third
                            Positioned(
                              left: 56.w,
                              child: Container(
                                height: 33.h,
                                width: 38.w,
                                clipBehavior: Clip.hardEdge,
                                foregroundDecoration: BoxDecoration(
                                  border: Border.all(
                                    style: BorderStyle.solid,
                                    width: 1.5.w,
                                    color: Color(0xffF5F5F5),
                                  ),
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Color(0xffEFF2ED),
                                      blurRadius: 10.r,
                                      spreadRadius: 1.r,
                                    ),
                                  ],
                                  border: Border.all(
                                    style: BorderStyle.solid,
                                    width: 1.5.w,
                                    color: Color(0xffF5F5F5),
                                  ),
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                                child: Image.asset(
                                  'assets/images/stadium.png',
                                  fit: BoxFit.fitHeight,
                                ),
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
          ],
        ),
      ),
    );
  }
}
