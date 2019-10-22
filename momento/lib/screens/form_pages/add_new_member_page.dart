import 'package:flutter/material.dart';
import 'package:momento/bloc/add_new_member_bloc.dart';
import 'package:momento/bloc/profile_bloc.dart';
import 'package:momento/constants.dart';
import 'package:momento/models/member.dart';
import 'package:momento/repositories/family_repository.dart';
import 'package:momento/repositories/member_repository.dart';
import 'package:momento/screens/form_pages//components/form_image_selector.dart';
import 'package:momento/screens/components/ugly_button.dart';
import 'package:momento/services/cloud_storage_service.dart';
import 'package:momento/screens/components/dialogs.dart';
import 'package:momento/services/snack_bar_service.dart';
import 'package:provider/provider.dart';
import 'components/form_drop_down_field.dart';
import 'components/form_date_field.dart';
import 'components/form_text_field.dart';

/// UI part for add new member pages
class AddNewMemberPage extends StatefulWidget {
  final List<Member> members;
  AddNewMemberPage(this.members);
  @override
  _AddNewMemberPageState createState() => _AddNewMemberPageState();
}

class _AddNewMemberPageState extends State<AddNewMemberPage> {
  final GlobalKey<State> _keyLoader = GlobalKey<State>();
  final _snackBarService = SnackBarService();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _genderController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _motherController = TextEditingController();
  final _fatherController = TextEditingController();
  final _birthdayController = TextEditingController();
  final _deathdayController = TextEditingController();

  AddNewMemberBloc _bloc;

  @override
  void initState() {
    _bloc = AddNewMemberBloc(
      MemberRepository(),
      FamilyRepository(),
      CloudStorageService(),
      widget.members,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double horizontalPadding = MediaQuery.of(context).size.width * 0.1;
    return Scaffold(
      key: _scaffoldKey,
      body: Container(
        color: kThemeColor,
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
                      color: kHeaderColor,
                    ),
                  ),
                ),
              ),
              FormTextField(
                title: "First Name",
                controller: _firstNameController,
                onChanged: (value) {
                  _bloc.firstName = value;
                },
              ),
              FormTextField(
                title: "Last Name",
                controller: _lastNameController,
                onChanged: (value) {
                  _bloc.lastName = value;
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
                itemKey: _bloc.gender,
                controller: _genderController,
              ),
              FormDateField(
                title: "Date of Birth",
                controller: _birthdayController,
                onChange: (value) {
                  setState(() {
                    _bloc.birthday = value;
                    _bloc.updateFathers();
                    _bloc.updateMothers();
                  });
                },
                lastDate: _bloc.deathday,
              ),
              FormDateField(
                title: "Date of Death (if dead)",
                controller: _deathdayController,
                onChange: (value) {
                  setState(() {
                    _bloc.deathday = value;
                  });
                },
                firstDate: _bloc.birthday,
              ),
              FormDropDownField(
                title: "Father",
                items: Map<String, String>.fromIterable(
                  _bloc.fathers,
                  key: (f) => f.id,
                  value: (v) => v.firstName + " " + v.lastName,
                ),
                onChanged: (value) {
                  _bloc.father = value;
                },
                itemKey: _bloc.father,
                controller: _fatherController,
              ),
              FormDropDownField(
                title: "Mother",
                items: Map<String, String>.fromIterable(
                  _bloc.mothers,
                  key: (f) => f.id,
                  value: (v) => v.firstName + " " + v.lastName,
                ),
                onChanged: (value) {
                  _bloc.mother = value;
                },
                itemKey: _bloc.mother,
                controller: _motherController,
              ),
              FormTextField(
                title: "Description",
                controller: _descriptionController,
                maxLines: 5,
                onChanged: (value) {
                  _bloc.description = value;
                },
              ),
              ImageSelector(
                defaultImage: AssetImage("assets/images/default_member.png"),
                onChange: (value) {
                  _bloc.photo = value;
                },
                selected: _bloc.photo,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    UglyButton(
                      text: "Cancel",
                      color: kDarkRedMorandi,
                      onPressed: () {
                        Navigator.pop(context, null);
                      },
                    ),
                    UglyButton(
                      text: "Add",
                      color: kHeaderColor,
                      onPressed: () async {
                        final validation = _bloc.validate();
                        if (validation == "") {
                          Dialogs.showLoadingDialog(context, _keyLoader);
                          final newMember = await _bloc.addNewMember(
                            Provider.of<ProfileBloc>(context).family,
                          );
                          Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
                          Navigator.pop(context, newMember);
                        } else {
                          _snackBarService.showInSnackBar(
                              _scaffoldKey, "Please provide $validation");
                        }
                      },
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
