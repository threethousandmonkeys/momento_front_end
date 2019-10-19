import 'package:extended_image/extended_image.dart';
import "package:flutter/material.dart";
import 'package:momento/bloc/profile_bloc.dart';
import 'package:momento/models/artefact.dart';
import 'package:momento/screens/detail_page/artifact_detail_page.dart';
import 'package:momento/screens/form_pages//add_new_artefact_page.dart';
import 'package:provider/provider.dart';

const kTextColor = Color(0xFF1F275F);

/// ArtefactGallery: Instagram style of artifacts display under home page
/// (testing)
class ArtefactGallery extends StatefulWidget {
  @override
  _ArtefactGalleryState createState() => _ArtefactGalleryState();
}

class _ArtefactGalleryState extends State<ArtefactGallery> with AutomaticKeepAliveClientMixin {
  List<Artefact> currentArtefacts;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: false,
      child: StreamBuilder<List<Artefact>>(
        stream: Provider.of<ProfileBloc>(context).getArtefacts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            if (currentArtefacts == snapshot.data) {}
            return GridView.count(
              physics: ClampingScrollPhysics(),
              key: PageStorageKey("gallery"),
              crossAxisCount: 3,
              crossAxisSpacing: 2,
              mainAxisSpacing: 2,
              padding: EdgeInsets.all(0.0),
              children: _buildGrids(context, snapshot.data),
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }

  List<Widget> _buildGrids(BuildContext context, List<Artefact> artefacts) {
    return artefacts
        .map(
          (artefact) => Container(child: Thumbnail(artefact)),
        )
        .toList()
          ..add(
            Container(
              child: GestureDetector(
                child: Container(
                  child: Icon(
                    Icons.add,
                    size: 60,
                    color: kTextColor,
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
  }

  @override
  bool get wantKeepAlive => true;
}

class Thumbnail extends StatefulWidget {
  final Artefact artefact;
  Thumbnail(this.artefact);
  @override
  _ThumbnailState createState() => _ThumbnailState();
}

class _ThumbnailState extends State<Thumbnail> {
  Color theme = Colors.white;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        setState(() {
          theme = Colors.black26;
        });
      },
      onTapCancel: () {
        setState(() {
          theme = Colors.white;
        });
      },
      onTapUp: (_) {
        setState(() {
          theme = Colors.white;
        });
      },
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ArtefactDetailPage(widget.artefact),
          ),
        );
      },
      child: ExtendedImage.network(
        widget.artefact.thumbnail ?? widget.artefact.photo,
        fit: BoxFit.cover,
        cache: true,
        color: theme,
        colorBlendMode: BlendMode.darken,
      ),
    );
  }
}
