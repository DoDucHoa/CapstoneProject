import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pawnclaw_mobile_application/blocs/authentication/auth_bloc.dart';
import 'package:pawnclaw_mobile_application/common/constants.dart';
import 'package:pinput/pinput.dart';

class InputOTPPanel extends StatefulWidget {
  const InputOTPPanel({Key? key, required this.phoneNumber, this.error})
      : super(key: key);

  final String phoneNumber;
  final String? error;
  @override
  State<InputOTPPanel> createState() => _InputOTPPanelState();
}

class _InputOTPPanelState extends State<InputOTPPanel> {
  TextEditingController otpController = TextEditingController();
  late String verificationId;
  bool isValid = false;
  
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
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(width * regularPadRate),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Spacer(flex: 35),
            Text(
              "Nhập OTP",
              style: TextStyle(
                color: primaryFontColor,
                fontSize: width * extraLargeFontRate,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(flex: 1),
            Text(
              "để xác thực tài khoản của bạn",
              style: TextStyle(
                color: lightFontColor,
                fontSize: width * largeFontRate,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(flex: 1),
            Padding(
              padding: EdgeInsets.all(width * smallPadRate),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Pinput(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    closeKeyboardWhenCompleted: true,
                    // androidSmsAutofillMethod:
                    //     AndroidSmsAutofillMethod.smsUserConsentApi,
                    length: 6,
                    controller: otpController,
                    textCapitalization: TextCapitalization.characters,
                    showCursor: false,
                    keyboardType: TextInputType.number,
                    onChanged: (input) {
                      input.length == 6
                          ? setState(() {
                              isValid = true;

                            })
                          : setState(() {
                              isValid = false;
                            });
                            
                    },
                    // onCompleted: ((value) {
                    //   print(value)
                    // }),
                    
                    
                  ),
                  Text(
                    widget.error ?? "",
                    style: TextStyle(color: Colors.red),
                  ),
                ],
              ),
            ),
            const Spacer(flex: 30),
            Center(
              child: Opacity(
                opacity: isValid ? 1 : 0.3,
                child: ElevatedButton(
                  onPressed: () {
                    BlocProvider.of<AuthBloc>(context).add(VerifyOTP(
                        verificationId,
                        otpController.text,
                        widget.phoneNumber));
                  },
                  child: Text(
                    "Xác nhận",
                    style: TextStyle(
                        color: Colors.white, fontSize: width * regularFontRate),
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
      ),
    );
  }
}
