import 'package:search_tool/utils/eventbus.dart';
import 'package:search_tool/widget/darwer.dart';
import 'package:search_tool/widget/page_head.dart';
import 'package:search_tool/widget/result_table.dart';
import 'package:search_tool/widget/result_total.dart';
import 'package:search_tool/widget/scan_handle.dart';
import 'package:flutter/material.dart';

import '../common.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, title}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int total = 0;

  @override
  void initState() {
    bus.on('scan_ok', (arg) {
      setState(() {
        total = result.length;
      });
    });
    bus.on('scan_start', (arg) {
      if (mounted && total > 0) {
        setState(() {
          total = 0;
        });
      }
    });
    bus.on('open_drawer', (arg) {
      _scaffoldKey.currentState.openEndDrawer();
    });
    bus.on('close_drawer', (arg) {
      _scaffoldKey.currentState.openEndDrawer();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Container(
        child: Column(
          children: [
            Head(),
            Container(
              color: Colors.grey[100],
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Container(
                      margin: EdgeInsets.all(20),
                      width: double.infinity,
                      child: DataResult(),
                    )),
              ),
            )
          ],
        ),
      ),
      endDrawer: Update(),
    );
  }
}
