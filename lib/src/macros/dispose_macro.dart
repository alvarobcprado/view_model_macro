import 'dart:async';

import 'package:macros/macros.dart';
import 'package:view_model_macro/src/utils/libraries.dart';
import 'package:view_model_macro/src/utils/macro_extensions.dart';

macro class DisposeMacro
    implements ClassDeclarationsMacro, ClassDefinitionMacro {
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

    await declareDisposeMethod(clazz, builder);
  }

  FutureOr<void> declareDisposeMethod(
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
