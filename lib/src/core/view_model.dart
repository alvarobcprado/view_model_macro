import 'dart:async';

import 'package:macros/macros.dart';
import 'package:view_model_macro/src/macros/action_macro.dart';
import 'package:view_model_macro/src/macros/dispose_macro.dart';
import 'package:view_model_macro/src/macros/state_macro.dart';
import 'package:view_model_macro/src/notifiers/notifiers_barrel.dart';

/// {@template ViewModel}
/// Macro for build a ViewModel based on its states and optional actions.
/// 
/// For every [StateNotifier] in the class with the `@ViewModel()` annotation,
/// the macro will generate the following:
/// - A public getter for the stream of states from the [StateNotifier].
/// - A private getter for the current state from the [StateNotifier].
/// - A private method to emit a new state to the [StateNotifier].
/// 
/// If [enableActions] is true, the macro will generate the following for every
/// [ActionNotifier] in the class:
/// - A public getter for the stream of actions from the [ActionNotifier].
/// - A private method to emit a new action to the [ActionNotifier].
/// 
/// The macro will also generate a `dispose` method that will dispose all
/// [StateNotifier]s and [ActionNotifier]s declared in the class.
/// 
/// See more:
/// - [StateMacro]: The macro for building [StateNotifier]s.
/// - [ActionMacro]: The macro for building [ActionNotifier]s.
/// - [DisposeMacro]: The macro for building `dispose` methods.
/// {@endtemplate}
macro class ViewModel implements ClassDeclarationsMacro, ClassDefinitionMacro {
  /// {@macro ViewModel}
  const ViewModel({this.enableActions = false});

  /// If true, the macro will generate utility methods for [ActionNotifier]s.
  /// The default value is false.
  final bool enableActions;

  @override
  FutureOr<void> buildDeclarationsForClass(
    ClassDeclaration clazz,
    MemberDeclarationBuilder builder,
  ) async {
    await const StateMacro().buildDeclarationsForClass(clazz, builder);
    if (enableActions) {
      await const ActionMacro().buildDeclarationsForClass(clazz, builder);
    }

    await const DisposeMacro().buildDeclarationsForClass(clazz, builder);
  }

  @override
  FutureOr<void> buildDefinitionForClass(
    ClassDeclaration clazz,
    TypeDefinitionBuilder builder,
  ) async {
    await const DisposeMacro().buildDefinitionForClass(clazz, builder);
  }
}
