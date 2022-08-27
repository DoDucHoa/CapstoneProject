import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_snake_navigationbar/flutter_snake_navigationbar.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pncstaff_mobile_application/blocs/auth/auth_bloc.dart';
import 'package:pncstaff_mobile_application/blocs/booking/booking_bloc.dart';
import 'package:pncstaff_mobile_application/common/components/line_indicator.dart';
import 'package:pncstaff_mobile_application/common/components/loading_indicator.dart';
import 'package:pncstaff_mobile_application/common/constants.dart';
import 'package:pncstaff_mobile_application/repositories/booking/booking_repository.dart';
import 'package:pncstaff_mobile_application/screens/profile_screen/profile_screen.dart';

import 'components/welcome_panel.dart';
import 'subscreens/tracking_activities.dart';

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

  static List<Widget> _widgetOptions = <Widget>[
    Container(
      color: frameColor,
      child: TrackingActivities(),
    ),
    // Container(child: Text('Booking list'),),
    ProfileScreen(),
  ];

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
              body: _selectedItemPosition == 0
                  ? DefaultTabController(
                      length: 3,
                      child: NestedScrollView(
                        headerSliverBuilder: ((context, value) {
                          var authState =
                              BlocProvider.of<AuthBloc>(context).state;
                          var user = (authState as Authenticated).user;
                          return [
                            SliverAppBar(
                              centerTitle: true,
                              backgroundColor: frameColor,
                              expandedHeight: height * 0.15,
                              floating: true,
                              pinned: true,
                              collapsedHeight: height * 0.1,
                              flexibleSpace: FlexibleSpaceBar(
                                collapseMode: CollapseMode.pin,
                                background: WelcomePanel(
                                  username: user.name ?? "Staff",
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
                                labelColor: Colors.white,
                                padding: EdgeInsets.all(7),
                                unselectedLabelColor: Colors.white54,
                                labelStyle:
                                    TextStyle(fontWeight: FontWeight.w700),
                                indicator: LineIndicator(
                                    color: Colors.white, radius: width / 5),
                                splashBorderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(10),
                                    bottomRight: Radius.circular(10)),
                              ),
                            )
                          ];
                        }),
                        body: _widgetOptions.elementAt(_selectedItemPosition),
                      ),
                    )
                  : _widgetOptions.elementAt(_selectedItemPosition),
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
                        Iconsax.home5,
                      ),
                      label: ""),
                  // BottomNavigationBarItem(
                  // icon: Icon(
                  //   Iconsax.document_text5,
                  // ),
                  // label: ""),
                  BottomNavigationBarItem(
                      icon: Icon(
                        Icons.person_rounded,
                      ),
                      label: ""),
                ],
              ),
            );
          } else {
            return LoadingIndicator(
              loadingText: "PawNClaw xin chào!",
            );
          }
        },
      ),
    );
  }
}
