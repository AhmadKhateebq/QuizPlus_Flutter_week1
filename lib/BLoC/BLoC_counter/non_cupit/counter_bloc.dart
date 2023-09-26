import 'dart:async';

import 'package:test_3/BLoC/BLoC_counter/non_cupit/counter_event.dart';

class CounterBLoC {
  int _counter = 0;
  final StreamController<int> _streamController = StreamController();
  final StreamController<CounterEvent> _eventController =
      StreamController.broadcast();

  StreamSink<int> get counterSink => _streamController.sink;

  Stream<int> get streamCounter => _streamController.stream;

  Sink<CounterEvent> get counterEventSink {
    return _eventController.sink;
  }

  _event(CounterEvent event) {
    String className = (event).runtimeType.toString();
    String inc = (IncrementEvent).toString();
    String dec = (DecrementEvent).toString();
    String res = (ResetEvent).toString();
    if (className == inc) {
      counterSink.add(++_counter);
    } else if (className == dec) {
      counterSink.add(--_counter);
    } else if (className == res) {
      counterSink.add(_counter = 0);
    }
  }

  CounterBLoC() {
    _eventController.stream.listen(_event);
  }

  dispose() {
    _streamController.close();
    _eventController.close();
  }
}
