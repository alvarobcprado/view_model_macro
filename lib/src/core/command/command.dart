import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';
import 'package:view_model_macro/src/core/result.dart';

part 'command_state.dart';
part 'commands.dart';

/// Facilitates interaction with a ViewModel.
///
/// Encapsulates an action,
/// exposes its running and error states,
/// and ensures that it can't be launched again until it finishes.
///
/// Use [Command0] for actions without arguments.
/// Use [Command1] for actions with one argument.
///
/// Actions must return a [Result].
///
/// Consume the action result by listening to changes,
/// then call to [reset] when the state is consumed.
abstract class Command<T> extends ChangeNotifier {
  CommandState<T> _state = const CommandIdle();

  /// The current state of the [Command].
  CommandState<T> get state => getValue(_state);

  /// Indicates if the [Command] is running.
  bool get isRunning => state.isRunning;

  /// Indicates if the [Command] is in an error state.
  bool get isError => state.isError;

  /// Indicates if the [Command] is completed.
  bool get isCompleted => state.isCompleted;


  /// Returns the current [CommandState] and adds the [Command] to the current 
  /// collector.
  @internal
  R getValue<R>(R value) {
    final currentCollector = _CommandCollectorState._currentCollector;
    if (currentCollector != null) {
      currentCollector.addCommand(this);
    }
    return value;
  }

  Future<void> _run(CommandAction0<T> action) async {
    if (isRunning) return;

    _state = const CommandRunning();
    notifyListeners();

    try {
      final result = await action();
      _state = CommandCompleted(Result.success(result));
    } catch (e) {
      _state = CommandError(e);
    } finally {
      notifyListeners();
    }
  }

  /// Resets the current [Command] state.
  void reset() {
    _state = const CommandIdle();
    notifyListeners();
  }
}

/// {@template CommandCollector}
/// Collects [Command]s and updates the widget tree based on their state.
/// {@endtemplate}
class CommandCollector extends StatefulWidget {
  /// {@macro CommandCollector}
  const CommandCollector(this.builder, {super.key});

  /// {@macro CommandCollector}
  final Widget Function(BuildContext) builder;

  @override
  State<CommandCollector> createState() => _CommandCollectorState();
}

class _CommandCollectorState extends State<CommandCollector> {
  static final List<_CommandCollectorState> _collectorStack = [];

  static _CommandCollectorState? get _currentCollector =>
      _collectorStack.isNotEmpty ? _collectorStack.last : null;
  final Set<Command<dynamic>> _commands = {};

  void addCommand(Command<dynamic> command) {
    if (_commands.add(command)) {
      command.addListener(_update);
    }
  }

  void _update() => setState(() {});

  @override
  void dispose() {
    for (final command in _commands) {
      command.removeListener(_update);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _CommandCollectorState._collectorStack.add(this);
    final result = widget.builder(context);
    _CommandCollectorState._collectorStack.removeLast();
    return result;
  }
}
