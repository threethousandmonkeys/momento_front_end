import "package:flutter/material.dart";
import 'package:momento/bloc/artefact_gallery_bloc.dart';
import 'package:momento/models/family.dart';
import 'package:momento/models/member.dart';
import 'package:momento/screens/add_new_page/add_new_artefact_page.dart';
import 'package:momento/screens/components/loading_page.dart';

/// ArtefactGallery: Instagram style of artifacts display under home page
/// (testing)
class ArtefactGallery extends StatefulWidget {
  final Family family;
  final List<Member> members;
  ArtefactGallery(this.family, this.members);
  @override
  _ArtefactGalleryState createState() => _ArtefactGalleryState();
}

class _ArtefactGalleryState extends State<ArtefactGallery> {
  final _bloc = ArtefactGalleryBloc();
  Future<Null> _futureGallery;

  @override
  void initState() {
    _futureGallery = _bloc.init(widget.family);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Null>(
      future: _futureGallery,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return GridView.count(
            physics: NeverScrollableScrollPhysics(),
            padding: EdgeInsets.only(top: 0),
            crossAxisCount: 3,
            crossAxisSpacing: 1,
            children: _bloc.thumbnails
                    .map(
                      (url) => GestureDetector(
                        child: Image.network(
                          url,
                          fit: BoxFit.cover,
                        ),
                      ),
                    )
                    .toList() +
                [
                  GestureDetector(
                    child: Icon(
                      Icons.add,
                      size: 60,
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddNewArtefactPage(widget.family, widget.members),
                        ),
                      );
                    },
                  ),
                ],
          );
        } else {
          return LoadingPage();
        }
      },
    );
  }
}
