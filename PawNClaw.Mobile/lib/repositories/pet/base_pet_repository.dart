import 'package:pawnclaw_mobile_application/models/pet.dart';

abstract class BasePetRepository {
  Future<List<Pet>?> getPetsByCustomer({
    required int customerId,
  });
}
