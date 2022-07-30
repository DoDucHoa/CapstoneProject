import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pawnclaw_mobile_application/blocs/nearby_center/nearby_bloc.dart';
import 'package:pawnclaw_mobile_application/common/components/loading_indicator.dart';
import 'package:pawnclaw_mobile_application/common/components/primary_button.dart';
import 'package:pawnclaw_mobile_application/common/components/secondary_button.dart';
import 'package:pawnclaw_mobile_application/repositories/center/center_repository.dart';

import '../../../common/constants.dart';

class ShowAddressDialog extends StatefulWidget {
  const ShowAddressDialog({Key? key}) : super(key: key);

  @override
  State<ShowAddressDialog> createState() => _ShowAddressDialogState();
}

class _ShowAddressDialogState extends State<ShowAddressDialog> {
  late Position position;
  String? address;
  @override
  void initState() {
    var state =
        BlocProvider.of<NearbyBloc>(context).state as LoadedCurrentPosition;
    position = state.position;
    CenterRepository().getAddress(position).then((value) {
      setState(() {
        address = value;
      });
      
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return
        //  BlocProvider(
        //     create: (context) => NearbyBloc()..add(GetAddress(position)),
        //     child:
        BlocBuilder<NearbyBloc, NearbyState>(builder: (context, state) {
      return (address != null) ? Scaffold(
              backgroundColor: frameColor,
              body: Dialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40),
                    side: BorderSide.none,
                  ),
                  child: Container(
                    margin: EdgeInsets.symmetric(
                        vertical: width * regularPadRate,
                        horizontal: width * smallPadRate),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                            padding: EdgeInsets.all(width * mediumPadRate),
                            decoration: BoxDecoration(
                                color: primaryColor,
                                borderRadius: BorderRadius.circular(65)),
                            child: const Icon(
                              Iconsax.map5,
                              size: 65,
                              color: Colors.white,
                            )),
                        SizedBox(
                          height: width * mediumPadRate,
                        ),
                        Container(
                          width: width * 0.40,
                          child: Text(
                            address!,
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                height: 1.5),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(
                          height: width * smallPadRate,
                        ),
                        const Text(
                          "Đây là địa chỉ của bạn phải không?",
                          style: TextStyle(fontSize: 15, height: 1.5),
                          //textAlign: TextAlign.justify,
                        ),
                        SizedBox(
                          height: width * mediumPadRate,
                        ),
                        // PrimaryButton(
                        //     text: 'Xác nhận',
                        //     onPressed: () {
                        //       print(
                        //           'lat: ${state.position.latitude}, long: ${state.position.longitude}');
                        //       BlocProvider.of<NearbyBloc>(context)
                        //           //.add(GetCenterNearby(state.position.latitude, state.position.longitude, state.address));
                        //           .add(GetCenterNearby(10.824741,
                        //               106.691274, state.address));
                        //     },
                        //     contextWidth: width),
                        ElevatedButton(
                            onPressed: () {
                              print(
                                  'lat: ${position.latitude}, long: ${position.longitude}');
                              BlocProvider.of<NearbyBloc>(context)
                                  //.add(GetCenterNearby(state.position.latitude, state.position.longitude, state.address));
                                  .add(GetCenterNearby(
                                      10.824741, 106.691274, address!));
                            },
                            style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            )),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: width * smallPadRate),
                              child: const Center(
                                child: Text(
                                  'Xác nhận',
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700),
                                ),
                              ),
                            )),
                            SizedBox(height: width*smallPadRate,),
                            SecondaryButton(text: 'Trở về trang chủ', onPressed: ()=> Navigator.of(context).pop(), contextWidth: width)
                      ],
                    ),
                  )),
            )
          : LoadingIndicator(loadingText: 'Vui lòng đợi..');
    });
  }
}
