import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_snake_navigationbar/flutter_snake_navigationbar.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pawnclaw_mobile_application/blocs/authentication/auth_bloc.dart';
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

    return BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
      return (state is Authenticated)
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
                            //color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(width: 5, color: Colors.white),
                            image: (state.user.photoUrl != null)
                                ? DecorationImage(
                                    image: NetworkImage(state.user.photoUrl!))
                                : DecorationImage(
                                    image: AssetImage((state.customer!.gender! >
                                            -1)
                                        ? 'lib/assets/cus-${state.customer!.gender}.png'
                                        : 'lib/assets/cus-2.png')),
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
                              state.customer!.name!,
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
                                customer: state.customer!,
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
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                  title: Text("Thông báo"),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15)),
                                  content:
                                      Text("Bạn có chắc chắn muốn đăng xuất không?"),
                                  actions: [
                                    ElevatedButton(
                                      child: Text("Hủy"),
                                      style: ElevatedButton.styleFrom(
                                          primary: Colors.blueGrey[50],
                                          onPrimary: primaryFontColor,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(7))),
                                      onPressed: () =>
                                          Navigator.of(context).pop(),
                                    ),
                                    ElevatedButton(
                                      child: Text("Đồng ý"),
                                      style: ElevatedButton.styleFrom(
                                          primary: Colors.red,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(7))),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                        BlocProvider.of<AuthBloc>(context)
                                            .add(SignOut(context));
                                      },
                                    )
                                  ]);
                            });
                      },
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
            )
          : LoadingIndicator(loadingText: 'Vui lòng chờ');
    });
  }
}
