import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pawnclaw_mobile_application/blocs/search/search_bloc.dart';
import 'package:pawnclaw_mobile_application/common/constants.dart';
import 'package:pawnclaw_mobile_application/models/center.dart' as petCenter;
import 'package:pawnclaw_mobile_application/screens/search_screen.dart/SearchScreen.dart';

import '../components/center_card.dart';

class AvailableCenterScreen extends StatefulWidget {
  const AvailableCenterScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<AvailableCenterScreen> createState() => _ShowAvailableCenterState();
}

class _ShowAvailableCenterState extends State<AvailableCenterScreen> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: backgroundColor,
          appBar: AppBar(
            title: Text(
              "Khách sạn thú cưng",
              style: TextStyle(
                fontSize: width * largeFontRate,
                fontWeight: FontWeight.bold,
                color: primaryFontColor,
              ),
            ),
            leading: IconButton(
              onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => SearchScreen())),
              icon: Icon(
                Icons.arrow_back_ios_new,
                color: primaryFontColor,
              ),
            ),
            backgroundColor: backgroundColor,
            elevation: 0,
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ((state as SearchCompleted).searchResponse.districtName!.isNotEmpty)
                  ? Column(children:[
            Icon(
                Icons.flag_circle_rounded,
                size: 65,
                color: lightFontColor,
              ),
              Container(
                width: width * (1 - 2 * mediumPadRate),
                child: Text(
                  'Rất tiếc! Chúng tôi không thể tìm thấy \n khách sạn nào ở khu vực mà bạn yêu cầu.\nBạn có thể tham khảo những khách sạn \n ở khu vực lân cận sau đây.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: lightFontColor, height: 1.2),
                ),
              ),
              SizedBox(height: 15),
              Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                SizedBox(width: width*mediumPadRate,),
                Text(
                  (state as SearchCompleted).searchResponse.districtName!,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                )
              ]),])
              : Container(),
              ListView.builder(
                itemCount: (state as SearchCompleted).centers.length,
                itemBuilder: ((context, index) {
                  return CenterCard(
                    center: state.centers[index],
                  );
                }),
                physics: ClampingScrollPhysics(),
                shrinkWrap: true,
              ),
            ],
          ),
        );
      },
    );
  }
}
