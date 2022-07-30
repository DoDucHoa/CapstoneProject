import 'package:pawnclaw_mobile_application/models/pet.dart';

abstract class BasePetRepository {
  Future<List<Pet>?> getPetsByCustomer({
    required int customerId,
  });
  Future<bool> createPet(Pet pet);
  Future<bool> update(Pet pet);
}
