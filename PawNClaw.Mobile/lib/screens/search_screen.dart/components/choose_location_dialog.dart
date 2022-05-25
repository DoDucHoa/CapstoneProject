import 'package:flutter/material.dart';
import 'package:pawnclaw_mobile_application/common/constants.dart';
import 'package:pawnclaw_mobile_application/models/area.dart';
import 'package:pawnclaw_mobile_application/repositories/area/area_repository.dart';

class ChooseLocationDialog extends StatefulWidget {
  ChooseLocationDialog({Key? key, required this.cities}) : super(key: key);
  final List<Area>? cities;
  @override
  State<ChooseLocationDialog> createState() => _ChooseLocationDialogState();
}

class _ChooseLocationDialogState extends State<ChooseLocationDialog> {
  Area? cityValue;
  Districts? districtValue;
  List<Districts>? districts;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () async => false,
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        backgroundColor: Colors.white,
        child: Container(
          height: height * 0.3,
          width: width * 0.7,
          padding: EdgeInsets.all(width * smallPadRate),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                "Chọn khu vực",
                style: TextStyle(
                  fontSize: width * regularFontRate,
                  fontWeight: FontWeight.bold,
                  color: primaryFontColor,
                ),
              ),
              SizedBox(
                width: width * 0.5,
                child: DropdownButton<Area>(
                  isExpanded: true,
                  value: cityValue,
                  items: widget.cities?.map((e) {
                        return DropdownMenuItem(
                          child: Text(e.name!),
                          value: e,
                        );
                      }).toList() ??
                      [
                        const DropdownMenuItem(
                            child: CircularProgressIndicator())
                      ],
                  onChanged: (value) async {
                    var districtsOfCity =
                        await AreaRepository().getDistrictsByArea(value!.code!);
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
                width: width * 0.5,
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
                opacity: (cityValue != null && districtValue != null) ? 1 : 0.3,
                child: ElevatedButton(
                  onPressed: (cityValue != null && districtValue != null)
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
  }
}
