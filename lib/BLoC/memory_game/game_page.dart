// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:test_3/BLoC/memory_game/BLoCs/cards_bloc.dart';
import 'package:test_3/BLoC/memory_game/BLoCs/history_bloc.dart';
import 'package:test_3/BLoC/memory_game/widgets/card_widget.dart';

import 'card_data.dart';
const int size = 4;
main() {
  HistoryBLoC historyBLoC = HistoryBLoC();
  runApp(StreamBuilder(
      stream: historyBLoC.get(),
      builder: (context, snapshot) {
        return MaterialApp(
          home: SafeArea(
            child: Scaffold(
                appBar: AppBar(
                  title: Text("Game Page"),
                  backgroundColor: Colors.blueGrey,
                ),
                backgroundColor: Colors.blueGrey,
                body: GamePage(size: size, historyBLoC: historyBLoC)),
          ),
        );
      }));
}

class GamePage extends StatefulWidget {
  const GamePage({super.key, required this.size, required this.historyBLoC});

  final HistoryBLoC historyBLoC;
  final int size;

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  CardBLoC bloc = CardBLoC();
  MemoryCard card1 = MemoryCard(index: -1, num: -1, flipped: false);
  double height = 0;
  double width = 0;

  Widget mainApp() {
    return StreamBuilder(
        stream: bloc.get(),
        builder: (context, snapshot) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              playerTurnWidget(),
              const SizedBox(
                height: 20,
              ),
              createCardList(3, bloc.cards.map((e) => e.card).toList()),
            ],
          );
        });
  }

  @override
  void initState() {
    bloc.cards;
    int index = 0;
    bool pair = false;
    for (int i = 0; i < widget.size * 2; i++) {
      bloc.cards.add(CardStatus(
          status: STATUS.SET,
          card: MemoryCard(index: i, num: index, flipped: false)));
      if (pair) {
        index++;
      }
      pair = !pair;
    }
    bloc.cards.shuffle();
    for (int i = 0; i < bloc.cards.length; i++) {
      bloc.cards[i].card.index = i;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return mainApp();
  }

  Widget createCardList(int couple, List<MemoryCard> cards) {
    Column column = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [],
    );
    for (int i = 0; i < cards.length; i++) {
      if ((cards.length / 2) % 3 == 0) {
        column.children.add(tripleRow(cards[i], cards[++i], cards[++i]));
      } else {
        column.children.add(doubleRow(cards[i], cards[++i]));
      }
    }
    return column;
  }

  Row tripleRow(MemoryCard card1, MemoryCard card2, MemoryCard card3) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        memoryCardMaker(card1),
        memoryCardMaker(card2),
        memoryCardMaker(card3),
      ],
    );
  }

  Row doubleRow(
    MemoryCard card1,
    MemoryCard card2,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        memoryCardMaker(card1),
        memoryCardMaker(card2),
      ],
    );
  }

  Widget memoryCardMaker(MemoryCard card) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: cardMaker(card),
    );
  }

  Widget playerTurnWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          color: bloc.playerTurn == 1 ? Colors.green : Colors.white10,
          child: const Text("Player 1"),
        ),
        const SizedBox(
          width: 50,
          height: 5,
        ),
        Container(
          color: bloc.playerTurn == 2 ? Colors.green : Colors.white10,
          child: const Text("Player 2"),
        )
      ],
    );
  }

  Widget cardMaker(MemoryCard card) {
    Color color = bloc.cards[card.index].status == STATUS.SOLVED
        ? Colors.green
        : (bloc.cards[card.index].status == STATUS.SET
            ? Colors.black38
            : Colors.white38);
    String textValue = card.flipped ? card.num.toString() : "?";
    Text text = Text(
      textValue,
      style: TextStyle(color: Colors.white, fontSize: 18),
    );
    double heightMod = 0;
    double widthMod = 0;
    widget.size % 3 == 0
        ? {widthMod = 3, heightMod = widget.size * 2 / 3}
        : {heightMod = widget.size.toDouble(), widthMod = 2};
    return CardWidget(
      height: height / heightMod - 75,
      width: width / widthMod - 50,
      text: text,
      color: color,
      action: () {
        bloc.cardAction(card, widget.historyBLoC);
      },
    );
  }
}
