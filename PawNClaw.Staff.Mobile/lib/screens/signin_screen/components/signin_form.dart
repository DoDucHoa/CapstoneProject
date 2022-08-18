import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pncstaff_mobile_application/blocs/auth/auth_bloc.dart';
import 'package:pncstaff_mobile_application/common/components/primary_button.dart';
import 'package:pncstaff_mobile_application/common/constants.dart';
import 'package:iconsax/iconsax.dart';
import '../../../common/input_validation.dart';

class SignInForm extends StatefulWidget {
  const SignInForm({this.error, Key? key}) : super(key: key);

  final String? error;
  @override
  State<SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  String? emailError;
  String? passwordError;
  bool isHidden = true;

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
            const Spacer(
              flex: 35,
            ),
            Text(
              "Đăng nhập",
              style: TextStyle(
                color: primaryFontColor,
                fontSize: width * extraLargeFontRate,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(
              flex: 1,
            ),
            Text(
              "để sử dụng PawNClaw",
              style: TextStyle(
                color: lightFontColor,
                fontSize: width * largeFontRate,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(
              flex: 3,
            ),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                  labelText: "Email",
                  errorText: emailError,
                  prefixIcon: Container(
                      width: 30,
                      height: 30,
                      margin: EdgeInsets.all(5),
                      // padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: primaryBackgroundColor,
                          borderRadius: BorderRadius.circular(10)),
                      child: Icon(
                        Icons.mail_rounded,
                        color: primaryColor,
                        size: 20,
                      )),
                  border: InputBorder.none),
              onChanged: (input) => setState(() {
                emailError = InputValidator().isEmpty(input) ??
                    InputValidator().isValidMail(input);
              }),
            ),
            const Spacer(
              flex: 3,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: width * 0.65,
                  child: TextField(
                    obscureText: isHidden,
                    obscuringCharacter: '*',
                    controller: _passwordController,
                    decoration: InputDecoration(
                        labelText: "Mật khẩu",
                        errorText: passwordError,
                        prefixIcon: Container(
                            width: 30,
                            height: 30,
                            margin: EdgeInsets.all(5),
                            // padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                color: primaryBackgroundColor,
                                borderRadius: BorderRadius.circular(10)),
                            child: Icon(
                              Icons.lock,
                              color: primaryColor,
                              size: 20,
                            )),
                        border: InputBorder.none),
                    onChanged: (input) => setState(() {
                      passwordError = InputValidator().isEmpty(input);
                    }),
                  ),
                ),
                IconButton(
                    onPressed: () => setState(() {
                          isHidden ? isHidden = false : isHidden = true;
                        }),
                    icon: Icon(
                      (isHidden) ? Iconsax.eye_slash : Iconsax.eye,
                      color: primaryColor,
                    ))
              ],
            ),
            const Spacer(
              flex: 30,
            ),
            Center(
              child: Text(
                widget.error ?? "",
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
            ),
            Center(
              child: Opacity(
                opacity: (_passwordController.text != "" && emailError == null)
                    ? 1
                    : 0.3,
                child: PrimaryButton(
                    text: 'Đăng nhập',
                    contextWidth: width,
                    onPressed: (passwordError == null && emailError == null)
                        ? () {
                            BlocProvider.of<AuthBloc>(context).add(SignIn(
                                _emailController.text,
                                _passwordController.text));
                          }
                        : () {}),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
