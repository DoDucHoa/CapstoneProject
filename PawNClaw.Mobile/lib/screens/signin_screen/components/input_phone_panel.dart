import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:pawnclaw_mobile_application/blocs/authentication/auth_bloc.dart';
import 'package:pawnclaw_mobile_application/constants.dart';

class InputPhonePanel extends StatefulWidget {
  InputPhonePanel({Key? key}) : super(key: key);

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
    return Container(
      padding: const EdgeInsets.all(35),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Spacer(flex: 35),
          const Text(
            "Sign up",
            style: TextStyle(
              fontSize: 65,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(flex: 1),
          const Text(
            "to booking your service",
            style: TextStyle(
              color: Colors.black54,
              fontSize: 20,
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
              hintText: 'Phone Number',
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
                        BlocProvider.of<AuthBloc>(context)
                            .add(VerifyPhonenumber(phoneController.text));
                      }
                    : () {},
                child: const Text(
                  "Verify your phone number",
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