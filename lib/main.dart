import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/screenutil_init.dart';
import 'package:mpesa_flutter_plugin/initializer.dart';
import 'package:provider/provider.dart';
import 'package:sported_app/business_logic/blocs/auth/authentication_bloc.dart';
import 'package:sported_app/business_logic/cubits/edit_profile_cubit/edit_profile_cubit.dart';
import 'package:sported_app/business_logic/cubits/filter_chips_cubit/filter_chips_cubit.dart';
import 'package:sported_app/data/repositories/booking_history_repository.dart';
import 'package:sported_app/data/repositories/venue_data_provider.dart';
import 'package:sported_app/data/repositories/venue_repository.dart';
import 'package:sported_app/presentation/screens/auth_unknown_screen.dart';
import 'package:sported_app/presentation/shared/pages_switcher.dart';
import 'package:sported_app/simple_bloc_observer.dart';

import 'business_logic/blocs/filter_bloc/filter_bloc.dart';
import 'business_logic/cubits/booking_history_cubit/booking_history_cubit.dart';
import 'constants/constants.dart';
import 'data/repositories/auth_repo.dart';
import 'data/repositories/booking_history_data_provider.dart';
import 'data/repositories/venue_repository.dart';
import 'data/services/authentication_service.dart';
import 'locator.dart';
import 'presentation/shared/authenticate.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Bloc.observer = SimpleBlocObserver();
  MpesaFlutterPlugin.setConsumerKey(kConsumerKey);
  MpesaFlutterPlugin.setConsumerSecret(kConsumerSecret);
  setupServices();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final _navigatorKey = GlobalKey<NavigatorState>();
  NavigatorState get _navigator => _navigatorKey.currentState;
  @override
  Widget build(BuildContext context) {
    final VenueRepository venueRepository = VenueRepository(venueDataProvider: VenueDataProvider());
    final BookingHistoryRepository bookingHistoryRepository = BookingHistoryRepository(bookingHistoryDataProvider: BookingHistoryDataProvider());
    final AuthRepo authenticationRepository = AuthRepo();
    return MultiProvider(
      providers: [
        Provider<AuthenticationService>(
          create: (_) => AuthenticationService(),
        ),
        StreamProvider(create: (context) => context.read<AuthenticationService>().authStateChanges),
      ],
      child: ScreenUtilInit(
        designSize: Size(414, 736),
        allowFontScaling: false,
        builder: () => MultiBlocProvider(
          providers: [
            BlocProvider<AuthenticationBloc>(
              create: (_) => AuthenticationBloc(authMethods: authenticationRepository),
            ),
            BlocProvider<FilterBloc>(
              create: (_) => FilterBloc(venueRepository: venueRepository)..add(LoadFootball()),
            ),
            BlocProvider<FilterChipsCubit>(
              create: (_) => FilterChipsCubit(),
            ),
            BlocProvider<EditProfileCubit>(
              create: (_) => EditProfileCubit(),
            ),
            BlocProvider<BookingHistoryCubit>(
              create: (_) => BookingHistoryCubit(bookingHistoryRepository: bookingHistoryRepository)..loadBookingHistory(),
            ),
          ],
          child: MaterialApp(
            navigatorKey: _navigatorKey,
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              canvasColor: Color(0xff31323B),
              appBarTheme: AppBarTheme(
                color: Color(0xff18181A),
                actionsIconTheme: IconThemeData(
                  color: Color(0xffBABABB),
                ),
                iconTheme: IconThemeData(
                  color: Color(0xffBABABB),
                ),
                elevation: 0.0,
                brightness: Brightness.dark,
                centerTitle: true,
              ),
              accentColor: Color(0xff2F4826),
              splashColor: Colors.transparent,
              highlightColor: Color(0x1a2f4826),
              scaffoldBackgroundColor: Color(0xff18181A),
            ),
            home: BlocListener<AuthenticationBloc, AuthenticationState>(
              child: AuthUnknownScreen(),
              listener: (context, state) {
                print("state.status | " + "${state.status}");
                switch (state.status) {
                  case AuthenticationStatus.authenticated:
                    Future.delayed(Duration(seconds: 3), () {
                      BlocProvider.of<EditProfileCubit>(context)..getUserProfile();
                      // 5s over, navigate to a new page
                      _navigator.pushAndRemoveUntil<void>(
                        PagesSwitcher.route(),
                        (route) => false,
                      );
                    });
                    break;
                  case AuthenticationStatus.unauthenticated:
                    Future.delayed(Duration(seconds: 3), () {
                      // 5s over, navigate
                      _navigator.pushAndRemoveUntil<void>(
                        Authenticate.route(),
                        (route) => false,
                      );
                    });
                    break;
                  default:
                    break;
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
