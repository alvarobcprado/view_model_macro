// ignore_for_file: public_member_api_docs

import 'dart:async';

import 'package:macros/macros.dart';
import 'package:view_model_macro/src/utils/libraries.dart';
import 'package:view_model_macro/src/utils/macro_extensions.dart';

macro class DebouncerMacro
    implements MethodDeclarationsMacro, MethodDefinitionMacro {
  const DebouncerMacro(this.milliseconds);

  final int milliseconds;

  @override
  FutureOr<void> buildDefinitionForMethod(
    MethodDeclaration method,
    FunctionDefinitionBuilder builder,
  ) async {
    if (!method.hasBody) {
      builder.reportDiagnostic(
        'Debounced method must have a body',
        Severity.error,
        target: method.asDiagnosticTarget,
      );
    }

    builder.augment(
      FunctionBodyCode.fromParts(
        [
          '{\n',
          '    _${method.name}Debouncer((){\n',
          '      augmented();\n',
          '    });',
          '\n  }',
        ],
      ),
    );
  }

  @override
  FutureOr<void> buildDeclarationsForMethod(
    MethodDeclaration method,
    MemberDeclarationBuilder builder,
  ) async {
    if (!method.hasBody) {
      builder.reportDiagnostic(
        'Debounced method must have a body',
        Severity.error,
        target: method.asDiagnosticTarget,
      );
    }

    final debouncerIdentifier = await builder.resolveIdentifier(
      debouncerCore,
      'Debouncer',
    );

    builder.declareInType(
      DeclarationCode.fromParts(
        [
          'final ',
          debouncerIdentifier,
          ' _${method.name}Debouncer = ',
          debouncerIdentifier,
          '($milliseconds);',
        ],
      ),
    );
  }
}
