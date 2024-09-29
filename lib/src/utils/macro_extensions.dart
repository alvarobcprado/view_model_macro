import 'package:macros/macros.dart';

extension FieldX on FieldDeclaration {
  String get name => identifier.name;
}

extension MethodX on MethodDeclaration {
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
