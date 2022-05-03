import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pawnclaw_mobile_application/blocs/authentication/auth_bloc.dart';
import 'package:pawnclaw_mobile_application/screens/home_screen/HomeScreen.dart';

import 'components/input_otp_panel.dart';
import 'components/input_phone_panel.dart';

class SignInScreen extends StatefulWidget {
  SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state is Unauthenticated) {
            return InputPhonePanel();
          }
          if (state is PhoneVerified) {
            return InputOTPPanel(
              phoneNumber: state.phoneNumber,
            );
          }
          if (state is Authenticated) {
            return const HomeScreen();
          } else
            return const Center(
              child: CircularProgressIndicator(),
            );
        },
      ),
    );
  }
}
