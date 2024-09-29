import 'package:example/calculator.dart';
import 'package:flutter/material.dart';
import 'package:view_model_macro/view_model_macro.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  final counter = Calculator();

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () => counter.add(),
        ),
        body: Center(
          child: counter.countStream.collectAsState(
            (value) {
              return Text('Count: $value');
            },
          ),
        ),
      ),
    );
  }
}
