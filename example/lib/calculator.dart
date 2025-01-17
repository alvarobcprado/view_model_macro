import 'package:view_model_macro/view_model_macro.dart';

@ViewModelMacro()
class Calculator extends ViewModel {
  Calculator();

  int _count = 0;
  String _message = '';


  @CommandMacro()
  Future<void> _add() async {
    _message = 'Added';
    _count++;
    notifyListeners();
  }

  @CommandMacro()
  Future<void> _subtract() async {
    _message = 'Subtracted';
    _count--;
    await Future.delayed(const Duration(seconds: 1));
    notifyListeners();
  }

  @CommandMacro()
  Future<void> _reset(bool force, String resetMessage) async {
    await Future.delayed(const Duration(seconds: 1));
    if (force) {
      subtract.reset();
      add.reset();
    }

    _count = 0;
    _message = resetMessage;

    notifyListeners();
  }
}
