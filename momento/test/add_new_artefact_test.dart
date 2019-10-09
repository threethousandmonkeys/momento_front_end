import 'package:flutter_test/flutter_test.dart';
import 'package:momento/bloc/add_new_artefact_bloc.dart';

void main() {
  final _addNewArtefactBloc = AddNewArtefactBloc();
  test("empty_name", () {
    _addNewArtefactBloc.validate();
  });
}
