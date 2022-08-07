import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:pawnclaw_mobile_application/blocs/authentication/auth_bloc.dart';
import 'package:pawnclaw_mobile_application/common/constants.dart';

class InputPhonePanel extends StatefulWidget {
  const InputPhonePanel({Key? key}) : super(key: key);

  @override
  State<InputPhonePanel> createState() => _InputPhonePanelState();
}

class _InputPhonePanelState extends State<InputPhonePanel> {
  bool isValid = false;
  TextEditingController phoneController = TextEditingController();
  String initialCountry = 'VN';
  PhoneNumber number = PhoneNumber(isoCode: 'VN');
  String? verificationID;

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
              "Đăng nhập",
              style: TextStyle(
                color: primaryFontColor,
                fontSize: width * extraLargeFontRate,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(flex: 1),
            Text(
              "để sử dụng dịch vụ",
              style: TextStyle(
                color: lightFontColor,
                fontSize: width * largeFontRate,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(flex: 3),
            InternationalPhoneNumberInput(
              onInputChanged: (PhoneNumber number) {
                setState(() {
                  phoneController.text = number.phoneNumber ?? "";
                });
              },
              onInputValidated: (bool value) {
                setState(() {
                  isValid = value;
                });
              },
              selectorConfig: const SelectorConfig(
                useEmoji: true,
                leadingPadding: 10,
                setSelectorButtonAsPrefixIcon: true,
                selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
              ),
              ignoreBlank: false,
              errorMessage: "",
              initialValue: number,
              autoValidateMode: AutovalidateMode.always,
              selectorTextStyle: TextStyle(
                color: primaryColor,
              ),
              formatInput: false,
              maxLength: 9,
              keyboardType: const TextInputType.numberWithOptions(
                  signed: true, decimal: true),
              cursorColor: Colors.black,
              inputDecoration: InputDecoration(
                hintText: 'Số điện thoại',
                hintStyle: TextStyle(
                  color: Colors.grey.shade500,
                  fontSize: 16,
                ),
                border: InputBorder.none,
              ),
            ),
            const Spacer(flex: 30),
            Center(
              child: Opacity(
                opacity: isValid ? 1 : 0.3,
                child: ElevatedButton(
                    onPressed: isValid
                        ? () {
                            FirebaseAuth.instance.signOut();
                            BlocProvider.of<AuthBloc>(context)
                                .add(VerifyPhonenumber(phoneController.text));
                          }
                        : () {},
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    )),
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(vertical: width * smallPadRate),
                      child: const Center(
                        child: Text(
                          'Xác thực số điện thoại',
                          style:  TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
