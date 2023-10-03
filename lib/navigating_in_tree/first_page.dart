import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:test_3/navigating_in_tree/redux.dart';
import 'package:test_3/navigating_in_tree/second_page.dart';

class FirstScreen extends StatelessWidget {
  const FirstScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: const Text("First screen"),),
        body: const Center(
            child: Text("set random value to screen 2")),
        floatingActionButton: StoreConnector<String, VoidCallback>(
            converter: (store) => () => store.dispatch(
                FluxAction(action: Operation.SET, payload:"${Random().nextInt(99)}")),
            builder: (context, action) => FloatingActionButton(onPressed: () {
                  action.call();
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) {
                    return const SecondScreen();
                  }));
                })),

      ),
    );
  }
}

main() {
  runApp(StoreProvider(
      store: store,
      child: const MaterialApp(
        home: FirstScreen(),
      )));
}
