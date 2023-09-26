import 'package:flutter/material.dart';

class MemoryCard with ChangeNotifier{
  int num ;
  int index ;
  bool revealed = false;
  bool solved = false;
  MemoryCard(this.num,this.index);
  reveal(){
    revealed = true;
    notifyListeners();
  }
  hide(){
    revealed = false;
    notifyListeners();
  }
  solve(){
    solved = true;
    revealed = true;
    notifyListeners();
  }
}