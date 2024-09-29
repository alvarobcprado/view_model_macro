import 'package:view_model_macro/view_model_macro.dart';

// export 'package:flutter/widgets.dart';

@ViewModel()
class Calculator {
  final int _countState = 0;

  void add() => _emitCount(countValue + 1);
  void subtract() => _emitCount(countValue - 1);
}
