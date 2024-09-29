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

    final valueNotifier = await builder.resolveIdentifier(
      flutterFoundation,
      'ValueNotifier',
    );

    for (final field in fields) {
      final name = field.name;
      final notifierName = '${name}Notifier';
      final notifierGetterName =
          '${name.public.withoutSuffix('State')}Notifier';
      final stateName = '${name.public.withoutSuffix('State')}Value';
      final emitterName =
          'emit${name.public.capitalizeFirst.withoutSuffix('State')}';

      builder
        ..declareInType(
          DeclarationCode.fromParts([
            '  late final $notifierName = ',
            valueNotifier,
            '<',
            field.type.code,
            '>($name);',
          ]),
        )
        ..declareInType(
          DeclarationCode.fromParts([
            '  ',
            valueNotifier,
            '<',
            field.type.code,
            '> get $notifierGetterName => $notifierName;',
          ]),
        )
        ..declareInType(
          DeclarationCode.fromParts([
            '  ',
            field.type.code,
            ' get $stateName => $notifierName.value;',
          ]),
        )
        ..declareInType(
          DeclarationCode.fromParts([
            '  void $emitterName(',
            field.type.code,
            ' value) => $notifierName.value = value;',
          ]),
        );
    }
  }
}
