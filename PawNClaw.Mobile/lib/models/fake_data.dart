import 'package:pawnclaw_mobile_application/models/pet.dart';
import 'package:pawnclaw_mobile_application/models/review.dart';
import 'package:pawnclaw_mobile_application/models/voucher.dart';

// import 'cage_type.dart';
// import 'cage.dart';

// List<CageTypes> FAKE_CAGETYPES =  [
//   CageType(id: 1, name: 'Size S'),
//   CageType(id: 2, name: 'Size M'),
//   CageType(id: 3, name: 'Size L'),
// ];

// List<Cage> FAKE_CAGES = [
//   Cage(id: 0, name: 'Chuồng VIP size S',cagetype: 1,discount: 10000, price: 100000, imageUrl: 'lib/assets/cage.png', description: 'This is a true fact: I never had a fear of heights until I fell off a roof. If Fantasy Hockey actually lived up to its name, every team would have Henrik Lundqvist and Joffrey Lupul on it. I don\'t need a big house, just a two-floor condo - you could say I have lofty expectations. Do we make money or does money make us? Chezwich. If you wake up with a giant zit, you are really facing your fears when you look in the mirror.'),
//   Cage(id: 1, name: 'Chuồng Guest size S',cagetype: 1,discount: 0, price: 80000, imageUrl: 'lib/assets/cage.png', description: 'This is a true fact: I never had a fear of heights until I fell off a roof. If Fantasy Hockey actually lived up to its name, every team would have Henrik Lundqvist and Joffrey Lupul on it. I don\'t need a big house, just a two-floor condo - you could say I have lofty expectations. Do we make money or does money make us? Chezwich. If you wake up with a giant zit, you are really facing your fears when you look in the mirror.'),
//   Cage(id: 2, name: 'Chuồng VIP size M',cagetype: 2,discount: 0, price: 100000, imageUrl: 'lib/assets/cage.png', description: 'This is a true fact: I never had a fear of heights until I fell off a roof. If Fantasy Hockey actually lived up to its name, every team would have Henrik Lundqvist and Joffrey Lupul on it. I don\'t need a big house, just a two-floor condo - you could say I have lofty expectations. Do we make money or does money make us? Chezwich. If you wake up with a giant zit, you are really facing your fears when you look in the mirror.'),
//   Cage(id: 3, name: 'Chuồng Guest size M',cagetype: 2,discount: 20000, price: 100000, imageUrl: 'lib/assets/cage.png', description: 'This is a true fact: I never had a fear of heights until I fell off a roof. If Fantasy Hockey actually lived up to its name, every team would have Henrik Lundqvist and Joffrey Lupul on it. I don\'t need a big house, just a two-floor condo - you could say I have lofty expectations. Do we make money or does money make us? Chezwich. If you wake up with a giant zit, you are really facing your fears when you look in the mirror.'),
//   Cage(id: 4, name: 'Chuồng VIP size L',cagetype: 3,discount: 0, price: 100000, imageUrl: 'lib/assets/cage.png', description: 'This is a true fact: I never had a fear of heights until I fell off a roof. If Fantasy Hockey actually lived up to its name, every team would have Henrik Lundqvist and Joffrey Lupul on it. I don\'t need a big house, just a two-floor condo - you could say I have lofty expectations. Do we make money or does money make us? Chezwich. If you wake up with a giant zit, you are really facing your fears when you look in the mirror.'),
//   Cage(id: 5, name: 'Chuồng Guest size L',cagetype: 3,discount: 0, price: 100000, imageUrl: 'lib/assets/cage.png', description: 'This is a true fact: I never had a fear of heights until I fell off a roof. If Fantasy Hockey actually lived up to its name, every team would have Henrik Lundqvist and Joffrey Lupul on it. I don\'t need a big house, just a two-floor condo - you could say I have lofty expectations. Do we make money or does money make us? Chezwich. If you wake up with a giant zit, you are really facing your fears when you look in the mirror.'),

// ];

const CAGE_PHOTOS = [
  'lib/assets/cage.png',
  'lib/assets/center0.jpg',
  'lib/assets/cage.png',
  'lib/assets/center0.jpg',
  'lib/assets/cage.png',
  'lib/assets/cage.png',
];

List<Review> FAKE_REVIEWS = [
  Review(
      customerName: 'Alice Smith',
      customerAva: 'lib/assets/cus0.png',
      description: 'A Sudden Warm Rainstorm Washes Down In Sweet Hyphens.',
      rating: 5),
  Review(
      customerName: 'Kelly Smith',
      customerAva: 'lib/assets/cus1.png',
      description: 'A Sudden Warm Rainstorm Washes Down In Sweet Hyphens.',
      rating: 4),
  Review(
      customerName: 'John Smith',
      customerAva: 'lib/assets/cus2.png',
      description: 'A Sudden Warm Rainstorm Washes Down In Sweet Hyphens.',
      rating: 5),
];

List<Voucher> FAKE_VOUCHERS = [
  Voucher(value: 10000, minCondition: 50000, startDate: '1/5/2022', expireDate: '30/5/2022'),
  Voucher(value: 20000, minCondition: 70000, startDate: '1/5/2022', expireDate: '30/5/2022'),
  Voucher(value: 30000, minCondition: 100000, startDate: '1/5/2022', expireDate: '30/5/2022'),
  Voucher(value: 50000, minCondition: 200000, startDate: '1/5/2022', expireDate: '30/5/2022'),
];

List<List<Pet>> FAKE_REQUESTS = [
  [Pet(id: 0, weight: 0.5, name: 'Pet 1'),
   Pet(id: 1, weight: 0.5, name: 'Pet 2',)]
   ,
   [Pet(id: 2, weight: 0.5, name: 'Pet 3'),
    Pet(id: 3, weight: 0.5, name: 'Pet 4',
    ),Pet(id: 4, weight: 0.5, name: 'Pet 5'),],
  // [
  //  Pet(id: 5, weight: 0.5, name: 'Pet 6',)],
  //  [Pet(id: 6, weight: 0.5, name: 'Pet 7'),
  //   Pet(id: 7, weight: 0.5, name: 'Pet 8',),
  //   Pet(id: 8, weight: 0.5, name: 'Pet 9'),
  //   Pet(id: 9, weight: 0.5, name: 'Pet 10'),],
    
];