import 'package:flutter/material.dart';
import 'package:momento/constants.dart';
import 'package:momento/screens/components/ugly_button.dart';
import 'package:image_picker/image_picker.dart';
import 'components/form_text_field.dart';
import 'components/form_drop_down_field.dart';
import 'components/form_date_field.dart';

class AddNewArtefactPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double horizontalPadding = MediaQuery.of(context).size.width * 0.1;
    return Scaffold(
      body: Container(
        decoration: kBackgroundDecoration,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: ListView(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 50.0, bottom: 20),
                child: Center(
                  child: Text(
                    "ADD NEW ARTEFACT",
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              FormTextField(
                title: "Name",
              ),
              FormDateField(
                title: "Date Created",
                controller: TextEditingController(),
              ),
              FormDropDownField(
                title: "Original Owner",
//                items: ["123", "1234"],
              ),
              FormDropDownField(
                title: "Current Owner",
//                items: ["123", "1235"],
              ),
              FormTextField(
                title: "Description",
                maxLines: 4,
              ),
              MaterialButton(
                child: Text("Upload Photo"),
                onPressed: () async {
                  await ImagePicker.pickImage(source: ImageSource.gallery);
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  UglyButton(
                    text: "Cancel",
                    height: 10,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  UglyButton(
                    text: "Add",
                    height: 10,
                    onPressed: () {},
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
