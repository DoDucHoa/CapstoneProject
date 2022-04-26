import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:pawnclaw_mobile_application/blocs/bloc/auth_bloc.dart';
import 'package:pawnclaw_mobile_application/constants.dart';
import 'package:pawnclaw_mobile_application/screens/components/input_otp_panel.dart';
import 'package:pawnclaw_mobile_application/screens/components/input_phone_panel.dart';

class SignInScreen extends StatefulWidget {
  SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  bool isValid = false;
  bool isVerify = false;

  String initialCountry = 'VN';
  PhoneNumber number = PhoneNumber(isoCode: 'VN');
  TextEditingController phoneController = TextEditingController();
  TextEditingController otpController = TextEditingController();

  FirebaseAuth _auth = FirebaseAuth.instance;
  String? verificationId;
  String? otp;

  set string(String value) => setState(() => otp = value);

  void signInWithPhoneAuthCredential(
      PhoneAuthCredential phoneAuthCredential) async {
    //Sign in to firebase with phone auth credential
    await _auth.signInWithCredential(phoneAuthCredential);
    //get Access Token for authen/author
    String token = await FirebaseAuth.instance.currentUser!.getIdToken();
  }

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
            return Center(child: Text("Login successfully."));
          } else
            return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
