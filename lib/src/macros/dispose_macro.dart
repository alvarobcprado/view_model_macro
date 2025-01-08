// ignore_for_file: deprecated_member_use

import 'dart:async';

import 'package:macros/macros.dart';
import 'package:view_model_macro/src/macros/view_model_macro.dart';
import 'package:view_model_macro/src/utils/macro_extensions.dart';

/// {@template DisposeMacro}
/// A macro for building `dispose` method 
/// 
/// See more:
/// - [ViewModelMacro]: The macro for building ViewModels.
/// {@endtemplate}
macro class DisposeMacro
    implements ClassDeclarationsMacro, ClassDefinitionMacro {
  /// {@macro DisposeMacro}
  const DisposeMacro();

  @override
  FutureOr<void> buildDeclarationsForClass(
    ClassDeclaration clazz,
    MemberDeclarationBuilder builder,
  ) async {
    final methods = await builder.methodsOf(clazz);

    // check if dispose method exists
    if (methods.any((method) => method.name == 'dispose')) {
      return;
    }

    await _declareDisposeMethod(clazz, builder);
  }

  FutureOr<void> _declareDisposeMethod(
    ClassDeclaration clazz,
    MemberDeclarationBuilder builder,
  ) async {
    builder.declareInType(
      DeclarationCode.fromParts([
        '  external void dispose();\n',
      ]),
    );
  }

  @override
  FutureOr<void> buildDefinitionForClass(
    ClassDeclaration clazz,
    TypeDefinitionBuilder builder,
  ) async {
    final methods = await builder.methodsOf(clazz);

    methods.removeWhere((method) => method.name != 'dispose');

    if (methods.isEmpty) return;

    final dispose = methods.first;

    if (!dispose.hasExternal) return;

    final disposeBuilder = await builder.buildMethod(dispose.identifier);

    final disposableFields = <FieldDeclaration>[];

    disposeBuilder.augment(
      FunctionBodyCode.fromParts([
        '{\n',
        for (final field in disposableFields) '    ${field.name}.dispose();\n',
        '    super.dispose();\n',
        '  }',
        '\n',
      ],),
    );
  }
}
