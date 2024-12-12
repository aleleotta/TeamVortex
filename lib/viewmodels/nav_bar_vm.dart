import 'package:flutter/material.dart';

class NavBarViewModel extends ChangeNotifier {
  int _selectedIndex = 0;

  int get selectedIndex => _selectedIndex;

  /// Sets the selected index and notifies listeners.
  set selectedIndex(int value) {
    _selectedIndex = value;
    notifyListeners();
  }
}