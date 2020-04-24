import 'package:flutter/material.dart';

class Handle extends StatefulWidget {
  Handle({Key key}) : super(key: key);

  @override
  _Handletate createState() => _Handletate();
}

class _Handletate extends State<Handle> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            child: FlatButton(
              color: Colors.red,
              onPressed: () => {},
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
              onPressed: () {},
            ),
            padding: EdgeInsets.all(20.0),
          ),
          Container(
              width: 150,
              child: TextField(
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  isDense: true,
                  contentPadding: EdgeInsets.all(0),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  hintText: '搜索',
                ),
              ))
        ],
      ),
    );
  }
}
