import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_snake_navigationbar/flutter_snake_navigationbar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pawnclaw_mobile_application/blocs/authentication/auth_bloc.dart';
import 'package:pawnclaw_mobile_application/common/components/elevated_container.dart';
import 'package:pawnclaw_mobile_application/common/components/loading_indicator.dart';
import 'package:pawnclaw_mobile_application/common/constants.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pawnclaw_mobile_application/screens/profile_screen/profile_screen.dart';
import 'package:pawnclaw_mobile_application/screens/search_by_name_screen/search_by_name_screen.dart';

import '../search_by_name_screen/search_by_name_screen.dart';
import 'components/home_body.dart';
import 'components/welcome_panel.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedItemPosition = 0;
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    print(height);
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is Authenticated) {
          return Scaffold(
            backgroundColor: backgroundColor,
            resizeToAvoidBottomInset: true,
            body: NestedScrollView(
                headerSliverBuilder: (context, value) {
                  return [
                    SliverAppBar(
                      elevation: 5,
                      floating: true,
                      backgroundColor: primaryColor.withOpacity(0.3),
                      shadowColor: primaryColor.withOpacity(0.2),
                      expandedHeight: height * 0.3,
                      pinned: true,
                      leading: Container(),
                      flexibleSpace: FlexibleSpaceBar(
                        collapseMode: CollapseMode.pin,
                        background: WelcomePanel(
                          username: state.user.name!,
                        ),
                      ),
                      centerTitle: false,
                      bottom: PreferredSize(
                        preferredSize: Size(width * 0.6, height * 0.09),
                        child: Container(
                          padding: EdgeInsets.only(bottom: 10),
                          child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                  primary: Colors.white,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(50))),
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => SearchScreen()));

                                // showSearch(
                                //     context: context,
                                //     delegate: CustomerSearchDelegate());
                              },
                              icon: Icon(
                                Icons.search_rounded,
                                color: primaryColor,
                              ),
                              label: Container(
                                  margin: EdgeInsets.fromLTRB(0, 12, 24, 12),
                                  child: Text(
                                    'Tìm kiếm trung tâm thú cưng',
                                    style: TextStyle(
                                        color: lightFontColor.withOpacity(0.3)),
                                  ))),
                        ),
                      ),
                    )
                  ];
                },
                body: const HomeBody()),
            // body: SingleChildScrollView(
            //   child: Column(
            //     mainAxisAlignment: MainAxisAlignment.start,
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     children: [
            //       WelcomePanel(username: state.user.name!),
            //       const HomeBody(),
            //     ],
            //   ),
            // ),
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
              onTap: (index) {
                setState(() => _selectedItemPosition = index);
                switch (index){
                  case 0: Navigator.of(context).push(MaterialPageRoute(builder: (context) => const HomeScreen()));
                  break;
                  case 1: Navigator.of(context).push(MaterialPageRoute(builder: (context) => const HomeScreen()));
                  break;
                  case 2: Navigator.of(context).push(MaterialPageRoute(builder: (context) => const ProfileScreen()));
                  break;
                }
              },
              items: const [
                BottomNavigationBarItem(
                    icon: Icon(
                      Iconsax.home5,
                    ),
                    label: ""),
                BottomNavigationBarItem(
                    icon: Icon(
                      Iconsax.message5,
                    ),
                    label: ""),
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.person_rounded,
                    ),
                    label: ""),
              ],
            ),
          );
        }
        return LoadingIndicator(
          loadingText: "PawNClaw xin chào!",
        );
      },
    );
  }
}

class CustomerSearchDelegate extends SearchDelegate {
  List<String> searchResults = ['Dogily', 'Lazy dog', 'vetery'];

  @override
  List<Widget>? buildActions(BuildContext context) => [
        IconButton(
            onPressed: () {
              if (query.isEmpty) {
                close(context, null);
              } else {
                query = '';
              }
            },
            icon: const Icon(Icons.clear_outlined))
      ];

  @override
  Widget? buildLeading(BuildContext context) => IconButton(
      onPressed: () => close(context, null),
      icon: const Icon(Icons.arrow_back_ios_new_rounded));

  @override
  Widget buildResults(BuildContext context) => Center(
        child: Text(query),
      );

  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> suggestions = [];
    if (query.isEmpty)
      suggestions = searchResults;
    else {
      suggestions = searchResults.where((searchResult) {
        final result = searchResult.toLowerCase();
        final input = query.toLowerCase();
        return result.contains(input);
      }).toList();
    }

    // ['Dogily', 'Lazy dog', 'vetery'];

    return ListView.builder(
      itemBuilder: (context, index) {
        final suggestion = suggestions[index];
        return ListTile(
          title: Text(suggestion),
          onTap: () {
            query = suggestion;
            showResults(context);
          },
        );
      },
      itemCount: suggestions.length,
    );
  }
}
