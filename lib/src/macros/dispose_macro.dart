// ignore_for_file: deprecated_member_use

import 'dart:async';

import 'package:macros/macros.dart';
import 'package:view_model_macro/src/notifiers/notifiers_barrel.dart';
import 'package:view_model_macro/src/utils/libraries.dart';
import 'package:view_model_macro/src/utils/macro_extensions.dart';

/// {@template DisposeMacro}
/// A macro for building `dispose` method for [Notifier]s in the class.
/// 
/// For every [Notifier] in the class with the `@DisposeMacro()` annotation, the
/// macro will generate the following:
/// - A `dispose` method that will call dispose on all [Notifier]s declared in 
/// the class.
/// 
/// See more:
/// - [StateMacro]: The macro for building [StateNotifier]s.
/// - [ActionMacro]: The macro for building [ActionNotifier]s.
/// - [ViewModel]: The macro for building ViewModels.
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

    final fields = await builder.fieldsOf(clazz);

    final notifier = await builder.resolveIdentifier(
      notifierCore,
      'Notifier',
    );

    final disposableFields = <FieldDeclaration>[];
    for (final field in fields) {
      final type = field.type is OmittedTypeAnnotation
          ? await builder.inferType(field.type as OmittedTypeAnnotation)
          : field.type.code;

      final fieldType = await builder.resolve(type.code);
      final notifierType = await builder.resolve(
        NamedTypeAnnotationCode(name: notifier),
      );

      if (await fieldType.isSubtypeOf(notifierType)) {
        disposableFields.add(field);
      }
    }

    disposeBuilder.augment(
      FunctionBodyCode.fromParts([
        '{\n',
        for (final field in disposableFields) '    ${field.name}.dispose();\n',
        '  }',
      ]),
    );
  }
}
