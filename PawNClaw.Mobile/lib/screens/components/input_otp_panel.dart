import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pawnclaw_mobile_application/blocs/bloc/auth_bloc.dart';
import 'package:pawnclaw_mobile_application/screens/signin_screen/SignInScreen.dart';

class InputOTPPanel extends StatefulWidget {
  InputOTPPanel({Key? key, required this.phoneNumber}) : super(key: key);

  final String phoneNumber;
  @override
  State<InputOTPPanel> createState() => _InputOTPPanelState();
}

class _InputOTPPanelState extends State<InputOTPPanel> {
  TextEditingController otpController = TextEditingController();
  late String verificationId;
  @override
  void initState() {
    // TODO: implement initState
    _verifyPhone(widget.phoneNumber);
    super.initState();
  }

  _verifyPhone(String phoneNumber) async {
    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (phoneAuthCredential) async {},
        verificationFailed: (verificationFailed) async {},
        codeSent: (verificationId, resendingToken) async {
          setState(() {
            this.verificationId = verificationId;
          });
        },
        codeAutoRetrievalTimeout: (verificationId) async {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(35),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Spacer(flex: 35),
          const Text(
            "Enter OTP",
            style: TextStyle(
              fontSize: 65,
              fontWeight: FontWeight.bold,
            ),
          ),
          Spacer(flex: 1),
          const Text(
            "to verify your account",
            style: TextStyle(
              color: Colors.black54,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          TextField(
            controller: otpController,
            onChanged: (value) {},
          ),
          Spacer(flex: 30),
          Center(
            child: Opacity(
              opacity: 1,
              child: ElevatedButton(
                onPressed: () {
                  BlocProvider.of<AuthBloc>(context)
                      .add(VerifyOTP(this.verificationId, otpController.text));
                },
                child: Text(
                  "Verify your phonenumber",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
