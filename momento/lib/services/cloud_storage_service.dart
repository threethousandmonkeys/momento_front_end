import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';

class CloudStorageService {
  final _cloudStorage = FirebaseStorage.instance;

  /// path should conform to the format "rootFolder/.../fileFolder/"
  Future<String> uploadPhotoAt(String path, String id, File file) async {
    final storageReference = _cloudStorage.ref().child(path + id);
    final type = extension(file.path) == "" ? "" : extension(file.path).substring(1);
    final uploadTask = storageReference.putFile(file, StorageMetadata(contentType: "image/$type"));
    final downloadUrl = await uploadTask.onComplete;
    final url = await downloadUrl.ref.getDownloadURL();
    return url;
  }

  Future<dynamic> getPhoto(String path) async {
    String url;
    try {
      url = await _cloudStorage.ref().child(path).getDownloadURL();
    } catch (e) {
      return null;
    }
    return url;
  }

  Future<Null> deletePhoto(String url) async {
    final storageReference = await _cloudStorage.getReferenceFromUrl(url);
    if (storageReference != null) {
      storageReference.delete();
    }
  }
}
