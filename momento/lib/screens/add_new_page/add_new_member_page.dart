import 'package:flutter/material.dart';
import 'package:momento/bloc/add_new_bloc.dart';
import 'package:momento/constants.dart';
import 'package:momento/screens/components/ugly_button.dart';
import 'components/form_drop_down_field.dart';
import 'components/form_date_field.dart';
import 'components/form_text_field.dart';

class AddNewMemberPage extends StatefulWidget {
  final String familyId;
  AddNewMemberPage(this.familyId);
  @override
  _AddNewMemberPageState createState() => _AddNewMemberPageState();
}

class _AddNewMemberPageState extends State<AddNewMemberPage> {
  AddNewBloc _bloc = AddNewBloc();

  @override
  void initState() {
    super.initState();
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
                controller: _bloc.firstNameController,
              ),
              FormDropDownField(
                "Gender",
                ["Male", "Female", "Others"],
              ),
              FormDateField(
                title: "Date of Birth",
                controller: _bloc.dateOfBirthController,
//                date: dateOfBirth,
              ),
              FormDateField(
                title: "Date of Death (if dead)",
                controller: _bloc.dateOfDeathController,
              ),
              FormTextField(
                title: "Description",
                maxLines: 5,
                controller: _bloc.descriptionController,
              ),
              MaterialButton(
                child: Text("Upload Photo"),
                onPressed: _bloc.pickImage,
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
                    onPressed: () async {
                      await _bloc.addNewMember(widget.familyId);
                      Navigator.pop(context);
                    },
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
