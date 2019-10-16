import 'package:flutter/material.dart';
import 'package:flutter_multiselect/flutter_multiselect.dart';
import 'package:momento/bloc/profile_bloc.dart';
import 'package:momento/bloc/update_event_bloc.dart';
import 'package:momento/constants.dart';
import 'package:momento/models/event.dart';
import 'package:momento/models/member.dart';
import 'package:momento/screens/form_pages//components/form_image_selector.dart';
import 'package:momento/screens/components/ugly_button.dart';
import 'package:momento/services/dialogs.dart';
import 'package:momento/services/snack_bar_service.dart';
import 'package:provider/provider.dart';
import 'components/form_date_field.dart';
import 'components/form_text_field.dart';

class UpdateEventPage extends StatefulWidget {
  final Event event;
  final List<Member> members;
  UpdateEventPage(this.event, this.members);
  @override
  _UpdateEventPageState createState() => _UpdateEventPageState();
}

class _UpdateEventPageState extends State<UpdateEventPage> {
  UpdateEventBloc _bloc;
  final GlobalKey<State> _keyLoader = GlobalKey<State>();
  final _snackBarService = SnackBarService();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    _nameController.text = widget.event.name;
    _descriptionController.text = widget.event.description;
    _bloc = UpdateEventBloc(widget.event);
    super.initState();
  }

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
                    "UPDATE EVENT",
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              FormTextField(
                title: "Event Name",
                onChanged: (value) {
                  _bloc.event.name = value;
                },
                controller: _nameController,
              ),
              FormDateField(
                title: "Date",
                onChange: (value) {
                  setState(() {
                    _bloc.event.date = value;
                  });
                },
                controller: _dateController,
                initialDateTime: widget.event.date,
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
                value: _bloc.event.participants,
                initialValue: widget.event.participants,
                change: (value) {
                  if (value == null) {
                    _bloc.event.participants = [];
                  } else {
                    _bloc.event.participants = List<String>.from(value);
                  }
                },
              ),
              FormTextField(
                title: "Description",
                maxLines: 5,
                onChanged: (value) {
                  _bloc.event.description = value;
                },
                controller: _descriptionController,
              ),
              ImageSelector(
                defaultImage: NetworkImage(widget.event.photo),
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
                          final newEvent =
                              await _bloc.updateEvent(Provider.of<ProfileBloc>(context).family.id);
                          Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
                          Navigator.pop(context, newEvent);
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
