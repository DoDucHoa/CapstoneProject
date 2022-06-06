import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:pawnclaw_mobile_application/blocs/booking/booking_bloc.dart';
import 'package:pawnclaw_mobile_application/common/constants.dart';
import 'package:pawnclaw_mobile_application/models/center.dart' as petCenter;
import 'package:pawnclaw_mobile_application/models/pet.dart';
import 'package:pawnclaw_mobile_application/screens/search_screen.dart/components/choose_pet_dialog.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:readmore/readmore.dart';

import '../../../models/fake_data.dart';

class SupplyDetails extends StatefulWidget {
  final petCenter.Supplies supply;
  const SupplyDetails({required this.supply, Key? key}) : super(key: key);

  @override
  State<SupplyDetails> createState() => _SupplyDetailsState();
}

class _SupplyDetailsState extends State<SupplyDetails> {
  int activeIndex = 0;

  @override
  Widget build(BuildContext context) {
    var state = BlocProvider.of<BookingBloc>(context).state;
    var requests = (state as BookingUpdated).requests;
    Size size = MediaQuery.of(context).size;
    double appbarSize = size.height * 0.35;
    petCenter.Supplies supply = widget.supply;

    List<Pet> pets = [];
    requests!.forEach((elements) {
      elements.forEach((element) {
        pets.add(element);
      });
    });
    // pet = pets[0];

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
                            itemCount: CAGE_PHOTOS.length,
                            itemBuilder: (context, index, realIndex) {
                              return Container(
                                  width: size.width,
                                  child: Image.asset(
                                    CAGE_PHOTOS[index],
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
                        Positioned(
                            left: size.width / 3 + 15,
                            top: appbarSize * (1 - 0.2),
                            child: Center(
                              child: buildIndicator(),
                            )),

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
          body: Container(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Container(
                  height: 70,
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
                        supply.name!,
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Text(
                            NumberFormat.currency(
                              decimalDigits: 0,
                              symbol: '',
                            ).format(supply.discountPrice == 0
                                ? supply.sellPrice
                                : supply.discountPrice),
                            //double.parse(cage.price.toStringAsFixed(0)).toStringAsExponential(),
                            style: TextStyle(fontSize: 15),
                          ),
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
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15))),
                  child: Text(
                    'THÚ CƯNG',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
                Container(
                  height: height * 0.2,
                  width: width,
                  padding: EdgeInsets.symmetric(
                      horizontal: width * extraSmallPadRate),
                  color: Colors.white,
                  child: SizedBox(
                    height: width,
                    child:
                        //  SingleChildScrollView(
                        //   scrollDirection: Axis.horizontal, child: Row(
                        //   crossAxisAlignment: CrossAxisAlignment.start,
                        //   mainAxisSize: MainAxisSize.min,
                        //   children: [
                        ListView.separated(
                      itemBuilder: (context, index) {
                        return InkWell(
                            onTap: () {
                              setState(() {
                                selectedIndex = index;
                                // pet = pets[index];
                                // print('pet id at choose ${pet.id}');
                                // print(pets[index].id.toString());
                              });
                            },
                            child: Stack(
                                alignment: AlignmentDirectional.topCenter,
                                children: [
                                  selectedIndex == index
                                      ? Positioned(
                                          child: Icon(Icons.check_circle,
                                              color: primaryColor, size: 20),
                                          top: 5,
                                          right: 5)
                                      : Container(),
                                  Container(
                                    height: width * 0.32,
                                    width: width * 0.3,
                                    decoration: BoxDecoration(
                                        color: index == selectedIndex
                                            ? primaryColor.withOpacity(0.15)
                                            : frameColor,
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    child: PetCard(pets[index], context),
                                  ),
                                  Positioned(
                                    bottom: width * regularPadRate,
                                    //   left: width * 0.3 / 5,
                                    child: Center(
                                      child: Text(pets[index].name!,
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w700,
                                              color: index == selectedIndex
                                                  ? primaryColor
                                                  : lightFontColor)),
                                    ),
                                  )
                                ]));
                      },
                      separatorBuilder: (context, index) => SizedBox(
                        width: 12,
                      ),
                      itemCount: pets.length,
                      shrinkWrap: true,
                      physics: ClampingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                    ),
                    // ],
                  ),
                  // ),
                ),
                //ChoosePetCard(requests: FAKE_REQUESTS),
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
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w600),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        ReadMoreText(
                          // cage.description,
                          "This is description...",
                          style: TextStyle(
                            fontSize: 15,
                            color: lightFontColor,
                            fontWeight: FontWeight.w500,
                          ), //halt
                          trimLines:
                              5, //thêm card chọn pet xong thì sửa số này lại nhá
                          trimCollapsedText: 'xem thêm',
                          trimExpandedText: 'thu gọn',
                          // maxLines: 5,
                          // overflow: TextOverflow.ellipsis,
                        )
                      ],
                    )),

                // Container(
                //     padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                //     //decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(15))),
                //     child: ElevatedButton(
                //       onPressed: () => showCupertinoDialog(
                //         barrierDismissible: false,
                //         context: context,
                //         builder: (context) {
                //           return ChoosePetDialog(requests: requests);
                //         },
                //       ).then((value) {
                //         BlocProvider.of<BookingBloc>(context).add(
                //           SelectSupply(
                //               sellPrice: supply.sellPrice!,
                //               supplyId: supply.id!,
                //               petId: value),
                //         );
                //         ScaffoldMessenger.of(context).showSnackBar(
                //             SnackBar(content: Text("Thêm sản phẩm thành công.")));
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
                //                   .format(supply.discountPrice == 0
                //                       ? supply.sellPrice
                //                       : supply.discountPrice),
                //           style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                //         ),
                //         Expanded(child: SizedBox(height: 45)),
                //       ]),
                //       style: ElevatedButton.styleFrom(
                //           shape: RoundedRectangleBorder(
                //               borderRadius: BorderRadius.circular(15))),
                //     ))
              ])),
        ),
        floatingActionButton: Container(
            padding: EdgeInsets.only(left: 30),
            //decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(15))),
            child: ElevatedButton(
              onPressed: () {
                print('pet id:' + pets[selectedIndex].id!.toString());
                BlocProvider.of<BookingBloc>(context).add(SelectSupply(
                        sellPrice: supply.sellPrice!,
                        supplyId: supply.id!,
                        petId: pets[selectedIndex]
                            .id!) //: (state as BookingUpdated).selectedPet!.id!),
                    );

                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Thêm sản phẩm thành công.")));
                Navigator.of(context).pop();
              },
              child: Row(children: [
                Expanded(
                    child: SizedBox(
                  height: 45,
                )),
                Text(
                  'Thêm vào giỏ hàng - ' +
                      NumberFormat.currency(
                              decimalDigits: 0, symbol: 'đ', locale: 'vi_vn')
                          .format(supply.discountPrice == 0
                              ? supply.sellPrice
                              : supply.discountPrice),
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

Widget PetCard(Pet pet, BuildContext context) {
  double height = MediaQuery.of(context).size.height;
  double width = MediaQuery.of(context).size.width;

  return Center(
    child: Container(
        height: height * 0.05,
        width: height * 0.05,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(height),
            border: Border.all(
                color: Colors.white,
                width: 3,
                strokeAlign: StrokeAlign.outside)),
        child: CircleAvatar(
          backgroundImage: AssetImage('lib/assets/cat_avatar0.png'),
        )),
  );
}

// Widget buildContent(petCenter.Supplies supply, Size size, BuildContext context,
//     List<List<Pet>> requests) {
  // return Container(
  //     child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
  //   Container(
  //     height: 70,
  //     width: size.width,
  //     padding: EdgeInsets.symmetric(horizontal: 10),
  //     decoration: BoxDecoration(
  //         color: Colors.white,
  //         borderRadius: BorderRadius.only(
  //             bottomLeft: Radius.circular(15),
  //             bottomRight: Radius.circular(15))),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Text(
  //           supply.name!,
  //           style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
  //         ),
  //         SizedBox(
  //           height: 10,
  //         ),
  //         Row(
  //           children: [
  //             Text(
  //               NumberFormat.currency(
  //                 decimalDigits: 0,
  //                 symbol: '',
  //               ).format(supply.discountPrice == 0
  //                   ? supply.sellPrice
  //                   : supply.discountPrice),
  //               //double.parse(cage.price.toStringAsFixed(0)).toStringAsExponential(),
  //               style: TextStyle(fontSize: 15),
  //             ),
  //           ],
  //         ),
  //         // cage.discount! > 0 ?
  //         SizedBox(
  //           height: 20,
  //         ),
  //       ],
  //     ),
  //   ),
  //   SizedBox(
  //     height: 15,
  //   ),
  //   Container(
  //     height: 50,
  //     width: size.width,
  //     padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
  //     decoration: BoxDecoration(
  //         color: Colors.white,
  //         borderRadius: BorderRadius.only(
  //             topLeft: Radius.circular(15), topRight: Radius.circular(15))),
  //     child: Text('THÚ CƯNG', style: TextStyle(fontWeight: FontWeight.w700),),
  //   ),
    
  //   //ChoosePetCard(requests: FAKE_REQUESTS),
  //   SizedBox(
  //     height: 15,
  //   ),
  //   Container(
  //       //height: 100,
  //       width: size.width,
  //       padding: EdgeInsets.fromLTRB(10, 20, 10, 20),
  //       decoration: BoxDecoration(
  //           color: Colors.white,
  //           borderRadius: BorderRadius.only(
  //               bottomLeft: Radius.circular(15),
  //               bottomRight: Radius.circular(15))),
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           Text(
  //             'Chi tiết',
  //             style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
  //           ),
  //           SizedBox(
  //             height: 10,
  //           ),
  //           ReadMoreText(
  //             // cage.description,
  //             "This is description...",
  //             style: TextStyle(
  //               fontSize: 15,
  //               color: lightFontColor,
  //               fontWeight: FontWeight.w500,
  //             ), //halt
  //             trimLines: 5, //thêm card chọn pet xong thì sửa số này lại nhá
  //             trimCollapsedText: 'xem thêm',
  //             trimExpandedText: 'thu gọn',
  //             // maxLines: 5,
  //             // overflow: TextOverflow.ellipsis,
  //           )
  //         ],
  //       )),
    
  //   // Container(
  //   //     padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
  //   //     //decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(15))),
  //   //     child: ElevatedButton(
  //   //       onPressed: () => showCupertinoDialog(
  //   //         barrierDismissible: false,
  //   //         context: context,
  //   //         builder: (context) {
  //   //           return ChoosePetDialog(requests: requests);
  //   //         },
  //   //       ).then((value) {
  //   //         BlocProvider.of<BookingBloc>(context).add(
  //   //           SelectSupply(
  //   //               sellPrice: supply.sellPrice!,
  //   //               supplyId: supply.id!,
  //   //               petId: value),
  //   //         );
  //   //         ScaffoldMessenger.of(context).showSnackBar(
  //   //             SnackBar(content: Text("Thêm sản phẩm thành công.")));
  //   //       }),
  //   //       child: Row(children: [
  //   //         Expanded(
  //   //             child: SizedBox(
  //   //           height: 45,
  //   //         )),
  //   //         Text(
  //   //           'Thêm vào giỏ hàng - ' +
  //   //               NumberFormat.currency(
  //   //                       decimalDigits: 0, symbol: 'đ', locale: 'vi_vn')
  //   //                   .format(supply.discountPrice == 0
  //   //                       ? supply.sellPrice
  //   //                       : supply.discountPrice),
  //   //           style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
  //   //         ),
  //   //         Expanded(child: SizedBox(height: 45)),
  //   //       ]),
  //   //       style: ElevatedButton.styleFrom(
  //   //           shape: RoundedRectangleBorder(
  //   //               borderRadius: BorderRadius.circular(15))),
  //   //     ))
  // ]));
// }
