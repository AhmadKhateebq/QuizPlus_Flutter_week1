import 'package:flutter/material.dart';

import 'counter_bloc.dart';
import 'counter_event.dart';

main() {
  runApp(const MaterialApp(
    home: CounterPage(),
  ));
}

class CounterPage extends StatelessWidget {
  const CounterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Row(
      children: [
        buildScreen(),

        buildScreen(),
      ],
    ));
  }

  Widget buildScreen() {
    final bloc = CounterBLoC();
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        StreamBuilder(
            stream: bloc.streamCounter,
            initialData: 0,
            builder: (context, snapshot) {
              return Center(child: Text(snapshot.data.toString()));
            }),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              onPressed: () => bloc.counterEventSink.add(DecrementEvent()),
              child: const Icon(Icons.remove),
            ),
            FloatingActionButton(
              onPressed: () => bloc.counterEventSink.add(IncrementEvent()),
              child: const Icon(Icons.add),
            ),
          ],
        ),
        FloatingActionButton(
          onPressed: () => bloc.counterEventSink.add(ResetEvent()),
          child: const Icon(Icons.numbers),
        ),
      ],
    );
  }
}
