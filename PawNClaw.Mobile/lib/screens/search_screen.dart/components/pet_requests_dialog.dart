import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pawnclaw_mobile_application/common/constants.dart';
import 'package:pawnclaw_mobile_application/models/pet.dart';

import '../../../blocs/search/search_bloc.dart';
import '../../../common/components/primary_icon_button.dart';
import 'pet_bubble.dart';

class PetRequestsDialog extends StatefulWidget {
  const PetRequestsDialog({Key? key, required this.requests}) : super(key: key);

  final List<List<Pet>> requests;

  @override
  State<PetRequestsDialog> createState() => _PetRequestsDialogState();
}

class _PetRequestsDialogState extends State<PetRequestsDialog> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(40),
        side: BorderSide.none,
      ),
      child: Container(
          padding: EdgeInsets.all(width * smallPadRate),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(40),
            color: Colors.white,
          ),
          height: height * 0.7,
          width: width * 0.7,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "Yêu cầu của bạn",
                style: TextStyle(
                  fontSize: width * regularFontRate,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              ListView.builder(
                  shrinkWrap: true,
                  itemCount: widget.requests.length,
                  itemBuilder: (context, requestIndex) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Phòng ${requestIndex + 1}',
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: lightFontColor),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: width * 0.55,
                              height: width * 0.25,
                              child: ListView.builder(
                                shrinkWrap: true,
                                physics: const ScrollPhysics(),
                                itemCount: widget.requests[requestIndex].length,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: ((context, index) {
                                  // return Text("data");
                                  return Row(
                                    // crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      SelectedPetBubble(
                                          width: width,
                                          pet: widget.requests[requestIndex]
                                              [index]),
                                    ],
                                  );
                                }),
                              ),
                            ),
                            PrimaryIconButton(
                                icon: Icons.delete_forever_outlined,
                                color: Colors.red.withOpacity(0.8),
                                onPressed: () {
                                  BlocProvider.of<SearchBloc>(context).add(
                                      RemovePetRequest(
                                          widget.requests[requestIndex]));
                                  //Navigator.pop(context);
                                  setState(() {});
                                  if (widget.requests.length == 1) {
                                    Navigator.pop(context);
                                  }
                                }),
                          ],
                        ),
                      ],
                    );
                  }),
              const Spacer(),
              ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 15),
                    child: Center(
                      child: Text(
                        "ĐÓNG",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  )),
              SizedBox(
                height: 20,
              ),
              Text(
                "*Lưu ý: những em thú cưng thuộc về cùng yêu cầu sẽ được xếp chung một chuồng.",
                style: TextStyle(
                    fontStyle: FontStyle.italic,
                    color: primaryColor,
                    fontSize: 11),
              )
            ],
          )),
    );
  }
}
