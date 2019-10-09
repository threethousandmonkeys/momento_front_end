import "package:flutter/material.dart";
import 'package:momento/bloc/profile_bloc.dart';
import 'package:momento/models/artefact.dart';
import 'package:momento/screens/detail_page/artifact_detail_page.dart';
import 'package:momento/screens/form_pages//add_new_artefact_page.dart';
import 'package:momento/screens/form_pages/update_artefact_page.dart';
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
    _bloc = Provider.of<ProfileBloc>(context);
    return StreamBuilder<List<Artefact>>(
      stream: _bloc.getArtefacts,
      initialData: null,
      builder: (context, snapshot) {
        if (snapshot.data == null) {
          return Text("Loading");
        }
        return GridView.count(
          physics: NeverScrollableScrollPhysics(),
          padding: EdgeInsets.only(top: 0),
          crossAxisCount: 3,
          crossAxisSpacing: 1,
          mainAxisSpacing: 1,
          children: _buildGrids(snapshot.data),
        );
      },
    );
  }

  List<Widget> _buildGrids(List<Artefact> artefacts) {
    List<Widget> grids = artefacts
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
            child: FadeInImage.assetNetwork(
              placeholder: "assets/images/loading_image.gif",
              image: artefact.thumbnail ?? artefact.photo,
              fit: BoxFit.cover,
            ),
          ),
        )
        .toList();
    grids.add(
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
              builder: (context) => AddNewArtefactPage(_bloc.family, _bloc.getLatestMembers),
            ),
          );
          if (newArtefact != null) {
            _bloc.addArtefact(newArtefact);
          }
        },
      ),
    );
    return grids;
  }

  @override
  bool get wantKeepAlive => true;
}
