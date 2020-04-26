import 'package:flutter/material.dart';

class NotImplementedDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('未实现'),
      content: const Text('这个功能正在开发中 ...'),
      actions: <Widget>[
        FlatButton(
          onPressed: () {
            Navigator.pop(context, false);
          },
          child: const Text('关闭'),
        ),
      ],
    );
  }
}
