import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pncstaff_mobile_application/blocs/auth/auth_bloc.dart';
import 'package:pncstaff_mobile_application/blocs/search/search_bloc.dart';
import 'package:pncstaff_mobile_application/common/components/elevated_container.dart';
import 'package:pncstaff_mobile_application/common/constants.dart';
import 'package:pncstaff_mobile_application/models/booking.dart';
import 'package:pncstaff_mobile_application/screens/search_screen/search_screen.dart';

class WelcomePanel extends StatefulWidget {
  const WelcomePanel({Key? key, required this.username}) : super(key: key);

  final String username;

  @override
  State<WelcomePanel> createState() => _WelcomePanelState();
}

class _WelcomePanelState extends State<WelcomePanel> {
  TextEditingController _searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    var user = (BlocProvider.of<AuthBloc>(context).state as Authenticated).user;
    return SafeArea(
      child: Stack(
        children: [
          Container(
            height: height * 0.1,
          ),
          Container(
            padding: EdgeInsets.all(10),
            height: height * 0.4,
            width: width,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  primaryColor,
                  lightPrimaryColor,
                ],
                begin: Alignment.bottomRight,
                end: Alignment.topLeft,
              ),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ElevatedContainer(
                      height: height * 0.06,
                      width: width *(1 - 2*smallPadRate - smallPadRate) - height * 0.03,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: TextField(
                          onChanged: (value) => setState(() {}),
                          controller: _searchController,
                          decoration: InputDecoration(
                            // suffixIcon: IconButton(
                            //   onPressed: () {},
                            //   icon: Icon(
                            //     Icons.navigate_next,
                            //     color: _searchController.text.isEmpty
                            //         ? Colors.white
                            //         : primaryColor,
                            //     size: 20,
                            //   ),
                            // ),
                            // prefixIcon: Icon(
                            //   Icons.search,
                            //   color: primaryColor,
                            // ),
                            hintText: "Tìm kiếm theo mã chuồng",
                            hintStyle:
                                TextStyle(color: lightFontColor, fontSize: 16),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      elevation: width * 0.015,
                    ),
                    _searchController.text.isEmpty
                        ? ElevatedContainer(
                          elevation: 5,
                          height: height * 0.06,
                          width: height * 0.06,
                          // decoration: BoxDecoration(
                          //   border: Border.all(
                          //     color: Colors.white,
                          //     width: 2,
                          //   ),
                          //   borderRadius: BorderRadius.circular(50),
                          // ),
                          child: CircleAvatar(
                              radius: height * 0.03,
                              backgroundColor: Colors.white,
                              backgroundImage: NetworkImage(user.url ?? ""),
                              
                            ),
                        )
                        : Container(
                            width: height * 0.05,
                            height: height * 0.05,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: Colors.white.withOpacity(0.7),
                            ),
                            child: IconButton(
                              onPressed: () {
                                var center = (BlocProvider.of<AuthBloc>(context)
                                        .state as Authenticated)
                                    .user
                                    .petCenter;
                                var cageCode = _searchController.text.toUpperCase();
                                BlocProvider.of<SearchBloc>(context)
                                    .add(SearchByCagecode(cageCode, center!.id!));
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => SearchScreen(),
                                ));
                              },
                              icon: Icon(
                                Icons.search,
                                color: primaryColor,
                                size: height * 0.03,
                              ),
                            ),
                          ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
