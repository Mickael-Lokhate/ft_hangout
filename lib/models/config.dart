import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

class HeaderColor extends ChangeNotifier {
  MaterialAccentColor _headerColor = Colors.blueAccent;

  get headerColor => _headerColor;

  void updateColor(int colorId) {
    switch (colorId) {
      case 1:
        _headerColor = Colors.redAccent;
        break;
      case 2:
        _headerColor = Colors.blueAccent;
        break;
      case 3:
        _headerColor = Colors.yellowAccent;
        break;
      case 4:
        _headerColor = Colors.greenAccent;
        break;
    }
    notifyListeners();
  }
}

HeaderColor headerColorGlobal = HeaderColor();
Database? database;