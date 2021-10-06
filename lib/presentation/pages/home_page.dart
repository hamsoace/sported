import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sported_app/presentation/widgets/home/g_map.dart';
import 'package:sported_app/presentation/widgets/home/home_carousel.dart';
import 'package:sported_app/presentation/widgets/home/home_page_sports_filter.dart';
import 'package:sported_app/presentation/widgets/home/home_top_bar.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        //GMap
        FutureBuilder(
          future: _determinePosition(),
          builder: (context, AsyncSnapshot<Position> snapshot) {
            if (snapshot.hasData && snapshot.connectionState == ConnectionState.done) {
              final lat = snapshot.data.latitude;
              final long = snapshot.data.longitude;
              return GMap(lat: lat, long: long);
            }
            return Container();
          },
        ),

        //search
        HomeTopBar(),

        //select sport
        Positioned(top: 48.0.h, right: 0.0, left: 0.0, child: HomePageSportsFilter()),

        //carousel
        HomeCarousel(),
      ],
    );
  }
}
