import 'package:view_model_macro/view_model_macro.dart';

@ViewModel(enableActions: true)
class Calculator {
  Calculator() {
    countStream.collect((countValue) {
      if (countValue % 3 == 0 && countValue > 0) {
        _dispatchShowSnackBar();
      }
    });
  }

  final StateNotifier<int> _count = StateNotifier(0);
  final ActionNotifier<void> _showSnackBar = ActionNotifier();

  void add() => _emitCount(_countValue + 1);
  void subtract() => _emitCount(_countValue - 1);
}
