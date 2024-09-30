import 'package:view_model_macro/view_model_macro.dart';

@ViewModel()
class Calculator {
  Calculator() {
    countStream.collect((countValue) {
      if (countValue % 3 == 0) {
        _dispatchShowSnackBar();
      }
    });
  }

  final StateNotifier<int> _countState = StateNotifier(0);
  final ActionNotifier<void> _showSnackBarAction = ActionNotifier();

  void add() => _emitCount(_countValue + 1);
  void subtract() => _emitCount(_countValue - 1);
}
