// 对当前 ip +1
String ipPlusOne(String ip) {
  var ipValue = ip.split('.').toList();
  if (ipValue.length != 4) {
    print(ip);
    return "";
  }
  var ip3 = int.parse(ipValue[3]);
  var ip2 = int.parse(ipValue[2]);

  if (ip3 == 255) {
    ip2++;
    ip3 = 0;
  } else {
    ip3++;
  }
  return '${ipValue[0]}.${ipValue[1]}.$ip2.$ip3';
}

String getModel(String mac) {
  var info = mac.split(":").toList()[3];
  var model = "";
  switch (info) {
    case "0d":
      model = "X30";
      break;
    case "0e":
      model = "IX100";
      break;
    case "0f":
      model = "IX200";
      break;
    case "20":
      model = "X20";
      break;
    case "21":
      model = "SH30";
      break;
    case "22":
      model = "SW15";
      break;
    case "23":
      model = "SC15";
      break;
    case "24":
      model = "IA03";
      break;
    case "25":
      model = "IV03";
      break;
    case "26":
      model = "IA05";
      break;
    case "27":
      model = "IV05";
      break;
    case "28":
      model = "M100";
      break;
    default:
  }

  return model;
}
