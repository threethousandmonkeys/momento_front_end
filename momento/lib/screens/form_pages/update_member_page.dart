import 'package:flutter/material.dart';
import 'package:momento/bloc/profile_bloc.dart';
import 'package:momento/bloc/update_member_bloc.dart';
import 'package:momento/constants.dart';
import 'package:momento/models/member.dart';
import 'package:momento/screens/form_pages//components/form_image_selector.dart';
import 'package:momento/screens/components/ugly_button.dart';
import 'package:momento/services/dialogs.dart';
import 'package:momento/services/snack_bar_service.dart';
import 'package:provider/provider.dart';
import 'components/form_drop_down_field.dart';
import 'components/form_date_field.dart';
import 'components/form_text_field.dart';

/// UI part for update new member pages
class UpdateMemberPage extends StatefulWidget {
  final Member member;
  final List<Member> members;
  UpdateMemberPage(this.member, this.members);
  @override
  _UpdateMemberPageState createState() => _UpdateMemberPageState();
}

class _UpdateMemberPageState extends State<UpdateMemberPage> {
  UpdateMemberBloc _bloc;
  final GlobalKey<State> _keyLoader = GlobalKey<State>();
  final _snackBarService = SnackBarService();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    _firstNameController.text = widget.member.firstName;
    _lastNameController.text = widget.member.lastName;
    _descriptionController.text = widget.member.description;
    _bloc = UpdateMemberBloc(widget.member, widget.members);
    super.initState();
  }

  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _birthdayController = TextEditingController();
  final _deathdayController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double horizontalPadding = MediaQuery.of(context).size.width * 0.1;
    return Scaffold(
      key: _scaffoldKey,
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
                    "UPDATE MEMBER",
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              FormTextField(
                title: "First Name",
                controller: _firstNameController,
                onChanged: (value) {
                  _bloc.member.firstName = value;
                },
              ),
              FormTextField(
                title: "Last Name",
                controller: _lastNameController,
                onChanged: (value) {
                  _bloc.member.lastName = value;
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
                  _bloc.member.gender = value;
                },
                itemKey: _bloc.member.gender,
              ),
              FormDateField(
                title: "Date of Birth",
                controller: _birthdayController,
                onChange: (value) {
                  setState(() {
                    _bloc.member.birthday = value;
                    _bloc.updateFathers();
                    _bloc.updateMothers();
                  });
                },
                lastDate: _bloc.member.deathday,
                initialDateTime: widget.member.birthday,
              ),
              FormDateField(
                title: "Date of Death (if dead)",
                controller: _deathdayController,
                onChange: (value) {
                  setState(() {
                    _bloc.member.deathday = value;
                  });
                },
                firstDate: _bloc.member.birthday,
                initialDateTime: widget.member.deathday,
              ),
              FormDropDownField(
                title: "Father",
                items: Map<String, String>.fromIterable(
                  _bloc.fathers,
                  key: (f) => f.id,
                  value: (v) => v.firstName,
                ),
                onChanged: (value) {
                  _bloc.member.fatherId = value;
                },
                itemKey: _bloc.member.fatherId,
              ),
              FormDropDownField(
                title: "Mother",
                items: Map<String, String>.fromIterable(
                  _bloc.mothers,
                  key: (f) => f.id,
                  value: (v) => v.firstName,
                ),
                onChanged: (value) {
                  _bloc.member.motherId = value;
                },
                itemKey: _bloc.member.motherId,
              ),
              FormTextField(
                title: "Description",
                controller: _descriptionController,
                maxLines: 5,
                onChanged: (value) {
                  _bloc.member.description = value;
                },
              ),
              ImageSelector(
                defaultImage: NetworkImage(widget.member.photo),
                onChange: (value) {
                  _bloc.photo = value;
                },
                selected: _bloc.photo,
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    UglyButton(
                      text: "Cancel",
                      height: 10,
                      onPressed: () {
                        Navigator.pop(context, null);
                      },
                    ),
                    UglyButton(
                      text: "Update",
                      height: 10,
                      onPressed: () async {
                        final validation = _bloc.validate();
                        if (validation == "") {
                          Dialogs.showLoadingDialog(context, _keyLoader);
                          final newMember =
                              await _bloc.updateMember(Provider.of<ProfileBloc>(context).family.id);
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
