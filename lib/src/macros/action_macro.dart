// ignore_for_file: deprecated_member_use

import 'dart:async';

import 'package:macros/macros.dart';
import 'package:view_model_macro/src/models/models_barrel.dart';
import 'package:view_model_macro/src/utils/libraries.dart';
import 'package:view_model_macro/src/utils/macro_extensions.dart';
import 'package:view_model_macro/src/utils/string_extensions.dart';

/// {@template ActionMacro}
/// A macro for building [ActionNotifier]s utility methods.
///
/// For every [ActionNotifier] in the class with the `@ActionMacro()`
/// annotation, the macro will generate the following:
/// - A public getter for the stream of actions from the [ActionNotifier].
/// - A private method to dispatch a new action to the [ActionNotifier].
///
/// See more:
/// - [DisposeMacro]: The macro for building `dispose` methods.
/// - [StateMacro]: The macro for building [StateNotifier]s.
/// - [ViewModel]: The macro for building ViewModels.
/// {@endtemplate}
macro class ActionMacro implements ClassDeclarationsMacro {
  /// {@macro ActionMacro}
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
    final actionNotifierIdentifier = await builder.resolveIdentifier(
      actionNotifierCore,
      'ActionNotifier',
    );

    final actionNotifierType = await builder.resolve(
      NamedTypeAnnotationCode(name: actionNotifierIdentifier),
    );

    final streamIdentifier = await builder.resolveIdentifier(
      dartAsyncCore,
      'Stream',
    );

    final classFields = await builder.fieldsOf(clazz);

    final actionNotifierFields = <FieldDeclaration>[];

    for (final field in classFields) {
      if (field.type is OmittedTypeAnnotation) {
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
      final isAction = await type.isSubtypeOf(actionNotifierType);

      if (isAction) {
        if (!isPrivate) {
          builder.reportDiagnostic(
            'StateNotifier type must be private.',
            Severity.error,
            target: field.asDiagnosticTarget,
          );
          continue;
        }
        actionNotifierFields.add(field);
      }
    }

    for (final field in actionNotifierFields) {
      final name = field.name;
      final notifierName = name;
      final notifierGetterName = '${name.public.withoutSuffix('Action')}Stream';
      final emitterName =
          '_dispatch${name.public.capitalizeFirst.withoutSuffix('Action')}';

      final fieldType = field.type as NamedTypeAnnotation;
      final innerType = fieldType.typeArguments.firstOrNull;

      if (innerType is! NamedTypeAnnotation) {
        return builder.reportDiagnostic(
          'ActionNotifier type must be specified at declaration. e.g: '
          'final ActionNotifier<int> _valueState = ActionNotifier();',
          Severity.error,
          target: field.asDiagnosticTarget,
        );
      }

      final isVoid = innerType.identifier.name == 'void';

      builder
        ..declareInType(
          DeclarationCode.fromParts([
            '  ',
            streamIdentifier,
            '<',
            innerType.code,
            '> get $notifierGetterName => $notifierName.stream;',
          ]),
        )
        ..declareInType(
          DeclarationCode.fromParts([
            '  void $emitterName(',
            if (!isVoid) ...[innerType.code, ' value'],
            ') => $notifierName.notify(${isVoid ? null : 'value'});',
            '\n',
          ]),
        );
    }
  }
}
