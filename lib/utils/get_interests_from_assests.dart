import 'dart:convert';

import 'package:bubbles/models/interest.dart';
import 'package:flutter/services.dart';

Future<List<Interest>> getInterestsFromAssets() async {
  String jsonString = await rootBundle.loadString('assets/interests.json');
  List<dynamic> jsonData = jsonDecode(jsonString);
  return jsonData.map((e) => Interest.fromJson(e)).toList();
}
