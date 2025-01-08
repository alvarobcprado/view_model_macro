import 'dart:async';

import 'package:macros/macros.dart';
import 'package:view_model_macro/src/macros/dispose_macro.dart';
import 'package:view_model_macro/src/macros/fields_macro.dart';

/// {@template ViewModel}
/// Macro for build a ViewModel based on its states and optional actions.
///
/// For every private field in the class with the `@ViewModelMacro()` annotation
/// the macro will generate the following:
/// - A public getter for the current field
/// - A protected setter for the current field
///

/// The macro will also generate a `dispose` method that will dispose all
/// the listeners.
///
/// See more:
/// - [DisposeMacro]: The macro for building `dispose` methods.
/// {@endtemplate}
macro class ViewModelMacro implements ClassDeclarationsMacro, 
ClassDefinitionMacro {
  /// {@macro ViewModel}
  const ViewModelMacro();

  @override
  FutureOr<void> buildDeclarationsForClass(
    ClassDeclaration clazz,
    MemberDeclarationBuilder builder,
  ) async {
    await const FieldsMacro().buildDeclarationsForClass(clazz, builder);
  }

  @override
  FutureOr<void> buildDefinitionForClass(
    ClassDeclaration clazz,
    TypeDefinitionBuilder builder,
  ) async {
    await const FieldsMacro().buildDefinitionForClass(clazz, builder);
  }
}
