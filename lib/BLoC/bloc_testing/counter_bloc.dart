import 'dart:async';

import 'package:flutter/material.dart';

class CounterBLoC {
  int counter = 0;
  final StreamController<int> _counterStream = StreamController();
  final StreamController<int> _eventStream = StreamController();

  _event(int i) {
    counter = i;
    _counterStream.sink.add(i);
  }

  CounterBLoC() {
    _eventStream.stream.listen(_event);
  }

  doEvent(int i) {
    _eventStream.sink.add(i);
  }

  Stream<int> get dataStream => _counterStream.stream;

}

main() {
  int i = 10;
  CounterBLoC counterBLoC = CounterBLoC();
  runApp(MaterialApp(
    home: StreamBuilder(
      initialData: 10,
      stream: counterBLoC.dataStream,
      builder: (context, snapshot) {
        return Scaffold(
          body: Center(child: Text("${snapshot.data}")),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              counterBLoC.doEvent(++i);
            },
            child: const Icon(Icons.add),
          ),
        );
      },
    ),
  ));
}
