// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_3/memory_card_game/memory_card.dart';

import 'memory_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.size});

  final int size;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int c = 0;

  @override
  Widget build(BuildContext context) {
    Provider.of<MemoryProvider>(context).size = widget.size;
    return mainApp();
  }

  Widget mainApp() {
    return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                playerTurn(Provider.of<MemoryProvider>(context)),
                const SizedBox(
                  height: 20,
                ),
                createCardList(widget.size),
              ],
            );
  }

  Widget createCardList(int couple) {
    List<MemoryCard> cards = [];
    int index = 0;
    bool pair = false;
    for (int i = 0; i < couple * 2; i++) {
      cards.add(MemoryCard(index, i));
      if (pair) {
        index++;
        pair = !pair;
      } else {
        pair = !pair;
      }
    }
    cards.shuffle();

    Column column = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [],
    );
    for (int i = 0; i < cards.length; i++) {
      cards[i].index = i;
    }
    for (int i = 0; i < cards.length; i++) {
      column.children.add(Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          memoryCardMaker(cards[i].num),
          memoryCardMaker(cards[++i].num),
        ],
      ));
    }
    return column;
  }

  Widget memoryCardMaker(int no) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ChangeNotifierProvider(
        create: (_) => (MemoryCard(no, c++)),
        builder: (context, child) =>
            cardWithProvider(context.watch<MemoryCard>()),
      ),
    );
  }

  Widget playerTurn(MemoryProvider provider) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          color: provider.player1Turn ? Colors.green : Colors.white10,
          child: const Text("Player 1"),
        ),
        const SizedBox(
          width: 50,
          height: 5,
        ),
        Container(
          color: !provider.player1Turn ? Colors.green : Colors.white10,
          child: const Text("Player 2"),
        )
      ],
    );
  }

  Widget cardWithProvider(MemoryCard memoryCard) {
    return Container(
      color: memoryCard.solved
          ? Colors.green
          : (!memoryCard.revealed ? Colors.black38 : Colors.white38),
      child: TextButton(
        onPressed: () {
          Provider.of<MemoryProvider>(context,listen: false).card(memoryCard,context);
        },
        child: !memoryCard.revealed
            ? const Text(
                "?",
                style: TextStyle(color: Colors.white),
              )
            : Text("${memoryCard.num}",
                style: const TextStyle(color: Colors.black)),
      ),
    );
  }
}
