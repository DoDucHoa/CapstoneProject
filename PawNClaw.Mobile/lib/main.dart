import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pawnclaw_mobile_application/blocs/pet/pet_bloc.dart';
import 'package:pawnclaw_mobile_application/blocs/sponsor/sponsor_bloc.dart';
import 'package:pawnclaw_mobile_application/blocs/transaction/transaction_bloc.dart';
import 'package:pawnclaw_mobile_application/common/constants.dart';
import 'package:pawnclaw_mobile_application/repositories/auth/auth_repository.dart';
import 'package:pawnclaw_mobile_application/repositories/pet/pet_repository.dart';
import 'package:pawnclaw_mobile_application/repositories/sponsor_banner/sponsor_repository.dart';
import 'package:pawnclaw_mobile_application/repositories/transaction/transaction_repository.dart';
import 'package:pawnclaw_mobile_application/screens/home_screen/HomeScreen.dart';
import 'package:pawnclaw_mobile_application/screens/signin_screen/SignInScreen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'blocs/authentication/auth_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key); 

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    print(user); 
     
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthBloc(authRepository: AuthRepository())
            ..add(CheckingCurrentAuth(user)),
        ),
        BlocProvider(
            create: (context) => PetBloc(petRepository: PetRepository())),
         BlocProvider(
            create: (context) => SponsorBloc()..add(InitSponsorBanner())),
      ], 
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'PawnClaw',
        theme: ThemeData(
          primarySwatch:
              MaterialColor(primaryColor.value, getSwatch(primaryColor)),
        ),
        home: const SignInScreen(),
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales:   [
          const Locale('en'), 
          const Locale('vi')
          ],
      ),
    );
  }
}

Map<int, Color> getSwatch(Color color) {
  final hslColor = HSLColor.fromColor(color);
  final lightness = hslColor.lightness;

  /// if [500] is the default color, there are at LEAST five
  /// steps below [500]. (i.e. 400, 300, 200, 100, 50.) A
  /// divisor of 5 would mean [50] is a lightness of 1.0 or
  /// a color of #ffffff. A value of six would be near white
  /// but not quite.
  final lowDivisor = 6;

  /// if [500] is the default color, there are at LEAST four
  /// steps above [500]. A divisor of 4 would mean [900] is
  /// a lightness of 0.0 or color of #000000
  final highDivisor = 5;

  final lowStep = (1.0 - lightness) / lowDivisor;
  final highStep = lightness / highDivisor;

  return {
    50: (hslColor.withLightness(lightness + (lowStep * 5))).toColor(),
    100: (hslColor.withLightness(lightness + (lowStep * 4))).toColor(),
    200: (hslColor.withLightness(lightness + (lowStep * 3))).toColor(),
    300: (hslColor.withLightness(lightness + (lowStep * 2))).toColor(),
    400: (hslColor.withLightness(lightness + lowStep)).toColor(),
    500: (hslColor.withLightness(lightness)).toColor(),
    600: (hslColor.withLightness(lightness - highStep)).toColor(),
    700: (hslColor.withLightness(lightness - (highStep * 2))).toColor(),
    800: (hslColor.withLightness(lightness - (highStep * 3))).toColor(),
    900: (hslColor.withLightness(lightness - (highStep * 4))).toColor(),
  };
}
