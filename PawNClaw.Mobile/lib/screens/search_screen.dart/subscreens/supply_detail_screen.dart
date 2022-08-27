import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:pawnclaw_mobile_application/blocs/booking/booking_bloc.dart';
import 'package:pawnclaw_mobile_application/common/components/primary_icon_button.dart';
import 'package:pawnclaw_mobile_application/common/components/secondary_icon_button.dart';
import 'package:pawnclaw_mobile_application/common/constants.dart';
import 'package:pawnclaw_mobile_application/models/center.dart' as petCenter;
import 'package:pawnclaw_mobile_application/models/pet.dart';
import 'package:pawnclaw_mobile_application/screens/search_screen.dart/components/choose_pet_dialog.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:readmore/readmore.dart';

import '../../../models/fake_data.dart';

class SupplyDetails extends StatefulWidget {
  final petCenter.Supplies supply;
  final bool? isUpdate;
  final int? quantity;
  final int? petId;
  const SupplyDetails(
      {required this.supply,
      this.isUpdate,
      this.quantity,
      this.petId,
      Key? key})
      : super(key: key);

  @override
  State<SupplyDetails> createState() => _SupplyDetailsState();
}

class _SupplyDetailsState extends State<SupplyDetails> {
  int activeIndex = 0;
  int selectedIndex = 0;
  int quantity = 1;
  // late Pet pet;

  @override
  void initState() {
    quantity = widget.quantity ?? 1;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var state = BlocProvider.of<BookingBloc>(context).state;
    var requests = (state as BookingUpdated).requests;
    //var pet = requests![0][0];
    Size size = MediaQuery.of(context).size;
    double height = size.height;
    double width = size.width;
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
                            itemCount: 1,
                            itemBuilder: (context, index, realIndex) {
                              return Container(
                                  width: size.width,
                                  child: (supply.photo?.url == null)
                                      ? Image.asset(
                                          CAGE_PHOTOS[index],
                                          fit: BoxFit.cover,
                                        )
                                      : Image.network(
                                          supply.photo!.url!,
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
          body: Container(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                    locale: 'vi_vn')
                                .format(supply.discountPrice == 0
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
                        if ((widget.isUpdate != null && widget.isUpdate!) &&
                            pets[index].id == widget.petId) {
                          selectedIndex = index;
                        }
                        ;
                        return (widget.isUpdate == null)
                            ? InkWell(
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
                                                  color: primaryColor,
                                                  size: 20),
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
                                    ]))
                            : (pets[index].id != widget.petId)
                                ? Container()
                                : InkWell(
                                    onTap: () {
                                      setState(() {
                                        selectedIndex = index;
                                        // pet = pets[index];
                                        // print('pet id at choose ${pet.id}');
                                        // print(pets[index].id.toString());
                                      });
                                    },
                                    child: Stack(
                                        alignment:
                                            AlignmentDirectional.topCenter,
                                        children: [
                                          selectedIndex == index
                                              ? Positioned(
                                                  child: Icon(
                                                      Icons.check_circle,
                                                      color: primaryColor,
                                                      size: 20),
                                                  top: 5,
                                                  right: 5)
                                              : Container(),
                                          Container(
                                            height: width * 0.32,
                                            width: width * 0.3,
                                            decoration: BoxDecoration(
                                                color: index == selectedIndex
                                                    ? primaryColor
                                                        .withOpacity(0.15)
                                                    : frameColor,
                                                borderRadius:
                                                    BorderRadius.circular(15)),
                                            child:
                                                PetCard(pets[index], context),
                                          ),
                                          Positioned(
                                            bottom: width * regularPadRate,
                                            //   left: width * 0.3 / 5,
                                            child: Center(
                                              child: Text(pets[index].name!,
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      color: index ==
                                                              selectedIndex
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
                // Container(
                //     //height: 100,
                //     width: size.width,
                //     padding: EdgeInsets.fromLTRB(10, 20, 10, 20),
                //     decoration: BoxDecoration(
                //         color: Colors.white,
                //         borderRadius: BorderRadius.only(
                //             bottomLeft: Radius.circular(15),
                //             bottomRight: Radius.circular(15))),
                //     child: Column(
                //       crossAxisAlignment: CrossAxisAlignment.start,
                //       children: [
                //         Text(
                //           'Chi tiết',
                //           style: TextStyle(
                //               fontSize: 18, fontWeight: FontWeight.w600),
                //         ),
                //         SizedBox(
                //           height: 10,
                //         ),
                //         ReadMoreText(
                //           // cage.description,
                //           "This is description...",
                //           style: TextStyle(
                //             fontSize: 15,
                //             color: lightFontColor,
                //             fontWeight: FontWeight.w500,
                //           ), //halt
                //           trimLines:
                //               5, //thêm card chọn pet xong thì sửa số này lại nhá
                //           trimCollapsedText: 'xem thêm',
                //           trimExpandedText: 'thu gọn',
                //           // maxLines: 5,
                //           // overflow: TextOverflow.ellipsis,
                //         )
                //       ],
                //     )),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SecondaryIconButton(
                          icon: Iconsax.minus_square,
                          color: primaryColor,
                          onPressed: () {
                            if (widget.isUpdate != null && widget.isUpdate!) {
                              if (quantity > 0) {
                                setState(() {
                                  quantity = quantity - 1;
                                });
                              }
                            } else if (quantity > 1) {
                              setState(() {
                                quantity = quantity - 1;
                              });
                            }
                          }),
                      SizedBox(
                        width: 10,
                      ),
                      Text(quantity.toString(),
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              height: 1.5)),
                      SizedBox(
                        width: 10,
                      ),
                      SecondaryIconButton(
                          icon: Iconsax.add_square,
                          color: primaryColor,
                          onPressed: () {
                            // print(supply.quantity);
                            if (widget.isUpdate != null && widget.isUpdate!) {
                              if (quantity < supply.quantity!) {
                                setState(() {
                                  quantity = quantity + 1;
                                });
                              } else {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content: Text(
                                      'Số lượng của sản phẩm này đã đạt đủ'),
                                ));
                              }
                            } else if (state.booking
                                .supplyOrderCreateParameters!.isNotEmpty) {
                              var supplyOrder = state
                                  .booking.supplyOrderCreateParameters!
                                  .where((element) =>
                                      supply.id == element.supplyId);

                              if (supplyOrder.isNotEmpty) {
                                int booked = 0;
                                supplyOrder.forEach((element) {
                                  booked += element.quantity!;
                                });

                                if (quantity + booked < supply.quantity!) {
                                  setState(() {
                                    quantity = quantity + 1;
                                  });
                                } else {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                    content: Text(
                                        'Số lượng của sản phẩm này đã đạt đủ'),
                                  ));
                                }
                              } else {
                                if (quantity < supply.quantity!) {
                                  setState(() {
                                    quantity = quantity + 1;
                                  });
                                } else {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                    content: Text(
                                        'Số lượng của sản phẩm này đã đạt đủ'),
                                  ));
                                }
                              }
                            } else {
                              if (quantity < supply.quantity!) {
                                setState(() {
                                  quantity = quantity + 1;
                                });
                              } else {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content: Text(
                                      'Số lượng của sản phẩm này đã đạt đủ'),
                                ));
                              }
                            }
                          }),
                    ],
                  ),
                )

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
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Container(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            //decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(15))),
            child: ElevatedButton(
              onPressed: () {
                //print('pet id:' + pets[selectedIndex].id!.toString());
                bool isValid = false;
                if (widget.isUpdate != null && widget.isUpdate!) {
                  if (quantity < supply.quantity!) {
                    isValid = true;
                  } else {
                    isValid = false;
                  }
                } else if (state
                    .booking.supplyOrderCreateParameters!.isNotEmpty) {
                  var supplyOrder = state.booking.supplyOrderCreateParameters!
                      .where((element) => supply.id == element.supplyId);

                  if (supplyOrder.isNotEmpty) {
                    int booked = 0;
                    supplyOrder.forEach((element) {
                      booked += element.quantity!;
                    });
                    if (quantity + booked <= supply.quantity!) {
                      isValid = true;
                    } else {
                      isValid = false;
                    }
                  } else {
                    if (quantity < supply.quantity!) {
                      isValid = true;
                    } else {
                      isValid = false;
                    }
                  }
                } else {
                  if (quantity <= supply.quantity!) {
                    isValid = true;
                  } else {
                    isValid = false;
                  }
                }
                if (isValid) {
                  BlocProvider.of<BookingBloc>(context).add(SelectSupply(
                          sellPrice: supply.sellPrice!,
                          quantity: quantity,
                          supplyId: supply.id!,
                          isUpdate: widget.isUpdate ?? false,
                          petId: pets[selectedIndex]
                              .id!) //: (state as BookingUpdated).selectedPet!.id!),
                      );
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(((widget.isUpdate == null)
                              ? 'Thêm vào'
                              : 'Cập nhật') +
                          " sản phẩm thành công.")));
                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Số lượng của sản phẩm này đã đạt đủ'),
                  ));
                }
              },
              child: Row(children: [
                Expanded(
                    child: SizedBox(
                  height: 45,
                )),
                Text(
                  (quantity == 0)
                      ? 'Xóa sản phẩm'
                      : ((widget.isUpdate == null) ? 'Thêm vào' : 'Cập nhật') +
                          ' giỏ hàng - ' +
                          NumberFormat.currency(
                                  decimalDigits: 0,
                                  symbol: 'đ',
                                  locale: 'vi_vn')
                              .format(supply.discountPrice == 0
                                  ? supply.sellPrice! * quantity
                                  : supply.discountPrice! * quantity),
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                ),
                Expanded(child: SizedBox(height: 45)),
              ]),
              style: ElevatedButton.styleFrom(
                  primary: (quantity > 0) ? primaryColor : Colors.red,
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
          image: (pet.photos!.isNotEmpty)
              ? DecorationImage(
                  image: NetworkImage(pet.photos!.first.url!),
                  fit: BoxFit.contain)
              : null,
          border: Border.all(
            color: Colors.white,
            width: 3, /*strokeAlign: StrokeAlign.outside*/
          )),
      child: (pet.photos!.isEmpty)
          ? CircleAvatar(
              backgroundImage: AssetImage((pet.petTypeCode == 'DOG')
                  ? 'lib/assets/dog.png'
                  : 'lib/assets/black-cat.png'),
            )
          : null,
    ),
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
