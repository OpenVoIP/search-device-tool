import 'package:SADPTool/common.dart';
import 'package:SADPTool/model/item.dart';
import 'package:SADPTool/utils/eventbus.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class DataResult extends StatefulWidget {
  DataResult({Key key}) : super(key: key);

  @override
  _DataResultState createState() => _DataResultState();
}

class _DataResultState extends State<DataResult> {
  static const platform_complex_structure =
      const MethodChannel('tqcenglish.flutter.dev/scan');

  List<ScanItem> data = List<ScanItem>();

  bool _sortAscending = false;
  int _sortColumnIndex = 0;

  void _openURL(url) async {
    await platform_complex_structure.invokeMethod('open_url', url);
  }

  List<DataRow> _createRows() {
    List<DataRow> newList = data.map((item) {
      return DataRow(
          selected: selectedData.contains(item),
          onSelectChanged: (value) {
            setState(() {
              if (value) {
                selectedData.add(item);
              } else {
                selectedData.remove(item);
              }
            });
          },
          cells: [
            DataCell(Text('${item.number}')),
            DataCell(
              Text(
                item.ip,
                style: TextStyle(color: Colors.blue),
              ),
              onTap: item.model != ""
                  ? () => {_openURL('http://${item.ip}:80')}
                  : null,
            ),
            DataCell(Text(item.mac)),
            DataCell(Text(
              item.model,
              style: TextStyle(color: Colors.red),
            )),
            DataCell(Text(item.hostname)),
            DataCell(Text(item.manuf)),
          ]);
    }).toList();
    return newList;
  }

  @override
  void initState() {
    bus.on("scan_start", (arg) {
      setState(() {
        data = [];
      });
    });
    bus.on("scan_ok", (arg) {
      setState(() {
        data = result;
      });
    });

    bus.on("filter", (arg) {
      setState(() {
        data = result.where((item) {
          return item.mac.startsWith(arg);
        }).toList();
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return data.length > 0
        ? DataTable(
            sortColumnIndex: _sortColumnIndex,
            sortAscending: _sortAscending,
            showCheckboxColumn: true,
            columns: [
              DataColumn(
                  label: Text("编号"),
                  onSort: (int columnIndex, bool ascending) {
                    setState(() {
                      _sortAscending = ascending;
                      _sortColumnIndex = columnIndex;
                      if (ascending) {
                        data.sort((a, b) => a.number.compareTo(b.number));
                      } else {
                        data.sort((a, b) => b.number.compareTo(a.number));
                      }
                    });
                  }),
              DataColumn(
                  label: Text("IP 地址"),
                  onSort: (int columnIndex, bool ascending) {
                    setState(() {
                      _sortColumnIndex = columnIndex;
                      _sortAscending = ascending;
                      if (ascending) {
                        data.sort((a, b) => a.ip.compareTo(b.ip));
                      } else {
                        data.sort((a, b) => b.ip.compareTo(a.ip));
                      }
                    });
                  }),
              DataColumn(
                  label: Text("Mac 地址"),
                  onSort: (int columnIndex, bool ascending) {
                    setState(() {
                      _sortColumnIndex = columnIndex;
                      _sortAscending = ascending;
                      if (ascending) {
                        data.sort((a, b) => a.mac.compareTo(b.mac));
                      } else {
                        data.sort((a, b) => b.mac.compareTo(a.mac));
                      }
                    });
                  }),
              DataColumn(
                  label: Text(
                    "型号",
                  ),
                  onSort: (int columnIndex, bool ascending) {
                    setState(() {
                      _sortColumnIndex = columnIndex;
                      _sortAscending = ascending;
                      if (ascending) {
                        data.sort((a, b) => a.model.compareTo(b.model));
                      } else {
                        data.sort((a, b) => b.model.compareTo(a.model));
                      }
                    });
                  }),
              DataColumn(
                  label: Text("主机名"),
                  onSort: (int columnIndex, bool ascending) {
                    setState(() {
                      _sortColumnIndex = columnIndex;
                      _sortAscending = ascending;
                      if (ascending) {
                        data.sort((a, b) => a.hostname.compareTo(b.hostname));
                      } else {
                        data.sort((a, b) => b.hostname.compareTo(a.hostname));
                      }
                    });
                  }),
              DataColumn(
                  label: Text("厂家"),
                  onSort: (int columnIndex, bool ascending) {
                    setState(() {
                      _sortColumnIndex = columnIndex;
                      _sortAscending = ascending;
                      if (ascending) {
                        data.sort((a, b) => a.manuf.compareTo(b.manuf));
                      } else {
                        data.sort((a, b) => b.manuf.compareTo(a.manuf));
                      }
                    });
                  }),
            ],
            rows: _createRows(),
          )
        : Container(
            height: MediaQuery.of(context).size.height - 200,
            child: Center(
                child: SpinKitFadingCircle(
              color: Colors.black,
              size: 100.0,
            )));
  }
}
