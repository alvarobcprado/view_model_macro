import 'package:rxdart/rxdart.dart';
import 'package:view_model_macro/src/models/notifier.dart';

class StateNotifier<T> extends Notifier<T> {
  StateNotifier(T initialValue)
      : _subject = BehaviorSubject<T>.seeded(initialValue);

  final BehaviorSubject<T> _subject;

  T get state => _subject.value;

  @override
  void emit(T value) {
    _subject.add(value);
  }

  @override
  Stream<T> get stream => _subject.stream;
}
