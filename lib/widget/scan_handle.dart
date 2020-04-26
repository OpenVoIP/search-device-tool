import 'package:SADPTool/model/item.dart';
import 'package:SADPTool/utils/eventbus.dart';
import 'package:SADPTool/widget/not_implemented_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../common.dart';

class Handle extends StatefulWidget {
  Handle({Key key}) : super(key: key);

  @override
  _Handletate createState() => _Handletate();
}

class _Handletate extends State<Handle> {
  static const platform_complex_structure =
      const MethodChannel('tqcenglish.flutter.dev/scan');

  void _handleScan() async {
    var data = await platform_complex_structure.invokeMethod('startScan');

    // 解析扫描结果
    result.clear();
    var number = 0;
    data.forEach((key, value) {
      var values = value.split("###");
      result
          .add(ScanItem(values[0], values[1], values[2], values[3], number++));
    });
    bus.emit("scan_ok");
  }

  @override
  void initState() {
    super.initState();
    _handleScan();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            child: FlatButton(
              color: Colors.red,
              onPressed: () => {
                showDialog<void>(
                  context: context,
                  builder: (BuildContext context) => NotImplementedDialog(),
                )
              },
              child: Text(
                '导出',
                style: TextStyle(color: Colors.white),
              ),
            ),
            padding: EdgeInsets.all(20.0),
          ),
          Container(
            child: OutlineButton(
              child: Text("刷新"),
              onPressed: () {
                _handleScan();
              },
            ),
            padding: EdgeInsets.all(20.0),
          ),
          Container(
              width: 200,
              child: TextField(
                onSubmitted: (text) {
                  bus.emit("filter", text);
                },
                decoration: InputDecoration(
                  prefixIcon: Padding(
                    padding: EdgeInsets.all(0.0),
                    child: Icon(Icons.search, size: 18),
                  ),
                  isDense: true,
                  contentPadding: EdgeInsets.all(0),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  hintText: '搜索 mac',
                ),
              ))
        ],
      ),
    );
  }
}
