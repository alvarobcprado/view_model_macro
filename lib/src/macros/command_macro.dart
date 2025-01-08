// ignore_for_file: deprecated_member_use

import 'dart:async';

import 'package:macros/macros.dart';
import 'package:view_model_macro/src/utils/libraries.dart';
import 'package:view_model_macro/src/utils/macro_extensions.dart';

/// {@template CommandMacro}
/// A macro for building Commands for a ViewModel.
/// {@endtemplate}
macro class CommandMacro implements MethodDeclarationsMacro {
  /// {@macro CommandMacro}
  const CommandMacro();

  @override
  FutureOr<void> buildDeclarationsForMethod(
    MethodDeclaration method,
    MemberDeclarationBuilder builder,
  ) async {
    final name = method.name;
    final publicName = name.substring(1);

    if (method.isGetter || method.isSetter || !name.startsWith('_')) {
      builder.reportDiagnostic(
        'Only private methods are allowed to be Commands.',
        Severity.error,
      );
      return;
    }

    final namedReturnType = method.returnType.checkNamed(builder);

    if (namedReturnType == null) {
      builder.reportDiagnostic(
        'Only methods with named return types are allowed to be Commands.',
        Severity.error,
      );
      return;
    }

    final futureIdentifier = await builder.resolveIdentifier(
      dartAsync,
      'Future',
    );

    final returnType = await builder.resolve(namedReturnType.code);
    final futureType = await builder.resolve(
      NamedTypeAnnotationCode(name: futureIdentifier),
    );

    final isSameSubtype = await returnType.isSubtypeOf(futureType);
    final hasNamedGeneric = namedReturnType.typeArguments.isNotEmpty;

    if (!isSameSubtype || !hasNamedGeneric) {
      builder.reportDiagnostic(
        'Only methods with return type Future<T> are allowed to be Commands.',
        Severity.error,
      );
      return;
    }

    final namedParameters = method.namedParameters;
    if (namedParameters.isNotEmpty) {
      builder.reportDiagnostic(
        'Only methods with positional parameters are allowed to be Commands.',
        Severity.error,
      );
      return;
    }

    final positionalParameters = method.positionalParameters;
    if (positionalParameters.length > 2) {
      builder.reportDiagnostic(
        'Only methods with 2 or less positional parameters are allowed to '
        'be Commands.',
        Severity.error,
      );
      return;
    }

    final parameterCount = positionalParameters.length;

    final command = await builder.resolveIdentifier(
      commandCore,
      'Command$parameterCount',
    );

    builder.declareInType(
      DeclarationCode.fromParts(
        [
          '  late final ',
          command,
          '<',
          namedReturnType.typeArguments.first.code,
          if (namedReturnType.isNullable) '?',
          '>',
          ' $publicName = ',
          command,
          '(${method.name});\n',
        ],
      ),
    );
  }
}
