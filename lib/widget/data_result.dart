import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DataResult extends StatefulWidget {
  DataResult({Key key}) : super(key: key);

  @override
  _DataResultState createState() => _DataResultState();
}

class _DataResultState extends State<DataResult> {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        sortColumnIndex: 0,
        sortAscending: true,
        showCheckboxColumn: true,
        columns: [
          DataColumn(label: Text("编号")),
          DataColumn(label: Text("设备类型")),
          DataColumn(label: Text("激活状态")),
          DataColumn(label: Text("IP 地址")),
          DataColumn(label: Text("端口")),
          DataColumn(label: Text("软件版本")),
          DataColumn(label: Text("网关")),
          DataColumn(label: Text("HTTP端口")),
          DataColumn(label: Text("mac 地址")),
        ],
        rows: [
          DataRow(cells: [
            DataCell(Text("1")),
            DataCell(Text("x10")),
            DataCell(Text("未激活")),
            DataCell(Text("192.68.1.1")),
            DataCell(Text("8000")),
            DataCell(Text("v1")),
            DataCell(Text("192.168.1.1")),
            DataCell(Text("80")),
            DataCell(Text("11-22-33-44-55")),
          ]),
          DataRow(cells: [
            DataCell(Text("2")),
            DataCell(Text("x10")),
            DataCell(Text("未激活")),
            DataCell(Text("192.68.1.1")),
            DataCell(Text("8000")),
            DataCell(Text("v1")),
            DataCell(Text("192.168.1.1")),
            DataCell(Text("80")),
            DataCell(Text("11-22-33-44-55")),
          ])
        ],
      ),
    ));
  }
}
