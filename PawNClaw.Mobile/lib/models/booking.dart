// import 'package:pawnclaw_mobile_application/models/center.dart';
// import 'package:pawnclaw_mobile_application/models/pet.dart';

// class BookingInformation {
//   List<Map<Pet, List<Supplies>>> supplyOrder;
//   List<Map<Pet, List<Services>>> serviceOrder;
//   List<Map<CageTypes, List<Pet>>> cageOrder;
//   double discountValue;
//   double total;
//   DateTime checkIn;
//   DateTime checkOut;

//   BookingInformation(
//     this.supplyOrder,
//     this.serviceOrder,
//     this.cageOrder,
//     this.discountValue,
//     this.total,
//     this.checkIn,
//     this.checkOut,
//   );

//   double _getTotal(
//       List<Map<Pet, List<Supplies>>> supplies,
//       List<Map<Pet, List<Services>>> services,
//       List<Map<CageTypes, List<Pet>>> cages,
//       double discount) {
//     double supplyTotal = 0;
//     double serviceTotal = 0;
//     double cageTotal = 0;
//     supplies.forEach((element) {
//       element.values.forEach((supplies) {
//         supplies.forEach((supply) {
//           supplyTotal += supply.sellPrice!;
//         });
//       });
//     });
//     services.forEach((element) {
//       element.values.forEach((services) {
//         services.forEach((service) {
//           serviceTotal += service.sellPrice!;
//         });
//       });
//     });
//     // cages.forEach((element) {element.keys})
//   }
// }
