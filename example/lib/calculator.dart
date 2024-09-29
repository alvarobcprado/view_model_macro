import 'package:view_model_macro/view_model_macro.dart';

@ViewModel()
class Calculator {
  final StateNotifier<int> _countState = StateNotifier(0);

  void add() => _emitCount(_countValue + 1);
  void subtract() => _emitCount(_countValue - 1);
}
