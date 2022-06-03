import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pncstaff_mobile_application/blocs/auth/auth_bloc.dart';
import 'package:pncstaff_mobile_application/common/components/loading_indicator.dart';
import 'package:pncstaff_mobile_application/screens/home_screen/home_screen.dart';
import 'package:pncstaff_mobile_application/screens/signin_screen/components/signin_form.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is Unauthenticated) {
          return SignInForm(error: state.error);
        }
        if (state is Authenticated) {
          return const HomeScreen();
        } else
          return const Scaffold(
              body: LoadingIndicator(loadingText: "Vui lòng đợi"));
      },
    );
  }
}
