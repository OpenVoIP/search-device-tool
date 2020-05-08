import 'package:SADPTool/model/item.dart';
import 'package:flutter/services.dart';

var result = List<ScanItem>();
List<ScanItem> selectedData = List<ScanItem>();
const platform_complex_structure =
    const MethodChannel('tqcenglish.flutter.dev/scan');
