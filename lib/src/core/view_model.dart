import 'dart:async';

import 'package:macros/macros.dart';
import 'package:view_model_macro/src/macros/dispose_macro.dart';
import 'package:view_model_macro/src/macros/state_macro.dart';

macro class ViewModel implements ClassDeclarationsMacro, ClassDefinitionMacro {
  const ViewModel();

  @override
  FutureOr<void> buildDeclarationsForClass(
    ClassDeclaration clazz,
    MemberDeclarationBuilder builder,
  ) async {
    await const StateMacro().buildDeclarationsForClass(clazz, builder);
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
