import 'dart:convert';
import 'package:flutter/services.dart';

Future<Map<String, dynamic>> readJson(String file) async {
  final String response = await rootBundle.loadString(file);
  final data = await json.decode(response);
  return (data);
}
