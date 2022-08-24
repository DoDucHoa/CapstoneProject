import 'package:flutter/cupertino.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:pawnclaw_mobile_application/blocs/booking/booking_bloc.dart';
import 'package:pawnclaw_mobile_application/common/constants.dart';
import 'package:pawnclaw_mobile_application/models/cage_type.dart';
import 'package:pawnclaw_mobile_application/models/center.dart' as petCenter;
import 'package:pawnclaw_mobile_application/models/pet.dart';
import 'package:pawnclaw_mobile_application/screens/search_screen.dart/components/choose_request_dialog.dart';
import 'package:pawnclaw_mobile_application/screens/search_screen.dart/components/pet_bubble.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:readmore/readmore.dart';

import '../../../models/cage.dart';
import '../../../models/fake_data.dart';
import '../components/choose_request_card.dart';

class CageDetails extends StatefulWidget {
  final CageTypes cageType;
  final Cages cage;
  const CageDetails({required this.cageType, required this.cage, Key? key})
      : super(key: key);

  @override
  State<CageDetails> createState() => _CageDetailsState();
}

class _CageDetailsState extends State<CageDetails> {
  int activeIndex = 0;
  List<int>? selectedPetIds = null;
  late List<List<Pet>> requests;
  late bool haveAvailableRequests;

  bool isSuitable(List<Pet> request, CageTypes cageTypes) {
    if (cageTypes.isSingle!) return request.length == 1;
    return true;
  }

  bool isFitCage(List<Pet> request, CageTypes cageTypes) {
    double height = 0;
    double width = 0;
    for (var pet in request) {
      if (height < (pet.height! + addHeight)) {
        height = pet.height! + addHeight;
      }
      width += double.parse(
          ((pet.length! + pet.height!) / widthRatio).toStringAsFixed(1));
    }
    PetSizeCage petSizeCage = PetSizeCage(height, width, request.length == 1);

    return cageTypes.height! >= petSizeCage.height! &&
        cageTypes.width! >= petSizeCage.width! &&
        (cageTypes.isSingle! ? petSizeCage.isSingle! : true);
  }

  bool isSelectedCage(List<int> request, Cages cage) {
    var state = BlocProvider.of<BookingBloc>(context).state as BookingUpdated;
    var booking = state.booking;
    bool isSelected = false;
    if (booking.bookingDetailCreateParameters!.isNotEmpty) {
      booking.bookingDetailCreateParameters!.forEach((element) {
        if (element.cageCode == cage.code &&
            element.petId!.toString() != request.toString()) {
          isSelected = true;
          return;
        }
      });
    }
    return isSelected;
  }

  @override
  void initState() {
    var state = BlocProvider.of<BookingBloc>(context).state;
    requests = (state as BookingUpdated).requests!;
    haveAvailableRequests = false;
    for (var element in requests) {
      if (isFitCage(element, widget.cageType)) {
        haveAvailableRequests = true;
        selectedPetIds = [];
        element.forEach((element) {
          selectedPetIds!.add(element.id!);
        });
        break;
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var state = BlocProvider.of<BookingBloc>(context).state as BookingUpdated;

    Size size = MediaQuery.of(context).size;
    double appbarSize = size.height * 0.35;
    CageTypes cageType = widget.cageType;
    Cages cage = widget.cage;
    // print('ready to build cage details');
    // print(state.booking.selectedPetsIds?? 'null');
    // print(selectedPetIds);

    return Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (context, value) {
            return [
              SliverAppBar(
                centerTitle: true,
                backgroundColor: Colors.white,
                expandedHeight: appbarSize,
                floating: true,
                pinned: true,
                //leading: Icon(Icons.arrow_back),
                flexibleSpace: FlexibleSpaceBar(
                    collapseMode: CollapseMode.pin,
                    background: Stack(
                      children: [
                        //campaign image
                        CarouselSlider.builder(
                            itemCount: 1,
                            itemBuilder: (context, index, realIndex) {
                              return Container(
                                  width: size.width,
                                  child: (cageType.photo?.url == null)
                                      ? Image.asset(
                                          CAGE_PHOTOS[index],
                                          fit: BoxFit.cover,
                                        )
                                      : Image.network(
                                          cageType.photo!.url!,
                                          fit: BoxFit.cover,
                                        ));
                            },
                            options: CarouselOptions(
                                height: appbarSize,
                                viewportFraction: 1,
                                enableInfiniteScroll: false,
                                onPageChanged: ((index, reason) {
                                  setState(() => activeIndex = index);
                                }))),
                        // Positioned(
                        //     left: size.width / 3 + 15,
                        //     top: appbarSize * (1 - 0.2),
                        //     child: Center(
                        //       child: buildIndicator(),
                        //     )),
                        Container(
                          height: appbarSize,
                          decoration: const BoxDecoration(
                            // borderRadius:
                            //     BorderRadius.only(bottomLeft: Radius.circular(60)),
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.black12,
                                Colors.black26,
                                Colors.black38,
                                Colors.black54,
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            height: appbarSize * 0.2,
                            child: Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topLeft: const Radius.circular(30.0),
                                  topRight: const Radius.circular(30.0),
                                ),
                                color: Colors.white,
                              ),
                            )),
                      ],
                    )),
              )
            ];
          },
          body: buildContent(cageType, cage, size, context, requests),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Container(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            //decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(15))),
            child: ElevatedButton(
              onPressed: (selectedPetIds != null)
                  ? () {
                      List<int>? petIds =
                          state.booking.selectedPetsIds ?? selectedPetIds;
                      print(petIds);
                      

                      if (isSelectedCage(petIds!, cage)) {
                        showDialog(
                            context: context,
                            builder: ((context) => AlertDialog(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15)),
                                  title: Text('Phòng đã chọn'),
                                  content: Text(
                                      'Bạn đã chọn phòng này cho các bé khác rồi. Bạn có chắc muốn đổi phòng không?'),
                                  actions: <Widget>[
                                    TextButton(
                                      child: Text('Hủy'),
                                      style: TextButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          primary: lightFontColor),
                                      onPressed: () {
                                        Navigator.pop(context, false);
                                      },
                                    ),
                                    TextButton(
                                      child: Text('Đổi phòng'),
                                      style: TextButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10))),
                                      onPressed: () {
                                        Navigator.pop(context, true);
                                      },
                                    )
                                  ],
                                ))).then(
                          (changeCage) {
                            if (changeCage){
                              BlocProvider.of<BookingBloc>(context).add(ChangeCage(
                            price: cageType.totalPrice!,
                            cageCode: cage.code!,
                            replacePetId: petIds,
                          ));
                             ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text("Đổi phòng thành công.")));
                        Navigator.of(context).pop();
                            }
                          },
                        );
                      } else {
                        BlocProvider.of<BookingBloc>(context).add(SelectCage(
                            price: cageType.totalPrice!,
                            cageCode: cage.code!,
                            petId: petIds,
                          ));
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text("Chọn phòng thành công.")));
                        Navigator.of(context).pop();
                      }
                      // print(changeCage);
                      // if (changeCage != null) {
                      //   if (changeCage!) {
                      //     BlocProvider.of<BookingBloc>(context).add(ChangeCage(
                      //       price: cageType.totalPrice!,
                      //       cageCode: cage.code!,
                      //       replacePetId: petIds,
                      //     ));
                      //   } else {
                      //     BlocProvider.of<BookingBloc>(context).add(SelectCage(
                      //       price: cageType.totalPrice!,
                      //       cageCode: cage.code!,
                      //       petId: petIds,
                      //     ));
                      //   }
                      //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      //       content: Text((changeCage! ? "Đổi" : "Chọn") +
                      //           " phòng thành công.")));
                      //   Navigator.of(context).pop();
                      // }
                      // print(context.read<BookingBloc>().state);
                      //print(state.booking.selectedPetsIds);
                      // print(selectedPetIds);
                    }
                  : null,
              // => showCupertinoDialog(
              //   barrierDismissible: false,
              //   context: context,
              //   builder: (context) {
              //     return ChooseRequestDialog(requests: requests);
              //   },
              // ).then((value) {
              //   BlocProvider.of<BookingBloc>(context).add(
              //     SelectCage(
              //         price: cageType.totalPrice!,
              //         cageCode: cage.code!,
              //         petId: value),
              //   );
              //   ScaffoldMessenger.of(context).showSnackBar(
              //       SnackBar(content: Text("Thêm chuồng thành công.")));
              // }),
              child: Row(children: [
                Expanded(
                    child: SizedBox(
                  height: 45,
                )),
                Text(
                  'Thêm vào giỏ hàng - ' +
                      NumberFormat.currency(
                              decimalDigits: 0, symbol: 'đ', locale: 'vi_vn')
                          .format(cageType.totalPrice!),
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                ),
                Expanded(child: SizedBox(height: 45)),
              ]),
              style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15))),
            )));
  }

  Widget buildIndicator() => AnimatedSmoothIndicator(
        activeIndex: activeIndex,
        count: CAGE_PHOTOS.length,
        effect: ScrollingDotsEffect(
            activeDotColor: lightFontColor, dotHeight: 10, dotWidth: 10),
      );
}

Widget buildContent(CageTypes cageType, Cages cage, Size size,
    BuildContext context, List<List<Pet>> requests) {
  double height = MediaQuery.of(context).size.height;
  double width = MediaQuery.of(context).size.width;
  return Container(
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
        Container(
          height: 80,
          width: size.width,
          padding: EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(15),
                  bottomRight: Radius.circular(15))),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                cage.name!,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Text(
                    NumberFormat.currency(
                            decimalDigits: 0, symbol: 'đ', locale: 'vi_vn')
                        .format(cageType
                            .totalPrice), //  == 0 ? sellPrice : discountPrice),
                    //double.parse(cage.price.toStringAsFixed(0)).toStringAsExponential(),
                    style: TextStyle(fontSize: 13),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  if (cageType.totalPrice == 0) //(discountPrice > 0)
                    Text(
                      NumberFormat.currency(
                              decimalDigits: 0, symbol: 'đ', locale: 'vi_vn')
                          .format(0), //sellPrice),
                      style: TextStyle(
                          fontSize: 13,
                          color: lightFontColor,
                          decoration: TextDecoration.lineThrough),
                    ),
                  SizedBox(
                    width: 5,
                  ),
                  if (cageType.totalPrice! == 0) //(discountPrice > 0)
                    Padding(
                        padding: const EdgeInsets.only(right: 5, bottom: 5),
                        child: Container(
                          padding: EdgeInsets.all(11 * 0.4),
                          decoration: BoxDecoration(
                            color: primaryColor,
                            borderRadius: BorderRadius.circular(15),
                            //border: Border.all(width: 1),
                          ),
                          child: Text(
                            '  Khuyến mãi  ',
                            style: TextStyle(
                                fontSize: 11,
                                color: Colors.white,
                                fontWeight: FontWeight.w700),
                          ),
                        )),
                ],
              ),
              // cage.discount! > 0 ?
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
        SizedBox(
          height: 15,
        ),
        Container(
          height: 50,
          width: size.width,
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15), topRight: Radius.circular(15))),
          child: Text(
            'THÚ CƯNG',
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
        ),
        ChooseRequestCard(
            requests: requests,
            cageType: cageType,
            callback: (val) {
              print('value: ');
              print(val);

              BlocProvider.of<BookingBloc>(context)
                  .add(SelectRequest(petId: val));
              context.findRootAncestorStateOfType()!.setState(() {});
            }),
        SizedBox(
          height: 15,
        ),
        Container(
            //height: 100,
            width: size.width,
            padding: EdgeInsets.fromLTRB(10, 20, 10, 20),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(15),
                    bottomRight: Radius.circular(15))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Chi tiết',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  height: 10,
                ),
                ReadMoreText(
                  // cage.description,
                  cageType.description!,
                  style: TextStyle(
                    fontSize: 15,
                    color: lightFontColor,
                    fontWeight: FontWeight.w500,
                  ), //halt
                  trimLines: 5, //thêm card chọn pet xong thì sửa số này lại nhá
                  trimCollapsedText: 'xem thêm',
                  trimExpandedText: 'thu gọn',
                  // maxLines: 5,
                  // overflow: TextOverflow.ellipsis,
                )
              ],
            )),
        //SizedBox(height: 40),
        // Container(
        //     padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        //     //decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(15))),
        //     child: ElevatedButton(
        //       onPressed: () => showCupertinoDialog(
        //         barrierDismissible: false,
        //         context: context,
        //         builder: (context) {
        //           return ChooseRequestDialog(requests: requests);
        //         },
        //       ).then((value) {
        //         BlocProvider.of<BookingBloc>(context).add(
        //           SelectCage(
        //               price: cageType.totalPrice!,
        //               cageCode: cage.code!,
        //               petId: value),
        //         );
        //         ScaffoldMessenger.of(context).showSnackBar(
        //             SnackBar(content: Text("Thêm chuồng thành công.")));
        //       }),
        //       child: Row(children: [
        //         Expanded(
        //             child: SizedBox(
        //           height: 45,
        //         )),
        //         Text(
        //           'Thêm vào giỏ hàng - ' +
        //               NumberFormat.currency(
        //                       decimalDigits: 0, symbol: 'đ', locale: 'vi_vn')
        //                   .format(cageType.totalPrice),
        //           style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        //         ),
        //         Expanded(child: SizedBox(height: 45)),
        //       ]),
        //       style: ElevatedButton.styleFrom(
        //           shape: RoundedRectangleBorder(
        //               borderRadius: BorderRadius.circular(15))),
        //     ))
      ]));
}
