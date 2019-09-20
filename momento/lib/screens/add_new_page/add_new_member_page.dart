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
                onChanged: (value) {
                  _bloc.firstName = value;
                },
              ),
              FormDropDownField(
                title: "Gender",
                items: ["Male", "Female", "Others"],
                onChanged: (value) {
                  _bloc.gender = value;
                },
              ),
              FormDateField(
                title: "Date of Birth",
                controller: _bloc.birthdayController,
                onChange: (value) {
                  _bloc.birthday = value;
                },
              ),
              FormDateField(
                title: "Date of Death (if dead)",
                controller: _bloc.deathdayController,
                onChange: (value) {
                  _bloc.deathday = value;
                },
              ),
              FormTextField(
                title: "Description",
                maxLines: 5,
                onChanged: (value) {
                  _bloc.description = value;
                },
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
                      final validation = _bloc.validate();
                      if (validation == "") {
                        await _bloc.addNewMember(widget.familyId);
                        Navigator.pop(context);
                      } else {
                        print(validation);
                      }
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
