import 'package:flutter/material.dart';
import 'package:momento/bloc/add_new_artefact_bloc.dart';
import 'package:momento/constants.dart';
import 'package:momento/models/family.dart';
import 'package:momento/models/member.dart';
import 'package:momento/repositories/artefact_repository.dart';
import 'package:momento/repositories/family_repository.dart';
import 'package:momento/screens/form_pages//components/form_image_selector.dart';
import 'package:momento/screens/components/ugly_button.dart';
import 'package:momento/services/cloud_storage_service.dart';
import 'package:momento/services/dialogs.dart';
import 'package:momento/services/snack_bar_service.dart';
import 'components/form_drop_down_field.dart';
import 'components/form_date_field.dart';
import 'components/form_text_field.dart';

/// UI part for add new artifact pages
class AddNewArtefactPage extends StatefulWidget {
  final Family family;
  final List<Member> members;
  AddNewArtefactPage(this.family, this.members);
  @override
  _AddNewArtefactPageState createState() => _AddNewArtefactPageState();
}

class _AddNewArtefactPageState extends State<AddNewArtefactPage> {
  AddNewArtefactBloc _bloc;
  final GlobalKey<State> _keyLoader = GlobalKey<State>();
  final _snackBarService = SnackBarService();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _nameController = TextEditingController();
  final _dateCreatedController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _originalOwnerController = TextEditingController();
  final _currentOwnerController = TextEditingController();

  @override
  void initState() {
    _bloc = AddNewArtefactBloc(ArtefactRepository(), CloudStorageService(), FamilyRepository());
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
                    "ADD NEW ARTEFACT",
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                      color: kMainTextColor,
                    ),
                  ),
                ),
              ),
              FormTextField(
                title: "Artefact Name",
                onChanged: (value) {
                  _bloc.name = value;
                },
                controller: _nameController,
              ),
              FormDateField(
                title: "Date Created",
                onChange: (value) {
                  setState(() {
                    _bloc.dateCreated = value;
                  });
                },
                controller: _dateCreatedController,
              ),
              FormDropDownField(
                title: "Original Owner",
                items: Map<String, String>.fromIterable(
                  widget.members,
                  key: (f) => f.id,
                  value: (v) => v.firstName + " " + v.lastName,
                ),
                onChanged: (value) {
                  _bloc.originalOwner = value;
                },
                itemKey: _bloc.originalOwner,
                controller: _originalOwnerController,
              ),
              FormDropDownField(
                title: "Current Owner",
                items: Map<String, String>.fromIterable(
                  widget.members,
                  key: (f) => f.id,
                  value: (v) => v.firstName + " " + v.lastName,
                ),
                onChanged: (value) {
                  _bloc.currentOwner = value;
                },
                itemKey: _bloc.currentOwner,
                controller: _currentOwnerController,
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
                defaultImage: AssetImage("assets/images/default_artefact.png"),
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
                      color: kHeaderColor,
                      onPressed: () {
                        Navigator.pop(context, null);
                      },
                    ),
                    UglyButton(
                      text: "Add",
                      height: 10,
                      color: kMainTextColor,
                      onPressed: () async {
                        final validation = _bloc.validate();
                        if (validation == "") {
                          Dialogs.showLoadingDialog(context, _keyLoader);
                          final newArtefact = await _bloc.addNewArtefact(widget.family);
                          Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
                          Navigator.pop(context, newArtefact);
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
