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
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return StreamBuilder<List<Artefact>>(
      stream: Provider.of<ProfileBloc>(context).getArtefacts,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          return GridView.count(
            key: PageStorageKey("gallery"),
            crossAxisCount: 3,
            crossAxisSpacing: 2,
            mainAxisSpacing: 2,
            padding: EdgeInsets.all(0.0),
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
                            builder: (context) => AddNewArtefactPage(
                              Provider.of<ProfileBloc>(context).family,
                              Provider.of<ProfileBloc>(context).getLatestMembers,
                            ),
                          ),
                        );
                        if (newArtefact != null) {
                          Provider.of<ProfileBloc>(context).addArtefact(newArtefact);
                        }
                      },
                    ),
                  ),
          );
        } else {
          return Container();
        }
      },
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
