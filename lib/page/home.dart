import 'package:SADPTool/utils/eventbus.dart';
import 'package:SADPTool/widget/page_head.dart';
import 'package:SADPTool/widget/result_table.dart';
import 'package:SADPTool/widget/result_total.dart';
import 'package:SADPTool/widget/scan_handle.dart';
import 'package:flutter/material.dart';

import '../common.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, title}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int total = 0;

  @override
  void initState() {
    bus.on('scan_ok', (arg) {
      setState(() {
        total = result.length;
      });
    });
    super.initState();
  }

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
                children: [
                  Result(
                    total: total,
                  ),
                  Handle()
                ],
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
