import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_snake_navigationbar/flutter_snake_navigationbar.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pawnclaw_mobile_application/blocs/user/user_bloc.dart';
import 'package:pawnclaw_mobile_application/common/components/loading_indicator.dart';
import 'package:pawnclaw_mobile_application/screens/profile_screen/subscreens/personal_info_screen.dart';

import '../../common/constants.dart';
import '../home_screen/HomeScreen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _selectedItemPosition = 2;
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return BlocBuilder<UserBloc, UserState>(builder: (context, state) {
      return (state is UserUpdated)
          ? Scaffold(
              backgroundColor: frameColor,
              body: Padding(
                padding: EdgeInsets.all(width * regularPadRate),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: width * 0.2,
                          height: width * 0.2,
                          margin: EdgeInsets.fromLTRB(0, 20, 10, 20),
                          decoration: BoxDecoration(
                              color: Colors.blueGrey[100],
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(width: 5, color: Colors.white),
                              image:
                                  // (state.user. != null)
                                  //     ?
                                  DecorationImage(
                                      image: AssetImage('lib/assets/cus2.png'))
                              // : null
                              ),
                          // child:
                          // (imgURL == null)
                          //     ?
                          //  const Center(
                          //     child: Icon(
                          //     Iconsax.image4,
                          //     color: Colors.white,
                          //     size: 35,
                          //   ))
                          // : null,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              state.user.name!,
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: width * regularFontRate,
                                  height: 1.5),
                            ),
                            Text(
                              "Pet Lover",
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: width * smallFontRate,
                                  color: lightFontColor,
                                  height: 1.5),
                            ),
                          ],
                        )
                      ],
                    ),
                    GestureDetector(
                      onTap: () => Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => PersonalInfoScreen(
                                user: state.user,
                              ))),
                      child: Container(
                        // width: width*regularPadRate,
                        padding: EdgeInsets.all(width * smallPadRate),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(children: [
                          Container(
                            height: 35,
                            width: 35,
                            decoration: BoxDecoration(
                              color: Colors.blueGrey[50],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(
                              Icons.person_rounded,
                              color: lightFontColor,
                            ),
                          ),
                          SizedBox(
                            width: width * smallPadRate,
                          ),
                          Text(
                            "Thông tin cá nhân",
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                                height: 1.5),
                          ),
                          Expanded(child: SizedBox()),
                          Icon(
                            Icons.arrow_forward_ios_rounded,
                            color: lightFontColor,
                            size: 15,
                          )
                        ]),
                      ),
                    ),
                    SizedBox(
                      height: width * smallPadRate,
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        // width: width*regularPadRate,
                        padding: EdgeInsets.all(width * smallPadRate),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(children: [
                          Container(
                            height: 35,
                            width: 35,
                            decoration: BoxDecoration(
                              color: Colors.blueGrey[50],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(
                              Iconsax.more_circle5,
                              color: lightFontColor,
                            ),
                          ),
                          SizedBox(
                            width: width * smallPadRate,
                          ),
                          Text(
                            "FAQs",
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                                height: 1.5),
                          ),
                          Expanded(child: SizedBox()),
                          Icon(
                            Icons.arrow_forward_ios_rounded,
                            color: lightFontColor,
                            size: 15,
                          )
                        ]),
                      ),
                    ),
                    SizedBox(
                      height: width * smallPadRate,
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        // width: width*regularPadRate,
                        padding: EdgeInsets.all(width * smallPadRate),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(children: [
                          Container(
                            height: 35,
                            width: 35,
                            decoration: BoxDecoration(
                              color: Colors.blueGrey[50],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(
                              Icons.policy_rounded,
                              color: lightFontColor,
                            ),
                          ),
                          SizedBox(
                            width: width * smallPadRate,
                          ),
                          Text(
                            "Điều khoản & chính sách",
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                                height: 1.5),
                          ),
                          Expanded(child: SizedBox()),
                          Icon(
                            Icons.arrow_forward_ios_rounded,
                            color: lightFontColor,
                            size: 15,
                          )
                        ]),
                      ),
                    ),
                    Expanded(child: SizedBox()),
                    TextButton.icon(
                      onPressed: () {},
                      style: TextButton.styleFrom(primary: Colors.red),
                      icon: Icon(
                        Iconsax.logout,
                        size: 18,
                      ),
                      label: Text("Đăng xuất"),
                    )
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
                onTap: (index) {
                  setState(() => _selectedItemPosition = index);
                  switch (index) {
                    case 0:
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const HomeScreen()));
                      break;
                    case 1:
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const HomeScreen()));
                      break;
                    case 2:
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const ProfileScreen()));
                      break;
                  }
                },
                items: const [
                  BottomNavigationBarItem(
                      icon: Icon(
                        Iconsax.home5,
                      ),
                      label: ""),
                  BottomNavigationBarItem(
                      icon: Icon(
                        Iconsax.message5,
                      ),
                      label: ""),
                  BottomNavigationBarItem(
                      icon: Icon(
                        Icons.person_rounded,
                      ),
                      label: ""),
                ],
              ),
            )
          : LoadingIndicator(loadingText: 'Vui lòng chờ');
    });
  }
}
