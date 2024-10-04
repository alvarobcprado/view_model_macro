// ignore_for_file: deprecated_member_use

import 'dart:async';

import 'package:macros/macros.dart';
import 'package:view_model_macro/src/notifiers/notifiers_barrel.dart';
import 'package:view_model_macro/src/utils/libraries.dart';
import 'package:view_model_macro/src/utils/macro_extensions.dart';
import 'package:view_model_macro/src/utils/string_extensions.dart';

/// {@template StateMacro}
/// A macro for building [StateNotifier]s utility methods.
///
/// For every [StateNotifier] in the class with the `@StateMacro()` annotation,
/// the macro will generate the following:
/// - A public getter for the stream of states from the [StateNotifier].
/// - A private getter for the current state from the [StateNotifier].
/// - A private method to emit a new state to the [StateNotifier].
///
/// See more:
/// - [ActionMacro]: The macro for building [ActionNotifier]s.
/// - [DisposeMacro]: The macro for building `dispose` methods.
/// - [ViewModel]: The macro for building ViewModels.
/// {@endtemplate}
macro class StateMacro implements ClassDeclarationsMacro {
  /// {@macro StateMacro}
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
    final stateNotifierIdentifier = await builder.resolveIdentifier(
      notifierCore,
      'StateNotifier',
    );

    final stateNotifierType = await builder.resolve(
      NamedTypeAnnotationCode(name: stateNotifierIdentifier),
    );

    final streamIdentifier = await builder.resolveIdentifier(
      notifierCore,
      'StateStream',
    );

    final classFields = await builder.fieldsOf(clazz);

    final stateNotifierFields = <FieldDeclaration>[];


    for (final field in classFields) {
      // For now, declaration phase only supports NamedTypeAnnotation
      if(field.type is OmittedTypeAnnotation) {
        builder.reportDiagnostic(
          'Only named types are supported in this macro. e.g: '
          '<Type> ${field.name}',
          Severity.warning,
          target: field.asDiagnosticTarget,
        );
        continue;
      }

      final type = await builder.resolve(field.type.code);
      final isPrivate = field.name.startsWith('_');
      final isState = await type.isSubtypeOf(stateNotifierType);

      if (isState) {
        if (!isPrivate) {
          builder.reportDiagnostic(
            'StateNotifier type must be private.',
            Severity.error,
            target: field.asDiagnosticTarget,
          );
          continue;
        }
        stateNotifierFields.add(field);
      }
    }

    for (final field in stateNotifierFields) {
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
          'StateNotifier type must be specified at declaration. e.g: '
          'final StateNotifier<int> _valueState = StateNotifier();',
          Severity.error,
          target: field.asDiagnosticTarget,
        );
      }

      builder
        ..declareInType(
          DeclarationCode.fromParts([
            '  ',
            streamIdentifier,
            '<',
            innerType.code,
            '> get $notifierGetterName => $notifierName.stateStream;',
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
            ' value) => $notifierName.notify(value);',
            '\n',
          ]),
        );
    }
  }
  
}
