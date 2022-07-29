import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pncstaff_mobile_application/blocs/auth/auth_bloc.dart';
import 'package:pncstaff_mobile_application/common/components/outlined_text_field.dart';
import 'package:pncstaff_mobile_application/common/constants.dart';
import 'package:pncstaff_mobile_application/common/services/upload_service.dart';
import 'package:pncstaff_mobile_application/models/account.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  Account user = Account();
  bool isEdit = false;

  @override
  void initState() {
    // TODO: implement initState
    var account =
        (BlocProvider.of<AuthBloc>(context).state as Authenticated).user;
    setState(() {
      user = account;
      nameController.text = user.name ?? "";
      emailController.text = user.userName ?? user.email!;
      phoneController.text = user.phone ?? "chưa có số điện thoại";
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: true,
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
                    left: width * 0.3,
                    bottom: 0,
                    child: Align(
                      alignment: Alignment.center,
                      child: CircleAvatar(
                        radius: width * 0.2,
                        backgroundImage: NetworkImage(user.url ?? ""),
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
                                setState(() {
                                  user.url = imageUrl;
                                });
                              },
                              iconSize: 20,
                              icon: Icon(Icons.add_photo_alternate_rounded),
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
              padding: EdgeInsets.only(bottom: width * regularPadRate),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    user.name ?? "",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 22,
                      color: primaryFontColor,
                    ),
                  ),
                  Text(
                    "Nhân viên tại ${user.petCenter!.name}",
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
                    icon: Icons.email,
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
                                nameController.text = user.name ?? "";
                                emailController.text =
                                    user.userName ?? user.email!;
                                phoneController.text =
                                    user.phone ?? "chưa có số điện thoại";
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
                              Icons.edit,
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
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      primary:
                          (!isEdit) ? Colors.amber[700] : lightPrimaryColor,
                    ),
                    child: RichText(
                      text: TextSpan(
                        children: [
                          WidgetSpan(
                            child: Icon(
                              Icons.lock,
                              size: 15,
                              // color: primaryColor,
                            ),
                          ),
                          TextSpan(
                            text: (!isEdit) ? " CHANGE PASSWORD" : " CONFIRM",
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
    );
  }
}
