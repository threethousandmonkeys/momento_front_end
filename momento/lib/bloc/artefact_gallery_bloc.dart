import 'package:momento/models/family.dart';
import 'package:momento/services/cloud_storage_service.dart';

class ArtefactGalleryBloc {
  final _cloudStorageService = CloudStorageService();

  List<String> thumbnails = [];

  Future<Null> init(Family family) async {
    for (String artefactId in family.artefacts) {
      thumbnails
          .add(await _cloudStorageService.getPhoto("${family.id}/artefacts/original/$artefactId"));
    }
  }
}
