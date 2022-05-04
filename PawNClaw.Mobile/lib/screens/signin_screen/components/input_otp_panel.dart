import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pawnclaw_mobile_application/blocs/authentication/auth_bloc.dart';
import 'package:pinput/pinput.dart';

class InputOTPPanel extends StatefulWidget {
  InputOTPPanel({Key? key, required this.phoneNumber}) : super(key: key);

  final String phoneNumber;
  @override
  State<InputOTPPanel> createState() => _InputOTPPanelState();
}

class _InputOTPPanelState extends State<InputOTPPanel> {
  TextEditingController otpController = TextEditingController();
  late String verificationId;
  final TextEditingController _pinPutController = TextEditingController();
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
          const Spacer(flex: 35),
          const Text(
            "Enter OTP",
            style: TextStyle(
              fontSize: 65,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(flex: 1),
          const Text(
            "to verify your account",
            style: TextStyle(
              color: Colors.black54,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          // TextField(
          //   controller: otpController,
          //   onChanged: (value) {},
          // ),
          const Spacer(flex: 1),
          Padding(
            padding: const EdgeInsets.all(5),
            child: Pinput(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              closeKeyboardWhenCompleted: true,
              androidSmsAutofillMethod:
                  AndroidSmsAutofillMethod.smsUserConsentApi,
              length: 6,
              controller: otpController,
              textCapitalization: TextCapitalization.characters,
              showCursor: false,
              keyboardType: TextInputType.number,
            ),
          ),
          const Spacer(flex: 30),
          Center(
            child: Opacity(
              opacity: 1,
              child: ElevatedButton(
                onPressed: () {
                  BlocProvider.of<AuthBloc>(context)
                      .add(VerifyOTP(verificationId, otpController.text));
                },
                child: const Text(
                  "Confirm",
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
