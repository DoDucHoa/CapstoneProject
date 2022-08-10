import 'package:pawnclaw_mobile_application/models/pet.dart';
import 'package:pawnclaw_mobile_application/models/photo.dart';

abstract class BasePetRepository {
  Future<List<Pet>?> getPetsByCustomer({
    required int customerId,
  });
  Future<bool> createPet(Pet pet);
  Future<bool> update(Pet pet);
  Future<bool> delete(Pet pet);
  Future<bool> updateAvatar(Photo photo);
}
