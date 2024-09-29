import 'package:rxdart/rxdart.dart';
import 'package:view_model_macro/src/models/notifier.dart';

class ActionNotifier<T> extends Notifier<T> {
  ActionNotifier() : _subject = PublishSubject<T>();

  final PublishSubject<T> _subject;

  @override
  void emit(T value) {
    _subject.add(value);
  }

  @override
  Stream<T> get stream => _subject.stream;
}
