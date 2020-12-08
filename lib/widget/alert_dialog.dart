import 'package:flutter/material.dart';
import 'package:search_tool/i10n/localizations.dart';

class CustomDialog extends StatelessWidget {
  CustomDialog({Key key, this.msg, this.title}) : super(key: key);
  final String msg;
  final String title;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(msg),
      actions: <Widget>[
        FlatButton(
          onPressed: () {
            Navigator.pop(context, false);
          },
          child: Text(AppLocalizations.of(context).close),
        ),
      ],
    );
  }
}
