import "package:flutter/material.dart";

class ArtefactGallery extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GridView.count(
      physics: NeverScrollableScrollPhysics(),
      padding: EdgeInsets.only(top: 0.5),
      crossAxisCount: 3,
      crossAxisSpacing: 1,
      children: List.generate(10, (index) {
        return Image.asset(
          "assets/images/test_artefact${index + 1}.jpg",
          fit: BoxFit.cover,
        );
      }),
    );
  }
}
