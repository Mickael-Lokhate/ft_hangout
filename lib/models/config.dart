import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

class HeaderColor with ChangeNotifier {
  MaterialAccentColor _headerColor = Colors.blueAccent;

  get headerColor => _headerColor;

  MaterialAccentColor updateColor(int colorId) {
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
      case 5:
        _headerColor = Colors.deepOrangeAccent;
        break;
      case 6:
        _headerColor = Colors.deepPurpleAccent;
        break;
      case 7:
        _headerColor = Colors.pinkAccent;
        break;
    }
    notifyListeners();
    return _headerColor;
  }
}

HeaderColor headerColorGlobal = HeaderColor();
Database? database;