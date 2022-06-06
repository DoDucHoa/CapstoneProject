import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:pawnclaw_mobile_application/models/booking_create_model.dart';
import 'package:intl/intl.dart';
import 'package:pawnclaw_mobile_application/models/center.dart';
import 'package:pawnclaw_mobile_application/models/pet.dart';

part 'booking_event.dart';
part 'booking_state.dart';

class BookingBloc extends Bloc<BookingEvent, BookingState> {
  BookingBloc() : super(BookingInitial()) {
    on<InitBooking>((event, emit) {
      BookingRequestModel booking = new BookingRequestModel(
        bookingCreateParameter: BookingCreateParameter(
          centerId: event.centerId,
          startBooking:
              DateFormat('yyyy-MM-dd HH:mm:ss').format(event.startBooking),
          endBooking:
              DateFormat('yyyy-MM-dd HH:mm:ss').format(event.endBooking),
          customerId: event.customerId,
          createTime: DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()),
          statusId: 1,
        ),
        bookingDetailCreateParameters: [],
        serviceOrderCreateParameters: [],
        supplyOrderCreateParameters: [],
      );
      emit(BookingUpdated(booking: booking, requests: event.request));
    });
    on<SelectCage>((event, emit) {
      BookingRequestModel booking = (state as BookingUpdated).booking;
      booking.bookingDetailCreateParameters!.add(
        BookingDetailCreateParameters(
          cageCode: event.cageCode,
          price: event.price,
          petId: event.petId,
          duration: DateTime.parse(booking.bookingCreateParameter!.endBooking!)
              .difference(
                  DateTime.parse(booking.bookingCreateParameter!.startBooking!))
              .inHours,
        ),
      );
      emit(BookingUpdated(booking: booking));
    });
    on<SelectSupply>(
      (event, emit) {
        BookingRequestModel booking = (state as BookingUpdated).booking;
        SupplyOrderCreateParameters supplyOrder =
            new SupplyOrderCreateParameters(
                petId: event.petId,
                sellPrice: event.sellPrice,
                totalPrice: event.sellPrice,
                supplyId: event.supplyId,
                quantity: 1);
        bool isExisted = false;
        for (var element in booking.supplyOrderCreateParameters!) {
          if (element.supplyId == supplyOrder.supplyId &&
              element.petId == supplyOrder.petId) {
            element.quantity = element.quantity! + 1;
            element.totalPrice = element.totalPrice! + element.sellPrice!;
            isExisted = true;
            print("Updated");
          }
        }
        if (isExisted == false) {
          booking.supplyOrderCreateParameters!.add(supplyOrder);
          print("Added");
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
            new ServiceOrderCreateParameters(
                sellPrice: price,
                totalPrice: price,
                petId: event.petId,
                serviceId: event.serviceId,
                quantity: 1);
        bool isExisted = false;
        for (var element in booking.serviceOrderCreateParameters!) {
          if (element.serviceId == serviceOrder.serviceId &&
              element.petId == serviceOrder.petId) {
            element.quantity = element.quantity! + 1;
            element.sellPrice = price;
            element.totalPrice = element.totalPrice! + price;
            isExisted = true;
            print("Updated");
          }
        }
        if (isExisted == false) {
          booking.serviceOrderCreateParameters!.add(serviceOrder);
          print("Added");
        }
        emit(BookingUpdated(booking: booking));
      },
    );

    on<SelectRequest>((event, emit){
      BookingRequestModel booking = (state as BookingUpdated).booking;
      print('emit');
      print(event.petId);
      emit(BookingUpdated(booking: booking,selectedPetIds: event.petId));
    } );
    
    
  }
}
