import 'package:cloud_firestore/cloud_firestore.dart';

/// a model to represent family, which store the name and description and email
class Address {
  String line1;
  String line2;
  String state;
  String country;
  String postcode;

  Address({
    this.line1,
    this.line2,
    this.state,
    this.country,
    this.postcode
  });
}

Future<Address> parseAddress(String uid) async {
}
