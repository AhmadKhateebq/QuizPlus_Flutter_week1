import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'counter.dart';
import 'counter_inc_dec_widget.dart';

class CounterScreen extends StatelessWidget {
  const CounterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Providers'),
        backgroundColor: Colors.amberAccent,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            createCounterWidget(),
            const SizedBox(
              height: 50,
            ),
            createCounterWidget(),
          ],
        ),
      ),
    );
  }

  Widget createCounterWidget() {
    return ChangeNotifierProvider(
      create: (_) => (Counter()),
      builder: (context, child) =>
          CounterWidget(counter: context.watch<Counter>()),
    );
  }
}
