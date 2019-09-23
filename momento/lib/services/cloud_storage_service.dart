import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class CloudStorageService {
  final _cloudStorage = FirebaseStorage.instance;

  /// path should conform to the format "rootFolder/.../fileFolder/"
  Future<Null> uploadPhotoAt(String path, String id, File file) async {
    final storageReference = _cloudStorage.ref().child(path + id);
    final uploadTask = storageReference.putFile(file);
    await uploadTask.onComplete;
  }

  Future<dynamic> getPhoto(String path) async {
    return await _cloudStorage.ref().child(path).getDownloadURL();
  }
}
