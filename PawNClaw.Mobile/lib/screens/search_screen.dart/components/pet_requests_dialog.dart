import 'package:flutter/material.dart';
import 'package:pawnclaw_mobile_application/common/constants.dart';
import 'package:pawnclaw_mobile_application/models/pet.dart';

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
                    return SizedBox(
                      width: width * 0.5,
                      height: width * 0.2,
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: const ScrollPhysics(),
                        itemCount: widget.requests[requestIndex].length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: ((context, index) {
                          // return Text("data");
                          return SelectedPetBubble(
                              width: width,
                              pet: widget.requests[requestIndex][index]);
                        }),
                      ),
                    );
                  }),
              const Spacer(),
              Text(
                "*Lưu ý: những em thú cưng thuộc về cùng yêu cầu sẽ được xếp chung một chuồng.",
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  color: primaryColor,
                ),
              )
            ],
          )),
    );
  }
}