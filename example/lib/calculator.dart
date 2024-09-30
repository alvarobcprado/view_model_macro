import 'package:view_model_macro/view_model_macro.dart';

@ViewModel()
class Calculator {
  Calculator() {
    _countState.collect((countValue) => _emitReverseCount(countValue * -1));
  }

  final StateNotifier<int> _countState = StateNotifier(0);
  final StateNotifier<double> _reverseCountState = StateNotifier(0.0);

  void add() => _emitCount(_countValue + 1);
  void subtract() => _emitCount(_countValue - 1);
}
