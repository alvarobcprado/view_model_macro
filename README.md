# data_class

[![pub package](https://img.shields.io/pub/v/view_model_macro.svg)](https://pub.dev/packages/view_model_macro)
[![License: MIT](https://img.shields.io/badge/license-MIT-purple.svg)](https://opensource.org/licenses/MIT)

Support for ViewModels utilities in Dart using [macros](https://dart.dev/language/macros).

## ✨ Features

- `StateNotifier` with private state and emitter and public Stream.

- `ActionNotifier` optional notifier with private emitter and public Stream.

- `Dispose` automatically disposes all notifiers declared from ViewModel

## 🧑‍💻 Example

```dart
import 'package:view_model_macro/view_model_macro.dart';

@ViewModel()
class Counter {
  final StateNotifier<int> _countState = StateNotifier(0);

  void add() => _emitCount(_countValue + 1);
  void subtract() => _emitCount(_countValue - 1);
}

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  // Declare the ViewModel
  final counter = Counter();

  @override
  void dispose() {
    // Disposes when needed
    counter.dispose();
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
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Collect the data from the stream
              // and build a widget based on its data
              counter.countStream.collectAsWidget(
                initialData: 0,
                (value) {
                  return Text('Count: $value');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

```

## 🚀 Quick Start

1. Add `package:view_model_macro` to your `pubspec.yaml`

   ```yaml
   dependencies:
     view_model_macro: any
   ```

1. Enable experimental macros in `analysis_options.yaml`

   ```yaml
   analyzer:
     enable-experiment:
       - macros
   ```

1. Use the `@ViewModel` annotation (see above example).

1. Run it

   ```sh
   flutter run --enable-experiment=macros
   ```

_\*Requires Dart SDK >= 3.5.0_