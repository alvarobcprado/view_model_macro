import 'dart:async';

import 'package:macros/macros.dart';
import 'package:view_model_macro/src/utils/libraries.dart';
import 'package:view_model_macro/src/utils/macro_extensions.dart';
import 'package:view_model_macro/src/utils/string_extensions.dart';

macro class ActionMacro implements ClassDeclarationsMacro {
  const ActionMacro();

  @override
  FutureOr<void> buildDeclarationsForClass(
    ClassDeclaration clazz,
    MemberDeclarationBuilder builder,
  ) async {
    await _declareActions(clazz, builder);
  }

  FutureOr<void> _declareActions(
    ClassDeclaration clazz,
    MemberDeclarationBuilder builder,
  ) async {
    final classFields = await builder.fieldsOf(clazz);

    final fields = [...classFields]..removeWhere((field) {
        final isPrivate = field.name.startsWith('_');
        final isAction = field.name.endsWith('Action');

        return !isPrivate || !isAction;
      });

    final actionNotifier = await builder.resolveIdentifier(
      actionNotifierCore,
      'ActionNotifier',
    );

    final actionNotifierType =
        await builder.resolve(NamedTypeAnnotationCode(name: actionNotifier));

    final actionFields = <FieldDeclaration>[];
    for (final field in fields) {
      final isPrivate = field.name.startsWith('_');
      final isAction = field.name.endsWith('Action');

      if (!isPrivate || !isAction) continue;

      if (field.type is OmittedTypeAnnotation) {
        return builder.reportDiagnostic(
          'ActionNotifier type must be specified at declaration. e.g: final ActionNotifier<int> _valueAction = ActionNotifier();',
          Severity.error,
          target: field.asDiagnosticTarget,
        );
      }

      final type = await builder.resolve(field.type.code);
      final isActionNotifier = await type.isSubtypeOf(actionNotifierType);

      if (isActionNotifier) {
        actionFields.add(field);
      }
    }

    final stream = await builder.resolveIdentifier(
      dartAsync,
      'Stream',
    );

    for (final field in actionFields) {
      final name = field.name;
      final notifierName = name;
      final notifierGetterName = '${name.public.withoutSuffix('Action')}Stream';
      final emitterName =
          '_dispatch${name.public.capitalizeFirst.withoutSuffix('Action')}';

      final fieldType = field.type as NamedTypeAnnotation;
      final innerType = fieldType.typeArguments.firstOrNull;

      if (innerType is! NamedTypeAnnotation) {
        return builder.reportDiagnostic(
          'ActionNotifier type must be specified at declaration. e.g: final ActionNotifier<int> _valueState = ActionNotifier();',
          Severity.error,
          target: field.asDiagnosticTarget,
        );
      }

      final isVoid = innerType.identifier.name == 'void';

      builder
        ..declareInType(
          DeclarationCode.fromParts([
            '  ',
            stream,
            '<',
            innerType.code,
            '> get $notifierGetterName => $notifierName.stream;',
          ]),
        )
        ..declareInType(
          DeclarationCode.fromParts([
            '  void $emitterName(',
            if (!isVoid) ...[innerType.code, ' value'],
            ') => $notifierName.emit(${isVoid ? null : 'value'});',
            '\n',
          ]),
        );
    }
  }
}
