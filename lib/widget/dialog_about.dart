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
            Row(
              children: <Widget>[
                Text('版本:'),
                Text('0.0.1'),
              ],
            ),
            Row(
              children: <Widget>[
                Text('使用说明:'),
                Text('本程序使用 arp 扫描局域网内通信设备(即不支持跨网段)'),
              ],
            )
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
