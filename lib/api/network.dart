import 'dart:convert';

import 'package:http/http.dart' as http;

Future<String> fetchNetworkUpdate(
    String host, String token, Map<String, String> data) async {
  print(host);
  print(data);
  final response = await http.post('http://$host/api/set-network-info',
      body: json.encode(data),
      headers: {
        'Authorization': token,
      });

  if (response.statusCode == 200) {
    rebootDevice(host, token);
    return "更新成功";
  } else {
    print("Failed to update ${response.statusCode}");
    return "更新失败";
  }
}

rebootDevice(String host, String token) async {
  await http.get('http://$host/api/reboot', headers: {
    'Authorization': token,
  });
}
