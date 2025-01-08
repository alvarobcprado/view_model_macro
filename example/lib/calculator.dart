import 'package:view_model_macro/view_model_macro.dart';

@ViewModelMacro()
class Calculator extends ViewModel {
  Calculator();

  int _count = 0;

  void add() {
    count++;
    notifyListeners();
  }

  void subtract() {
    count--;
    notifyListeners();
  }
}
