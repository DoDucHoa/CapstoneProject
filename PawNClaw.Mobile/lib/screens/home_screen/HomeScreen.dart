import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pawnclaw_mobile_application/blocs/authentication/auth_bloc.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: ElevatedButton(
              child: BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  if (state is Authenticated)
                    return Text(state.user.name! + "Logged in");
                  return Text("Logged in");
                },
              ),
              onPressed: () {
                var state = BlocProvider.of<AuthBloc>(context).state;
                if (state is Authenticated) print(state.user.jwtToken);
              },
            ),
          ),
          Center(
            child: ElevatedButton(
              child: Text("Logout"),
              onPressed: () {
                BlocProvider.of<AuthBloc>(context).add(SignOut(context));
              },
            ),
          ),
        ],
      ),
    );
  }
}
