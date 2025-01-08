import 'package:view_model_macro/view_model_macro.dart';

@ViewModelMacro()
class Calculator extends ViewModel {
  Calculator();

  int _count = 0;
  late final subtract = Command0(_subtract);

  void add() {
    count++;
    notifyListeners();
  }

  Future<void> _subtract() async {
    count--;
    await Future.delayed(const Duration(seconds: 1));
    notifyListeners();
  }
}
