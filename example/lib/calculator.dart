import 'package:view_model_macro/view_model_macro.dart';

// export 'package:flutter/widgets.dart';

@ViewModel()
class Calculator {
  final int _countState = 0;

  void add() => emitCount(countValue + 1);
  void subtract() => emitCount(countValue - 1);
}
