import 'package:flutter/material.dart';

class IdProvider with ChangeNotifier {
  // Add your code here
  String? id;

  String? get userId => id;

  void setId(String? id) {
    this.id = id;
    notifyListeners();
  }
}
