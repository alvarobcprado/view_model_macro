// ignore_for_file: deprecated_member_use

import 'dart:async';

import 'package:macros/macros.dart';
import 'package:view_model_macro/src/utils/libraries.dart';
import 'package:view_model_macro/src/utils/macro_extensions.dart';

/// {@template FieldsMacro}
/// A macro for building getters and setters for the private fields of a 
/// ViewModel.
/// {@endtemplate}
macro class FieldsMacro implements ClassDeclarationsMacro, 
ClassDefinitionMacro {
  /// {@macro FieldsMacro}
  const FieldsMacro();

  @override
  FutureOr<void> buildDeclarationsForClass(
    ClassDeclaration clazz,
    MemberDeclarationBuilder builder,
  ) async {
    // Create getters for private fields
    final fields = await builder.fieldsOf(clazz);
    final privateFields = fields.where((e) => e.name.startsWith('_'));

    final protectedAnnotation = await builder.resolveIdentifier(
      metaCore,
      'protected',
    );

    for (final field in privateFields) {
      final publicName = field.name.substring(1);

      // Check and cast the type using our extension methods
      final namedType = field.type.checkNamed(builder);
      if (namedType == null) continue;

      builder
        // Declare the getter in the class
        ..declareInType(
          DeclarationCode.fromParts(
            [
              '  external ',
              namedType.identifier,
              if (namedType.isNullable) '?',
              ' get ',
              publicName,
              ';\n',
            ],
          ),
        )
        // Declare the setter in the class
        ..declareInType(
          DeclarationCode.fromParts(
            [
              '  @',
              protectedAnnotation,
              '\n',
              '  external void set ',
              publicName,
              '(',
              namedType.identifier,
              if (namedType.isNullable) '?',
              ' value',
              ');\n',
            ],
          ),
        );
    }
  }

  @override
  FutureOr<void> buildDefinitionForClass(
    ClassDeclaration clazz,
    TypeDefinitionBuilder builder,
  ) async {
    // Get all getter methods
    final methods = await builder.methodsOf(clazz);
    final getters = methods.where((m) => m.isGetter);
    final setters = methods.where((m) => m.isSetter);

    // Build the implementation for each getter and setter
    for (final getter in getters) {
      final getterMethod = await builder.buildMethod(getter.identifier);
      final fieldName = '_${getter.identifier.name}';

      getterMethod.augment(
        FunctionBodyCode.fromString('=> getValue($fieldName);\n'),
      );
    }

    for (final setter in setters) {
      final setterMethod = await builder.buildMethod(setter.identifier);
      final fieldName = setter.name;

      setterMethod.augment(
        FunctionBodyCode.fromParts(
          [
            '{\n',
            '    if(value != _$fieldName){\n',
            '      _$fieldName = value;\n',
            '    }',
            '\n  }\n',
          ],
        ),
      );
    }
  }
}
