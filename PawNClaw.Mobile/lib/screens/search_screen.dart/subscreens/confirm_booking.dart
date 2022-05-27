// import 'package:flutter/material.dart';
// import 'package:pawnclaw_mobile_application/common/constants.dart';
// import 'package:pawnclaw_mobile_application/screens/search_screen.dart/subscreens/booking_success_screen.dart';
// import 'package:pawnclaw_mobile_application/screens/search_screen.dart/subscreens/track_booking_screen.dart';
// import 'package:pawnclaw_mobile_application/screens/search_screen.dart/subscreens/vouchers_screen.dart';

// class ConfirmBooking extends StatefulWidget {
//   ConfirmBooking({Key? key}) : super(key: key);

//   @override
//   State<ConfirmBooking> createState() => _ConfirmBookingState();
// }

<<<<<<< HEAD
// class _ConfirmBookingState extends State<ConfirmBooking> {
//   @override
//   Widget build(BuildContext context) {
//     double height = MediaQuery.of(context).size.height;
//     double width = MediaQuery.of(context).size.width;
//     return Scaffold(
//       backgroundColor: backgroundColor,
//       appBar: AppBar(
//         title: Text(
//           "Đặt lịch",
//           style: TextStyle(
//             fontSize: width * largeFontRate,
//             fontWeight: FontWeight.bold,
//             color: primaryFontColor,
//           ),
//         ),
//         leading: IconButton(
//           onPressed: () => Navigator.of(context).pop(),
//           icon: Icon(
//             Icons.arrow_back_ios_new,
//             color: primaryFontColor,
//           ),
//         ),
//         backgroundColor: Colors.white,
//         elevation: 0,
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             Container(
//               padding: EdgeInsets.symmetric(horizontal: width * smallPadRate),
//               height: height * 0.12,
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.only(
//                   bottomLeft: Radius.circular(25),
//                   bottomRight: Radius.circular(25),
//                 ),
//                 color: Colors.white,
//               ),
//               child: Row(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   CircleAvatar(
//                     radius: height * 0.04,
//                     backgroundColor: lightPrimaryColor,
//                     backgroundImage: AssetImage('lib/assets/vet-ava.png'),
//                   ),
//                   Padding(
//                     padding: EdgeInsets.all(width * smallPadRate),
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           "Petland veterinary",
//                           style: TextStyle(
//                             fontSize: width * largeFontRate,
//                             fontWeight: FontWeight.w500,
//                             color: primaryFontColor,
//                           ),
//                         ),
//                         RichText(
//                           text: TextSpan(
//                             children: [
//                               WidgetSpan(
//                                 child: Icon(
//                                   Icons.location_on_rounded,
//                                   size: width * regularFontRate,
//                                   color: primaryColor,
//                                 ),
//                               ),
//                               TextSpan(
//                                 text: "64A Street",
//                                 style: TextStyle(
//                                   color: lightFontColor,
//                                   fontWeight: FontWeight.w600,
//                                   fontSize: width * smallFontRate,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   )
//                 ],
//               ),
//             ),
//             Container(
//               padding: EdgeInsets.symmetric(horizontal: width * smallPadRate),
//               margin: EdgeInsets.symmetric(
//                 horizontal: width * smallPadRate,
//                 vertical: width * smallPadRate,
//               ),
//               width: width,
//               height: height * 0.15,
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(10),
//                 color: Colors.white,
//               ),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     "THỜI GIAN",
//                     style: TextStyle(
//                       color: primaryFontColor,
//                       fontWeight: FontWeight.w600,
//                       fontSize: width * regularFontRate,
//                     ),
//                   ),
//                   Container(
//                     padding: EdgeInsets.all(width * smallPadRate * 0.5),
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(10),
//                       color: backgroundColor,
//                     ),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                       children: [
//                         Column(
//                           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                           children: [
//                             Text(
//                               "CHECK IN",
//                               style: TextStyle(
//                                 color: lightFontColor,
//                               ),
//                             ),
//                             Text(
//                               "03:00 PM, 11/05/2022",
//                               style: TextStyle(
//                                 color: primaryFontColor,
//                                 fontWeight: FontWeight.w500,
//                                 fontSize: width * smallFontRate,
//                               ),
//                             )
//                           ],
//                         ),
//                         Container(
//                           width: 1.5,
//                           height: height * 0.04,
//                           color: lightFontColor,
//                         ),
//                         Column(
//                           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                           children: [
//                             Text(
//                               "CHECK OUT",
//                               style: TextStyle(
//                                 color: lightFontColor,
//                               ),
//                             ),
//                             Text(
//                               "03:00 PM, 11/05/2022",
//                               style: TextStyle(
//                                 color: primaryFontColor,
//                                 fontWeight: FontWeight.w500,
//                                 fontSize: width * smallFontRate,
//                               ),
//                             )
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             Container(
//               padding: EdgeInsets.all(width * mediumPadRate),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(15),
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     "THÚ CƯNG",
//                     style: TextStyle(
//                       color: primaryFontColor,
//                       fontWeight: FontWeight.w600,
//                       fontSize: width * regularFontRate,
//                     ),
//                   ),
//                   Row(
//                     children: [
//                       Container(
//                         margin: EdgeInsets.only(
//                             bottom: width * extraSmallPadRate,
//                             top: width * mediumPadRate,
//                             right: width * extraSmallPadRate,
//                             left: 0),
//                         padding: EdgeInsets.all(width * smallPadRate * 0.25),
//                         height: height * 0.1,
//                         width: height * 0.1,
//                         decoration: BoxDecoration(
//                           color: primaryColor.withOpacity(0.15),
//                           borderRadius: BorderRadius.circular(15),
//                         ),
//                         child: Stack(
//                           children: [
//                             SizedBox(
//                               height: height * 0.1,
//                               width: height * 0.1,
//                             ),
//                             Positioned(
//                               right: 0,
//                               bottom: 0,
//                               child: CircleAvatar(
//                                 backgroundImage:
//                                     AssetImage('lib/assets/cat_avatar0.png'),
//                               ),
//                             ),
//                             CircleAvatar(
//                               backgroundImage:
//                                   AssetImage('lib/assets/cat_avatar0.png'),
//                             ),
//                           ],
//                         ),
//                       ),
//                       SizedBox(
//                         height: height * 0.06,
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               "Chuồng 1",
//                               style: TextStyle(
//                                 color: primaryFontColor,
//                                 fontWeight: FontWeight.w500,
//                                 fontSize: width * regularFontRate,
//                               ),
//                             ),
//                             Text(
//                               "Alice, Abby",
//                               style: TextStyle(
//                                 color: lightFontColor,
//                                 fontWeight: FontWeight.w500,
//                                 fontSize: width * regularFontRate * 0.8,
//                               ),
//                             ),
//                           ],
//                         ),
//                       )
//                     ],
//                   ),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(
//                         "Chuồng VIP size XL",
//                         style: TextStyle(
//                           color: primaryFontColor,
//                           fontWeight: FontWeight.w500,
//                           fontSize: width * regularFontRate * 0.8,
//                         ),
//                       ),
//                       RichText(
//                         text: TextSpan(
//                           children: [
//                             TextSpan(
//                               text: "100.000 đ",
//                               style: TextStyle(
//                                 fontSize: width * regularFontRate * 0.8 * 0.8,
//                                 color: primaryFontColor,
//                                 fontWeight: FontWeight.w500,
//                               ),
//                             ),
//                             TextSpan(
//                               text: " x2 giờ",
//                               style: TextStyle(
//                                 color: lightFontColor,
//                                 fontWeight: FontWeight.w500,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                   Row(
//                     children: [
//                       Container(
//                         margin: EdgeInsets.only(
//                             bottom: width * extraSmallPadRate,
//                             top: width * extraSmallPadRate,
//                             right: width * extraSmallPadRate,
//                             left: 0),
//                         padding: EdgeInsets.all(width * smallPadRate * 0.5),
//                         height: height * 0.1,
//                         width: height * 0.1,
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(15),
//                         ),
//                         child: CircleAvatar(
//                           backgroundImage:
//                               AssetImage('lib/assets/cat_avatar0.png'),
//                         ),
//                       ),
//                       SizedBox(
//                         height: height * 0.06,
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               "Alice",
//                               style: TextStyle(
//                                 color: primaryFontColor,
//                                 fontWeight: FontWeight.w500,
//                                 fontSize: width * regularFontRate,
//                               ),
//                             ),
//                             Text(
//                               "0.5 kg",
//                               style: TextStyle(
//                                 color: lightFontColor,
//                                 fontWeight: FontWeight.w500,
//                                 fontSize: width * regularFontRate * 0.8,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(
//                         "Pate mèo vị cá ngừ",
//                         style: TextStyle(
//                           color: primaryFontColor,
//                           fontWeight: FontWeight.w500,
//                           fontSize: width * regularFontRate * 0.8,
//                         ),
//                       ),
//                       Text(
//                         "100.000 đ",
//                         style: TextStyle(
//                           color: primaryFontColor,
//                           fontWeight: FontWeight.w500,
//                           fontSize: width * regularFontRate * 0.8,
//                         ),
//                       )
//                     ],
//                   ),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(
//                         "Dịch vụ tắm mát xa",
//                         style: TextStyle(
//                           color: primaryFontColor,
//                           fontWeight: FontWeight.w500,
//                           fontSize: width * regularFontRate * 0.8,
//                         ),
//                       ),
//                       Text(
//                         "100.000 đ",
//                         style: TextStyle(
//                           color: primaryFontColor,
//                           fontWeight: FontWeight.w500,
//                           fontSize: width * regularFontRate * 0.8,
//                         ),
//                       )
//                     ],
//                   ),
//                   Row(
//                     children: [
//                       Container(
//                         margin: EdgeInsets.only(
//                             bottom: width * extraSmallPadRate,
//                             top: width * extraSmallPadRate,
//                             right: width * extraSmallPadRate,
//                             left: 0),
//                         padding: EdgeInsets.all(width * smallPadRate * 0.5),
//                         height: height * 0.1,
//                         width: height * 0.1,
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(15),
//                         ),
//                         child: CircleAvatar(
//                           backgroundImage:
//                               AssetImage('lib/assets/cat_avatar0.png'),
//                         ),
//                       ),
//                       SizedBox(
//                         height: height * 0.06,
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               "Abby",
//                               style: TextStyle(
//                                 color: primaryFontColor,
//                                 fontWeight: FontWeight.w500,
//                                 fontSize: width * regularFontRate,
//                               ),
//                             ),
//                             Text(
//                               "5.5 kg",
//                               style: TextStyle(
//                                 color: lightFontColor,
//                                 fontWeight: FontWeight.w500,
//                                 fontSize: width * regularFontRate * 0.8,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(
//                         "Sữa vitamin",
//                         style: TextStyle(
//                           color: primaryFontColor,
//                           fontWeight: FontWeight.w500,
//                           fontSize: width * regularFontRate * 0.8,
//                         ),
//                       ),
//                       Text(
//                         "100.000 đ",
//                         style: TextStyle(
//                           color: primaryFontColor,
//                           fontWeight: FontWeight.w500,
//                           fontSize: width * regularFontRate * 0.8,
//                         ),
//                       )
//                     ],
//                   ),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(
//                         "Dịch vụ tắm mát xa",
//                         style: TextStyle(
//                           color: primaryFontColor,
//                           fontWeight: FontWeight.w500,
//                           fontSize: width * regularFontRate * 0.8,
//                         ),
//                       ),
//                       Text(
//                         "100.000 đ",
//                         style: TextStyle(
//                           color: primaryFontColor,
//                           fontWeight: FontWeight.w500,
//                           fontSize: width * regularFontRate * 0.8,
//                         ),
//                       )
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//             // Container(
//             //   padding: EdgeInsets.symmetric(
//             //     horizontal: width * smallPadRate,
//             //     vertical: width * smallPadRate * 0.5,
//             //   ),
//             //   margin: EdgeInsets.symmetric(
//             //     horizontal: width * mediumPadRate,
//             //     vertical: width * smallPadRate,
//             //   ),
//             //   width: width,
//             //   decoration: BoxDecoration(
//             //     borderRadius: BorderRadius.circular(15),
//             //     color: Colors.white,
//             //     border: Border.all(color: Colors.black12),
//             //   ),
//             //   child: Row(
//             //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             //     children: [
//             //       Icon(
//             //         Icons.card_giftcard,
//             //         color: primaryColor,
//             //       ),
//             //       Padding(
//             //         padding:
//             //             EdgeInsets.symmetric(horizontal: width * smallPadRate),
//             //         child: Text(
//             //           "Áp dụng ưu đãi",
//             //           style: TextStyle(
//             //             fontWeight: FontWeight.w600,
//             //           ),
//             //         ),
//             //       ),
//             //       Spacer(),
//             //       Icon(
//             //         Icons.navigate_next,
//             //         color: primaryColor,
//             //       ),
//             //     ],
//             //   ),
//             // ),
//             Container(
//               padding: EdgeInsets.symmetric(
//                 horizontal: width * mediumPadRate,
//                 vertical: width * smallPadRate,
//               ),
//               child: OutlinedButton.icon(
//                   style: OutlinedButton.styleFrom(
//                       backgroundColor: Colors.white,
//                       shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(10))),
//                   onPressed: () {
//                     Navigator.of(context).push(
//                         MaterialPageRoute(builder: (context) => Vouchers()));
//                   },
//                   icon: Image.asset(
//                     'lib/assets/coupon.png',
//                     width: 30,
//                   ),
//                   label: Container(
//                       padding: EdgeInsets.fromLTRB(10, 15, 5, 15),
//                       child: Row(
//                         children: [
//                           Text(
//                             'Áp dụng ưu đãi',
//                             style: TextStyle(color: primaryFontColor),
//                           ),
//                           Expanded(child: SizedBox()),
//                           Icon(Icons.keyboard_double_arrow_right),
//                         ],
//                       ))),
//             ),
//             Container(
//               padding: EdgeInsets.symmetric(
//                 horizontal: width * smallPadRate,
//               ),
//               margin: EdgeInsets.symmetric(horizontal: width * mediumPadRate),
//               width: width,
//               height: height * 0.3,
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(15),
//                 color: Colors.white,
//                 border: Border.all(color: Colors.black12),
//               ),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     "THÔNG TIN HÓA ĐƠN",
//                     style: TextStyle(
//                       color: primaryFontColor,
//                       fontWeight: FontWeight.w600,
//                       fontSize: width * regularFontRate,
//                     ),
//                   ),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(
//                         "Dịch vụ",
//                         style: TextStyle(
//                           color: primaryFontColor,
//                           fontSize: width * regularFontRate * 0.8,
//                         ),
//                       ),
//                       Text(
//                         "200.000 đ",
//                         style: TextStyle(
//                           color: primaryFontColor,
//                           fontWeight: FontWeight.w500,
//                           fontSize: width * regularFontRate * 0.8,
//                         ),
//                       )
//                     ],
//                   ),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(
//                         "Đồ dùng",
//                         style: TextStyle(
//                           color: primaryFontColor,
//                           fontSize: width * regularFontRate * 0.8,
//                         ),
//                       ),
//                       Text(
//                         "200.000 đ",
//                         style: TextStyle(
//                           color: primaryFontColor,
//                           fontWeight: FontWeight.w500,
//                           fontSize: width * regularFontRate * 0.8,
//                         ),
//                       )
//                     ],
//                   ),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(
//                         "Chi phí khách sạn x 2 giờ",
//                         style: TextStyle(
//                           color: primaryFontColor,
//                           fontSize: width * regularFontRate * 0.8,
//                         ),
//                       ),
//                       Text(
//                         "200.000 đ",
//                         style: TextStyle(
//                           color: primaryFontColor,
//                           fontWeight: FontWeight.w500,
//                           fontSize: width * regularFontRate * 0.8,
//                         ),
//                       )
//                     ],
//                   ),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(
//                         "Giảm giá",
//                         style: TextStyle(
//                           color: primaryFontColor,
//                           fontSize: width * regularFontRate * 0.8,
//                         ),
//                       ),
//                       Text(
//                         "-200.000 đ",
//                         style: TextStyle(
//                           color: primaryFontColor,
//                           fontWeight: FontWeight.w500,
//                           fontSize: width * regularFontRate * 0.8,
//                         ),
//                       )
//                     ],
//                   ),
//                   Container(
//                     width: width,
//                     height: 1.5,
//                     color: Colors.black12,
//                   ),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(
//                         "Tổng tiền",
//                         style: TextStyle(
//                           color: primaryFontColor,
//                           fontSize: width * regularFontRate * 0.8,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                       Text(
//                         "400.000 đ",
//                         style: TextStyle(
//                           color: primaryFontColor,
//                           fontWeight: FontWeight.w800,
//                           fontSize: width * regularFontRate * 0.8,
//                         ),
//                       )
//                     ],
//                   ),
//                 ],
//               ),
//             ),
=======
class _ConfirmBookingState extends State<ConfirmBooking> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text(
          "Đặt lịch",
          style: TextStyle(
            fontSize: width * largeFontRate,
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
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: width * smallPadRate),
              height: height * 0.12,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(25),
                  bottomRight: Radius.circular(25),
                ),
                color: Colors.white,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: height * 0.04,
                    backgroundColor: lightPrimaryColor,
                    backgroundImage: AssetImage('lib/assets/vet-ava.png'),
                  ),
                  Padding(
                    padding: EdgeInsets.all(width * smallPadRate),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Petland veterinary",
                          style: TextStyle(
                            fontSize: width * largeFontRate,
                            fontWeight: FontWeight.w500,
                            color: primaryFontColor,
                          ),
                        ),
                        RichText(
                          text: TextSpan(
                            children: [
                              WidgetSpan(
                                child: Icon(
                                  Icons.location_on_rounded,
                                  size: width * regularFontRate,
                                  color: primaryColor,
                                ),
                              ),
                              TextSpan(
                                text: "64A Street",
                                style: TextStyle(
                                  color: lightFontColor,
                                  fontWeight: FontWeight.w600,
                                  fontSize: width * smallFontRate,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: width * smallPadRate),
              margin: EdgeInsets.symmetric(
                horizontal: width * smallPadRate,
                vertical: width * smallPadRate,
              ),
              width: width,
              height: height * 0.15,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "THỜI GIAN",
                    style: TextStyle(
                      color: primaryFontColor,
                      fontWeight: FontWeight.w600,
                      fontSize: width * regularFontRate,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(width * smallPadRate * 0.5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: backgroundColor,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              "CHECK IN",
                              style: TextStyle(
                                color: lightFontColor,
                              ),
                            ),
                            Text(
                              "03:00 PM, 11/05/2022",
                              style: TextStyle(
                                color: primaryFontColor,
                                fontWeight: FontWeight.w500,
                                fontSize: width * smallFontRate,
                              ),
                            )
                          ],
                        ),
                        Container(
                          width: 1.5,
                          height: height * 0.04,
                          color: lightFontColor,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              "CHECK OUT",
                              style: TextStyle(
                                color: lightFontColor,
                              ),
                            ),
                            Text(
                              "03:00 PM, 11/05/2022",
                              style: TextStyle(
                                color: primaryFontColor,
                                fontWeight: FontWeight.w500,
                                fontSize: width * smallFontRate,
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(width * mediumPadRate),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "THÚ CƯNG",
                    style: TextStyle(
                      color: primaryFontColor,
                      fontWeight: FontWeight.w600,
                      fontSize: width * regularFontRate,
                    ),
                  ),
                  Row(
                    children: [
                      Container(
                        margin: EdgeInsets.only(
                            bottom: width * extraSmallPadRate,
                            top: width * mediumPadRate,
                            right: width * extraSmallPadRate,
                            left: 0),
                        padding: EdgeInsets.all(width * smallPadRate * 0.25),
                        height: height * 0.1,
                        width: height * 0.1,
                        decoration: BoxDecoration(
                          color: primaryColor.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Stack(
                          children: [
                            SizedBox(
                              height: height * 0.1,
                              width: height * 0.1,
                            ),
                            Positioned(
                              right: 0,
                              bottom: 0,
                              child: CircleAvatar(
                                backgroundImage:
                                    AssetImage('lib/assets/cat_avatar0.png'),
                              ),
                            ),
                            CircleAvatar(
                              backgroundImage:
                                  AssetImage('lib/assets/cat_avatar0.png'),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: height * 0.06,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Chuồng 1",
                              style: TextStyle(
                                color: primaryFontColor,
                                fontWeight: FontWeight.w500,
                                fontSize: width * regularFontRate,
                              ),
                            ),
                            Text(
                              "Alice, Abby",
                              style: TextStyle(
                                color: lightFontColor,
                                fontWeight: FontWeight.w500,
                                fontSize: width * regularFontRate * 0.8,
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Chuồng VIP size XL",
                        style: TextStyle(
                          color: primaryFontColor,
                          fontWeight: FontWeight.w500,
                          fontSize: width * regularFontRate * 0.8,
                        ),
                      ),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: "100.000 đ",
                              style: TextStyle(
                                fontSize: width * regularFontRate * 0.8 * 0.8,
                                color: primaryFontColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            TextSpan(
                              text: " x2 giờ",
                              style: TextStyle(
                                color: lightFontColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        margin: EdgeInsets.only(
                            bottom: width * extraSmallPadRate,
                            top: width * extraSmallPadRate,
                            right: width * extraSmallPadRate,
                            left: 0),
                        padding: EdgeInsets.all(width * smallPadRate * 0.5),
                        height: height * 0.1,
                        width: height * 0.1,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: CircleAvatar(
                          backgroundImage:
                              AssetImage('lib/assets/cat_avatar0.png'),
                        ),
                      ),
                      SizedBox(
                        height: height * 0.06,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Alice",
                              style: TextStyle(
                                color: primaryFontColor,
                                fontWeight: FontWeight.w500,
                                fontSize: width * regularFontRate,
                              ),
                            ),
                            Text(
                              "0.5 kg",
                              style: TextStyle(
                                color: lightFontColor,
                                fontWeight: FontWeight.w500,
                                fontSize: width * regularFontRate * 0.8,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Pate mèo vị cá ngừ",
                        style: TextStyle(
                          color: primaryFontColor,
                          fontWeight: FontWeight.w500,
                          fontSize: width * regularFontRate * 0.8,
                        ),
                      ),
                      Text(
                        "100.000 đ",
                        style: TextStyle(
                          color: primaryFontColor,
                          fontWeight: FontWeight.w500,
                          fontSize: width * regularFontRate * 0.8,
                        ),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Dịch vụ tắm mát xa",
                        style: TextStyle(
                          color: primaryFontColor,
                          fontWeight: FontWeight.w500,
                          fontSize: width * regularFontRate * 0.8,
                        ),
                      ),
                      Text(
                        "100.000 đ",
                        style: TextStyle(
                          color: primaryFontColor,
                          fontWeight: FontWeight.w500,
                          fontSize: width * regularFontRate * 0.8,
                        ),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        margin: EdgeInsets.only(
                            bottom: width * extraSmallPadRate,
                            top: width * extraSmallPadRate,
                            right: width * extraSmallPadRate,
                            left: 0),
                        padding: EdgeInsets.all(width * smallPadRate * 0.5),
                        height: height * 0.1,
                        width: height * 0.1,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: CircleAvatar(
                          backgroundImage:
                              AssetImage('lib/assets/cat_avatar0.png'),
                        ),
                      ),
                      SizedBox(
                        height: height * 0.06,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Abby",
                              style: TextStyle(
                                color: primaryFontColor,
                                fontWeight: FontWeight.w500,
                                fontSize: width * regularFontRate,
                              ),
                            ),
                            Text(
                              "5.5 kg",
                              style: TextStyle(
                                color: lightFontColor,
                                fontWeight: FontWeight.w500,
                                fontSize: width * regularFontRate * 0.8,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Sữa vitamin",
                        style: TextStyle(
                          color: primaryFontColor,
                          fontWeight: FontWeight.w500,
                          fontSize: width * regularFontRate * 0.8,
                        ),
                      ),
                      Text(
                        "100.000 đ",
                        style: TextStyle(
                          color: primaryFontColor,
                          fontWeight: FontWeight.w500,
                          fontSize: width * regularFontRate * 0.8,
                        ),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Dịch vụ tắm mát xa",
                        style: TextStyle(
                          color: primaryFontColor,
                          fontWeight: FontWeight.w500,
                          fontSize: width * regularFontRate * 0.8,
                        ),
                      ),
                      Text(
                        "100.000 đ",
                        style: TextStyle(
                          color: primaryFontColor,
                          fontWeight: FontWeight.w500,
                          fontSize: width * regularFontRate * 0.8,
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
            // Container(
            //   padding: EdgeInsets.symmetric(
            //     horizontal: width * smallPadRate,
            //     vertical: width * smallPadRate * 0.5,
            //   ),
            //   margin: EdgeInsets.symmetric(
            //     horizontal: width * mediumPadRate,
            //     vertical: width * smallPadRate,
            //   ),
            //   width: width,
            //   decoration: BoxDecoration(
            //     borderRadius: BorderRadius.circular(15),
            //     color: Colors.white,
            //     border: Border.all(color: Colors.black12),
            //   ),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //     children: [
            //       Icon(
            //         Icons.card_giftcard,
            //         color: primaryColor,
            //       ),
            //       Padding(
            //         padding:
            //             EdgeInsets.symmetric(horizontal: width * smallPadRate),
            //         child: Text(
            //           "Áp dụng ưu đãi",
            //           style: TextStyle(
            //             fontWeight: FontWeight.w600,
            //           ),
            //         ),
            //       ),
            //       Spacer(),
            //       Icon(
            //         Icons.navigate_next,
            //         color: primaryColor,
            //       ),
            //     ],
            //   ),
            // ),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: width * mediumPadRate,
                vertical: width * smallPadRate,
              ),
              child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10))),
                  onPressed: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => Vouchers()));
                  },
                  icon: Image.asset(
                    'lib/assets/coupon.png',
                    width: 30,
                  ),
                  label: Container(
                      padding: EdgeInsets.fromLTRB(10, 15, 5, 15),
                      child: Row(
                        children: [
                          Text(
                            'Áp dụng ưu đãi',
                            style: TextStyle(color: primaryFontColor),
                          ),
                          Expanded(child: SizedBox()),
                          Icon(Icons.keyboard_double_arrow_right),
                        ],
                      ))),
            ),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: width * smallPadRate,
              ),
              margin: EdgeInsets.symmetric(horizontal: width * mediumPadRate),
              width: width,
              height: height * 0.3,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.white,
                border: Border.all(color: Colors.black12),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    Text(
                      "CHI PHÍ DỰ KIẾN",
                      style: TextStyle(
                        color: primaryFontColor,
                        fontWeight: FontWeight.w600,
                        fontSize: width * regularFontRate,
                      ),
                    ),
                    SizedBox(width:5 ),
                    Icon(Icons.info_rounded, color: primaryColor,)
                  ]),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Dịch vụ",
                        style: TextStyle(
                          color: primaryFontColor,
                          fontSize: width * regularFontRate * 0.8,
                        ),
                      ),
                      Text(
                        "200.000 đ",
                        style: TextStyle(
                          color: primaryFontColor,
                          fontWeight: FontWeight.w500,
                          fontSize: width * regularFontRate * 0.8,
                        ),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Đồ dùng",
                        style: TextStyle(
                          color: primaryFontColor,
                          fontSize: width * regularFontRate * 0.8,
                        ),
                      ),
                      Text(
                        "200.000 đ",
                        style: TextStyle(
                          color: primaryFontColor,
                          fontWeight: FontWeight.w500,
                          fontSize: width * regularFontRate * 0.8,
                        ),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Chi phí khách sạn x 2 giờ",
                        style: TextStyle(
                          color: primaryFontColor,
                          fontSize: width * regularFontRate * 0.8,
                        ),
                      ),
                      Text(
                        "200.000 đ",
                        style: TextStyle(
                          color: primaryFontColor,
                          fontWeight: FontWeight.w500,
                          fontSize: width * regularFontRate * 0.8,
                        ),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Giảm giá",
                        style: TextStyle(
                          color: primaryFontColor,
                          fontSize: width * regularFontRate * 0.8,
                        ),
                      ),
                      Text(
                        "-200.000 đ",
                        style: TextStyle(
                          color: primaryFontColor,
                          fontWeight: FontWeight.w500,
                          fontSize: width * regularFontRate * 0.8,
                        ),
                      )
                    ],
                  ),
                  Container(
                    width: width,
                    height: 1.5,
                    color: Colors.black12,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Tổng tiền",
                        style: TextStyle(
                          color: primaryFontColor,
                          fontSize: width * regularFontRate * 0.8,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        "400.000 đ",
                        style: TextStyle(
                          color: primaryFontColor,
                          fontWeight: FontWeight.w800,
                          fontSize: width * regularFontRate * 0.8,
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
>>>>>>> af1e2b92beb18521f88728e1fbbee7149af6a1b5

//             Padding(
//               padding: EdgeInsets.symmetric(
//                 horizontal: width * mediumPadRate,
//                 vertical: width * smallPadRate,
//               ),
//               child: ElevatedButton(
//                   onPressed: () {
//                     Navigator.of(context).push(MaterialPageRoute(
//                         builder: (context) => BookingSuccess()));
//                   },
//                   style: ElevatedButton.styleFrom(
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(15),
//                     ),
//                   ),
//                   child: Padding(
//                     padding: EdgeInsets.symmetric(vertical: 15),
//                     child: Center(
//                       child: Text(
//                         "ĐẶT LỊCH",
//                         style: TextStyle(color: Colors.white),
//                       ),
//                     ),
//                   )),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
