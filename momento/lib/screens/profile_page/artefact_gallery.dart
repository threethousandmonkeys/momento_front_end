import "package:flutter/material.dart";
import 'package:momento/screens/add_new_page/add_new_artefact_page.dart';

/// ArtefactGallery: Instagram style of artifacts display under home page
/// (testing)
class ArtefactGallery extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GridView.count(
      physics: NeverScrollableScrollPhysics(),
      padding: EdgeInsets.only(top: 0.5),
      crossAxisCount: 3,
      crossAxisSpacing: 1,

      /// display of artifacts(not connect to backend)
      children: List.generate(
            10,
            (index) {
              return GestureDetector(
                onTap: () {
                  print("tapped");
                },
                child: Image.asset(
                  "assets/images/test_artefact${index + 1}.jpg",
                  fit: BoxFit.cover,
                ),
              );
            },
          ) +

          /// add new button at the back of all existing artifacts
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
                    builder: (context) => AddNewArtefactPage(),
                  ),
                );
              },
            ),
          ],
    );
  }
}
