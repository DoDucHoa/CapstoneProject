import 'package:flutter/material.dart';
import 'package:pncstaff_mobile_application/common/constants.dart';
import 'package:pncstaff_mobile_application/common/services/upload_service.dart';
import 'package:pncstaff_mobile_application/models/activity_request_model.dart';
import 'package:pncstaff_mobile_application/models/booking_detail.dart';
import 'package:pncstaff_mobile_application/models/pet.dart';
import 'package:pncstaff_mobile_application/repositories/activity/activity_repository.dart';
import 'package:pncstaff_mobile_application/screens/activity_screen/booking_activity.dart';
import 'package:pncstaff_mobile_application/screens/activity_screen/components/pet_card.dart';
import 'package:intl/intl.dart';

class ActivityDetail extends StatefulWidget {
  const ActivityDetail({required this.pet, this.service, this.supply, Key? key})
      : super(key: key);

  final SupplyOrders? supply;
  final ServiceOrders? service;
  final Pet pet;

  @override
  State<ActivityDetail> createState() => _ActivityDetailState();
}

class _ActivityDetailState extends State<ActivityDetail> {
  String? imageUrl;
  @override
  Widget build(BuildContext context) {
    var supply = widget.supply;
    var service = widget.service;
    var pet = widget.pet;
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text(
          "Cập nhật hoạt động",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: primaryFontColor,
          ),
        ),
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: primaryFontColor,
          ),
        ),
        backgroundColor: backgroundColor,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(width * smallPadRate),
              child: Text(
                "Thú cưng",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: lightFontColor,
                ),
              ),
            ),
            PetCard(pet: widget.pet),
            Padding(
              padding: EdgeInsets.all(width * smallPadRate),
              child: Text(
                "${widget.supply != null ? "Đồ dùng" : "Dịch vụ"}",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: lightFontColor,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                right: width * smallPadRate,
                left: width * smallPadRate,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(children: [
                Container(
                  margin: EdgeInsets.all(width * extraSmallPadRate + 5),
                  height: 55,
                  child: ClipRRect(
                    child: Image.asset("lib/assets/vet-ava.png"),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${widget.supply?.supply?.name ?? widget.service?.service?.description}",
                      style: TextStyle(
                          color: primaryFontColor,
                          fontSize: 15,
                          fontWeight: FontWeight.w700),
                    ),
                    Text(
                      "${widget.supply?.note ?? widget.service?.note ?? "không có chú thích"}",
                      style: TextStyle(
                          color: lightFontColor,
                          fontSize: 13,
                          fontWeight: FontWeight.w600),
                    ),
                  ],
                )
              ]),
            ),
            Padding(
              padding: EdgeInsets.all(width * smallPadRate),
              child: Text(
                "Bằng chứng",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: lightFontColor,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                  onTap: () async {
                    var resultUrl = await FirebaseUpload().pickFile(
                        "booking/${supply != null ? supply.bookingId : service!.bookingId}");
                    setState(() {
                      imageUrl = resultUrl;
                    });
                  },
                  child: Container(
                    height: height * 0.18,
                    width: height * 0.18,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15)),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            margin:
                                EdgeInsets.symmetric(vertical: width * 0.05),
                            child: Icon(
                              Icons.camera_alt_rounded,
                              size: width * 0.15,
                              color: primaryColor,
                            ),
                          ),
                          Text(
                            "Mở máy ảnh",
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: width * regularFontRate,
                              color: lightFontColor,
                            ),
                          ),
                        ]),
                  ),
                ),
                Container(
                  height: height * 0.18,
                  width: height * 0.18,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15)),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          margin: EdgeInsets.symmetric(vertical: width * 0.05),
                          child: Icon(
                            Icons.file_upload_outlined,
                            size: width * 0.15,
                            color: primaryColor,
                          ),
                        ),
                        Text(
                          "Tải ảnh lên",
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: width * regularFontRate,
                            color: lightFontColor,
                          ),
                        ),
                      ]),
                ),
              ],
            ),
            Container(
              padding: EdgeInsets.all(width * mediumPadRate),
              alignment: Alignment.bottomCenter,
              child: Column(
                children: [
                  Center(
                    child: Text(
                      imageUrl == null
                          ? "*Tải ảnh lên trước khi gửi bằng chứng"
                          : "Ảnh đã được tải lên!",
                      style: TextStyle(
                        color: primaryColor,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                  Opacity(
                    opacity: imageUrl == null ? 0.5 : 1,
                    child: ElevatedButton(
                      onPressed: imageUrl != null
                          ? () async {
                              ActivityRequestModel activity =
                                  ActivityRequestModel(
                                createBookingActivityParameter:
                                    CreateBookingActivityParameter(
                                  bookingId:
                                      supply?.bookingId ?? service?.bookingId,
                                  description:
                                      "Cung cấp ${supply?.supply?.name ?? service?.service?.description}",
                                  provideTime: DateFormat('yyyy-MM-dd HH:mm:ss')
                                      .format(DateTime.now()),
                                  serviceId: service?.service?.id,
                                  supplyId: supply?.supply?.id,
                                  petId: pet.id,
                                ),
                                createPhotoParameter: CreatePhotoParameter(
                                  photoTypeId: 11,
                                  url: imageUrl,
                                ),
                              );
                              String? result = await ActivityRepository()
                                  .addNewActivity(activity);
                              print(result);
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => BookingActivityScreen(
                                    bookingId: supply?.bookingId ??
                                        service?.bookingId),
                              ));
                            }
                          : () {},
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      )),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: width * extraSmallPadRate,
                          horizontal: width * regularPadRate,
                        ),
                        child: Text(
                          "Gửi bằng chứng",
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
