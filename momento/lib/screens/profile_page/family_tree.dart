import 'package:flutter/material.dart';
import 'package:momento/screens/create_page/create_page.dart';
import 'package:momento/constants.dart';

class FamilyTree extends StatefulWidget {
  @override
  _FamilyTreeState createState() => _FamilyTreeState();
}

class _FamilyTreeState extends State<FamilyTree> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CreatePage(
                title: "MEMBER",
                children: <Widget>[
                  FormTextField(
                    title: "First Name",
                  ),
                  FormDropdownField(
                    title: "Gender",
                    items: [Text("Male"), Text("Female")],
                  )
                ],
              ),
            ),
          );
        },
        child: Icon(
          Icons.people_outline,
          size: 100,
        ),
      ),
    );
  }
}
