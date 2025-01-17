part of 'command.dart';

/// Typedefs for a [Command] action without arguments.
typedef CommandAction0<T> = FutureOr<T> Function();

/// Typedefs for a [Command] action with one argument of type [A].
typedef CommandAction1<T, A> = FutureOr<T> Function(A);

/// Typedefs for a [Command] action with two arguments of type [A] and [B].
typedef CommandAction2<T, A, B> = FutureOr<T> Function(A, B);

/// Typedefs for a [Command] action with three arguments of type [A], [B] and 
/// [C].
typedef CommandAction3<T, A, B, C> = FutureOr<T> Function(A, B, C);

/// {@template Command0}
/// A [Command] to run an action without arguments.
/// Takes a [CommandAction0] as action.
/// {@endtemplate}
final class Command0<T> extends Command<T> {
  /// {@macro Command0}
  Command0(this._action);

  final CommandAction0<T> _action;

  /// Executes the action.
  Future<void> run() async {
    await _run(_action);
  }
}

/// {@template Command1}
/// A [Command] to run an action with one argument.
/// Takes a [CommandAction1] as action.
/// {@endtemplate}
final class Command1<T, A> extends Command<T> {
  /// {@macro Command1}
  Command1(this._action);

  final CommandAction1<T, A> _action;

  /// Executes the action with the p0.
  Future<void> run(A p0) async {
    await _run(() => _action(p0));
  }
}

/// {@template Command2}
/// A [Command] to run an action with two arguments.
/// Takes a [CommandAction2] as action.
/// {@endtemplate}
final class Command2<T, A, B> extends Command<T> {
  /// {@macro Command2}
  Command2(this._action);

  final CommandAction2<T, A, B> _action;

  /// Executes the action with the arguments.
  Future<void> run(A p0, B p1) async {
    await _run(() => _action(p0, p1));
  }
}

/// {@template Command3}
/// A [Command] to run an action with two arguments.
/// Takes a [CommandAction3] as action.
/// {@endtemplate}
final class Command3<T, A, B, C> extends Command<T> {
  /// {@macro Command3}
  Command3(this._action);

  final CommandAction3<T, A, B, C> _action;

  /// Executes the action with the arguments.
  Future<void> run(A p0, B p1, C p2) async {
    await _run(() => _action(p0, p1, p2));
  }
}
