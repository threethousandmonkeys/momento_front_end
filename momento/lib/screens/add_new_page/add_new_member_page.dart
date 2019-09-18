import 'package:flutter/material.dart';
import 'package:momento/constants.dart';
import 'package:momento/components/ugly_button.dart';
import 'package:image_picker/image_picker.dart';
import 'components/form_drop_down_field.dart';
import 'components/form_date_field.dart';
import 'components/form_text_field.dart';
import 'package:momento/models/member.dart';

class AddNewMemberPage extends StatefulWidget {
  @override
  _AddNewMemberPageState createState() => _AddNewMemberPageState();
}

class _AddNewMemberPageState extends State<AddNewMemberPage> {
  TextEditingController firstNameController;
  TextEditingController dateOfBirthController;
  TextEditingController dateOfDeathController;
  TextEditingController descriptionController;

  void _addMember() {
    String firstName = firstNameController.text;
    String description = descriptionController.text;
    print(firstName);
    print(description);
  }

  @override
  void initState() {
    super.initState();
    firstNameController = TextEditingController();
    dateOfBirthController = TextEditingController();
    dateOfDeathController = TextEditingController();
    descriptionController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    firstNameController.dispose();
    dateOfBirthController.dispose();
    dateOfDeathController.dispose();
    descriptionController.dispose();
  }

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
                    "ADD NEW MEMBER",
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              FormTextField(
                title: "First Name",
                controller: firstNameController,
              ),
              FormDropDownField(
                "Gender",
                Gender.values.map((value) => value.toString().split('.')[1]).toList(),
              ),
              FormDateField(
                title: "Date of Birth",
                controller: dateOfBirthController,
              ),
              FormDateField(
                title: "Date of Death (if dead)",
                controller: dateOfDeathController,
              ),
              FormTextField(
                title: "Description",
                maxLines: 5,
                controller: descriptionController,
              ),
              MaterialButton(
                child: Text("Upload Photo"),
                onPressed: () async {
                  final image = await ImagePicker.pickImage(source: ImageSource.gallery);
                  print(image);
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
                    onPressed: _addMember,
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
