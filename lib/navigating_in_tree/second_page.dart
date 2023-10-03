import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

class SecondScreen extends StatelessWidget {
  const SecondScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: const Text("Screen 2"),),
        body: Center(
            child: StoreConnector<String, String>(
                builder: (context, value) => Text(value),
                converter: (store) => store.state)),
        floatingActionButton: FloatingActionButton(onPressed: () {
          Navigator.pop(context);
        }),
      ),
    );
  }
}
