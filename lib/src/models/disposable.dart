// ignore_for_file: one_member_abstracts

import 'package:view_model_macro/src/macros/macros_barrel.dart';

/// {@template Disposable}
/// A interface for [Disposable]s.
///
/// All [Disposable]s should implement this interface for macro [DisposeMacro]
/// to work.
/// {@endtemplate}
abstract interface class Disposable {
  /// The dispose method that should be implemented by all [Disposable]s.
  void dispose();
}
