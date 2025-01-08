part of 'command.dart';

/// Represents the current state of a [Command].
sealed class CommandState<T> {
  const CommandState();

  /// Verifies if the [Command] is in idle state
  bool get isIdle => this is CommandIdle;

  /// Verifies if the [Command] is running
  bool get isRunning => this is CommandRunning;

  /// Verifies if the [Command] is an error
  bool get isError => this is CommandError;

  /// Verifies if the [Command] is completed
  bool get isCompleted => this is CommandCompleted;
}

/// {@template CommandIdle}
/// Represents the idle state of a [Command].
/// {@endtemplate}
final class CommandIdle<T> extends CommandState<T> {
  /// {@macro CommandIdle}
  const CommandIdle();
}


/// {@template CommandRunning}
/// Represents the running state of a [Command].
/// {@endtemplate}
final class CommandRunning<T> extends CommandState<T> {
  /// {@macro CommandRunning}
  const CommandRunning();
}

/// {@template CommandError}
/// Represents the error state of a [Command].
/// {@endtemplate}
final class CommandError<T> extends CommandState<T> {
  /// {@macro CommandError}
  const CommandError(this.error);

  /// The error value resulted from the [Command].
  final Object error;
}


/// {@template CommandCompleted}
/// Represents the completed state of a [Command].
/// {@endtemplate}
final class CommandCompleted<T> extends CommandState<T> {
  /// {@macro CommandCompleted}
  const CommandCompleted(this.result);

  /// The result value completed from the [Command].
  final Result<T> result;
}
