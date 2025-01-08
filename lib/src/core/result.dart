import 'dart:async';

/// Represents a sealed result that can hold either a successful data value [T]
/// or an error value.
///
/// This class is sealed and can only be useg with the [Result.success]
/// and [Result.error] constructors
sealed class Result<T> {
  const Result();

  /// Creates a [Result] representing a successful result with the specified
  /// [data] of type [T].
  const factory Result.success(T data) = Success<T>._;

  /// Creates a [Result] representing an error with the specified [exception]
  const factory Result.error(Object exception) = Error<T>._;

  /// Creates a [Result] wrapping the specified [fn] function call.
  /// If the function call throws an exception, it is caught and wrapped in an
  /// error result.
  ///
  /// The [onError] function can be used to map the exception to a different
  /// type.
  static Result<T> guard<T>(
    T Function() fn, {
    Object Function(Object)? onError,
  }) {
    try {
      return Result.success(fn());
    } catch (e) {
      return Result.error(onError?.call(e) ?? e);
    }
  }

  /// Creates a [Result] wrapping the specified async [fn] function call.
  /// If the function call throws an exception, it is caught and wrapped in an
  /// error result.
  ///
  /// The [onError] function can be used to map the exception to a different
  /// type.
  static Future<Result<T>> asyncGuard<T>(
    Future<T> Function() fn, {
    Object Function(Object)? onError,
  }) async {
    try {
      return Result.success(await fn());
    } catch (e) {
      return Result.error(onError?.call(e) ?? e);
    }
  }
}

/// Represents a successful [Result] holding the [data] value.
class Success<T> extends Result<T> {
  const Success._(this.data);

  /// The data value of the successful result.
  final T data;
}

/// Represents an error [Result] holding the [exception].
class Error<T> extends Result<T> {
  const Error._(this.exception);

  /// The exception value of the error result.
  final Object exception;
}

/// Extension methods for [Result] to provide convenient operations.
extension ResultExtension<T> on Result<T> {
  /// Performs a conditional execution based on the type of the [Result].
  ///
  /// The [success] function is invoked if the [Result] is a successful
  /// result with [T] data, and the [error] function is invoked if it is an
  /// error result with exception.
  R when<R>({
    required R Function(T data) success,
    required R Function(Object exception) error,
  }) {
    return switch (this) {
      Success(:final data) => success(data),
      Error(:final exception) => error(exception),
    };
  }

  /// Performs a conditional execution based on the type of the [Result],
  /// allowing the functions to be nullable.
  ///
  /// The [success] function is invoked if the [Result] is a successful
  /// result with [T] data, and the [error] function is invoked if it is an
  /// error result with exception.
  ///
  /// If the [Result] is either two types and the function of this type is
  /// null, it returns null.
  R? maybeWhen<R>({
    R Function(T data)? success,
    R Function(Object exception)? error,
  }) {
    return switch (this) {
      Success(:final data) => success?.call(data),
      Error(:final exception) => error?.call(exception),
    };
  }

  /// Retrieves the data value of the [Result] if it is a successful result,
  /// otherwise returns null.
  T? get dataOrNull {
    return maybeWhen(
      success: (data) => data,
    );
  }

  /// Retrieves the exception value of the [Result] if it is an error result,
  /// otherwise returns null.
  Object? get exceptionOrNull {
    return maybeWhen(
      error: (exception) => exception,
    );
  }

  /// Verifies if the [Result] is a success type
  bool get isSuccess => this is Success;

  /// Verifies if the [Result] is an error type
  bool get isError => this is Error;
}

/// Extension methods for [Future<Result>] to provide convenient operations.
extension AsyncResultExtension<T, E> on Future<Result<T>> {
  /// Performs a conditional execution based on the type of the [Result].
  Future<R> thenWhen<R>({
    required R Function(T data) success,
    required R Function(Object exception) error,
  }) async {
    return then((result) {
      return result.when(
        success: success,
        error: error,
      );
    });
  }

  /// Performs a conditional execution based on the type of the [Result],
  /// allowing the functions to be nullable.
  Future<R?> thenMaybeWhen<R>({
    R Function(T data)? success,
    R Function(Object exception)? error,
  }) async {
    return then((result) {
      return result.maybeWhen(
        success: success,
        error: error,
      );
    });
  }

  /// Retrieves the data value of the [Result] if it is a successful result,
  /// otherwise returns null.
  Future<T?> get dataOrNull async {
    return thenMaybeWhen(
      success: (data) => data,
    );
  }

  /// Retrieves the exception value of the [Result] if it is an error result,
  /// otherwise returns null.
  Future<Object?> get exceptionOrNull async {
    return thenMaybeWhen(
      error: (exception) => exception,
    );
  }

  /// Verifies if the [Result] returns a success type
  Future<bool> get isSuccess async {
    return then((result) async {
      return result.isSuccess;
    });
  }

  /// Verifies if the [Result] returns an error type
  Future<bool> get isError async {
    return then((result) async {
      return result.isError;
    });
  }
}

/// Extension methods for [Future] to provide convenient operations.
extension AsyncResultWrapperExtension<T> on Future<T> {
  /// Wraps the returned [Future] of type [T] in a [Result] of type
  /// [T, Object] and returns it.
  Future<Result<T>> get result async {
    return Result.asyncGuard(() async => this);
  }
}

/// Extension methods for [Result] to provide convenient operations.
extension ThrowableResultExtension<T> on Result<T> {
  /// Retrieves the data value of the [Result] if it is a successful result,
  /// otherwise throws exception.
  T get dataOrThrow {
    return when(
      success: (data) => data,
      // ignore: only_throw_errors
      error: (exception) => throw exception,
    );
  }
}

/// Extension methods for Future of [Result] to provide convenient operations.
extension ThrowableFutureResultExtension<T> on Future<Result<T>> {
  /// Retrieves the data value of the [Result] if it is a successful result,
  /// otherwise throws exception.
  Future<T> get dataOrThrow async {
    return thenWhen(
      success: (data) => data,
      // ignore: only_throw_errors
      error: (exception) => throw exception,
    );
  }
}
