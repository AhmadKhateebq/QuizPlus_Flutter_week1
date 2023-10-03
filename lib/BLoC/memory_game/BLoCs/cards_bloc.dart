import 'dart:async';
import 'dart:developer';

import '../card_data.dart';
import 'history_bloc.dart';

class CardBLoC {
  MemoryCard card1 = MemoryCard(index: -1, num: -1, flipped: false);
  int playerTurn = 1;
  final List<CardStatus> _cards = [];
  final StreamController<List<CardStatus>> _cardsStream = StreamController();
  final StreamController<CardAction> _eventStream = StreamController();

  event(CardAction action) {
    switch (action.status) {
      case STATUS.FLIPPED:
        _cardsStream.sink.add(List.of(_cards
          ..[action.index].card.flipped = !_cards[action.index].card.flipped));
      case STATUS.SOLVED:
        _cardsStream.sink.add(
            List.of(_cards..[action.index].card.flipped = true)
              ..[action.index].status = STATUS.SOLVED);
      case STATUS.FINISHED:
      case STATUS.SET:
      // TODO: Handle this case.
    }
  }

  CardBLoC() {
    _eventStream.stream.listen(event);
  }

  Stream<List<CardStatus>> get() => _cardsStream.stream;

  List<CardStatus> get cards => _cards;

  cardAction(MemoryCard card, HistoryBLoC historyBLoC) {
    if (card.flipped) {
      return;
    }
    if (card1.index == -1) {
      card1 = card;
      // card.flipped = true;
      event(CardAction(index: card.index, status: STATUS.FLIPPED));
    }
    if (card1.flipped && card1.index != card.index) {
      if (card1.num == card.num) {
        event(CardAction(index: card1.index, status: STATUS.SOLVED));
        event(CardAction(index: card.index, status: STATUS.SOLVED));
        //solved
        historyBLoC.history.add(History(
            card1id: card1.index,
            card2id: card.index,
            good: true,
            player: playerTurn));
        card1 = MemoryCard(index: -1, num: -1, flipped: false);
        //   solve both cards
      } else {
        // changeTurn();
        // hide both cards;
        historyBLoC.history.add(History(
            card1id: card1.index,
            card2id: card.index,
            good: false,
            player: playerTurn));
        event(CardAction(index: card.index, status: STATUS.FLIPPED));
        Future.delayed(const Duration(milliseconds: 500)).then((value) => {
              event(CardAction(index: card1.index, status: STATUS.FLIPPED)),
              event(CardAction(index: card.index, status: STATUS.FLIPPED)),
              playerTurn == 1 ? playerTurn = 2 : playerTurn = 1,
              card1 = MemoryCard(index: -1, num: -1, flipped: false),
            });
      }
    }
    if (finished()) {
      for (var value in historyBLoC.history) {
        log(value.toString());
      }
    }

  }

  finished() {
    return (cards
            .map((e) => e.status)
            .where((element) => element == STATUS.SOLVED)
            .length) ==
        cards.length;
  }
}

class CardAction {
  int index;
  STATUS status;

  CardAction({required this.index, required this.status});
}

class CardStatus {
  MemoryCard card;
  STATUS status;

  CardStatus({required this.status, required this.card});
}

enum STATUS { FLIPPED, SOLVED, FINISHED, SET }
