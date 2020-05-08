import 'package:SADPTool/api/network.dart';
import 'package:SADPTool/common.dart';
import 'package:SADPTool/utils/utils.dart';
import 'package:SADPTool/widget/divider_admin.dart';
import 'package:flutter/material.dart';

class Update extends StatefulWidget {
  Update({Key key}) : super(key: key);

  @override
  _UpdateState createState() => _UpdateState();
}

class _UpdateState extends State<Update> {
  final _formKey = GlobalKey<FormState>();
  bool _checkboxDHCP = true; //维护复选框状态

  String password;
  String gateway;
  String mask;
  String ipStart;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 600,
      child: Drawer(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: EdgeInsets.all(20),
              child: Text(
                '修改 ${selectedData.length} 台设备网络',
                style: TextStyle(fontSize: 30),
              ),
            ),
            if (selectedData.length != 0)
              Container(
                margin: EdgeInsets.all(20),
                child: Row(
                  children: <Widget>[
                    Checkbox(
                      value: _checkboxDHCP,
                      activeColor: Colors.red, //选中时的颜色
                      onChanged: (value) {
                        setState(() {
                          _checkboxDHCP = value;
                        });
                      },
                    ),
                    Text(
                      '开启 DHCP',
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                ),
              ),
            if (selectedData.length != 0)
              Container(
                margin: EdgeInsets.only(left: 100, top: 50, right: 50),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      TextFormField(
                        enabled: !_checkboxDHCP,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: selectedData.length == 1
                              ? "IP"
                              : "开始 IP, 后续IP自动 +1",
                          labelStyle: TextStyle(fontSize: 25),
                        ),
                        validator: (value) {
                          if (value.isEmpty && !_checkboxDHCP) {
                            return '输入 IP';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          ipStart = value;
                        },
                      ),
                      // SizedBox(height: 20),
                      // TextFormField(
                      //   decoration: InputDecoration(
                      //     border: OutlineInputBorder(),
                      //     labelText: "端口",
                      //     labelStyle: TextStyle(fontSize: 25),
                      //   ),
                      //   validator: (value) {
                      //     if (value.isEmpty) {
                      //       return '输入 端口';
                      //     }
                      //     return null;
                      //   },
                      // ),
                      SizedBox(height: 20),
                      TextFormField(
                        enabled: !_checkboxDHCP,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "子网掩码",
                          labelStyle: TextStyle(fontSize: 25),
                        ),
                        validator: (value) {
                          if (value.isEmpty && !_checkboxDHCP) {
                            return '子网掩码';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          mask = value;
                        },
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        enabled: !_checkboxDHCP,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "网关",
                          labelStyle: TextStyle(fontSize: 25),
                        ),
                        validator: (value) {
                          if (value.isEmpty && !_checkboxDHCP) {
                            return '网关';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          gateway = value;
                        },
                      ),
                      SizedBox(height: 40),
                      DividerAdminLine(),
                      SizedBox(height: 10),
                      TextFormField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "管理员密码",
                          labelStyle: TextStyle(fontSize: 25),
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return '必须填写密码';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          password = value;
                        },
                      ),
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          child: RaisedButton(
                            color: Colors.red,
                            onPressed: () async {
                              // Validate returns true if the form is valid, or false
                              // otherwise.
                              if (_formKey.currentState.validate()) {
                                // 提交
                                String token = await platform_complex_structure
                                    .invokeMethod('create_token', password);

                                //更新
                                selectedData.forEach((device) async {
                                  var data;
                                  if (_checkboxDHCP) {
                                    data = {
                                      "ip_assignment": "dhcp",
                                      "ip_address": "",
                                      "subnet_mask": "",
                                      "default_gateway": "",
                                      "primary_dns": "8.8.8.8",
                                      "alternative_dns": "114.114.114.114",
                                    };
                                  } else {
                                    data = {
                                      "ip_assignment": "static",
                                      "ip_address": ipStart,
                                      "subnet_mask": mask,
                                      "default_gateway": gateway,
                                      "primary_dns": "8.8.8.8",
                                      "alternative_dns": "114.114.114.114",
                                    };

                                    ipStart = ipPlusOne(ipStart);
                                  }
                                  print(token);
                                  String resultRes = await fetchNetworkUpdate(
                                      device.ip, token, data);
                                  print(resultRes);

                                });
                                Navigator.of(context).pop();
                              }
                            },
                            child: Text(
                              '提交修改',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 25),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
