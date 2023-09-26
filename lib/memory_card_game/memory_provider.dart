import 'dart:async';

import 'package:flutter/material.dart';
import 'package:test_3/memory_card_game/history_home_widget.dart';
import 'package:test_3/memory_card_game/history_page.dart';
import 'package:test_3/memory_card_game/memory_card.dart';

class MemoryProvider with ChangeNotifier {
  final MemoryCard stateZero = MemoryCard(-1, -1);
  late MemoryCard _card1;
  bool player1Turn = true;
  List<Map<bool,Map<int, int>>> player1moves = [];
  List<Map<bool,Map<int, int>>> player2moves = [];
  int _size = -1;
  int leftMoves = -1;

  MemoryProvider() {
    _card1 = stateZero;
  }
  set size(int size){
    _size = size;
    if(leftMoves == -1) {
      leftMoves = size;
    }
  }
  int get size => _size;
  changeTurn() {
    player1Turn = !player1Turn;
    notifyListeners();
  }

  card(MemoryCard card, BuildContext context) {
    if (_card1.num == -1) {
      if (card.revealed == false) {
        _card1 = card;
        card.reveal();
      }
    } else if (_card1.revealed && _card1.index != card.index) {
      if (card1.num == card.num) {
        //solved
        if (player1Turn) {
          player1moves.add({true:
            {card1.index: card.index}
          });
        } else {
          player2moves.add({true:
            {card1.index: card.index}
          });
        }
        card1.solve();
        card.solve();
        leftMoves = leftMoves - 1;
        _card1 = stateZero;
      } else {
        if (player1Turn) {
          player1moves.add({false:
            {card1.index: card.index}
          });
        } else {
          player2moves.add({false:
            {card1.index: card.index}
          });
        }
        changeTurn();
        card.reveal();
        Future.delayed(const Duration(seconds: 1), () {
          card.hide();
          card1.hide();
          _card1 = stateZero;
        });
      }
    }
    if (leftMoves == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HistoryHome()),
      );
    }
  }
  int player1won(){
    int c1 = 0;
    int c2 = 0;
    for (var value in player1moves) {
      value.keys.first == true? c1+=2:c1-=1;
    }
    for (var value in player2moves) {
      value.keys.first == true? c2+=2:c2-=1;
    }
    if(c1 == c2) {
      return 0;
    }
    return (c1>c2)?1:-1;
  }
  MemoryCard get card1 => _card1;
}
