import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pawnclaw_mobile_application/blocs/authentication/auth_bloc.dart';
import 'package:pawnclaw_mobile_application/common/constants.dart';
import 'package:pawnclaw_mobile_application/common/date_picker.dart';
import 'package:pawnclaw_mobile_application/common/input_validation.dart';
import 'package:intl/intl.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({Key? key, required this.phoneNumber}) : super(key: key);

  final String phoneNumber;

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _birthController = TextEditingController();
  String? nameError;
  String? emailError;
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    // TODO: implement initState
    _phoneController.text = widget.phoneNumber;
    super.initState();
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
              "Chào mừng!",
              style: TextStyle(
                color: primaryFontColor,
                fontSize: width * extraLargeFontRate,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(flex: 1),
            Text(
              "Hãy điền thông tin của bạn để hoàn tất đăng nhập",
              style: TextStyle(
                color: lightFontColor,
                fontSize: width * largeFontRate,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(flex: 3),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: "Tên",
                errorText: nameError,
                prefixIcon: Icon(
                  Icons.person,
                  color: primaryColor,
                ),
              ),
              onChanged: (input) => setState(() {
                nameError = InputValidator().isEmpty(input);
              }),
            ),
            const Spacer(flex: 3),
            TextField(
              controller: _phoneController,
              decoration: InputDecoration(
                labelText: "Số điện thoại",
                prefixIcon: Icon(
                  Icons.phone,
                  color: primaryColor,
                ),
              ),
              readOnly: true,
            ),
            const Spacer(flex: 3),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: "Địa chỉ email",
                errorText: emailError,
                prefixIcon: Icon(
                  Icons.mail,
                  color: primaryColor,
                ),
              ),
              onChanged: (input) => setState(() {
                emailError = InputValidator().isEmpty(input) ??
                    InputValidator().isValidMail(input);
              }),
              autofocus: false,
            ),
            const Spacer(flex: 3),
            GestureDetector(
              onTap: () async {
                final DateTime? picked = await selectSingleDate(context);
                setState(() {
                  _selectedDate = picked ?? DateTime.now();
                  _birthController.text =
                      DateFormat('dd/MM/yyyy').format(picked!);
                });
              },
              child: TextField(
                enabled: false,
                controller: _birthController,
                decoration: InputDecoration(
                  labelText: "Ngày sinh",
                  errorText: InputValidator().isEmpty(_birthController.text),
                  prefixIcon: const Icon(Icons.calendar_month),
                ),
                readOnly: true,
              ),
            ),
            const Spacer(flex: 30),
            Center(
              child: Opacity(
                opacity: (nameError == null &&
                        emailError == null &&
                        _birthController.text != "")
                    ? 1
                    : 0.3,
                child: ElevatedButton(
                  onPressed: (nameError == null && emailError == null)
                      ? () {
                          BlocProvider.of<AuthBloc>(context).add(SignUp(
                              _nameController.text,
                              _phoneController.text,
                              _emailController.text,
                              _selectedDate));
                        }
                      : () {},
                  child: Text(
                    "Confirm",
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
