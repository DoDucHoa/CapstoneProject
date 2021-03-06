import 'dart:io';
import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class FirebaseUpload {
  Future<String?> pickFile(String destination, bool isCamera) async {
    final ImagePicker _picker = ImagePicker();
    XFile? result = await _picker.pickImage(
      source: isCamera ? ImageSource.camera : ImageSource.gallery,
    );
    if (result != null) {
      File file = File(result.path);
      print(file.path);
      destination = "$destination/${file.path.split('/').last}";
      final ref = FirebaseStorage.instance.ref(destination);
      var resultUrl = await (await ref.putFile(file)).ref.getDownloadURL();
      print(resultUrl);
      return resultUrl;
    } else {
      // User canceled the picker
      print("Upload failed");
      return null;
    }
  }
}
