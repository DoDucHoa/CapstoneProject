import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pawnclaw_mobile_application/screens/search_screen.dart/SearchScreen.dart';
import 'package:pawnclaw_mobile_application/screens/search_screen.dart/subscreens/choose_pet_screen.dart';

import '../../../blocs/search/search_bloc.dart';
import '../../../common/constants.dart';
import '../../home_screen/HomeScreen.dart';

class SearchFailDialog extends StatelessWidget {
  final String errorMessage;
  // final VoidCallback onPressed;
  const SearchFailDialog(
      {required this.errorMessage,
      // required this.onPressed,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return BlocBuilder<SearchBloc, SearchState>(builder: (context, state) {
      return Scaffold(
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
                          color: disableColor,
                          borderRadius: BorderRadius.circular(65)),
                      child: Icon(
                        Iconsax.chart_fail3,
                        size: 65,
                        color: Colors.white,
                      )),
                  SizedBox(
                    height: width * mediumPadRate,
                  ),
                  Text(
                    transferError(errorMessage)[0],
                    style: TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w700, height: 1.5),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: width * smallPadRate,
                  ),
                  Text(
                    transferError(errorMessage)[1],
                    style: TextStyle(fontSize: 15, height: 1.5),
                    textAlign: TextAlign.justify,
                  ),
                  SizedBox(
                    height: width * mediumPadRate,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        BlocProvider.of<SearchBloc>(context)
                          ..add(BackToPetSelection(
                              (state as SearchFail).requests));
                        // Navigator.of(context).push(MaterialPageRoute(
                        //   builder: (context) => SearchScreen(),
                        // )
                        //     // builder: (_) => BlocProvider.value(
                        //     //       value: BlocProvider.of<SearchBloc>(context),
                        //     //       child: ChoosePetScreen(),
                        //     //     ))
                        //     );
                        // .then((value) => context
                        //     .findRootAncestorStateOfType()!
                        //     .setState(() {}))
                      },
                      style: ElevatedButton.styleFrom(
                          // primary: Cprim,

                          shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      )),
                      child: Container(
                        //width: width * (1 - 2 * regularPadRate),
                        padding: EdgeInsets.symmetric(
                            vertical: width * smallPadRate),
                        child: Center(
                          child: Text(
                            'Ch???nh s???a th??ng tin ?????t l???ch',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                      )),
                  SizedBox(
                    height: width * smallPadRate,
                  ),
                  ElevatedButton(
                      onPressed: () => Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: ((context) => HomeScreen()))),
                      style: ElevatedButton.styleFrom(
                          primary: Colors.white,
                          side: BorderSide(
                            color: primaryColor,
                          ),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15))),
                      child: Container(
                        //width: width*(1 - 2*regularPadRate),
                        padding: EdgeInsets.symmetric(
                          vertical: width * smallPadRate,
                        ),
                        child: Center(
                          child: Text(
                            'Quay v??? trang ch???',
                            style: TextStyle(
                                color: primaryColor,
                                fontSize: 15,
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                      )),
                  // ElevatedButton(
                  //     onPressed: () {

                  //     },
                  //     child: Container(
                  //       width: width * (1 - 2 * regularPadRate),
                  //       child: Text('Ch???nh s???a th??ng tin ?????t l???ch'),
                  //     )),
                  // ElevatedButton(
                  //     onPressed: () => Navigator.of(context).push(
                  //         MaterialPageRoute(builder: ((context) => HomeScreen()))),
                  //     child: Container(
                  //       width: width * (1 - 2 * regularPadRate),
                  //       child: Text(),
                  //     ))
                ],
              ),
            )),
      );
    });
  }

  List<String> transferError(String errorMessage) {
    String s = errorMessage.toLowerCase();
    print(s);
    List<String> result = [];
    if (s.contains('pet') && s.contains('already')) {
      result.add('Th?? c??ng ???? ???????c g???i trong th???i gian m?? b???n ch???n');
      result.add(
          'Kh??ng th??? ti???n h??nh khi th?? c??ng c???a b???n ???? ???????c g???i ?????n kh??ch s???n trong th???i gian n??y.');
      return result;
    }
    if (s.contains('startbooking')) {
      result.add('Th???i gian b???n ch???n kh??ng h???p l???');
      result.add('Vui l??ng ch???c ch???n r???ng th???i gian b???n ch???n l?? th???c t???.');
      return result;
    }
    result.add('???? x???y ra l???i');
    result.add('Vui L??ng th??? l???i sau');
    return result;
  }
}
