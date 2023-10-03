// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
main(){
  runApp(const MaterialApp(
    home: MyPage(),
  ));
}
class MyPage extends StatefulWidget {
  const MyPage({super.key});

  @override
  State<MyPage> createState() {
    print("createState");
    return _MyPageState();
  }
}

class _MyPageState extends State<MyPage> {
  void _increment() {
    setState(() {
      _counter = _counter + 1;
    });
  }

  late int _counter;
  @override
  void initState() {
    print("initState");
    _counter = 0;
    super.initState();
  }

  @override
  void didChangeDependencies() {
    print("didChangeDependencies");
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(covariant MyPage oldWidget) {
    print("didUpdateWidget");
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    print("dispose");
    super.dispose();
  }

  @override
  void deactivate() {
    print("deactivate");
    super.deactivate();
  }
  TextEditingController controller = TextEditingController(text: "init");
  @override
  Widget build(BuildContext context) {

    print("build");
    return Scaffold(
      appBar: AppBar(
        title: const Text("Lifecycle Demo"),
      ),
      body: Column(
        children: [
          Text(controller.text),
          TextField(
            controller: controller,
            onChanged: (text){
              setState(() {
                
              });
            },
          ),
          ElevatedButton(onPressed: (){}, child: const Text("Increment"))
        ],
      ),
    );
  }
}