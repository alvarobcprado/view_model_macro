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
    counter.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        floatingActionButton: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FloatingActionButton(
              onPressed: counter.add.run,
              child: const Icon(Icons.add),
            ),
            const SizedBox(height: 8),
            FloatingActionButton(
              onPressed: counter.subtract.run,
              child: const Icon(Icons.remove),
            ),
            const SizedBox(height: 8),
            FloatingActionButton(
              onPressed: () => counter.reset.run(true, 'Reseted!'),
              child: CommandCollector(
                (context) {
                  final isReseting = counter.reset.isRunning;

                  return isReseting
                      ? const CircularProgressIndicator()
                      : const Icon(Icons.refresh);
                },
              ),
            )
          ],
        ),
        body: Collector(
          (context) => Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Count: ${counter.count}'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
