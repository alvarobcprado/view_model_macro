import 'dart:async';

import 'package:macros/macros.dart';
import 'package:view_model_macro/src/macros/action_macro.dart';
import 'package:view_model_macro/src/macros/dispose_macro.dart';
import 'package:view_model_macro/src/macros/state_macro.dart';

macro class ViewModel implements ClassDeclarationsMacro, ClassDefinitionMacro {
  const ViewModel({this.enableActions = true});

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
