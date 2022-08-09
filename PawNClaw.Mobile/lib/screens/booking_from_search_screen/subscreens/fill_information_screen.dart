import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pawnclaw_mobile_application/blocs/authentication/auth_bloc.dart';
import 'package:pawnclaw_mobile_application/blocs/search/search_bloc.dart';
import 'package:pawnclaw_mobile_application/common/constants.dart';
import 'package:pawnclaw_mobile_application/common/date_picker.dart';
import 'package:pawnclaw_mobile_application/models/area.dart';
import 'package:pawnclaw_mobile_application/repositories/area/area_repository.dart';
import 'package:intl/intl.dart';
import 'package:pawnclaw_mobile_application/repositories/center/center_repository.dart';
import 'package:pawnclaw_mobile_application/screens/search_screen.dart/components/choose_location_dialog.dart';

class FillInformationScreen extends StatefulWidget {
  final bool isSponsor;
  const FillInformationScreen({
    required this.isSponsor,
    Key? key,
  }) : super(key: key);

  @override
  State<FillInformationScreen> createState() => _FillInformationScreenState();
}

class _FillInformationScreenState extends State<FillInformationScreen> {
  List<Area>? cities;
  // TextEditingController _areaController = TextEditingController();
  DateTime? from;
  DateTime? to;
  int? due;
  late int customerId;
  // String? cityCode;
  // String? districtCode;
  TextEditingController _fromController = TextEditingController();
  TextEditingController _toController = TextEditingController();
  String? toTimeError;
  String? fromTimeError;

  @override
  void initState() {
    var authState = BlocProvider.of<AuthBloc>(context).state as Authenticated;
    customerId = authState.user.id!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: frameColor,
          appBar: AppBar(
            title: Text(
              "Thông tin đặt chỗ",
              style: TextStyle(
                fontSize: width * largeFontRate,
                fontWeight: FontWeight.bold,
                color: primaryFontColor,
              ),
            ),
            leading: IconButton(
              onPressed: () {
                BlocProvider.of<SearchBloc>(context)
                  ..add(BackToPetSelection(
                      (state as FillingInformation).requests));
              },
              // => Navigator.of(context).pop(),
              icon: Icon(
                Icons.arrow_back_ios_new,
                color: primaryFontColor,
              ),
            ),
            backgroundColor: backgroundColor,
            elevation: 0,
          ),
          body: Container(
            padding: EdgeInsets.all(width * regularPadRate),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Spacer(flex: 1),
                Padding(
                  padding: EdgeInsets.all(width * 0.01),
                  child: Text(
                    "Điền thông tin ",
                    style: TextStyle(
                      color: primaryFontColor,
                      fontSize: width * extraLargeFontRate,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                //const Spacer(flex: 3),
                Padding(
                  padding: EdgeInsets.all(width * 0.01),
                  child: Text(
                    "để chúng tôi giúp bạn tìm kiếm trung tâm phù hợp",
                    style: TextStyle(
                      color: lightFontColor,
                      fontSize: width * largeFontRate,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Spacer(flex: 1),
                GestureDetector(
                  //change to selectSingleDate
                  onTap: () => selectSingleTime(
                    context,
                    (date) {
                      if (to == null ||
                          (to != null && to!.compareTo(date) == 1)) {
                        setState(
                          () {
                            from = date;
                            _fromController.text =
                                DateFormat("dd/MM/yyyy, h:mm a").format(date);
                            if (to != null) {
                              due = getDue(from, to);
                            }
                            fromTimeError = null;
                          },
                        );
                      } else {
                        setState(() {
                          _fromController.text = "";
                          fromTimeError =
                              "Thời gian gửi phải trước thời gian nhận";
                        });
                      }
                    },
                  ),
                  child: Container(
                      padding: EdgeInsets.all(5),
                      margin: EdgeInsets.symmetric(vertical: 5),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15)),
                      child: TextField(
                        enabled: false,
                        readOnly: true,
                        controller: _fromController,
                        decoration: InputDecoration(
                          labelText: "Gửi từ",
                          prefixIcon: Container(
                              width: 30,
                              height: 30,
                              margin: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                  color: primaryBackgroundColor,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Icon(
                                Icons.access_time_filled,
                                color: primaryColor,
                                size: 20,
                              )),
                          border: InputBorder.none,
                        ),
                      )),
                ),
                Visibility(
                  visible: fromTimeError != null,
                  child: Text(
                    fromTimeError ?? "",
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                      color: Colors.red,
                    ),
                  ),
                ),
                //const Spacer(flex: 1),
                GestureDetector(
                  onTap: () async {
                    setState(() {
                      toTimeError = null;
                    });
                    if (from != null) {
                      var date = await selectSingleDateFrom(context, from!);
                      to = date!.add(new Duration(hours: 23));
                      print('hour: ${to!.hour}');
                      setState(() {
                        _toController.text =
                            DateFormat("dd/MM/yyyy").format(date);
                      });

                      due = getDue(from, to);
                      print('due: $due');
                    } else
                      setState(() {
                        toTimeError = 'Vui lòng chọn trước thời gian gửi';
                      });
                  },

                  // selectSingleTime(
                  //   context,
                  //   (date) {
                  //     if (from == null ||
                  //         (from != null && from!.compareTo(date) == -1)) {
                  //       setState(
                  //         () {
                  //           to = date;
                  //           _toController.text =
                  //               DateFormat("dd/MM/yyyy, h:mm a").format(date);
                  //           toTimeError = null;
                  //         },
                  //       );
                  //     } else {
                  //       setState(() {
                  //         _toController.text = "";
                  //         toTimeError = "Thời gian nhận phải sau thời gian gửi";
                  //       });
                  //     }
                  //   },
                  // ),
                  child: Container(
                      padding: EdgeInsets.all(5),
                      margin: EdgeInsets.symmetric(vertical: 5),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15)),
                      child: TextField(
                        enabled: false,
                        controller: _toController,
                        decoration: InputDecoration(
                          labelText: "Đến ngày",
                          prefixIcon: Container(
                              width: 30,
                              height: 30,
                              margin: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                  color: primaryBackgroundColor,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Icon(
                                Iconsax.calendar5,
                                color: primaryColor,
                                size: 20,
                              )),
                          border: InputBorder.none,
                        ),
                        readOnly: true,
                      )),
                ),
                Visibility(
                  visible: toTimeError != null,
                  child: Text(
                    toTimeError ?? "",
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                      color: Colors.red,
                    ),
                  ),
                ),
                const Spacer(flex: 3),
                // GestureDetector(
                //   onTap: () => showCupertinoDialog(
                //       barrierDismissible: false,
                //       context: context,
                //       builder: (context) {
                //         return ChooseLocationDialog(
                //           cities: cities,
                //         );
                //       }).then<Map>(
                //     ((value) {
                //       var a = Map<Area, Districts>.from(value);
                //       Area city = a.entries.first.key;
                //       Districts district = a.entries.first.value;
                //       setState(() {
                //         cityCode = city.code;
                //         districtCode = district.code;
                //         _areaController.text =
                //             district.name! + ", " + city.name!;
                //       });
                //       return a;
                //     }),
                //   ),
                //   child: Container(
                //       padding: EdgeInsets.all(5),
                //       margin: EdgeInsets.symmetric(vertical: 2),
                //       decoration: BoxDecoration(
                //           color: Colors.white,
                //           borderRadius: BorderRadius.circular(15)),
                //       child: TextField(
                //         enabled: false,
                //         readOnly: true,
                //         controller: _areaController,
                //         decoration: InputDecoration(
                //           labelText: "Địa điểm",
                //           prefixIcon: Container(
                //               width: 30,
                //               height: 30,
                //               margin: EdgeInsets.all(5),
                //               decoration: BoxDecoration(
                //                   color: primaryBackgroundColor,
                //                   borderRadius: BorderRadius.circular(10)),
                //               child: Icon(
                //                 Icons.location_on,
                //                 color: primaryColor,
                //               )),
                //           border: InputBorder.none,
                //         ),
                //         autofocus: false,
                //       )),
                // ),
                // const Spacer(flex: 30),
                Text(
                  "*Lưu ý: thời gian đặt chỗ của bạn sẽ được làm tròn tới phút 30 hoặc một tiếng để tiện cho việc xếp lịch và tính tiền.",
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    color: primaryColor,
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Center(
                  child: Opacity(
                    opacity: (_fromController.text.isNotEmpty &&
                            _toController.text.isNotEmpty)
                        ? 1
                        : 0.3,
                    child: ElevatedButton(
                      onPressed: (_fromController.text != "" &&
                              _toController.text != "")
                          ? () {
                              if (widget.isSponsor) {
                                BlocProvider.of<SearchBloc>(context).add(
                                    CheckSponsorCenter(
                                        (state as FillingInformation).centerId,
                                        customerId,
                                        state.requests,
                                        from!,
                                        due!));
                              } else {
                                BlocProvider.of<SearchBloc>(context).add(
                                    CheckCenter(
                                        (state as FillingInformation).centerId,
                                        state.requests,
                                        from!,
                                        due!,
                                        customerId));
                              }
                            }
                          : () {},
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            vertical: width * smallPadRate),
                        child: Center(
                          child: Text(
                            'Xác nhận',
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      )),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  int getDue(from, to) {
    int due;
    due = to.day - from!.day;
    if (due == 0) due = 1;
    return due;
  }
}
