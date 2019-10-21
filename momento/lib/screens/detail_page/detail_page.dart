import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:momento/constants.dart';

class DetailPage extends StatelessWidget {
  final Function edit;
  final Function delete;
  final List<Widget> content;
  DetailPage({this.edit, this.delete, this.content});
  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      appBar: PlatformAppBar(
        backgroundColor: kThemeColor,
        leading: PlatformIconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: kDarkRedMoranti,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        trailingActions: <Widget>[
          PlatformIconButton(
            icon: Icon(
              Icons.edit,
              color: kDarkRedMoranti,
            ),
            onPressed: edit,
          ),
          PlatformIconButton(
            icon: Icon(
              Icons.delete,
              color: kDarkRedMoranti,
            ),
            onPressed: () async {
              showPlatformDialog(
                context: context,
                androidBarrierDismissible: false,
                builder: (_) => PlatformAlertDialog(
                  title: PlatformText('Delete?'),
                  actions: <Widget>[
                    PlatformDialogAction(
                      child: PlatformText("Cancel"),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    PlatformDialogAction(
                      child: PlatformText(
                        "Delete",
                        style: TextStyle(
                          color: kMainTextColor,
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        delete();
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: Container(
        color: kThemeColor,
        child: ListView(children: content),
      ),
    );
  }
}
