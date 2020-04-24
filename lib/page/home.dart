import 'package:SADPTool/widget/data_result.dart';
import 'package:SADPTool/widget/handle.dart';
import 'package:SADPTool/widget/head.dart';
import 'package:SADPTool/widget/result.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, title}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        constraints: BoxConstraints(
            // minWidth: 400,
            ),
        child: Column(
          children: [
            Head(),
            Container(
              color: Colors.grey[100],
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [Result(), Handle()],
              ),
            ),
            Expanded(
              child: Scrollbar(
                child: DataResult(),
              ),
            )
          ],
        ),
      ),
    );
  }
}
