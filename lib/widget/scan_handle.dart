import 'package:search_tool/i10n/localizations.dart';
import 'package:search_tool/model/item.dart';
import 'package:search_tool/utils/eventbus.dart';
import 'package:search_tool/widget/alert_dialog.dart';
import 'package:flutter/material.dart';

import '../common.dart';

class Handle extends StatefulWidget {
  Handle({Key key}) : super(key: key);

  @override
  _Handletate createState() => _Handletate();
}

class _Handletate extends State<Handle> {
  void _download() async {
    String result = await platform_complex_structure.invokeMethod('download');
    showDialog<void>(
      context: context,
      builder: (BuildContext context) => CustomDialog(
          msg: AppLocalizations.of(context).saveTo + ' $result',
          title: AppLocalizations.of(context).dowload),
    );
  }

  void _handleScan() async {
    // 通知刷新
    bus.emit("scan_start");

    var data = await platform_complex_structure.invokeMethod('start_scan');

    // 解析扫描结果
    result.clear();
    selectedData.clear();

    var number = 0;
    data.forEach((key, value) {
      var values = value.split("###");
      var item = ScanItem(
        values[0],
        values[1],
        values[2],
        values[3],
        //Zycoo 判断设备类型
        // values[3].toString().contains("Zycoo") ? getModel(values[1].toString()) : "" // 在后段直接获取
        values[4],
        number++,
      );
      result.add(item);
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
              onPressed: () => {_download()},
              child: Text(
                AppLocalizations.of(context).export,
                style: TextStyle(color: Colors.white),
              ),
            ),
            padding: EdgeInsets.all(20.0),
          ),
          Container(
            child: FlatButton(
              color: Colors.blue,
              child: Text(
                AppLocalizations.of(context).refresh,
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                _handleScan();
              },
            ),
            padding: EdgeInsets.all(20.0),
          ),
          Container(
              width: 200,
              margin: EdgeInsets.only(right: 50),
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
                  hintText: AppLocalizations.of(context).serchByMac,
                ),
              ))
        ],
      ),
    );
  }
}
