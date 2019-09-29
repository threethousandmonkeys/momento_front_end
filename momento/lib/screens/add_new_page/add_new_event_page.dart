import 'package:flutter/material.dart';
import 'package:flutter_multiselect/flutter_multiselect.dart';
import 'package:momento/bloc/add_new_event_bloc.dart';
import 'package:momento/bloc/profile_bloc.dart';
import 'package:momento/constants.dart';
import 'package:momento/models/member.dart';
import 'package:momento/screens/add_new_page/components/form_image_selector.dart';
import 'package:momento/screens/components/ugly_button.dart';
import 'package:provider/provider.dart';
import 'components/form_date_field.dart';
import 'components/form_text_field.dart';

class AddNewEventPage extends StatefulWidget {
  @override
  _AddNewEventPageState createState() => _AddNewEventPageState();
}

class _AddNewEventPageState extends State<AddNewEventPage> {
  final _bloc = AddNewEventBloc();
  ProfileBloc _profileBloc;

  @override
  Widget build(BuildContext context) {
    if (_profileBloc == null) {
      _profileBloc = Provider.of<ProfileBloc>(context);
    }
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
                    "ADD NEW EVENT",
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
                  _bloc.name = value;
                },
              ),
              FormDateField(
                title: "Date",
                controller: _bloc.dateController,
                onChange: (value) {
                  setState(() {
                    _bloc.date = value;
                  });
                },
              ),
              StreamBuilder<List<Member>>(
                  stream: _profileBloc.getMembers,
                  builder: (context, snapshot) {
                    return MultiSelect(
                      autovalidate: false,
                      titleText: "Participants",
                      dataSource: snapshot.data
                          .map(
                            (member) => {
                              "display": member.firstName + " " + member.middleName,
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
                    );
                  }),
              FormTextField(
                title: "Description",
                maxLines: 5,
                onChanged: (value) {
                  _bloc.description = value;
                },
              ),
              ImageSelector(
                defaultImage: "assets/images/default_event.jpg",
                onChange: (value) {
                  _bloc.photo = value;
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Row(
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
                          final newFamily = await _bloc.addNewEvent(_profileBloc.family);
                          Navigator.pop(context, newFamily);
                        } else {
                          print(validation);
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
