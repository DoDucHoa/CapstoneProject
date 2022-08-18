import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:pawnclaw_mobile_application/blocs/authentication/auth_bloc.dart';
import 'package:pawnclaw_mobile_application/models/booking.dart';
import 'package:pawnclaw_mobile_application/models/booking_create_model.dart';
import 'package:intl/intl.dart';
import 'package:pawnclaw_mobile_application/models/center.dart';
import 'package:pawnclaw_mobile_application/models/pet.dart';
import 'package:pawnclaw_mobile_application/models/transaction_details.dart';
import 'package:pawnclaw_mobile_application/repositories/booking/booking_repository.dart';

part 'booking_event.dart';
part 'booking_state.dart';

class BookingBloc extends Bloc<BookingEvent, BookingState> {
  BookingBloc() : super(BookingInitial()) {
    on<InitBooking>((event, emit) {
      BookingRequestModel booking = BookingRequestModel(
        bookingCreateParameter: BookingCreateParameter(
            centerId: event.centerId,
            startBooking:
                DateFormat('yyyy-MM-dd HH:mm:ss').format(event.startBooking),
            endBooking:
                DateFormat('yyyy-MM-dd HH:mm:ss').format(event.endBooking),
            customerId: event.customerId,
            createTime:
                DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()),
            statusId: 1,
            due: event.due),
        bookingDetailCreateParameters: [],
        serviceOrderCreateParameters: [],
        supplyOrderCreateParameters: [],
      );
      emit(BookingUpdated(booking: booking, requests: event.request));
    });

    on<ReorderBooking>((event, emit) {
// print('im here');
      BookingRequestModel booking = BookingRequestModel(
        bookingCreateParameter: BookingCreateParameter(
            centerId: event.centerId,
            startBooking:
                DateFormat('yyyy-MM-dd HH:mm:ss').format(event.startBooking),
            endBooking:
                DateFormat('yyyy-MM-dd HH:mm:ss').format(event.endBooking),
            customerId: event.customerId,
            createTime:
                DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()),
            statusId: 1,
            due: event.due),
        bookingDetailCreateParameters: [],
        serviceOrderCreateParameters: [],
        supplyOrderCreateParameters: [],
      );
      print(event.transactionDetails.serviceOrders);
      event.transactionDetails.bookingDetails!.forEach((element) {
        booking.bookingDetailCreateParameters!.add(
            BookingDetailCreateParameters(
                cageCode: element.cageCode,
                petId: element.getPetIds(),
                duration: event.due,
                price: element.price));
      });
      if (event.transactionDetails.serviceOrders != null) {
        event.transactionDetails.serviceOrders!.forEach((serviceOrder) {
          var service = event.center.services!
              .firstWhere((service) => service.id == serviceOrder.serviceId);
          Pet pet = event.transactionDetails
              .getPets()
              .firstWhere((pet) => pet.id == serviceOrder.petId);
          double price = 0;
          service.servicePrices!.forEach((element) {
            if (element.minWeight! <= pet.weight! &&
                element.maxWeight! > pet.weight!) {
              price = element.price!;
            }
          });
          booking.serviceOrderCreateParameters!
              .add(ServiceOrderCreateParameters(
            serviceId: serviceOrder.serviceId,
            quantity: serviceOrder.quantity,
            sellPrice: price,
            totalPrice: price * serviceOrder.quantity!,
            petId: serviceOrder.petId,
          ));
        });
      }
      if (event.transactionDetails.supplyOrders != null) {
        event.transactionDetails.supplyOrders!.forEach((supplyOrder) {
          var supply = event.center.supplies!
              .firstWhere((supply) => supply.id == supplyOrder.supplyId);
          if (supply.quantity! >= supplyOrder.quantity!) {
            booking.supplyOrderCreateParameters!
                .add(SupplyOrderCreateParameters(
              supplyId: supplyOrder.supplyId,
              quantity: supplyOrder.quantity,
              sellPrice: supply.sellPrice!,
              totalPrice: supply.sellPrice! * supplyOrder.quantity!,
              petId: supplyOrder.petId,
            ));
          }
        });
      }

      emit(BookingUpdated(booking: booking, requests: event.request));
    });

    on<SelectCage>((event, emit) {
      BookingRequestModel booking = (state as BookingUpdated).booking;
      BookingDetailCreateParameters details = BookingDetailCreateParameters(
        cageCode: event.cageCode,
        price: event.price,
        petId: event.petId,
        duration: booking.bookingCreateParameter!.due,
      );
      print('ready $event');
      int detectedIndex = booking.isCageSelected(details);
      if (detectedIndex != -1) {
        print('change cage');
        //booking.bookingDetailCreateParameters!.removeAt(detectedIndex);
        //booking.bookingDetailCreateParameters!.forEach((element) {print(element.petId);});
        booking.bookingDetailCreateParameters!.removeWhere(
            (element) => element.petId.toString() == event.petId.toString());

        booking.bookingDetailCreateParameters!.add(details);
      } else {
        print('new cage');
        booking.bookingDetailCreateParameters!.add(details);
      }
      //print(booking.bookingDetailCreateParameters!.last.toJson());
      booking.selectedPetsIds = null;
      emit(BookingUpdated(booking: booking));
    });
    on<SelectSupply>(
      (event, emit) {
        BookingRequestModel booking = (state as BookingUpdated).booking;
        SupplyOrderCreateParameters supplyOrder = SupplyOrderCreateParameters(
            petId: event.petId,
            sellPrice: event.sellPrice,
            totalPrice: event.sellPrice * event.quantity,
            supplyId: event.supplyId,
            quantity: event.quantity);
        if (event.isUpdate != null && event.isUpdate == true) {
          if (event.quantity == 0) {
            booking.supplyOrderCreateParameters!.removeWhere((element) =>
                element.supplyId == event.supplyId &&
                element.petId == event.petId);
          } else {
            booking.supplyOrderCreateParameters!
                .where((element) =>
                    element.petId == event.petId &&
                    element.supplyId == event.supplyId)
                .forEach((element) {
              element.quantity = event.quantity;
              element.totalPrice = event.sellPrice * event.quantity;
            });
          }
        } else {
          bool isExisted = false;
          for (var element in booking.supplyOrderCreateParameters!) {
            if (element.supplyId == supplyOrder.supplyId &&
                element.petId == supplyOrder.petId) {
              element.quantity = element.quantity! + event.quantity;
              element.totalPrice =
                  element.totalPrice! + supplyOrder.totalPrice!;
              isExisted = true;
              print("Updated");
            }
          }
          if (isExisted == false) {
            booking.supplyOrderCreateParameters!.add(supplyOrder);
            print("Added");
          }
        }

        emit(BookingUpdated(booking: booking));
      },
    );
    on<SelectService>(
      (event, emit) {
        List<Pet> pets = [];
        (state as BookingUpdated).requests!.forEach((element) {
          element.forEach((pet) {
            pets.add(pet);
          });
        });
        Pet pet = pets.firstWhere((element) => element.id == event.petId);
        double price = 0;
        event.prices.forEach((element) {
          if (element.minWeight! <= pet.weight! &&
              element.maxWeight! > pet.weight!) {
            price = element.price!;
          }
        });
        print(price);
        BookingRequestModel booking = (state as BookingUpdated).booking;
        ServiceOrderCreateParameters serviceOrder =
            ServiceOrderCreateParameters(
                sellPrice: price,
                totalPrice: price * event.quantity,
                petId: event.petId,
                serviceId: event.serviceId,
                quantity: event.quantity);
        if (event.isUpdate != null && event.isUpdate == true) {
          if (event.quantity == 0) {
            booking.serviceOrderCreateParameters!.removeWhere((element) =>
                element.serviceId == event.serviceId &&
                element.petId == event.petId);
          } else {
            booking.serviceOrderCreateParameters!
                .where((element) =>
                    element.petId == event.petId &&
                    element.serviceId == event.serviceId)
                .forEach((element) {
              element.quantity = event.quantity;
              element.totalPrice = price * event.quantity;
            });
          }
        } else {
          bool isExisted = false;
          for (var element in booking.serviceOrderCreateParameters!) {
            if (element.serviceId == serviceOrder.serviceId &&
                element.petId == serviceOrder.petId) {
              element.quantity = element.quantity! + event.quantity;
              element.sellPrice = price;
              element.totalPrice =
                  element.totalPrice! + serviceOrder.totalPrice!;
              isExisted = true;
              print("Updated");
            }
          }
          if (isExisted == false) {
            booking.serviceOrderCreateParameters!.add(serviceOrder);
            print("Added");
          }
        }

        emit(BookingUpdated(booking: booking));
      },
    );

    on<SelectRequest>((event, emit) {
      BookingRequestModel booking = (state as BookingUpdated).booking;
      booking.selectedPetsIds = event.petId;
      emit(BookingUpdated(booking: booking));
      // print("petid : " +
      //     (state as BookingUpdated).booking.selectedPetsIds.toString());
    });

    on<AddVoucher>((event, emit) {
      BookingRequestModel booking = (state as BookingUpdated).booking;
      print('voucherCode : ' + event.voucherCode);
      booking.bookingCreateParameter!.voucherCode = event.voucherCode;
      emit(BookingUpdated(booking: booking));
      // print('voucherCode add: ' + (state as BookingUpdated).booking.bookingCreateParameter!.voucherCode!);
    });
    on<ConfirmBookingRequest>(
      (event, emit) async {
        var result = await BookingRepository().createBooking(event.booking);
        // if (result == '502') {
        emit(BookingSuccessful(event.booking, event.center));
        // } else {
        //   emit(BookingFailed(result));
        // }
      },
    );
    on<ChangeCage>((event, emit) {
      BookingRequestModel booking = (state as BookingUpdated).booking;
      booking.bookingDetailCreateParameters!.removeWhere(
        (element) => element.petId.toString() == event.replacePetId.toString(),
      );
      booking.bookingDetailCreateParameters!
          .firstWhere(
            (element) => element.cageCode == event.cageCode,
          )
          .petId = event.replacePetId;

      emit(BookingUpdated(booking: booking));
    });
  }
}
