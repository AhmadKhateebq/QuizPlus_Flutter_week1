import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

enum Type { increment, decrement, reset, set }

class Action {
  Type type;
  int? payload;

  Action({required this.type, this.payload});
}

int counterReducer(int state, dynamic action) {
  if (action == Type.increment) {
    return state + 1;
  }
  if (action == Type.decrement) {
    return state - 1;
  }
  if (action == Type.reset) {
    return state = 0;
  }
  if (action.type == Type.set) {
    return state = action.payload;
  }
  return state;
}

void main() {
  final store = Store<int>(counterReducer, initialState: 0);
  String title = 'Redux';
  runApp(StoreProvider<int>(
      store: store,
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: title,
          home: FlutterReduxApp(
            title: title,
            store: store,
          ))));
}

class FlutterReduxApp extends StatelessWidget {
  final Store<int> store;
  final String title;

  const FlutterReduxApp({
    Key? key,
    required this.store,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    log("build 1");
    TextEditingController controller = TextEditingController();
    return Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              StoreConnector<int, int>(
                converter: (store) => (store.state),
                builder: (context, count) {
                  log("text build");
                  return Text(
                    'Counter : $count',
                  );
                },
              )
            ],
          ),
        ),
        floatingActionButton: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            StoreConnector<int, VoidCallback>(
              converter: (store) {
                return () => store.dispatch(Type.increment);
              },
              builder: (context, callback) {
                log("button build");
                return FloatingActionButton(
                  onPressed: callback,
                  tooltip: 'Increment',
                  child: const Icon(Icons.add),
                );
              },
            ),
            StoreConnector<int, VoidCallback>(
              converter: (store) {
                return () => store.dispatch(Type.reset);
              },
              builder: (context, callback) {
                return FloatingActionButton(
                  onPressed: callback,
                  tooltip: 'reset',
                  child: const Icon(Icons.lock_reset_sharp),
                );
              },
            ),
            StoreConnector<int, VoidCallback>(
              converter: (store) {
                return () => store.dispatch(Type.decrement);
              },
              builder: (context, callback) {
                return FloatingActionButton(
                  onPressed: callback,
                  tooltip: 'decrement',
                  child: const Icon(Icons.remove),
                );
              },
            ),
            StoreConnector<int, VoidCallback>(
              converter: (store) {
                return () => store.dispatch(Action(
                    payload: int.parse(controller.text), type: Type.set));
              },
              builder: (context, callback) {
                return FloatingActionButton(
                  onPressed: callback,
                  tooltip: 'decrement',
                  child: const Icon(Icons.numbers),
                );
              },
            ),
            SizedBox(
              width: 150,
              child: TextField(
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
                maxLength: 20,
                controller: controller,
              ),
            )
          ],
        ));
  }
}
