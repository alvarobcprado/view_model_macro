// ignore_for_file: public_member_api_docs

extension StringX on String {
  String get capitalizeFirst => '${this[0].toUpperCase()}${substring(1)}';
  String get public => startsWith('_') ? substring(1) : this;
  String get private => startsWith('_') ? this : '_$this';
  String withoutSuffix(String suffix) =>
      endsWith(suffix) ? substring(0, length - suffix.length) : this;
  String withoutPrefix(String prefix) =>
      startsWith(prefix) ? substring(prefix.length) : this;
}
