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

    final stateNotifier = await builder.resolveIdentifier(
      viewModelMacro,
      'StateNotifier',
    );

    fields.removeWhere((field) {
      final isPrivate = field.name.startsWith('_');
      final isState = field.name.endsWith('State');

      return !isPrivate || !isState;
    });

    final stream = await builder.resolveIdentifier(
      dartAsync,
      'Stream',
    );

    for (final field in fields) {
      final name = field.name;
      final notifierName = '${name}Notifier';
      final stateName = '${name.public.withoutSuffix('State')}Value';
      final notifierGetterName = '${name.public.withoutSuffix('State')}Stream';
      final emitterName =
          '_emit${name.public.capitalizeFirst.withoutSuffix('State')}';

      builder
        ..declareInType(
          DeclarationCode.fromParts([
            '  late final $notifierName = ',
            stateNotifier,
            '<',
            field.type.code,
            '>($name);',
          ]),
        )
        ..declareInType(
          DeclarationCode.fromParts([
            '  ',
            stream,
            '<',
            field.type.code,
            '> get $notifierGetterName => $notifierName.stream;',
          ]),
        )
        ..declareInType(
          DeclarationCode.fromParts([
            '  ',
            field.type.code,
            ' get $stateName => $notifierName.state;',
          ]),
        )
        ..declareInType(
          DeclarationCode.fromParts([
            '  void $emitterName(',
            field.type.code,
            ' value) => $notifierName.emit(value);',
          ]),
        );
    }
  }
}
