import 'package:flutter/material.dart';
import 'package:momento/bloc/profile_bloc.dart';
import 'package:momento/bloc/update_artefact_bloc.dart';
import 'package:momento/constants.dart';
import 'package:momento/models/artefact.dart';
import 'package:momento/models/member.dart';
import 'package:momento/screens/form_pages//components/form_image_selector.dart';
import 'package:momento/screens/components/ugly_button.dart';
import 'package:momento/services/dialogs.dart';
import 'package:momento/services/snack_bar_service.dart';
import 'package:provider/provider.dart';
import 'components/form_drop_down_field.dart';
import 'components/form_date_field.dart';
import 'components/form_text_field.dart';

/// UI part for update new artifact pages
class UpdateArtefactPage extends StatefulWidget {
  final Artefact artefact;
  final List<Member> members;
  UpdateArtefactPage(this.artefact, this.members);
  @override
  _UpdateArtefactPageState createState() => _UpdateArtefactPageState();
}

class _UpdateArtefactPageState extends State<UpdateArtefactPage> {
  UpdateArtefactBloc _bloc;
  final GlobalKey<State> _keyLoader = GlobalKey<State>();
  final _snackBarService = SnackBarService();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    _nameController.text = widget.artefact.name;
    _descriptionController.text = widget.artefact.description;
    _bloc = UpdateArtefactBloc(widget.artefact);
    super.initState();
  }

  final _nameController = TextEditingController();
  final _dateCreatedController = TextEditingController();
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
                    "UPDATE ARTEFACT",
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
                  _bloc.artefact.name = value;
                },
                controller: _nameController,
              ),
              FormDateField(
                title: "Date Created",
                initialDateTime: widget.artefact.dateCreated,
                onChange: (value) {
                  setState(() {
                    _bloc.artefact.dateCreated = value;
                  });
                },
                controller: _dateCreatedController,
              ),
              FormDropDownField(
                title: "Original Owner",
                items: Map<String, String>.fromIterable(
                  widget.members,
                  key: (f) => f.id,
                  value: (v) => v.firstName,
                ),
                onChanged: (value) {
                  _bloc.artefact.originalOwnerId = value;
                },
                itemKey: widget.artefact.originalOwnerId,
              ),
              FormDropDownField(
                title: "Current Owner",
                items: Map<String, String>.fromIterable(
                  widget.members,
                  key: (f) => f.id,
                  value: (v) => v.firstName,
                ),
                onChanged: (value) {
                  _bloc.artefact.currentOwnerId = value;
                },
                itemKey: widget.artefact.currentOwnerId,
              ),
              FormTextField(
                title: "Description",
                maxLines: 5,
                onChanged: (value) {
                  _bloc.artefact.description = value;
                },
                controller: _descriptionController,
              ),
              ImageSelector(
                defaultImage: NetworkImage(widget.artefact.photo),
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
                          final newArtefact = await _bloc.updateArtefact(
                            Provider.of<ProfileBloc>(context).family.id,
                          );
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
