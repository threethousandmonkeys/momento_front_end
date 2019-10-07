import 'package:flutter/material.dart';
import 'package:momento/bloc/add_new_artefact_bloc.dart';
import 'package:momento/constants.dart';
import 'package:momento/models/family.dart';
import 'package:momento/models/member.dart';
import 'package:momento/screens/add_new_page/components/form_image_selector.dart';
import 'package:momento/screens/components/ugly_button.dart';
import 'package:momento/services/dialogs.dart';
import 'components/form_drop_down_field.dart';
import 'components/form_date_field.dart';
import 'components/form_text_field.dart';

class AddNewArtefactPage extends StatefulWidget {
  final Family family;
  final List<Member> members;
  AddNewArtefactPage(this.family, this.members);
  @override
  _AddNewArtefactPageState createState() => _AddNewArtefactPageState();
}

class _AddNewArtefactPageState extends State<AddNewArtefactPage> {
  AddNewArtefactBloc _bloc;
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();

  @override
  void initState() {
    _bloc = AddNewArtefactBloc(widget.members);
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
                    "ADD NEW Artefact",
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              FormTextField(
                title: "Artefact Name",
                onChanged: (value) {
                  _bloc.name = value;
                },
              ),
              FormDateField(
                title: "Date Created",
                controller: _bloc.dateCreatedController,
                onChange: (value) {
                  setState(() {
                    _bloc.dateCreated = value;
                  });
                },
              ),
              FormDropDownField(
                title: "Original Owner",
                items: Map<String, String>.fromIterable(
                  _bloc.members,
                  key: (f) => f.firstName,
                  value: (v) => v.id,
                ),
                onChanged: (value) {
                  _bloc.originalOwner = value;
                },
              ),
              FormDropDownField(
                title: "Current Owner",
                items: Map<String, String>.fromIterable(
                  _bloc.members,
                  key: (f) => f.firstName,
                  value: (v) => v.id,
                ),
                onChanged: (value) {
                  _bloc.currentOwner = value;
                },
              ),
              FormTextField(
                title: "Description",
                maxLines: 5,
                onChanged: (value) {
                  _bloc.description = value;
                },
              ),
              ImageSelector(
                defaultImage: "assets/images/default_artefact.jpg",
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
                          final newArtefact = await _bloc.addNewArtefact(widget.family);
                          Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
                          Navigator.pop(context, newArtefact);
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
