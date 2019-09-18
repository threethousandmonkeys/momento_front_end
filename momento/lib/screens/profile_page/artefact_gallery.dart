import "package:flutter/material.dart";
import 'package:momento/screens/create_page/create_page.dart';
import 'package:image_picker/image_picker.dart';

class ArtefactGallery extends StatelessWidget {
  List<Widget> thumbnails;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      physics: NeverScrollableScrollPhysics(),
      padding: EdgeInsets.only(top: 0.5),
      crossAxisCount: 3,
      crossAxisSpacing: 1,
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
                      builder: (context) => CreatePage(
                        title: "ARTEFACT",
                        children: <Widget>[
                          FormTextField(
                            title: "Name",
                          ),
                          FormTextField(
                            title: "Date Created",
                          ),
                          FormDropdownField(
                            title: "Original Owner",
                          ),
                          FormDropdownField(
                            title: "Current Owner",
                          ),
                          FormTextField(
                            title: "Description",
                            maxLines: 4,
                          ),
                          MaterialButton(
                            child: Text("Upload Photo"),
                            onPressed: () async {
                              var image = await ImagePicker.pickImage(source: ImageSource.gallery);
                            },
                          ),
                        ],
                      ),
                    ));
              },
            ),
          ],
    );
  }
}
