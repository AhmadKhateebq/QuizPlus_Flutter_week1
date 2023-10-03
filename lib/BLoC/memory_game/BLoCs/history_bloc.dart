import 'dart:async';

class HistoryBLoC {
  final List<History> _playersHistory = [];
  final StreamController<List<History>> _historyStream = StreamController();
  final StreamController<History> _eventStream = StreamController();

  _event(History history) =>
      _historyStream.sink.add(_playersHistory..add(history));

  HistoryBLoC() {
    _eventStream.stream.listen(_event);
  }

  Stream<List<History>> get() => _historyStream.stream;
  List<History> get history => _playersHistory;
  int get playerWon{
    int p1 = 0;
    int p2 = 0;
    for (var value in _playersHistory) {
      if(value.good){
        if(value.player == 1){
          p1+=2;
        }
        if(value.player == 1){
          p2+=2;
        }
      }else{
        if(value.player == 1){
          p1-=1;
        }
        if(value.player == 1){
          p2-=1;
        }
      }
    }
    return p1>p2? 1 : 2;
  }
  addToHistory(History history) {
    _eventStream.sink.add(history);
  }
}

class History {
  final int card1id;
  final int card2id;
  final bool good;
  final int player;

  @override
  String toString() {
    return 'History{card1id: $card1id, card2id: $card2id, good: $good, player: $player}';
  }

  const History(
      {required this.card1id, required this.card2id,required this.good, required this.player});
}
