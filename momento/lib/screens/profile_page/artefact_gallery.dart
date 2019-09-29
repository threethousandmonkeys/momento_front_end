import "package:flutter/material.dart";
import 'package:momento/bloc/profile_bloc.dart';
import 'package:momento/models/member.dart';
import 'package:momento/screens/add_new_page/add_new_artefact_page.dart';
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
    return StreamBuilder<List<String>>(
      stream: _bloc.getThumbnails,
      initialData: [],
      builder: (context, snapshot) {
        return GridView.count(
          physics: NeverScrollableScrollPhysics(),
          padding: EdgeInsets.only(top: 0),
          crossAxisCount: 3,
          crossAxisSpacing: 1,
          children: _buildGrids(snapshot.data),
        );
      },
    );
  }

  List<Widget> _buildGrids(List<String> urls) {
    List<Widget> grids = urls
        .map(
          (url) => GestureDetector(
            child: FadeInImage.assetNetwork(
              placeholder: "assets/images/loading_image.gif",
              image: url,
              fit: BoxFit.cover,
            ),
          ),
        )
        .toList();
    if (grids.length != 0) {
      grids.add(
        GestureDetector(
          child: Container(
            color: Colors.white38,
            child: Icon(
              Icons.add,
              size: 60,
            ),
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddNewArtefactPage(_bloc.family, _bloc.getLatestMembers),
              ),
            );
          },
        ),
      );
    }
    return grids;
  }

  @override
  bool get wantKeepAlive => true;
}
