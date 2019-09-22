import 'package:flutter/material.dart';
import 'package:momento/bloc/add_new_member_bloc.dart';
import 'package:momento/constants.dart';
import 'package:momento/models/family.dart';
import 'package:momento/models/member.dart';
import 'package:momento/screens/components/ugly_button.dart';
import 'components/form_drop_down_field.dart';
import 'components/form_date_field.dart';
import 'components/form_text_field.dart';

class AddNewMemberPage extends StatefulWidget {
  final Family family;
  AddNewMemberPage(this.family);
  @override
  _AddNewMemberPageState createState() => _AddNewMemberPageState();
}

class _AddNewMemberPageState extends State<AddNewMemberPage> {
  AddNewMemberBloc _bloc;

  @override
  void initState() {
    _bloc = AddNewMemberBloc(widget.family);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double horizontalPadding = MediaQuery.of(context).size.width * 0.1;
    return StreamBuilder<List<Member>>(
        stream: _bloc.getMembers,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
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
                        items: {
                          "Male": "Male",
                          "Female": "Female",
                          "Others": "Others",
                        },
                        onChanged: (value) {
                          _bloc.gender = value;
                        },
                      ),
                      FormDateField(
                        title: "Date of Birth",
                        controller: _bloc.birthdayTextController,
                        onChange: (value) {
                          setState(() {
                            _bloc.birthday = value;
                            _bloc.updateFathers();
                          });
                        },
                      ),
                      FormDateField(
                        title: "Date of Death (if dead)",
                        controller: _bloc.deathdayTextController,
                        onChange: (value) {
                          _bloc.deathday = value;
                        },
                        firstDate: _bloc.birthday,
                      ),
                      FormDropDownField(
                        title: "Father",
                        items: Map<String, String>.fromIterable(
                          _bloc.fathers,
                          key: (f) => f.firstName,
                          value: (v) => v.id,
                        ),
                        onChanged: (value) {
                          _bloc.father = value;
                        },
                      ),
                      FormDropDownField(
                        title: "Mother",
                        items: Map<String, String>.fromIterable(
                          _bloc.mothers,
                          key: (f) => f.firstName,
                          value: (v) => v.id,
                        ),
                        onChanged: (value) {
                          _bloc.mother = value;
                        },
                      ),
                      FormTextField(
                        title: "Description",
                        maxLines: 5,
                        onChanged: (value) {
                          _bloc.description = value;
                        },
                      ),
                      GestureDetector(
                        onTap: _bloc.pickImage,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[Text("Upload Photo"), Icon(Icons.photo_album)],
                        ),
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
                                await _bloc.addNewMember(widget.family.id);
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
          } else {
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        });
  }
}
