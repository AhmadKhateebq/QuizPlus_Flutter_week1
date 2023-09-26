import 'package:flutter/material.dart';

import 'counter.dart';

class CounterWidget extends StatelessWidget {
  final Counter counter;

  const CounterWidget({super.key, required this.counter});

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Counter : ${counter.count}',
            style: const TextStyle(fontSize: 24),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                color: Colors.deepOrange,
                child: IconButton(
                  onPressed: () => counter.decrement(),
                  icon: const Icon(Icons.remove),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Container(
                color: Colors.deepOrange,
                child: IconButton(
                  onPressed: () => counter.increment(),
                  icon: const Icon(Icons.add),
                ),
              )
            ],
          )
        ]);
  }
}
