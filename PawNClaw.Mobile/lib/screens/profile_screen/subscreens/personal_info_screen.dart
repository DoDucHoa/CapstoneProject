import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:pawnclaw_mobile_application/common/components/primary_button.dart';
import 'package:pawnclaw_mobile_application/common/components/secondary_button.dart';
import 'package:pawnclaw_mobile_application/common/constants.dart';
import 'package:pawnclaw_mobile_application/common/date_picker.dart';
import 'package:pawnclaw_mobile_application/models/account.dart';
import 'package:pawnclaw_mobile_application/models/customer.dart';
import 'package:pawnclaw_mobile_application/models/photo.dart';
import 'package:pawnclaw_mobile_application/repositories/auth/auth_repository.dart';
import 'package:pawnclaw_mobile_application/screens/profile_screen/profile_screen.dart';

import '../../../blocs/authentication/auth_bloc.dart';
import '../../../common/services/upload_service.dart';

class PersonalInfoScreen extends StatefulWidget {
  const PersonalInfoScreen(
      {required this.user, required this.customer, Key? key})
      : super(key: key);
  final Account user;
  final Customer customer;

  @override
  State<PersonalInfoScreen> createState() => _PersonalInfoScreenState();
}

class _PersonalInfoScreenState extends State<PersonalInfoScreen> {
  String? imgURL;
  bool isLoading = false;
  late int gender;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _birthdayController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  @override
  void initState() {
    _nameController.text = widget.customer.name!;
    _phoneController.text = widget.user.phone!;
    _emailController.text = widget.user.userName!;
    _birthdayController.text =
        DateFormat("dd/MM/yyyy").format(widget.customer.birth!).toString();
    //_addressController.text = widget.customer.address!;
    gender = widget.customer.gender!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    Account user = widget.user;
    Customer customer = widget.customer;

    return Scaffold(
      backgroundColor: frameColor,
      appBar: AppBar(
        // title: Text(
        //   'Thông tin cá nhân',
        // ),
        foregroundColor: primaryFontColor,
        backgroundColor: frameColor,
        titleSpacing: width * extraSmallPadRate,
        leadingWidth: width * mediumPadRate * 2,
        elevation: 0,
        leading: Container(),
        // leading: IconButton(
        //     icon:const Icon(
        //       Icons.arrow_back_ios_new_rounded,
        //       size: 20,
        //       color: lightFontColor,
        //     ),
        //     onPressed: () => Navigator.pop(context)),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: width * mediumPadRate),
        child: Column(children: [
          GestureDetector(
            onTap: () async {
              var resultUrl = await FirebaseUpload()
                  .pickFile("customers/${user.id}", false);
              while (resultUrl == null) {
                isLoading = true;
              }

              setState(() {
                isLoading = false;
                imgURL = resultUrl;
              });
            },
            child: Center(
              child: Stack(
                children: [
                  Container(
                    width: width * 0.35,
                    height: width * 0.35,
                    margin: EdgeInsets.only(bottom: width * regularPadRate),
                    decoration: BoxDecoration(
                      //color: Colors.blueGrey[50],
                      borderRadius: BorderRadius.circular(width * 0.3),
                      border: Border.all(width: 5, color: Colors.white),
                      image: (imgURL != null)
                          ? DecorationImage(
                              image: NetworkImage(imgURL!), fit: BoxFit.cover)
                          : (user.photoUrl != null)
                              ? DecorationImage(
                                  image: NetworkImage(user.photoUrl!))
                              : DecorationImage(
                                  image: AssetImage((customer.gender! < 2)
                              ? 'lib/assets/cus-${customer.gender}.png'
                              : 'lib/assets/cus-2.png')),
                    ),
                    child: (isLoading) ? CircularProgressIndicator() : null,
                  ),
                  Positioned(
                      bottom: width * regularPadRate,
                      right: width * extraSmallPadRate,
                      child: Container(
                          width: width * mediumPadRate,
                          height: width * mediumPadRate,
                          //margin: EdgeInsets.only(bottom: width * extraSmallPadRate),
                          decoration: BoxDecoration(
                            color: Colors.blueGrey[100],
                            borderRadius: BorderRadius.circular(7),
                            border: Border.all(width: 2, color: Colors.white),
                          ),
                          child: Icon(Iconsax.image5,
                              color: Colors.white, size: 13))),
                ],
              ),
            ),
          ),
          TextField(
            decoration: InputDecoration(
                hintText: 'Họ và tên',
                hintStyle: TextStyle(color: lightFontColor, fontSize: 15),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.white, width: 2),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(color: lightPrimaryColor, width: 1),
                ),
                border: InputBorder.none,
                fillColor: Colors.white60,
                filled: true),
            style: TextStyle(fontSize: 15),
            controller: _nameController,
          ),
          buildSmallSpacing(width),
          Container(
              width: width * (1 - 2 * mediumPadRate),
              child: InternationalPhoneNumberInput(
                onInputChanged: (value) {},
                isEnabled: false,
                spaceBetweenSelectorAndTextField: 0,
                selectorConfig: SelectorConfig(
                    //useEmoji: true,
                    selectorType: PhoneInputSelectorType.DIALOG),
                selectorTextStyle:
                    TextStyle(wordSpacing: -50, color: primaryFontColor),
                initialValue:
                    PhoneNumber(phoneNumber: user.phone, isoCode: 'VN'),
                inputDecoration: InputDecoration(
                    disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.white, width: 2),
                    ),
                    fillColor: Colors.white60,
                    filled: true),
                searchBoxDecoration: InputDecoration(
                    disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.white, width: 2),
                    ),
                    fillColor: Colors.white60,
                    filled: true),
              )
              // TextField(
              //   decoration: InputDecoration(
              //       hintText: 'Phone',
              //       hintStyle: TextStyle(color: lightFontColor, fontSize: 15),
              //       enabledBorder: OutlineInputBorder(
              //         borderRadius: BorderRadius.circular(10),
              //         borderSide: BorderSide(color: Colors.white, width: 2),
              //       ),
              //       focusedBorder: OutlineInputBorder(
              //         borderRadius: BorderRadius.circular(15),
              //         borderSide:
              //             BorderSide(color: lightPrimaryColor, width: 1),
              //       ),
              //       border: InputBorder.none,
              //       fillColor: Colors.white60,
              //       filled: true),
              //   style: TextStyle(fontSize: 15),
              //   controller: _emailController,
              // ),

              ),
          buildSmallSpacing(width),
          TextField(
            decoration: InputDecoration(
                hintText: 'Email',
                hintStyle: TextStyle(color: lightFontColor, fontSize: 15),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.white, width: 2),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(color: lightPrimaryColor, width: 1),
                ),
                border: InputBorder.none,
                fillColor: Colors.white60,
                filled: true),
            style: TextStyle(fontSize: 15),
            controller: _emailController,
          ),
          buildSmallSpacing(width),
          GestureDetector(
            onTap: () async {
              var date = await selectSingleDateTo(context, DateTime.now());
              if (date != null) {
                setState(() {
                  customer.birth = date;
                  _birthdayController.text =
                      DateFormat('dd/MM/yyyy').format(date);
                });
              }
            },
            child: TextField(
              enabled: false,
              decoration: InputDecoration(
                  disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.white, width: 2),
                  ),
                  prefixIcon: Icon(Icons.cake_rounded, color: lightFontColor),
                  border: InputBorder.none,
                  fillColor: Colors.white60,
                  filled: true),
              style: TextStyle(fontSize: 15),
              controller: _birthdayController,
            ),
          ),
          buildSmallSpacing(width),
          Row(
            children: [
              Text('Giới tính:',
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: lightFontColor)),
              Row(
                children: [
                  Radio(
                      value: 0,
                      groupValue: gender,
                      onChanged: ((value) {
                        setState(() {
                          gender = value as int;
                        });
                      })),
                  Text('Nam'),
                ],
              ),
              Row(
                children: [
                  Radio(
                      value: 1,
                      groupValue: gender,
                      onChanged: ((value) {
                        setState(() {
                          gender = value as int;
                        });
                      })),
                  Text('Nữ'),
                ],
              ),
              Row(
                children: [
                  Radio(
                      value: 2,
                      groupValue: gender,
                      onChanged: ((value) {
                        setState(() {
                          gender = value as int;
                        });
                      })),
                  Text('Khác'),
                ],
              ),
            ],
          ),
          buildSmallSpacing(2 * width),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: width * (1 - 3 * mediumPadRate) / 3,
                child: SecondaryButton(
                    text: 'Hủy',
                    onPressed: () {
                      if (isEdited()) {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                title: Text(
                                  'Bạn có muốn hủy thay đổi?',
                                  style: TextStyle(
                                      color: primaryFontColor, fontSize: 18),
                                ),
                                actions: [
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        primary: Colors.red,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(7))),
                                    child: Text('Hủy'),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        // primary: Colors.red,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(7))),
                                    child: Text('Đồng ý'),
                                    onPressed: () {
                                      Navigator.pop(context);
                                      Navigator.pop(context);
                                    },
                                  ),
                                ],
                              );
                            });
                      } else {
                          Navigator.of(context).pop();
                        }
                      //Navigator.of(context).pop();
                    },
                    contextWidth: width),
              ),
              Container(
                  width: width * (1 - 3 * mediumPadRate) / 3 * 2,
                  child: PrimaryButton(
                      text: 'Lưu thông tin',
                      onPressed: () {
                        if (isEdited()) {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  title: Text(
                                    'Bạn có muốn lưu thay đổi?',
                                    style: TextStyle(
                                        color: primaryFontColor, fontSize: 18),
                                  ),
                                  actions: [
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          primary: Colors.red,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(7))),
                                      child: Text('Hủy'),
                                      onPressed: () {
                                        print(imgURL);
                                        Navigator.pop(context);
                                      },
                                    ),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          // primary: Colors.red,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(7))),
                                      child: Text('Đồng ý'),
                                      onPressed: () async {
                                        Account tempAccount = Account(
                                            id: user.id,
                                            email: _emailController.text,
                                            userName: _emailController.text,
                                            phone: user.phone,
                                            name: _nameController.text,
                                            photoUrl: user.photoUrl,
                                            jwtToken: user.jwtToken,
                                            role: user.role);
                                        Customer tempCustomer = Customer(
                                            id: customer.id,
                                            name: _nameController.text,
                                            birth: customer.birth,
                                            gender: gender);

                                        if (imgURL != null &&
                                            imgURL != user.photoUrl) {
                                          bool isUpdateImg =
                                              await AuthRepository()
                                                  .updateCustomerAvatar(Photo(
                                                      idActor: customer.id,
                                                      url: imgURL,
                                                      isThumbnail: false,
                                                      status: true,
                                                      photoTypeId: 6));
                                          if (isUpdateImg) {
                                            user.photoUrl = imgURL;
                                            tempAccount.photoUrl = imgURL;
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(SnackBar(
                                              content: Text(
                                                  'Cập nhật ảnh đại diện thành công'),
                                              duration: Duration(seconds: 1),
                                            ));
                                          } else {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(SnackBar(
                                                    content: Text(
                                                        'Cập nhật ảnh đại diện thất bại'),
                                                    duration:
                                                        Duration(seconds: 1)));
                                          }
                                        }
                                        if (isEdited()) {
                                          bool isUpdateProfile =
                                              await AuthRepository()
                                                  .updateCustomerInfo(
                                                      tempAccount,
                                                      tempCustomer);
                                          if (isUpdateProfile) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(SnackBar(
                                              content: Text(
                                                  'Cập nhật thông tin thành công'),
                                              duration: Duration(seconds: 1),
                                            ));
                                            Navigator.of(context).pop();
                                            BlocProvider.of<AuthBloc>(context)
                                                .add(UpdateProfile(
                                                    tempAccount, tempCustomer));
                                            Navigator.pop(context);
                                            //Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileScreen()));
                                          } else {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(SnackBar(
                                                    content: Text(
                                                        'Cập nhật thông tin thất bại'),
                                                    duration:
                                                        Duration(seconds: 2)));
                                            Navigator.pop(context);
                                          }
                                        }
                                      },
                                    ),
                                  ],
                                );
                              });
                        }
                      },
                      contextWidth: width))
            ],
          ),
        ]),
      ),
    );
  }

  Widget buildSmallSpacing(width) {
    return SizedBox(
      height: width * smallPadRate,
    );
  }

  bool isEdited() {
    return _nameController.text != widget.user.name ||
        _emailController.text != widget.user.email ||
        _birthdayController.text !=
            DateFormat('dd/MM/yyyy').format(widget.customer.birth!) ||
        imgURL != null ||
        gender != widget.customer.gender;
  }
}
