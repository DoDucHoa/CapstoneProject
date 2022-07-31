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
                            'Chỉnh sửa thông tin đặt lịch',
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
                            'Quay về trang chủ',
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
                  //       child: Text('Chỉnh sửa thông tin đặt lịch'),
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
      result.add('Thú cưng đã được gửi trong thời gian mà bạn chọn');
      result.add(
          'Không thể tiến hành khi thú cưng của bạn đã được gửi đến khách sạn trong thời gian này.');
      return result;
    }
    if (s.contains('startbooking')) {
      result.add('Thời gian bạn chọn không hợp lệ');
      result.add('Vui lòng chắc chắn rằng thời gian bạn chọn là thực tế.');
      return result;
    }
    if (s.contains('no response')) {
      result.add('Không tìm thấy trung tâm phù hợp quanh khu vực của bạn');
      result.add('');
      return result;
    }
    result.add('Đã xảy ra lỗi');
    result.add('Vui Lòng thử lại sau');
    return result;
  }
}
