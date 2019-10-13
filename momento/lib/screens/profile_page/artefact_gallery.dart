import 'package:cached_network_image/cached_network_image.dart';
import "package:flutter/material.dart";
import 'package:momento/bloc/profile_bloc.dart';
import 'package:momento/models/artefact.dart';
import 'package:momento/screens/detail_page/artifact_detail_page.dart';
import 'package:momento/screens/form_pages//add_new_artefact_page.dart';
import 'package:provider/provider.dart';

/// ArtefactGallery: Instagram style of artifacts display under home page
/// (testing)
class ArtefactGallery extends StatefulWidget {
  @override
  _ArtefactGalleryState createState() => _ArtefactGalleryState();
}

class _ArtefactGalleryState extends State<ArtefactGallery> with AutomaticKeepAliveClientMixin {
  ProfileBloc _bloc;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (_bloc == null) {
      _bloc = Provider.of<ProfileBloc>(context);
    }
    return StreamBuilder<List<Artefact>>(
      stream: _bloc.getArtefacts,
      initialData: [],
      builder: (context, snapshot) {
        return GridView.count(
          key: PageStorageKey("gallery"),
          padding: EdgeInsets.only(top: 0),
          crossAxisCount: 3,
          crossAxisSpacing: 2,
          mainAxisSpacing: 2,
          children: snapshot.data
              .map(
                (artefact) => GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ArtefactDetailPage(artefact),
                      ),
                    );
                  },
                  child: CachedNetworkImage(
                    imageUrl: artefact.thumbnail ?? artefact.photo,
                    fit: BoxFit.cover,
                  ),
                ),
              )
              .toList()
                ..add(
                  GestureDetector(
                    child: Container(
                      color: Colors.white,
                      child: Icon(
                        Icons.add,
                        size: 60,
                      ),
                    ),
                    onTap: () async {
                      final newArtefact = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              AddNewArtefactPage(_bloc.family, _bloc.getLatestMembers),
                        ),
                      );
                      if (newArtefact != null) {
                        _bloc.addArtefact(newArtefact);
                      }
                    },
                  ),
                ),
        );
      },
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
