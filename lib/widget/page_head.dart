import 'package:SADPTool/utils/eventbus.dart';
import 'package:SADPTool/widget/dialog_about.dart';
import 'package:SADPTool/widget/dialog_setting.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Head extends StatelessWidget {
  const Head({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.black,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              margin: EdgeInsets.only(left: 10),
              child: Text(
                "设备搜索",
                style: TextStyle(color: Colors.white),
              ),
            ),
            Container(
              margin: EdgeInsets.only(right: 10),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.settings,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      showDialog<void>(
                        context: context,
                        builder: (BuildContext context) => SettingDialog(),
                      );
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.info, color: Colors.white),
                    onPressed: () {
                      showDialog<void>(
                        context: context,
                        builder: (BuildContext context) => AboutInfoDialog(),
                      );
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.update, color: Colors.white),
                    onPressed: () {
                      bus.emit("open_drawer");
                    },
                  ),
                ],
              ),
            )
          ],
        ));
  }
}
