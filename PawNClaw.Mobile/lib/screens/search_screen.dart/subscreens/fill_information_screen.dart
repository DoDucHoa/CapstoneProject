import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pawnclaw_mobile_application/blocs/search/search_bloc.dart';
import 'package:pawnclaw_mobile_application/common/constants.dart';
import 'package:pawnclaw_mobile_application/common/date_picker.dart';
import 'package:pawnclaw_mobile_application/models/area.dart';
import 'package:pawnclaw_mobile_application/repositories/area/area_repository.dart';
import 'package:intl/intl.dart';
import 'package:pawnclaw_mobile_application/repositories/center/center_repository.dart';

class FillInformationScreen extends StatefulWidget {
  const FillInformationScreen({
    Key? key,
    required this.height,
    required this.width,
  }) : super(key: key);
  final double height;
  final double width;

  @override
  State<FillInformationScreen> createState() => _FillInformationScreenState();
}

class _FillInformationScreenState extends State<FillInformationScreen> {
  List<Area>? cities;
  TextEditingController _areaController = TextEditingController();
  DateTime? from;
  DateTime? to;
  String? cityCode;
  String? districtCode;
  TextEditingController _fromController = TextEditingController();
  TextEditingController _toController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    AreaRepository().getAllArea().then((value) {
      setState(
        () {
          cities = value;
        },
      );
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: backgroundColor,
          appBar: AppBar(
            title: Text(
              "Thông tin đặt chỗ",
              style: TextStyle(
                fontSize: widget.width * largeFontRate,
                fontWeight: FontWeight.bold,
                color: primaryFontColor,
              ),
            ),
            leading: IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: Icon(
                Icons.arrow_back_ios_new,
                color: primaryFontColor,
              ),
            ),
            backgroundColor: backgroundColor,
            elevation: 0,
          ),
          body: Container(
            padding: EdgeInsets.all(widget.width * regularPadRate),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Spacer(flex: 35),
                Padding(
                  padding: EdgeInsets.all(widget.width * 0.01),
                  child: Text(
                    "Điền thông tin ",
                    style: TextStyle(
                      color: primaryFontColor,
                      fontSize: widget.width * extraLargeFontRate,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Spacer(flex: 3),
                Padding(
                  padding: EdgeInsets.all(widget.width * 0.01),
                  child: Text(
                    "để chúng tôi giúp bạn tìm ra trung tâm phù hợp",
                    style: TextStyle(
                      color: lightFontColor,
                      fontSize: widget.width * largeFontRate,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Spacer(flex: 10),
                GestureDetector(
                  onTap: () => selectSingleTime(
                    context,
                    (date) {
                      setState(
                        () {
                          from = date;
                          _fromController.text =
                              DateFormat("dd/MM/yyyy, h:mm a").format(date);
                        },
                      );
                    },
                  ),
                  child: TextField(
                    enabled: false,
                    readOnly: true,
                    controller: _fromController,
                    decoration: InputDecoration(
                      labelText: "From",
                      prefixIcon: Icon(
                        Icons.access_time_filled,
                        color: primaryColor,
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                const Spacer(flex: 3),
                GestureDetector(
                  onTap: () => selectSingleTime(
                    context,
                    (date) {
                      setState(
                        () {
                          to = date;
                          _toController.text =
                              DateFormat("dd/MM/yyyy, h:mm a").format(date);
                        },
                      );
                    },
                  ),
                  child: TextField(
                    enabled: false,
                    controller: _toController,
                    decoration: InputDecoration(
                      labelText: "To",
                      prefixIcon:
                          Icon(Icons.access_time_filled, color: primaryColor),
                      border: InputBorder.none,
                    ),
                    readOnly: true,
                  ),
                ),
                const Spacer(flex: 3),
                GestureDetector(
                  onTap: () => showCupertinoDialog(
                      context: context,
                      builder: (context) {
                        Area? cityValue;
                        Districts? districtValue;
                        List<Districts>? districts;
                        return StatefulBuilder(
                          builder: (context, setState) => Dialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            backgroundColor: Colors.white,
                            child: Container(
                              height: widget.height * 0.3,
                              width: widget.width * 0.7,
                              padding:
                                  EdgeInsets.all(widget.width * smallPadRate),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    "Chọn khu vực",
                                    style: TextStyle(
                                      fontSize: widget.width * regularFontRate,
                                      fontWeight: FontWeight.bold,
                                      color: primaryFontColor,
                                    ),
                                  ),
                                  SizedBox(
                                    width: widget.width * 0.5,
                                    child: DropdownButton<Area>(
                                      isExpanded: true,
                                      value: cityValue,
                                      items: cities?.map((e) {
                                            return DropdownMenuItem(
                                              child: Text(e.name!),
                                              value: e,
                                            );
                                          }).toList() ??
                                          [
                                            const DropdownMenuItem(
                                                child:
                                                    CircularProgressIndicator())
                                          ],
                                      onChanged: (value) async {
                                        var districtsOfCity =
                                            await AreaRepository()
                                                .getDistrictsByArea(
                                                    value!.code!);
                                        setState(() {
                                          cityValue = value;
                                          districts = districtsOfCity;
                                          districtValue = null;
                                        });
                                      },
                                      hint: const Text("Tỉnh/Thành phố"),
                                    ),
                                  ),
                                  SizedBox(
                                    width: widget.width * 0.5,
                                    child: DropdownButton<Districts>(
                                      isExpanded: true,
                                      value: districtValue,
                                      items: districts?.map((e) {
                                        return DropdownMenuItem(
                                          child: Text(e.name!),
                                          value: e,
                                        );
                                      }).toList(),
                                      onChanged: (value) {
                                        setState(() {
                                          districtValue = value;
                                        });
                                      },
                                      hint: const Text("Quận/Huyện"),
                                    ),
                                  ),
                                  Opacity(
                                    opacity: (cityValue != null &&
                                            districtValue != null)
                                        ? 1
                                        : 0.3,
                                    child: ElevatedButton(
                                      onPressed: (cityValue != null &&
                                              districtValue != null)
                                          ? () {
                                              Map<Area, Districts> result = {
                                                cityValue!: districtValue!
                                              };
                                              Navigator.pop(context, result);
                                            }
                                          : () {},
                                      child: const Text(
                                        "Confirm",
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }).then<Map>(
                    ((value) {
                      var a = Map<Area, Districts>.from(value);
                      Area city = a.entries.first.key;
                      Districts district = a.entries.first.value;
                      setState(() {
                        cityCode = city.code;
                        districtCode = district.code;
                        _areaController.text =
                            district.name! + ", " + city.name!;
                      });
                      return a;
                    }),
                  ),
                  child: TextField(
                    enabled: false,
                    readOnly: true,
                    controller: _areaController,
                    decoration: InputDecoration(
                      labelText: "Location",
                      prefixIcon: Icon(
                        Icons.location_on,
                        color: primaryColor,
                      ),
                      border: InputBorder.none,
                    ),
                    autofocus: false,
                  ),
                ),
                const Spacer(flex: 30),
                Text(
                  "*Lưu ý: thời gian đặt chỗ của bạn sẽ được làm tròn tới phút 30 hoặc một tiếng để tiện cho việc xếp lịch và tính tiền.",
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    color: primaryColor,
                  ),
                ),
                Center(
                  child: Opacity(
                    opacity: (_fromController.text != "" &&
                            _toController.text != "" &&
                            _areaController.text != "")
                        ? 1
                        : 0.3,
                    child: ElevatedButton(
                      onPressed: (_fromController.text != "" &&
                              _toController.text != "" &&
                              _areaController.text != "")
                          ? () => BlocProvider.of<SearchBloc>(context).add(
                              SearchCenter(
                                  (state as FillingInformation).requests,
                                  from!,
                                  to!,
                                  cityCode!,
                                  districtCode!,
                                  0))
                          : () {},
                      child: Text(
                        "Confirm",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: widget.width * regularFontRate),
                      ),
                      style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40.0),
                          ),
                        ),
                      ),
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
}
