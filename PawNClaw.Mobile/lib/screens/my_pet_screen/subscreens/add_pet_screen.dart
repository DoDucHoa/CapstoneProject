import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:pawnclaw_mobile_application/common/components/primary_button.dart';
import 'package:pawnclaw_mobile_application/common/constants.dart';
import 'package:pawnclaw_mobile_application/models/pet.dart';
import 'package:pawnclaw_mobile_application/repositories/pet/pet_repository.dart';
import 'package:pawnclaw_mobile_application/screens/my_pet_screen/my_pet_screen.dart';
import 'package:pawnclaw_mobile_application/screens/my_pet_screen/subscreens/pet_details_screen.dart';

import '../../../common/date_picker.dart';
import '../../../common/services/upload_service.dart';
import '../../../models/photo.dart';

class AddPetScreen extends StatefulWidget {
  const AddPetScreen(
      {required this.customerId, this.pet, this.isEdit, Key? key})
      : super(key: key);
  final int customerId;
  final Pet? pet;
  final bool? isEdit;
  @override
  State<AddPetScreen> createState() => _AddPetScreenState();
}

class _AddPetScreenState extends State<AddPetScreen> {
  String? imgURL;
  TextEditingController _nameController = TextEditingController();
  TextEditingController _dateController = TextEditingController();
  TextEditingController _heightController = TextEditingController();
  TextEditingController _weightController = TextEditingController();
  TextEditingController _lengthController = TextEditingController();
  TextEditingController _breedController = TextEditingController();

  String? breedType;
  bool nameError = false;
  bool weightError = false;
  bool heightError = false;
  bool lengthError = false;
  bool birdthdayError = false;
  bool breedError = false;

  DateTime? birthDay;
  @override
  void initState() {
    var petToUpdate = widget.pet;
    if (petToUpdate != null) {
      _nameController.text = petToUpdate.name!;
      _dateController.text =
          DateFormat('dd/MM/yyyy').format(petToUpdate.birth!);
      _heightController.text = petToUpdate.height!.toStringAsFixed(0);
      _weightController.text = petToUpdate.weight!.toStringAsFixed(0);
      _lengthController.text = petToUpdate.length!.toStringAsFixed(0);
      _breedController.text =
          petToUpdate.breedName!; // it makes user cannot change breed
      birthDay = petToUpdate.birth;
      breedType =
          petToUpdate.petTypeCode!; // it makes user cannot change breed2

      imgURL = null;
      // petToUpdate.photos!.isNotEmpty ? petToUpdate.photos!.first.url : null;
      //  print(petToUpdate.photos!.length);
    }
    super.initState();
  }

  bool isChanged() {
    return _nameController.text != widget.pet?.name ||
        _dateController.text !=
            DateFormat('dd/MM/yyyy').format(widget.pet!.birth!) ||
        _heightController.text != widget.pet!.height!.toStringAsFixed(0) ||
        _weightController.text != widget.pet!.weight!.toStringAsFixed(0) ||
        _lengthController.text != widget.pet!.length!.toStringAsFixed(0) ||
        _breedController.text != widget.pet!.breedName ||
        breedType != widget.pet?.petTypeCode ||
        (imgURL != widget.pet?.photos?.first.url && imgURL != null);
  }

  bool isFilled() {
    return _nameController.text != "" &&
        _dateController.text != "" &&
        _heightController.text != "" &&
        _weightController.text != "" &&
        _lengthController.text != "" &&
        _breedController.text != "" &&
        breedType != "" &&
        (imgURL != null || widget.pet?.photos != null);
  }

  bool isEdited() {
    return _nameController.text != "" ||
        _dateController.text != "" ||
        _heightController.text != "" ||
        _weightController.text != "" ||
        _lengthController.text != "" ||
        _breedController.text != "" ||
        //breedType != "" ||
        breedType != null ||
        imgURL != null;
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    var petToUpdate = widget.pet;
    var isEdit = widget.isEdit != null ? widget.isEdit : false;

    return Scaffold(
      backgroundColor: frameColor,
      appBar: AppBar(
          leading: Container(),
          backgroundColor: frameColor,
          toolbarHeight: 35,
          elevation: 0,
          actions: [
            IconButton(
                //TO-DO: ALERT USER TO SAVE THE PROCESS
                onPressed: () {
                  if (isEdit!) {
                    if (isChanged()) {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              title: Text('Hủy thay đổi'),
                              content:
                                  Text('Bạn có chắc chắn muốn hủy thay đổi?'),
                              actions: <Widget>[
                                ElevatedButton(
                                  child: Text('Không'),
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.grey[50],
                                    onPrimary: Colors.black,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(7)),
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                                ElevatedButton(
                                  child: Text('Có'),
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.red,
                                    onPrimary: Colors.white,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(7)),
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          });
                    } else {
                      Navigator.of(context).pop();
                    }
                  } else if (isEdited()) {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            title: Text('Hủy thay đổi'),
                            content:
                                Text('Bạn có chắc chắn muốn hủy thay đổi?'),
                            actions: <Widget>[
                              ElevatedButton(
                                child: Text('Không'),
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.grey[50],
                                  onPrimary: Colors.black,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(7)),
                                ),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                              ElevatedButton(
                                child: Text('Có'),
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.red,
                                  onPrimary: Colors.white,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(7)),
                                ),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        });
                  } else {
                    Navigator.of(context).pop();
                  }
                },
                icon: const Icon(
                  Iconsax.close_square,
                  color: lightFontColor,
                  size: 25,
                ))
          ]),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(width * mediumPadRate),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                onTap: () async {
                  var resultUrl = await FirebaseUpload()
                      .pickFile("customers/pet/${widget.customerId}", false);
                  if (resultUrl == null) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text("Uploading..."),
                    ));
                  } else
                    setState(() {
                      imgURL = resultUrl;
                    });
                },
                child: Center(
                  child: Container(
                    width: width * 0.35,
                    height: width * 0.35,
                    margin: EdgeInsets.only(bottom: width * regularPadRate),
                    decoration: BoxDecoration(
                        color: Colors.blueGrey[100],
                        borderRadius: BorderRadius.circular(width * 0.3),
                        border: Border.all(width: 5, color: Colors.white),
                        image: (imgURL != null)
                            ? DecorationImage(image: NetworkImage(imgURL!))
                            : ((petToUpdate != null &&
                                    petToUpdate.photos!.isNotEmpty)
                                ? DecorationImage(
                                    image: NetworkImage(
                                        petToUpdate.photos!.first.url!))
                                : null)),
                    child: (imgURL == null)
                        ? (petToUpdate != null && petToUpdate.photos!.isEmpty)
                            ? const Center(
                                child: Icon(
                                Iconsax.image4,
                                color: Colors.white,
                                size: 35,
                              ))
                            : null
                        : null,
                  ),
                ),
              ),
              Center(
                child: Container(
                  height: height * 0.07,
                  width: width * (1 - 2 * smallPadRate),
                  padding:
                      EdgeInsets.symmetric(horizontal: width * smallPadRate),
                  decoration: BoxDecoration(
                      color: (nameError) ? Colors.red[50] : Colors.white,
                      borderRadius: BorderRadius.circular(15)),
                  child: TextField(
                    controller: _nameController,
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: width * regularFontRate),
                    decoration: InputDecoration(
                        hintText: "Nhập tên thú cưng",
                        hintStyle: const TextStyle(
                          color: lightFontColor,
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
                          height: 1.4,
                        ),
                        border: InputBorder.none,
                        suffixIcon: IconButton(
                          icon: const Icon(
                            Icons.close_rounded,
                            color: lightFontColor,
                          ),
                          onPressed: () => _nameController.clear(),
                        )),
                  ),
                ),
              ),
              buildSpacing(width),
              Row(
                children: [
                  InkWell(
                    onTap: () {
                      setState(() {
                        breedType = 'DOG';
                        _breedController.clear();
                      });
                    },
                    child: Column(children: [
                      Container(
                        width: width * 0.2,
                        height: width * 0.2,
                        decoration: BoxDecoration(
                            color: (breedType != null &&
                                    breedType!.contains('DOG'))
                                ? primaryBackgroundColor
                                : Colors.blueGrey[100],
                            borderRadius: BorderRadius.circular(width * 0.3),
                            border: Border.all(
                                width: 4,
                                color: (breedType != null &&
                                        breedType!.contains('DOG'))
                                    ? lightPrimaryColor
                                    : Colors.white,
                                strokeAlign: StrokeAlign.outside),
                            image: const DecorationImage(
                                image: AssetImage('lib/assets/dog.png'),
                                scale: 0.8)),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        'Dog',
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 15,
                            color: (breedType != null &&
                                    breedType!.contains('DOG'))
                                ? primaryColor
                                : lightFontColor),
                      )
                    ]),
                  ),
                  SizedBox(
                    width: width * smallPadRate,
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        breedType = 'CAT';
                        _breedController.clear();
                      });
                    },
                    child: Column(children: [
                      Container(
                        width: width * 0.2,
                        height: width * 0.2,
                        decoration: BoxDecoration(
                            color: (breedType != null &&
                                    breedType!.contains('CAT'))
                                ? primaryBackgroundColor
                                : Colors.blueGrey[100],
                            borderRadius: BorderRadius.circular(width * 0.3),
                            border: Border.all(
                                width: 4,
                                color: (breedType != null &&
                                        breedType!.contains('CAT'))
                                    ? lightPrimaryColor
                                    : Colors.white,
                                strokeAlign: StrokeAlign.outside),
                            image: const DecorationImage(
                                image: AssetImage('lib/assets/black-cat.png'),
                                scale: 0.8)),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        'Cat',
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 15,
                            color: (breedType != null &&
                                    breedType!.contains('CAT'))
                                ? primaryColor
                                : lightFontColor),
                      )
                    ]),
                  )
                ],
              ),
              Visibility(
                  visible: (breedType != null),
                  child: buildSmallSpacing(width)),
              Visibility(
                visible: (breedType != null),
                child: Container(
                  height: height * 0.07,
                  width: width * (1 - 2 * mediumPadRate),
                  padding:
                      EdgeInsets.symmetric(horizontal: width * smallPadRate),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15)),
                  child: TextField(
                    controller: _breedController,
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: width * regularFontRate),
                    decoration: InputDecoration(
                        hintText: "Tên loài " +
                            ((breedType != null && breedType!.contains('DOG'))
                                ? 'chó'
                                : 'mèo'),
                        hintStyle: const TextStyle(
                          color: lightFontColor,
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
                          height: 1.4,
                        ),
                        border: InputBorder.none,
                        suffixIcon: IconButton(
                          icon: const Icon(
                            Icons.close_rounded,
                            color: lightFontColor,
                          ),
                          onPressed: () => _breedController.clear(),
                        )),
                  ),
                ),
              ),
              buildSpacing(width),
              GestureDetector(
                onTap: () async {
                  // setState(() {
                  //   _dateController = null;
                  // });
                  // if (from != null) {
                  var date = await selectSingleDateTo(context, DateTime.now());

                  // print('hour: ${to!.hour}');
                  _dateController.text = DateFormat("dd/MM/yyyy").format(date!);
                  // due = getDue(from, to);
                  // print('due: $due');
                  // } else
                  setState(() {
                    birthDay = date;
                    //     toTimeError = 'Vui lòng chọn trước thời gian gửi';
                  });
                },
                child: Container(
                    padding: EdgeInsets.all(5),
                    margin: EdgeInsets.symmetric(vertical: 2),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15)),
                    child: TextField(
                      enabled: false,
                      controller: _dateController,
                      style: TextStyle(fontWeight: FontWeight.w500),
                      decoration: InputDecoration(
                        labelText: "Ngày sinh (hoặc ngày nhận nuôi)",
                        labelStyle: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 15),
                        prefixIcon: Container(
                            width: 30,
                            height: 30,
                            margin: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                                color: primaryBackgroundColor,
                                borderRadius: BorderRadius.circular(10)),
                            child: Icon(
                              Icons.calendar_month_rounded,
                              color: primaryColor,
                              size: 20,
                            )),
                        border: InputBorder.none,
                      ),
                      readOnly: true,
                    )),
              ),
              buildSpacing(width),
              const Text(
                'Kích thước',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: lightFontColor,
                ),
              ),
              buildSmallSpacing(width),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: height * 0.07,
                    width: width * (1 - 3 * mediumPadRate) / 2,
                    // padding:
                    //     EdgeInsets.symmetric(horizontal: width * smallPadRate),
                    decoration: BoxDecoration(
                        //color: Colors.white,
                        borderRadius: BorderRadius.circular(15)),
                    child: TextField(
                      controller: _heightController,
                      keyboardType: TextInputType.number,
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: width * regularFontRate),
                      decoration: InputDecoration(
                          labelText: "Chiều cao",
                          labelStyle: TextStyle(
                            color: lightFontColor,
                            fontWeight: FontWeight.w500,
                            fontSize: 15,
                            height: 1.4,
                          ),
                          //floatingLabelStyle: TextStyle(color: lightPrimaryColor),
                          // border: InputBorder.none,
                          fillColor: Colors.white54,
                          filled: true,
                          focusColor: primaryBackgroundColor,
                          border: InputBorder.none,
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide:
                                  BorderSide(color: Colors.white, width: 1.5)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide(
                                  color: primaryBackgroundColor, width: 1.5)),
                          suffix: const Text(
                            'cm',
                            style: TextStyle(
                              color: lightFontColor,
                              fontWeight: FontWeight.w500,
                              fontSize: 15,
                              height: 1.4,
                            ),
                          )),
                    ),
                  ),
                  Container(
                    height: height * 0.07,
                    width: width * (1 - 3 * mediumPadRate) / 2,
                    // padding:
                    //     EdgeInsets.symmetric(horizontal: width * smallPadRate),
                    decoration: BoxDecoration(
                        // color: Colors.white,
                        borderRadius: BorderRadius.circular(15)),
                    child: TextField(
                      controller: _lengthController,
                      keyboardType: TextInputType.number,
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: width * regularFontRate),
                      decoration: InputDecoration(
                          labelText: "Chiều dài",
                          labelStyle: TextStyle(
                            color: lightFontColor,
                            fontWeight: FontWeight.w500,
                            fontSize: 15,
                            height: 1.4,
                          ),
                          //floatingLabelStyle: TextStyle(color: lightPrimaryColor),
                          // border: InputBorder.none,
                          fillColor: Colors.white54,
                          filled: true,
                          focusColor: primaryBackgroundColor,
                          border: InputBorder.none,
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide:
                                  BorderSide(color: Colors.white, width: 1.5)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide(
                                  color: primaryBackgroundColor, width: 1.5)),
                          suffix: const Text(
                            'cm',
                            style: TextStyle(
                              color: lightFontColor,
                              fontWeight: FontWeight.w500,
                              fontSize: 15,
                              height: 1.4,
                            ),
                          )),
                    ),
                  ),
                ],
              ),
              buildSpacing(width),
              Container(
                height: height * 0.07,
                width: width * (1 - 2 * mediumPadRate),
                // padding: EdgeInsets.symmetric(horizontal: width * smallPadRate),
                // decoration: BoxDecoration(
                //     // color: Colors.white,
                //     borderRadius: BorderRadius.circular(15)),
                child: TextField(
                  controller: _weightController,
                  keyboardType: TextInputType.number,
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: width * regularFontRate),
                  decoration: InputDecoration(
                      labelText: "Cân nặng",
                      labelStyle: TextStyle(
                        color: lightFontColor,
                        fontWeight: FontWeight.w500,
                        fontSize: 15,
                        height: 1.4,
                      ),
                      //floatingLabelStyle: TextStyle(color: lightPrimaryColor),
                      // border: InputBorder.none,
                      fillColor: Colors.white54,
                      filled: true,
                      focusColor: primaryBackgroundColor,
                      border: InputBorder.none,
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide:
                              BorderSide(color: Colors.white, width: 1.5)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(
                              color: primaryBackgroundColor, width: 1.5)),
                      suffix: const Text(
                        'kg',
                        style: TextStyle(
                          color: lightFontColor,
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
                          height: 1.4,
                        ),
                      )),
                ),
              ),
              buildSpacing(
                width * 6,
              )
            ]),
      ),
      floatingActionButton: Opacity(
        opacity: (isFilled()) ? 1 : 0.3,
        child: ElevatedButton(
            onPressed: () async {
              if (!isFilled()) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(
                    "Vui lòng nhập đầy đủ thông tin",
                    style: TextStyle(color: Colors.white),
                  ),
                  backgroundColor: Colors.red,
                ));
              } else if(isEdit! && !isChanged()){
                Navigator.pop(context);

              } else {
                Pet pet = Pet(
                    weight: double.parse(_weightController.text),
                    height: double.parse(_heightController.text),
                    length: double.parse(_lengthController.text),
                    name: _nameController.text,
                    birth: birthDay,
                    breedName: _breedController.text,
                    petTypeCode: breedType,
                    customerId: widget.customerId,
                    status: true,
                    photoUrl: imgURL
                    // photoUrl:
                    //     "https://l.messenger.com/l.php?u=https%3A%2F%2Ffirebasestorage.googleapis.com%2Fv0%2Fb%2Fpawnclaw-4b6ba.appspot.com%2Fo%2Fcustomers%252Fpet%252F11%252Fimage_picker8213551932780256987.png%3Falt%3Dmedia%26token%3D47defa75-e9c3-49d2-b146-8d32fe6b7347%2522%252C%2522customerId%2522%253A11&h=AT3b_QVqMDqliuVR38NtkE90KqB-QZLAePI77YZyRlmrK7H_esyrjHOZwLw3XsOhdvA8jka-XcFVWLxQ0nQDGCN_bgq0FtM8ok6btM593G1LLHfR367JehWZ6XHpM830-sGiLA"
                    );
                if (isEdit == false) {
                  bool createPet = await PetRepository().createPet(pet);
                  if (createPet) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Thêm thú cưng thành công!')));
                    // Navigator.of(context).push(
                    //     MaterialPageRoute(builder: (context) => MyPetScreen()));
                    Navigator.pop(context);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(
                            'Thêm thú cưng không thành công! Vui lòng thử lại sau.')));
                  }
                } else {
                  pet.id = petToUpdate!.id;
                  if (imgURL != null) {
                    var photo = Photo(
                        idActor: petToUpdate.id,
                        url: imgURL,
                        photoTypeId: 7,
                        isThumbnail: false,
                        status: true);
                    bool updateImage =
                        await PetRepository().updateAvatar(photo);
                    pet.photoUrl = imgURL;
                    if (updateImage) {
                      pet.photoUrl = imgURL;
                      pet.photos = [photo];
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Cập nhật ảnh thành công!')));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(
                              'Cập nhật ảnh không thành công! Vui lòng thử lại sau.')));
                    }
                  }
                  bool updatePet = await PetRepository().update(pet);

                  if (updatePet) {

                    pet.petHealthHistories = petToUpdate.petHealthHistories;
                    if(pet.photos == null){
                      pet.photos = petToUpdate.photos;
                    }
                    // print(pet.toJson());
                    // print('photourl ${pet.photoUrl}');
                    // print('photos ${pet.photos}');
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('Cập nhật thú cưng thành công!')));
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => PetDetailScreen(pet: pet)));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(
                            'Cập nhật thú cưng không thành công! Vui lòng thử lại sau.')));
                  }
                }
              }
            },
            style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            )),
            child: Container(
              padding: EdgeInsets.symmetric(vertical: width * smallPadRate),
              width: width * (1 - 2 * mediumPadRate),
              height: width * mediumPadRate * 2,
              child: Center(
                child: Text(
                  'Lưu thú cưng',
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w700),
                ),
              ),
            )),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget buildSpacing(width) {
    return SizedBox(
      height: width * smallPadRate,
    );
  }

  Widget buildSmallSpacing(width) {
    return SizedBox(
      height: width * extraSmallPadRate,
    );
  }
}
