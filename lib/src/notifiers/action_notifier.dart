import 'dart:async';

import 'package:view_model_macro/src/notifiers/notifiers_barrel.dart';

/// The type wrapper for [Stream]s emitted by an [ActionNotifier].
extension type ActionStream<T>(Stream<T> stream) {}

/// {@template ActionNotifier}
/// A [Notifier] that can be used to dispatch actions from ViewModel to View.
///
/// It can't hold any data and only emits actions.
///
/// See more:
/// - [Notifier]: The base class for Notifiers.
/// - [StateNotifier]: The notifier that holds states.
/// {@endtemplate}
class ActionNotifier<T> extends Notifier<T> {
  /// {@macro ActionNotifier}
  ActionNotifier();

  /// Returns the stream of actions emitted by the [ActionNotifier].
  ActionStream<T> get actionStream => ActionStream<T>(stream);
}
