import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:search_tool/i10n/localizations.dart';
import 'package:search_tool/utils/currentLocale.dart';

class SettingDialog extends StatefulWidget {
  SettingDialog({Key key}) : super(key: key);

  @override
  _SettingDialogState createState() => _SettingDialogState();
}

class _SettingDialogState extends State<SettingDialog> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      child: AlertDialog(
        title: Text(AppLocalizations.of(context).setting),
        content: Column(
          children: [
            RaisedButton(
                child: Text("中文"),
                onPressed: () {
                  Provider.of<CurrentLocale>(context, listen: false)
                      .setLocale(const Locale('zh', "CH"));
                }),
            RaisedButton(
              child: Text("English"),
              onPressed: () {
                Provider.of<CurrentLocale>(context, listen: false)
                    .setLocale(const Locale('en', "US"));
              },
            ),
          ],
        ),
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              Navigator.pop(context, false);
            },
            child: Text(AppLocalizations.of(context).close),
          ),
        ],
      ),
    );
  }
}
