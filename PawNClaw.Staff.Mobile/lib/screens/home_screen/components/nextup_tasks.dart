import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pncstaff_mobile_application/blocs/booking/booking_bloc.dart';
import 'package:pncstaff_mobile_application/common/constants.dart';
import 'package:pncstaff_mobile_application/models/booking_detail.dart';
import 'package:pncstaff_mobile_application/models/pet.dart';
import 'package:pncstaff_mobile_application/screens/activity_screen/components/activity_card.dart';
import 'package:pncstaff_mobile_application/screens/activity_screen/subscreens/activity_detail.dart';

class NextUpTasks extends StatefulWidget {
  const NextUpTasks({required this.bookings, Key? key}) : super(key: key);
  final List<BookingDetail> bookings;
  @override
  State<NextUpTasks> createState() => _NextUpTasksState();
}

class _NextUpTasksState extends State<NextUpTasks> {
  List<SupplyOrders> getPetForSupplies(
      BookingDetail booking, List<SupplyOrders> supplies) {
    List<Pet> pets = [];
    booking.bookingDetails!.forEach(
      (cage) => cage.petBookingDetails!.forEach(
        (pet) {
          pets.add(pet.pet!);
        },
      ),
    );
    supplies.forEach(
      (supply) {
        pets.forEach((pet) {
          if (pet.id == supply.petId) {
            supply.pet = pet;
          }
        });
      },
    );
    return supplies;
  }

  List<ServiceOrders> getPetForServices(
      BookingDetail booking, List<ServiceOrders> services) {
    List<Pet> pets = [];
    booking.bookingDetails!.forEach(
      (cage) => cage.petBookingDetails!.forEach(
        (pet) {
          pets.add(pet.pet!);
        },
      ),
    );
    services.forEach(
      (service) {
        pets.forEach((pet) {
          if (pet.id == service.petId) {
            service.pet = pet;
          }
        });
      },
    );
    return services;
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    var bookings = widget.bookings;
    return SingleChildScrollView(
      padding: EdgeInsets.all(width * smallPadRate),
      child: (bookings
                  .firstWhere(
                      (element) =>
                          element.getUndoneSupplyAct().isNotEmpty ||
                          element.getUndoneServiceAct().isNotEmpty,
                      orElse: () => BookingDetail(id: -1))
                  .id !=
              -1)
          ? ListView.builder(
              padding: EdgeInsets.zero,
              physics: ClampingScrollPhysics(),
              shrinkWrap: true,
              itemCount: bookings.length,
              itemBuilder: (context, index) {
                return (bookings[index].getUndoneServiceAct().isNotEmpty ||
                        bookings[index].getUndoneSupplyAct().isNotEmpty)
                    ? Container(
                        margin: EdgeInsets.only(bottom: width * smallPadRate),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: (bookings[index]
                                              .customer!
                                              .idNavigation!
                                              .photo ==
                                          null)
                                      ? CircleAvatar(
                                          radius: height * 0.04,
                                          backgroundColor:
                                              primaryBackgroundColor,
                                          backgroundImage:
                                              AssetImage('lib/assets/cus0.png'),
                                        )
                                      : CircleAvatar(
                                          radius: height * 0.04,
                                          backgroundColor: frameColor,
                                          backgroundImage: NetworkImage(
                                            bookings[index]
                                                .customer!
                                                .idNavigation!
                                                .photo!
                                                .url!,
                                          ),
                                        ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: Text(
                                    bookings[index].customer!.name!,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    color: lightFontColor,
                                    height: 1,
                                  ),
                                )
                              ],
                            ),
                            ListView.builder(
                                padding: EdgeInsets.zero,
                                physics: ClampingScrollPhysics(),
                                shrinkWrap: true,
                                itemCount:
                                    bookings[index].getUndoneSupplyAct().length,
                                itemBuilder: (context, supIndex) {
                                  List<SupplyOrders> supplies =
                                      getPetForSupplies(bookings[index],
                                          bookings[index].getUndoneSupplyAct());
                                  return Padding(
                                    padding: EdgeInsets.only(
                                        left: width * regularPadRate),
                                    child: InkWell(
                                      onTap: () => Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (_) =>
                                                  BlocProvider.value(
                                                      value: BlocProvider.of<
                                                          BookingBloc>(context),
                                                      child: ActivityDetail(
                                                        pet: supplies[supIndex]
                                                            .pet!,
                                                        supply:
                                                            supplies[supIndex],
                                                        booking:
                                                            bookings[index],
                                                      )))),
                                      child: ActivityCard(
                                          photo:
                                              "${supplies[supIndex].supply!.photos?.first.url}",
                                          activityName:
                                              "${supplies[supIndex].supply!.name}",
                                          note: "${supplies[supIndex].note}",
                                          pet: supplies[supIndex].pet!,
                                          // Pet(
                                          //     breedName: "Scottish Straight Cat",
                                          //     name: "Alice"),
                                          booking: bookings[index],
                                          remainCount: 1),
                                    ),
                                  );
                                }),
                            ListView.builder(
                                padding: EdgeInsets.zero,
                                physics: ClampingScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: bookings[index]
                                    .getUndoneServiceAct()
                                    .length,
                                itemBuilder: (context, serIndex) {
                                  List<ServiceOrders> services =
                                      getPetForServices(
                                          bookings[index],
                                          bookings[index]
                                              .getUndoneServiceAct());
                                  return Padding(
                                    padding: EdgeInsets.only(
                                        left: width * regularPadRate),
                                    child: InkWell(
                                      onTap: () => Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (_) =>
                                                  BlocProvider.value(
                                                      value: BlocProvider.of<
                                                          BookingBloc>(context),
                                                      child: ActivityDetail(
                                                        pet: services[serIndex]
                                                            .pet!,
                                                        service:
                                                            services[serIndex],
                                                        booking:
                                                            bookings[index],
                                                      )))),
                                      child: ActivityCard(
                                          photo:
                                              "${services[serIndex].service!.photos?.first.url}",
                                          activityName:
                                              "${services[serIndex].service!.description}",
                                          note: "${services[serIndex].note}",
                                          pet: services[serIndex].pet!,
                                          // Pet(
                                          //     breedName: "Scottish Straight Cat",
                                          //     name: "Alice"),
                                          booking: bookings[index],
                                          remainCount: 1),
                                    ),
                                  );
                                }),
                          ],
                        ),
                      )
                    : Container();
              },
            )
          : Center(
              child: Text(
                "Không còn dịch vụ hay vật dụng nào chưa cung cấp.",
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            ),
    );
  }
}
