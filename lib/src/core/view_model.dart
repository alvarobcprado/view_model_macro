import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';

/// {@template ViewModel}
/// A base class for ViewModels that extends [ChangeNotifier].
/// {@endtemplate}
abstract class ViewModel extends ChangeNotifier {
  /// {@macro ViewModel}
  ViewModel() {
    init();
  }

  /// Method called when the ViewModel is initialized.
  void init() {}

  @override
  void notifyListeners([Function? fn]) {
    if (fn != null) {
      // ignore: avoid_dynamic_calls
      fn();
    }
    super.notifyListeners();
  }

  /// Returns the specified [value].
  @internal
  T getValue<T>(T value) {
    final currentCollector = _CollectorState.currentCollector;
    if (currentCollector != null) {
      currentCollector.addViewNotifier(this);
    }
    return value;
  }
}

/// {@template Collector}
/// A widget that collects [ChangeNotifier]s and rebuilds the widget tree
/// whenever any of the [ChangeNotifier]s notify listeners.
/// {@endtemplate}
class Collector extends StatefulWidget {
  /// {@macro Collector}
  const Collector(this.builder, {super.key});

  /// The builder function that builds the widget tree.
  final WidgetBuilder builder;

  @override
  State<Collector> createState() => _CollectorState();
}

class _CollectorState extends State<Collector> {
  static final List<_CollectorState> _collectorStack = [];
  final Set<ChangeNotifier> _notifiers = {};

  void addViewNotifier(ChangeNotifier notifier) {
    if (_notifiers.add(notifier)) {
      notifier.addListener(_notifyView);
    }
  }

  @override
  void dispose() {
    super.dispose();
    for (final notifier in _notifiers) {
      notifier.removeListener(_notifyView);
    }
  }

  void _notifyView() => setState(() {});

  @override
  Widget build(BuildContext context) {
    _collectorStack.add(this); // Empilha o coletor atual
    final collectorAsWidget = widget.builder(context);
    _collectorStack.removeLast(); // Remove ao sair do escopo

    return collectorAsWidget;
  }

  static _CollectorState? get currentCollector =>
      _collectorStack.isNotEmpty ? _collectorStack.last : null;
}
