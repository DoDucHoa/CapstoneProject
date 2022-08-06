import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pawnclaw_mobile_application/common/components/primary_button.dart';
import 'package:pawnclaw_mobile_application/common/components/secondary_button.dart';
import 'package:pawnclaw_mobile_application/common/constants.dart';
import 'package:pawnclaw_mobile_application/models/booking.dart';
import 'package:pawnclaw_mobile_application/models/transaction_details.dart';
import 'package:pawnclaw_mobile_application/repositories/transaction/transaction_repository.dart';
import 'package:pawnclaw_mobile_application/screens/transaction_screen/subscreens/transaction_details_screen.dart';

import '../../../models/review.dart';

class ReviewDialog extends StatefulWidget {
  const ReviewDialog({required this.booking, required this.review, Key? key})
      : super(key: key);

  final Review review;
  final Booking booking;

  @override
  State<ReviewDialog> createState() => _ReviewDialogState();
}

class _ReviewDialogState extends State<ReviewDialog> {
  double? rate;
  TextEditingController _feedbackController = TextEditingController();

  @override
  void initState() {
    //rate = widget.review.rating!.toDouble();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    Review review = widget.review;
    bool isReviewed = review.rating != 0;
    if (isReviewed) {
      _feedbackController.text = review.description!;
      rate = review.rating!.toDouble();
    }

    var rateName = [
      "Bạn chưa đánh giá",
      "Chê",
      "Không hài lòng",
      "Bình thường",
      "Hài lòng",
      "Vô cùng hài lòng"
    ];

    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(40), side: BorderSide.none),
      // child: Container(
      //   height: height * 0.5,
      //   padding: EdgeInsets.all(width * regularPadRate),
      //   //margin: EdgeInsets.,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 80,
              width: 80,
              margin: EdgeInsets.all(width * mediumPadRate),
              decoration: BoxDecoration(
                  color: primaryColor, borderRadius: BorderRadius.circular(80)),
              child: Icon(
                Icons.rate_review_rounded,
                color: Colors.white,
                size: 40,
              ),
            ),
            // SizedBox(height: width*mediumPadRate,),
            (isReviewed)
                ? Text(
                    'Đánh giá của bạn',
                    style: TextStyle(
                        fontWeight: FontWeight.w600, height: 1.4, fontSize: 15),
                  )
                : Column(
                    children: [
                      Text(
                        'Trải nghiệm của bạn thế nào?',
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            height: 1.4,
                            fontSize: 15),
                      ),
                      Text(
                        'Hãy góp ý cho trung tâm',
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            height: 1.4,
                            fontSize: 13,
                            color: lightFontColor),
                      ),
                    ],
                  ),
            RatingBar.builder(
              itemBuilder: (context, _) => Icon(
                Iconsax.star1,
                color: primaryColor,
              ),
              onRatingUpdate: (rating) {
                setState(() {
                  rate = rating;
                });
              },
              unratedColor: Colors.blueGrey[200],
              initialRating: review.rating!.toDouble(),
              ignoreGestures: isReviewed,
              itemPadding: EdgeInsets.only(top: width * smallPadRate),
            ),
            Text(
              (rate != null) ? rateName[rate!.toInt()] + "!" : '',
              style: TextStyle(
                  color: (rate != null)
                      ? (rate! > 2)
                          ? (rate! == 3)
                              ? Colors.black
                              : primaryColor
                          : Colors.red
                      : null,
                  fontWeight: FontWeight.w600,
                  height: 1.4),
            ),
            
            Container(
              margin: EdgeInsets.all(width * mediumPadRate),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Đánh giá",
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        height: 1.4,
                        fontSize: 15,
                        color: lightFontColor),
                    // textAlign: TextAlign.left,
                  ),
                  SizedBox(
                  height: width * extraSmallPadRate,
                ),
                  TextField(
                    enabled: (!isReviewed),
                    maxLength: 50,
                    controller: _feedbackController,
                    onChanged: ((value) => setState(() {})),
                    maxLines: 2,
                    minLines: 1,
                    style: TextStyle(
                        //fontWeight: FontWeight.w600,
                        height: 1.4,
                        fontSize: 15,
                        ),
                    decoration: InputDecoration(
                      hintText: 'Viết đánh giá của bạn',
                      hintStyle: TextStyle(
                        fontWeight: FontWeight.w400,
                        height: 1.4,
                        fontSize: 13,
                        color: lightFontColor),
                      border: InputBorder.none,
                      fillColor: Colors.blueGrey.withOpacity(0.05),
                      filled: true,
                      counterText: '${_feedbackController.text.length}/50',
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                              color: Colors.blueGrey[50]!, width: 1.5)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                              color: Colors.blueGrey[50]!, width: 1.5)),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
                  padding:  EdgeInsets.symmetric(horizontal: width*mediumPadRate),
                  child:(isReviewed)
                ?  PrimaryButton(
                      text: 'Đóng',
                      onPressed: () => Navigator.of(context).pop(),
                      contextWidth: width)
                
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                        SecondaryButton(
                            text: 'Đóng',
                            onPressed: () => Navigator.of(context).pop(),
                            contextWidth: width),
                        PrimaryButton(
                            text: 'Gửi đánh giá',
                            onPressed: () async {
                              if (rate == null || rate == 0) {
                                setState(() {
                                  rate = 0;
                                });
                              } else {
                                bool sent = await TransactionRepository()
                                    .sendReview(new Review(
                                        rating: rate!.toInt(),
                                        bookingId: review.bookingId,
                                        description: _feedbackController.text));
                                if (sent) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(
                                              'Cảm ơn ý kiến đóng góp của bạn!')));
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) =>
                                          TransactionDetailsScreen(
                                              booking: widget.booking)));
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(
                                              'Gửi đánh giá không thành công! Vui lòng thử lại sau.')));
                                }
                              }
                            },
                            contextWidth: width)
                      ])),
            SizedBox(
              height: width * mediumPadRate,
            ),
          ],
        ),
      ),
      // ),
    );
  }
}
