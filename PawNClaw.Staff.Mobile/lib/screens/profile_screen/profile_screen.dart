import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pncstaff_mobile_application/blocs/auth/auth_bloc.dart';
import 'package:pncstaff_mobile_application/blocs/user/user_bloc.dart';
import 'package:pncstaff_mobile_application/common/components/loading_indicator.dart';
import 'package:pncstaff_mobile_application/common/components/outlined_text_field.dart';
import 'package:pncstaff_mobile_application/common/constants.dart';
import 'package:pncstaff_mobile_application/common/input_validation.dart';
import 'package:pncstaff_mobile_application/common/services/upload_service.dart';
import 'package:pncstaff_mobile_application/models/account.dart';
import 'package:pncstaff_mobile_application/models/user_profile.dart';
import 'package:pncstaff_mobile_application/repositories/user/user_repository.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController oldPassword = TextEditingController(text: "");
  TextEditingController newPassword = TextEditingController(text: "");
  TextEditingController verifyPassword = TextEditingController(text: "");
  bool isEdit = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    var account =
        (BlocProvider.of<AuthBloc>(context).state as Authenticated).user;
    return BlocProvider(
      create: (context) => UserBloc(userRepository: UserRepository())
        ..add(GetUserProfile(id: account.id!)),
      child: BlocBuilder<UserBloc, UserState>(
        builder: (context, state) {
          if (state is ProfileLoaded) {
            var user = state.profile;
            nameController.text = user.staffIdNavigation?.name ?? "";
            emailController.text = user.userName ?? "";
            phoneController.text = user.phone ?? "";
            return SafeArea(
              child: Scaffold(
                resizeToAvoidBottomInset: false,
                backgroundColor: frameColor,
                body: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                          bottom: width * smallPadRate,
                        ),
                        child: Stack(
                          children: [
                            Container(
                              height: height * 0.3,
                            ),
                            Container(
                              width: width,
                              height: height * 0.3 - width * 0.18,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(20),
                                  bottomRight: Radius.circular(20),
                                ),
                                image: DecorationImage(
                                    image: AssetImage("lib/assets/center0.jpg"),
                                    fit: BoxFit.fill),
                              ),
                            ),
                            Positioned(
                              top: 0,
                              right: 0,
                              child: IconButton(
                                icon: Icon(
                                  Icons.exit_to_app,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  BlocProvider.of<AuthBloc>(context)
                                      .add(SignOut());
                                },
                              ),
                            ),
                            Positioned(
                              left: width * 0.3,
                              bottom: 0,
                              child: Align(
                                alignment: Alignment.center,
                                child: CircleAvatar(
                                  radius: width * 0.2,
                                  backgroundImage: NetworkImage(
                                      user.photos?.first.url ?? ""),
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                      top: width * 0.4 - 38,
                                      left: width * 0.4 - 38,
                                    ),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: primaryColor,
                                      ),
                                      child: IconButton(
                                        onPressed: () async {
                                          var imageUrl = await FirebaseUpload()
                                              .pickFile("accounts/", false);
                                          await UserRepository()
                                              .updateUserAvatar(
                                                  user.photos!.first.id!,
                                                  imageUrl!);
                                          setState(() {
                                            user.photos?.first.url = imageUrl;
                                          });
                                        },
                                        iconSize: 20,
                                        icon: Icon(
                                            Icons.add_photo_alternate_rounded),
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.only(bottom: width * regularPadRate),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              user.staffIdNavigation?.name ?? "",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 22,
                                color: primaryFontColor,
                              ),
                            ),
                            Text(
                              "Nhân viên tại ${user.center?.name ?? ""}",
                              style: TextStyle(
                                fontWeight: FontWeight.w300,
                                fontSize: 20,
                                color: primaryFontColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      (isEdit)
                          ? OutlinedText(
                              labelText: "Name",
                              icon: Icons.person,
                              controller: nameController,
                              enable: isEdit,
                            )
                          : Container(),
                      OutlinedText(
                        labelText: "Email",
                        icon: Icons.email,
                        controller: emailController,
                        enable: false,
                      ),
                      OutlinedText(
                        labelText: "Phone",
                        icon: Icons.phone,
                        controller: phoneController,
                        enable: isEdit,
                      ),
                      Padding(
                        padding: EdgeInsets.all(width * regularPadRate),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              onPressed: !isEdit
                                  ? () {
                                      setState(
                                        () {
                                          isEdit = true;
                                        },
                                      );
                                    }
                                  : () {
                                      setState(
                                        () {
                                          nameController.text =
                                              user.staffIdNavigation?.name ??
                                                  "";
                                          emailController.text =
                                              user.userName ?? "";
                                          phoneController.text = user.phone ??
                                              "chưa có số điện thoại";
                                          isEdit = false;
                                        },
                                      );
                                    },
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                primary: (!isEdit)
                                    ? lightPrimaryColor.withOpacity(0.5)
                                    : Colors.amber[700],
                              ),
                              child: RichText(
                                text: TextSpan(
                                  children: [
                                    WidgetSpan(
                                      child: Icon(
                                        (!isEdit) ? Icons.edit : Icons.cancel,
                                        size: 15,
                                        // color: primaryColor,
                                      ),
                                    ),
                                    TextSpan(
                                      text: (!isEdit) ? " EDIT" : " CANCEL",
                                      // style: TextStyle(color: primaryColor),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: (!isEdit)
                                  ? () {
                                      String? passwordError;
                                      showCupertinoDialog(
                                        context: context,
                                        builder: (context) => Dialog(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          backgroundColor: frameColor,
                                          child: StatefulBuilder(
                                            builder: (context, setState) =>
                                                Container(
                                              padding: EdgeInsets.all(
                                                  width * smallPadRate),
                                              height: height * 0.5,
                                              width: width * 0.8,
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  Text(
                                                    "Đổi mật khẩu",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 20),
                                                  ),
                                                  Column(
                                                    children: [
                                                      OutlinedText(
                                                        controller: oldPassword,
                                                        labelText:
                                                            "Mật khẩu cũ",
                                                        icon: Icons
                                                            .lock_clock_rounded,
                                                        obsecure: true,
                                                      ),
                                                      OutlinedText(
                                                        controller: newPassword,
                                                        labelText:
                                                            "Mật khẩu mới",
                                                        icon: Icons.lock,
                                                        obsecure: true,
                                                      ),
                                                      OutlinedText(
                                                        controller:
                                                            verifyPassword,
                                                        labelText:
                                                            "Xác nhận mật khẩu mới",
                                                        icon: Icons.lock,
                                                        obsecure: true,
                                                      ),
                                                    ],
                                                  ),
                                                  (passwordError != null)
                                                      ? Text(
                                                          "*${passwordError!}",
                                                          style: TextStyle(
                                                            color: Colors.red,
                                                          ),
                                                        )
                                                      : Container(),
                                                  Flexible(
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceEvenly,
                                                      children: [
                                                        ElevatedButton(
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                                  shape:
                                                                      RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10),
                                                                  ),
                                                                  primary: Colors
                                                                          .amber[
                                                                      700]),
                                                          child: RichText(
                                                            text: TextSpan(
                                                              children: [
                                                                WidgetSpan(
                                                                  child: Icon(
                                                                    Icons
                                                                        .cancel,
                                                                    size: 15,
                                                                    // color: primaryColor,
                                                                  ),
                                                                ),
                                                                TextSpan(
                                                                    text:
                                                                        " CANCEL"
                                                                    // style: TextStyle(color: primaryColor),
                                                                    ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                        ElevatedButton(
                                                          onPressed: () async {
                                                            var error = await InputValidator()
                                                                .validatePassword(
                                                                    oldPassword
                                                                        .text,
                                                                    newPassword
                                                                        .text,
                                                                    verifyPassword
                                                                        .text);
                                                            if (error != null) {
                                                              setState(() =>
                                                                  passwordError =
                                                                      error);
                                                            } else {
                                                              await FirebaseAuth
                                                                  .instance
                                                                  .currentUser!
                                                                  .updatePassword(
                                                                      newPassword
                                                                          .text);
                                                              ScaffoldMessenger
                                                                      .of(
                                                                          context)
                                                                  .showSnackBar(
                                                                      SnackBar(
                                                                          content:
                                                                              Text("Đổi mật khẩu thành công")));
                                                              Navigator.pop(
                                                                  context);
                                                              BlocProvider.of<
                                                                          AuthBloc>(
                                                                      context)
                                                                  .add(
                                                                      SignOut());
                                                            }
                                                          },
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                            shape:
                                                                RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10),
                                                            ),
                                                            primary:
                                                                lightPrimaryColor,
                                                          ),
                                                          child: RichText(
                                                            text: TextSpan(
                                                              children: [
                                                                WidgetSpan(
                                                                  child: Icon(
                                                                    Icons.check,
                                                                    size: 15,
                                                                    // color: primaryColor,
                                                                  ),
                                                                ),
                                                                TextSpan(
                                                                    text:
                                                                        " CONFIRM"
                                                                    // style: TextStyle(color: primaryColor),
                                                                    ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ).then((value) {
                                        setState(() {
                                          oldPassword.text = "";
                                          newPassword.text = "";
                                          verifyPassword.text = "";
                                        });
                                      });
                                    }
                                  : () {
                                      if (nameController.text.isNotEmpty &&
                                          phoneController.text.isNotEmpty) {
                                        BlocProvider.of<UserBloc>(context).add(
                                            UpdateUserProfile(
                                                state.profile.id!,
                                                nameController.text,
                                                phoneController.text));
                                        setState(() {
                                          this.isEdit = false;
                                        });
                                      }
                                    },
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                primary: (!isEdit)
                                    ? Colors.amber[700]
                                    : lightPrimaryColor,
                              ),
                              child: RichText(
                                text: TextSpan(
                                  children: [
                                    WidgetSpan(
                                      child: Icon(
                                        (!isEdit) ? Icons.lock : Icons.check,
                                        size: 15,
                                        // color: primaryColor,
                                      ),
                                    ),
                                    TextSpan(
                                      text: (!isEdit)
                                          ? " CHANGE PASSWORD"
                                          : " CONFIRM",
                                      // style: TextStyle(color: primaryColor),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          } else {
            return LoadingIndicator(loadingText: "Vui lòng chờ");
          }
        },
      ),
    );
  }
}
