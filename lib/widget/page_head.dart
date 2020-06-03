import 'dart:convert';

import 'package:SADPTool/utils/eventbus.dart';
import 'package:SADPTool/widget/dialog_about.dart';
import 'package:SADPTool/widget/dialog_setting.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../common.dart';

class Head extends StatelessWidget {
  const Head({Key key}) : super(key: key);

  void _openURL(url) async {
    await platform_complex_structure.invokeMethod('open_url', url);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.black,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
                margin: EdgeInsets.only(left: 10),
                child: Row(
                  children: [
                    Text(
                      "设备搜索不支持跨网段,",
                      style: TextStyle(color: Colors.red, fontSize: 16),
                    ),
                    RichText(
                      text: TextSpan(
                        style: TextStyle(
                            color: Colors.lightBlue[400], fontSize: 18),
                        text: "请务必点击此处下载安装 WinPcap",
                        recognizer: TapGestureRecognizer()
                          ..onTap = () async {
                            final url = 'https://www.winpcap.org';
                            _openURL(url);
                          },
                      ),
                    ),
                  ],
                )),
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
                    icon: Icon(Icons.build, color: Colors.white),
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
