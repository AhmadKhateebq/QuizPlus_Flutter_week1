import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'game_screen.dart';
import 'memory_provider.dart';

void main() => runApp(ChangeNotifierProvider(
    create: (_) => (MemoryProvider()),
    builder: (context, child) => MaterialApp(
          debugShowCheckedModeBanner: false,
          home: Scaffold(
            appBar: AppBar(
              title: const Text('Memory Card Game'),
            ),
            body: const HomePage(
              size: 3,
            ),
          ),
        )));
