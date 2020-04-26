import 'package:flutter/material.dart';

class AboutInfoDialog extends StatefulWidget {
  AboutInfoDialog({Key key}) : super(key: key);

  @override
  _AboutInfoDialogState createState() => _AboutInfoDialogState();
}

class _AboutInfoDialogState extends State<AboutInfoDialog> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: AlertDialog(
        title: const Text('关于'),
        content: Column(
          children: [
            const Text('版本: 1.0.0'),
            const Text('内网设备扫描(不支持跨网段)'),
          ],
        ),
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
