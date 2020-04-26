import 'package:flutter/material.dart';

class Result extends StatelessWidget {
  const Result({Key key, this.total}) : super(key: key);
  final int total;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(5),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text("在线设备总数"),
            Divider(),
            Text('$total', style: TextStyle(fontSize: 40, color: Colors.green)),
          ],
        ));
  }
}
