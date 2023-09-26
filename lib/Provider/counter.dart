import 'package:flutter/cupertino.dart';

class Counter with ChangeNotifier {
  int _count = 0;

  int get count => _count;

  void increment() {
    _count = count + 1;
    notifyListeners();
  }

  void decrement() {
    if (_count > 0) {
      _count = count - 1;
      notifyListeners();
    }
  }
}
