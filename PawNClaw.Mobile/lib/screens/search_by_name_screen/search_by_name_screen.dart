import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pawnclaw_mobile_application/common/components/elevated_container.dart';
import 'package:pawnclaw_mobile_application/common/components/loading_indicator.dart';
import 'package:pawnclaw_mobile_application/common/constants.dart';
import 'package:pawnclaw_mobile_application/repositories/center/center_repository.dart';
import 'package:pawnclaw_mobile_application/screens/home_screen/HomeScreen.dart';
import 'package:pawnclaw_mobile_application/screens/search_by_name_screen/components/search_bar.dart';
import 'package:pawnclaw_mobile_application/models/center.dart' as petCenter;

import 'components/center_card.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  void initState() {
    CenterRepository().getAllCenter().then((value) {
      if (value == null) {
        centersName = [];
      } else {
        centersName = value.map((e) => e.name!).toList();
        allCenters = value;
        print('init suggestions');
      }
    });
    // if (centersName == null) {
    //   // centers.then((value) {centersName = value!.map((e) => e.name!).toList();});
    // } else {}
    super.initState();
  }

  TextEditingController controller = TextEditingController();
  List<petCenter.Center>? centers = [];
  int isFound = -1; // -1:init, 1: found, 0: finding, 2: not found
  String query = '';
  List<String>? suggestions = [];
  late List<String> centersName;
  late List<petCenter.Center> allCenters;
  // late StreamSubscription<Position> streamSubscription;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    var query = controller.text;

    return Scaffold(
      backgroundColor: frameColor,
      appBar: AppBar(
        backgroundColor: frameColor,
        elevation: 0,
        toolbarHeight: height * 0.1,
        bottom: PreferredSize(
            preferredSize: Size(width, height * 0.06),
            child: ElevatedContainer(
              height: height * 0.06,
              width: width * (1 - 2 * smallPadRate),
              child: TextField(
                controller: controller,
                //enabled: (isFound == -1),
                showCursor: true,
                autofocus: true,
                decoration: InputDecoration(
                    prefixIcon: const Icon(
                      Icons.search,
                      color: primaryColor,
                    ),
                    hintText: "Tìm kiếm trung tâm thú cưng",
                    hintStyle: TextStyle(
                      color: lightFontColor,
                      fontWeight: FontWeight.w500,
                      fontSize: 15,
                      height: 1.4,
                    ),
                    border: InputBorder.none,
                    suffixIcon: (query.isNotEmpty)
                        ? IconButton(
                            icon: const Icon(
                              Icons.close_rounded,
                              color: lightFontColor,
                            ),
                            onPressed: (() {
                              controller.clear();
                              setState(() {
                                query = '';
                                suggestions = [];
                                //isAutofocus = true;
                              });
                            }),
                          )
                        : null),
                onChanged: (value) {
                  buildSuggestion(value);
                  setState(() {
                    isFound = -1;
                    query = value;
                  });
                },

                onSubmitted: (value) async {
                  List<petCenter.Center>? found = await CenterRepository()
                      .getCentersByName(value.toLowerCase(), 0, 5);
                  if (found != null) {
                    setState(() {
                      if (found.isNotEmpty) {
                        centers = found;
                        isFound = 1;
                      } else {
                        isFound = 2;
                        centers = allCenters;
                      }
                      // isFound = 1;
                      suggestions = [];
                    });
                  }
                },
              ),
              elevation: width * 0.015,
            )),
        //titleSpacing: 10,
        leading: IconButton(
            onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => HomeScreen())),
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: lightFontColor,
            )),
        leadingWidth: width * mediumPadRate,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: width * smallPadRate),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              (suggestions != null || suggestions!.isNotEmpty)
                  ? ListView.builder(
                      itemBuilder: (context, index) => Container(
                        height: width * regularPadRate,
                        child: ListTile(
                          title: Text(
                            suggestions![index],
                            style: TextStyle(
                                fontSize: width * smallFontRate,
                                color: lightFontColor,
                                height: 1,
                                fontWeight: FontWeight.w500),
                          ),
                          leading: const Icon(
                            Icons.search_rounded,
                            color: lightFontColor,
                            size: 18,
                          ),
                          style: ListTileStyle.drawer,
                          horizontalTitleGap: 0,
                          onTap: () async {
                            controller.text = suggestions![index];
                            List<petCenter.Center>? found =
                                await CenterRepository().getCentersByName(
                                    suggestions![index].toLowerCase(), 0, 5);

                            if (found != null) {
                              setState(() {
                                centers = found;
                                isFound = 1;
                                suggestions = [];
                              });
                              FocusScope.of(context).unfocus();
                            }
                          },
                        ),
                      ),
                      itemCount:
                          (suggestions!.length > 5) ? 5 : suggestions!.length,
                      shrinkWrap: true,
                      physics: ClampingScrollPhysics(),
                    )
                  : Container(),
              //centers found
              (isFound == 2)
                  ? Container(
                    margin: EdgeInsets.symmetric(horizontal:  width * regularPadRate, vertical: width * smallPadRate),
                    child: Column(
                        children: [
                          Container(
                        padding: EdgeInsets.all(width * mediumPadRate),
                        decoration: BoxDecoration(
                            color: disableColor,
                            borderRadius: BorderRadius.circular(65)),
                        child: Icon(
                          Iconsax.chart_fail3,
                          size: 65,
                          color: Colors.white,
                        )
                        ),
                    SizedBox(
                      height: width * mediumPadRate,
                    ),
                    Text(
                      'Không tìm thấy kết quả',
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w700, height: 1.5),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: width * extraSmallPadRate,
                    ),
                    Text(
                      'Bạn có thể thử lại bằng từ khóa khác hoặc tham khảo các trung tâm bên dưới nhé?',
                      style: TextStyle(fontSize: 15, height: 1.5),
                      textAlign: TextAlign.center,
                    ),
                        ],
                      ),
                  )
                  : Container(),
              (isFound == 1 || isFound == 2)
                  ? ListView.builder(
                      itemBuilder: ((context, index) {
                        return CenterCard(center: centers![index]);
                      }),
                      shrinkWrap: true,
                      physics: ClampingScrollPhysics(),
                      itemCount: centers!.length,
                    )
                  : Container(),
              //loadding center
              (isFound == 0)
                  ? const LoadingIndicator(loadingText: 'Vui lòng đợi')
                  : Container(),
            ]),
      ),
    );
  }

  void buildSuggestion(value) {
    if (value.isNotEmpty) {
      setState(() {
        suggestions = centersName
            .where((e) => e.toLowerCase().contains(value.toLowerCase()))
            .toList();
      });
      return;
    }
    suggestions = [];
  }
  // void getLocation() async {
  //   var position = await Geolocator.getCurrentPosition(
  //       desiredAccuracy: LocationAccuracy.high);
  //   getAddress(position);
  //   setState(() {
  //     longitude = position.longitude;
  //     latitude = position.latitude;
  //   });

  // }

}
