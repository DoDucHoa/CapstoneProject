import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pawnclaw_mobile_application/blocs/authentication/auth_bloc.dart';
import 'package:pawnclaw_mobile_application/common/constants.dart';
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

  _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDatePickerMode: DatePickerMode.year,
      initialDate: DateTime.now(),
      firstDate: DateTime(1920),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate)
      setState(() {
        _selectedDate = picked;
        _birthController.text = DateFormat.yMd().format(picked);
      });
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
            "Welcome!",
            style: TextStyle(
              fontSize: 65,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(flex: 1),
          const Text(
            "Please fill your information to finish signing up",
            style: TextStyle(
              color: Colors.black54,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(flex: 3),
          TextField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText: "Name",
              errorText: nameError,
            ),
            onChanged: (input) => setState(() {
              nameError = InputValidator().isEmpty(input);
            }),
          ),
          const Spacer(flex: 3),
          TextField(
            controller: _phoneController,
            decoration: InputDecoration(
              labelText: "Phone",
            ),
            readOnly: true,
          ),
          const Spacer(flex: 3),
          TextField(
            controller: _emailController,
            decoration: InputDecoration(
              labelText: "Email",
              errorText: emailError,
            ),
            onChanged: (input) => setState(() {
              emailError = InputValidator().isEmpty(input) ??
                  InputValidator().isValidMail(input);
            }),
            autofocus: false,
          ),
          const Spacer(flex: 3),
          GestureDetector(
            onTap: () => _selectDate(context),
            child: TextField(
              enabled: false,
              controller: _birthController,
              decoration: InputDecoration(
                  labelText: "Birth",
                  errorText: InputValidator().isEmpty(_birthController.text)),
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
