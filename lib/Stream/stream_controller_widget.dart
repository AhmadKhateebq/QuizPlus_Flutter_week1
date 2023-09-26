import 'dart:async';

import 'package:flutter/material.dart';

class StreamWidget extends StatefulWidget {
  const StreamWidget({super.key});

  @override
  State<StreamWidget> createState() => _StreamWidgetState();
}

class _StreamWidgetState extends State<StreamWidget> {
  StreamController<double> streamController =
      StreamController.broadcast(onListen: () {
    print("Listened to");
  });
  late Stream<double> stream;
  double val = 0;
  late StreamSubscription<double> streamSubscription;

  @override
  void initState() {
    stream = streamController.stream;
    streams();
  }

  void streams() {
    streamSubscription = stream.listen((value) {
      if (value == 0) {
        print("finished");
      }
      setState(() {
        val += value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          stageOne(),
          stageTwo(),
          FloatingActionButton(
            onPressed: ()async{
              var v = await runToMax(5).toList();
             print(v);
            },
            child: const Text("Print"),
          ),
        ],
      ),
    );
  }

  Widget stageOne() {
    return Center(
      child: Column(
        children: [
          Text(
            "$val",
            style: const TextStyle(
                fontSize: 50, backgroundColor: Colors.deepOrangeAccent),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                  decoration: const BoxDecoration(
                      color: Colors.blueAccent, shape: BoxShape.circle),
                  child: IconButton(
                    onPressed: () {
                      streamController.add(0);
                      streamSubscription.pause();
                    },
                    icon: const Icon(Icons.cancel),
                  )),
              Container(
                  decoration: const BoxDecoration(
                      color: Colors.blueAccent, shape: BoxShape.circle),
                  child: IconButton(
                    onPressed: () {
                      streamSubscription.resume();
                    },
                    icon: const Icon(Icons.subscriptions),
                  )),
            ],
          )
        ],
      ),
    );
  }

  Widget stageTwo() {
    return Center(
      child: Column(
        children: [
          Text(
            "$val",
            style: const TextStyle(
                fontSize: 50, backgroundColor: Colors.deepOrangeAccent),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                  decoration: const BoxDecoration(
                      color: Colors.blueAccent, shape: BoxShape.circle),
                  child: IconButton(
                    onPressed: () {
                      streamController.add(0);
                    },
                    icon: const Icon(Icons.remove),
                  )),
              Container(
                  decoration: const BoxDecoration(
                      color: Colors.blueAccent, shape: BoxShape.circle),
                  child: IconButton(
                    onPressed: () {
                      streamController.add(1);
                    },
                    icon: const Icon(Icons.add),
                  )),
            ],
          )
        ],
      ),
    );
  }

  Stream<int>runToMax(int i)async*{
    if(i>0){
      yield i;
      yield* runToMax(i-1);
    }
  }
}
