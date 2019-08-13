import 'package:flutter/foundation.dart';

class Counter with ChangeNotifier {
  int _count = 0;
  get count => _count;

  addCount() {
    _count++;
    notifyListeners();
  }

  subCount() {
    _count--;
    notifyListeners();
  }
}
