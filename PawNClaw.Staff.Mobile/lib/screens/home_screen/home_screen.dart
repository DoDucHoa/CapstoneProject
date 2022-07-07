import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_snake_navigationbar/flutter_snake_navigationbar.dart';
import 'package:pncstaff_mobile_application/blocs/auth/auth_bloc.dart';
import 'package:pncstaff_mobile_application/blocs/booking/booking_bloc.dart';
import 'package:pncstaff_mobile_application/common/components/elevated_container.dart';
import 'package:pncstaff_mobile_application/common/components/line_indicator.dart';
import 'package:pncstaff_mobile_application/common/components/loading_indicator.dart';
import 'package:pncstaff_mobile_application/common/constants.dart';
import 'package:pncstaff_mobile_application/models/account.dart';
import 'package:pncstaff_mobile_application/models/booking.dart';
import 'package:pncstaff_mobile_application/repositories/booking/booking_repository.dart';
import 'package:pncstaff_mobile_application/screens/home_screen/components/home_body.dart';

import 'components/welcome_panel.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedItemPosition = 0;
  var user;
  @override
  void initState() {
    // TODO: implement initState
    var state = BlocProvider.of<AuthBloc>(context).state;
    setState(() {
      user = (state as Authenticated).user;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return BlocProvider(
      create: (context) => BookingBloc(bookingRepository: BookingRepository())
        ..add(
          GetProcessingBooking(user: user),
        ),
      child: BlocBuilder<BookingBloc, BookingState>(
        builder: (context, state) {
          if (state is BookingLoaded) {
            return Scaffold(
              backgroundColor: backgroundColor,
              resizeToAvoidBottomInset: true,
              body: DefaultTabController(
                length: 3,
                child: NestedScrollView(
                  headerSliverBuilder: ((context, value) {
                    var authState = BlocProvider.of<AuthBloc>(context).state;
                    var user = (authState as Authenticated).user;
                    return [
                      SliverAppBar(
                        centerTitle: true,
                        backgroundColor: frameColor,
                        expandedHeight: height * 0.15,
                        floating: true,
                        pinned: true,
                        flexibleSpace: FlexibleSpaceBar(
                          collapseMode: CollapseMode.pin,
                          background: WelcomePanel(
                            username: user.name ?? "Staff",
                            bookings: state.bookings,
                          ),
                        ),
                        shadowColor: Colors.transparent,
                        bottom: TabBar(
                          tabs: [
                            Tab(
                              text: 'To-do list',
                            ),
                            Tab(
                              text: 'Check-out today',
                            ),
                            Tab(
                              text: 'Next up tasks',
                            ),
                          ],
                          labelColor: primaryColor,
                          unselectedLabelColor: lightFontColor,
                          labelStyle: TextStyle(fontWeight: FontWeight.w700),
                          indicator: LineIndicator(
                              color: primaryColor, radius: width / 4),
                          splashBorderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(10),
                              bottomRight: Radius.circular(10)),
                        ),
                      )
                    ];
                  }),
                  body: Container(
                    color: frameColor,
                    width: width,
                    child: TabBarView(children: [
                      SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("${DateTime.now()}"),
                            ListView.builder(
                              shrinkWrap: true,
                              itemCount: 2,
                              itemBuilder: (context, index) {
                                return Container(
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text("Time"),
                                      Flexible(
                                        child: ListView(
                                          shrinkWrap: true,
                                          children: [
                                            Text("data"),
                                            Text("data"),
                                            Text("data"),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            )
                            // Row(
                            //   mainAxisSize: MainAxisSize.min,
                            //   children: [
                            //     Text("Time"),
                            //     ListView.builder(
                            //       shrinkWrap: true,
                            //       itemBuilder: ((context, index) {
                            //         return Container(
                            //           height: 150,
                            //           width: 10,
                            //           decoration: BoxDecoration(
                            //             borderRadius: BorderRadius.circular(15),
                            //           ),
                            //         );
                            //       }),
                            //       itemCount: 2,
                            //     )
                            //   ],
                            // ),
                          ],
                        ),
                      ),
                      Text("2"),
                      Text("3"),
                    ]),
                  ),
                ),
              ),
              bottomNavigationBar: SnakeNavigationBar.color(
                behaviour: SnakeBarBehaviour.floating,
                selectedItemColor: Colors.white,
                unselectedItemColor: Colors.black45,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                elevation: 20,
                height: height * 0.1,
                snakeViewColor: primaryColor,
                snakeShape: SnakeShape(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                  centered: true,
                  height: height * 0.07,
                  padding: EdgeInsets.all(height * 0.015),
                ),
                currentIndex: _selectedItemPosition,
                onTap: (index) => setState(() => _selectedItemPosition = index),
                items: const [
                  BottomNavigationBarItem(
                      icon: Icon(
                        Icons.home,
                      ),
                      label: ""),
                  BottomNavigationBarItem(
                      icon: Icon(
                        Icons.message,
                      ),
                      label: ""),
                  BottomNavigationBarItem(
                      icon: Icon(
                        Icons.person,
                      ),
                      label: ""),
                ],
              ),
            );
          } else {
            return LoadingIndicator(
              loadingText: "Bạn chờ pnw xíu nhé",
            );
          }
        },
      ),
    );
  }
}
