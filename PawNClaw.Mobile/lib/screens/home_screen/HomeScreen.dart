import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_snake_navigationbar/flutter_snake_navigationbar.dart';
import 'package:pawnclaw_mobile_application/blocs/authentication/auth_bloc.dart';
import 'package:pawnclaw_mobile_application/common/constants.dart';

import 'components/home_body.dart';
import 'components/welcome_panel.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedItemPosition = 0;
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is Authenticated)
          return Scaffold(
            resizeToAvoidBottomInset: true,
            body: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  WelcomePanel(
                      height: height, width: width, username: state.user.name!),
                  HomeBody(width: width, height: height),
                ],
              ),
            ),
            bottomNavigationBar: SnakeNavigationBar.color(
              behaviour: SnakeBarBehaviour.floating,
              selectedItemColor: Colors.white,
              unselectedItemColor: Colors.black45,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              elevation: 20,
              height: height * 0.1,
              snakeViewColor: primaryColor,
              snakeShape: SnakeShape(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
                centered: true,
                height: height * 0.07,
                padding: EdgeInsets.all(height * 0.015),
              ),
              currentIndex: _selectedItemPosition,
              onTap: (index) => setState(() => _selectedItemPosition = index),
              items: [
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.home,
                    ),
                    label: ""),
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.message,
                    ),
                    label: ""),
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.person,
                    ),
                    label: ""),
              ],
            ),
          );
        return Center(child: CircularProgressIndicator());
      },
    );
  }
}
