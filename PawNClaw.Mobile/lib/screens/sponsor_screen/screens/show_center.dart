import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pawnclaw_mobile_application/blocs/search/search_bloc.dart';
import 'package:pawnclaw_mobile_application/blocs/sponsor/sponsor_bloc.dart';
import 'package:pawnclaw_mobile_application/common/components/loading_indicator.dart';
import 'package:pawnclaw_mobile_application/common/constants.dart';
import 'package:pawnclaw_mobile_application/models/center.dart' as petCenter;
import 'package:pawnclaw_mobile_application/models/sponsor_banner.dart';
import 'package:pawnclaw_mobile_application/repositories/sponsor_banner/sponsor_repository.dart';
import 'package:pawnclaw_mobile_application/screens/home_screen/HomeScreen.dart';
import 'package:pawnclaw_mobile_application/screens/search_screen.dart/SearchScreen.dart';

import '../components/center_card.dart';

class AvailableCenterScreen extends StatefulWidget {
  final SponsorBanner banner;
  const AvailableCenterScreen({
    required this.banner,
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
    SponsorBanner banner = widget.banner;
    return 
    BlocProvider(
        create: (context) =>
            SponsorBloc()..add(GetCenterAtBanner(widget.banner.brandId!)),
        child: 
        BlocBuilder<SponsorBloc, SponsorState>(
      builder: (context, state) {
        print(context.read<SponsorBloc>().state);
       return (state is LoadedCenters)?
         Scaffold(
          backgroundColor: backgroundColor,
          appBar: AppBar(
            title: Text(
              banner.title!,
              style: TextStyle(
                fontSize: width * largeFontRate,
                fontWeight: FontWeight.bold,
                color: primaryFontColor,
              ),
            ),
            leading: IconButton(
              onPressed: () => //Navigator.of(context).pop(),
              Navigator.push(context,MaterialPageRoute(builder: (context) => HomeScreen())) ,
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
              
              ListView.builder(
                itemCount: state.centers.length,//(state as LoadedCenters).centers.length,
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
        ):LoadingIndicator(loadingText: 'Vui lòng đợi');
      },
    ) 
    );
  }
}
