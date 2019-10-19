import 'package:flutter/material.dart';
import 'package:flutter_multiselect/flutter_multiselect.dart';
import 'package:momento/bloc/add_new_event_bloc.dart';
import 'package:momento/constants.dart';
import 'package:momento/models/family.dart';
import 'package:momento/models/member.dart';
import 'package:momento/repositories/event_repository.dart';
import 'package:momento/repositories/family_repository.dart';
import 'package:momento/screens/form_pages//components/form_image_selector.dart';
import 'package:momento/screens/components/ugly_button.dart';
import 'package:momento/services/cloud_storage_service.dart';
import 'package:momento/services/dialogs.dart';
import 'package:momento/services/snack_bar_service.dart';
import 'components/form_date_field.dart';
import 'components/form_text_field.dart';

/// UI part for add new event pages
class AddNewEventPage extends StatefulWidget {
  final Family family;
  final List<Member> members;
  AddNewEventPage(this.family, this.members);
  @override
  _AddNewEventPageState createState() => _AddNewEventPageState();
}

class _AddNewEventPageState extends State<AddNewEventPage> {
  final _bloc = AddNewEventBloc(
    EventRepository(),
    FamilyRepository(),
    CloudStorageService(),
  );
  final GlobalKey<State> _keyLoader = GlobalKey<State>();
  final _snackBarService = SnackBarService();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _nameController = TextEditingController();
  final _dateController = TextEditingController();
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
                    "ADD NEW EVENT",
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              FormTextField(
                title: "Event Name (max 50 characters)",
                onChanged: (value) {
                  _bloc.name = value;
                },
                controller: _nameController,
              ),
              FormDateField(
                title: "Date",
                onChange: (value) {
                  setState(() {
                    _bloc.date = value;
                  });
                },
                controller: _dateController,
              ),
              MultiSelect(
                autovalidate: false,
                titleText: "Participants",
                dataSource: widget.members
                    .map(
                      (member) => {
                        "display": member.firstName + " " + member.lastName,
                        "value": member.id,
                      },
                    )
                    .toList(),
                textField: 'display',
                valueField: 'value',
                value: null,
                change: (value) {
                  _bloc.participants = List<String>.from(value);
                },
              ),
              FormTextField(
                title: "Description",
                maxLines: 5,
                onChanged: (value) {
                  _bloc.description = value;
                },
                controller: _descriptionController,
              ),
              ImageSelector(
                defaultImage: AssetImage("assets/images/default_event.jpg"),
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
                      text: "Add",
                      height: 10,
                      onPressed: () async {
                        final validation = _bloc.validate();
                        if (validation == "") {
                          Dialogs.showLoadingDialog(context, _keyLoader);
                          final newEvent = await _bloc.addNewEvent(widget.family);
                          Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
                          Navigator.pop(context, newEvent);
                        } 
                        else if (validation == "name length") {
                          _snackBarService.showInSnackBar(
                              _scaffoldKey, "Event name is too long");
                        }
                        else {
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
