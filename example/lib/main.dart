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

  void _onShowSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Show SnackBar from ActionNotifier')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () => counter.add(),
        ),
        body: Builder(builder: (context) {
          return counter.showSnackBarStream.collectAsListener(
            onData: (_) => _onShowSnackBar(context),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  counter.countStream.collectAsWidget(
                    initialData: 0,
                    (value) {
                      return Text('Count: $value');
                    },
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
