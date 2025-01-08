// ignore_for_file: public_member_api_docs

import 'package:macros/macros.dart';

extension FieldX on FieldDeclaration {
  String get name => identifier.name;
}

extension MethodX on MethodDeclaration {
  String get name => identifier.name;
}

extension ClassX on ClassDeclaration {
  String get name => identifier.name;
}

extension DiagnosticDeclarationBuilderX on DeclarationBuilder {
  void reportDiagnostic(
    String message,
    Severity severity, {
    DiagnosticTarget? target,
  }) {
    report(Diagnostic(DiagnosticMessage(message, target: target), severity));
  }
}

extension DiagnosticDefinitionBuilderX on DefinitionBuilder {
  void reportDiagnostic(
    String message,
    Severity severity, {
    DiagnosticTarget? target,
  }) {
    report(Diagnostic(DiagnosticMessage(message, target: target), severity));
  }
}

extension TypeAnnotationX on TypeAnnotation {
  T cast<T extends TypeAnnotation>() => this as T;

  NamedTypeAnnotation? checkNamed(Builder builder) {
    if (this is NamedTypeAnnotation) return this as NamedTypeAnnotation;
    if (this is OmittedTypeAnnotation) {
      builder.report(
        Diagnostic(
          DiagnosticMessage(
            'Only fields with explicit types are allowed.',
            target: asDiagnosticTarget,
          ),
          Severity.error,
        ),
      );
    } else {
      builder.report(
        Diagnostic(
          DiagnosticMessage(
            'Only fields with named types are allowed.',
            target: asDiagnosticTarget,
          ),
          Severity.error,
        ),
      );
    }
    return null;
  }
}
