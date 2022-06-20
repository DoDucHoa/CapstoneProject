import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_snake_navigationbar/flutter_snake_navigationbar.dart';
import 'package:pncstaff_mobile_application/blocs/auth/auth_bloc.dart';
import 'package:pncstaff_mobile_application/blocs/booking/booking_bloc.dart';
import 'package:pncstaff_mobile_application/common/components/elevated_container.dart';
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
              body: NestedScrollView(
                headerSliverBuilder: ((context, value) {
                  var authState = BlocProvider.of<AuthBloc>(context).state;
                  var user = (authState as Authenticated).user;
                  return [
                    SliverAppBar(
                      centerTitle: true,
                      backgroundColor: frameColor,
                      expandedHeight: height * 0.3,
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
                      bottom: PreferredSize(
                        preferredSize: Size(width * 0.85, height * 0.075),
                        child: ElevatedContainer(
                          height: height * 0.06,
                          width: width * 0.85,
                          child: TextField(
                            decoration: InputDecoration(
                              prefixIcon: Icon(
                                Icons.search,
                                color: primaryColor,
                              ),
                              hintText: "Tìm kiếm khách hàng",
                              hintStyle: TextStyle(
                                  color: lightFontColor,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15),
                              border: InputBorder.none,
                            ),
                          ),
                          elevation: width * 0.015,
                        ),
                      ),
                    )
                  ];
                }),
                body: HomeBody(bookings: state.bookings),
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
