import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'memory_provider.dart';

class HistoryPage extends StatefulWidget {
  final bool isPlayer1;

  const HistoryPage({super.key, required this.isPlayer1});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  @override
  Widget build(BuildContext context) {
    MemoryProvider provider = context.watch<MemoryProvider>();
    int won = provider.player1won();
    bool isPlayer1 = widget.isPlayer1;
    String playerWon = "Tie";
    if (won == 1) {
      if(isPlayer1) {
        playerWon = "You Won!";
      }else{
        playerWon = "You Lost";
      }
    }
    if (won == -1) {
      if(!isPlayer1) {
        playerWon = "You Won!";
      }else{
        playerWon = "You Lost";
      }
    }
    return Scaffold(
      body: Column(
        children: [
          Text(playerWon,style: const TextStyle(fontSize: 50),),
          const Text("your moves are",style: TextStyle(fontSize: 24),),
          Expanded(
            child: ListView.builder(
                itemCount: isPlayer1
                    ? provider.player1moves.length
                    : provider.player2moves.length,
                itemBuilder: (BuildContext context, int index) {
                  Map map = isPlayer1
                      ? provider.player1moves[index]
                      : provider.player2moves[index];
                  bool move = map.keys.first;
                  return ListTile(
                      leading: move
                          ? const Icon(
                              Icons.check,
                              color: Colors.green,
                            )
                          : const Icon(
                              Icons.close,
                              color: Colors.red,
                            ),
                      trailing: Text(
                        (map.keys.first?"good move":"bad move"),
                        style:
                            const TextStyle(color: Colors.green, fontSize: 15),
                      ),
                      title: Text("from index "
                          "${map.values.first.keys.first}"
                          " to index "
                          "${map.values.first.values.first}"));
                }),
          ),
        ],
      ),
    );
  }
}
