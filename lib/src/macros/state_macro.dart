import 'dart:async';

import 'package:macros/macros.dart';
import 'package:view_model_macro/src/utils/libraries.dart';
import 'package:view_model_macro/src/utils/macro_extensions.dart';
import 'package:view_model_macro/src/utils/string_extensions.dart';

macro class StateMacro implements ClassDeclarationsMacro {
  const StateMacro();

  @override
  FutureOr<void> buildDeclarationsForClass(
    ClassDeclaration clazz,
    MemberDeclarationBuilder builder,
  ) async {
    builder.declareInLibrary(
      DeclarationCode.fromString(
        "import 'package:view_model_macro/view_model_macro.dart';\n",
      ),
    );
    await _declareStates(clazz, builder);
  }

  FutureOr<void> _declareStates(
    ClassDeclaration clazz,
    MemberDeclarationBuilder builder,
  ) async {
    final fields = await builder.fieldsOf(clazz);

    fields.removeWhere((field) {
      final isPrivate = field.name.startsWith('_');
      final isState = field.name.endsWith('State');

      return !isPrivate || !isState;
    });

    final stateNotifier = await builder.resolveIdentifier(
      stateNotifierCore,
      'StateNotifier',
    );

    final stateNotifierType =
        await builder.resolve(NamedTypeAnnotationCode(name: stateNotifier));

    final stateFields = <FieldDeclaration>[];
    for (final field in fields) {
      final isPrivate = field.name.startsWith('_');
      final isState = field.name.endsWith('State');

      if (!isPrivate || !isState) continue;

      if (field.type is OmittedTypeAnnotation) {
        return builder.reportDiagnostic(
          'StateNotifier type must be specified at declaration. e.g: final StateNotifier<int> _valueState = StateNotifier();',
          Severity.error,
          target: field.asDiagnosticTarget,
        );
      }

      final type = await builder.resolve(field.type.code);
      final isStateNotifier = await type.isSubtypeOf(stateNotifierType);

      if (isStateNotifier) {
        stateFields.add(field);
      }
    }

    final stream = await builder.resolveIdentifier(
      dartAsync,
      'Stream',
    );

    for (final field in stateFields) {
      final name = field.name;
      final notifierName = name;
      final stateName = '${name.withoutSuffix('State')}Value';
      final notifierGetterName = '${name.public.withoutSuffix('State')}Stream';
      final emitterName =
          '_emit${name.public.capitalizeFirst.withoutSuffix('State')}';

      final fieldType = field.type as NamedTypeAnnotation;
      final innerType = fieldType.typeArguments.firstOrNull;

      if (innerType is! NamedTypeAnnotation) {
        return builder.reportDiagnostic(
          'StateNotifier type must be specified at declaration. e.g: final StateNotifier<int> _valueState = StateNotifier();',
          Severity.error,
          target: field.asDiagnosticTarget,
        );
      }

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
            '  ',
            innerType.code,
            ' get $stateName => $notifierName.state;',
          ]),
        )
        ..declareInType(
          DeclarationCode.fromParts([
            '  void $emitterName(',
            innerType.code,
            ' value) => $notifierName.emit(value);',
          ]),
        );
    }
  }
}
