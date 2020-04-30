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
            Padding(
              padding: EdgeInsets.only(left: 50, right: 10),
              child: Text("在线设备总数:"),
            ),
            Container(
              height: 40,
              padding: EdgeInsets.only(left: 5, right: 5),
              child: VerticalDivider(
                width: 2,
                color: Colors.grey,
              ),
            ),
            Container(
              child: Text('$total',
                  style: TextStyle(fontSize: 40, color: Colors.green)),
            )
          ],
        ));
  }
}
