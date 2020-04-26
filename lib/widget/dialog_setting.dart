import 'package:flutter/material.dart';

class SettingDialog extends StatefulWidget {
  SettingDialog({Key key}) : super(key: key);

  @override
  _SettingDialogState createState() => _SettingDialogState();
}

class _SettingDialogState extends State<SettingDialog> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: AlertDialog(
        title: const Text('设置'),
        content: const Text('语言设置: only 中文'),
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              Navigator.pop(context, false);
            },
            child: const Text('确定'),
          ),
        ],
      ),
    );
  }
}
