import 'package:flutter/material.dart';
import 'package:test_3/memory_card_game/history_page.dart';



class HistoryHome extends StatelessWidget {
  const HistoryHome({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 1,
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Center(child: Text('Ending Screen')),
          bottom: const TabBar(
            tabs: <Widget>[
              Tab(
               text: "Player 1",
              ),
              Tab(
                text: "Player 2",
              ),
            ],
          ),
        ),
        body: const TabBarView(
          children: <Widget>[
            Center(
              child: HistoryPage(isPlayer1: true),
            ),
            Center(
              child: HistoryPage(isPlayer1: false),
            ),

          ],
        ),
      ),
    );
  }
}