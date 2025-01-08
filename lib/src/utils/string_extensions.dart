// ignore_for_file: public_member_api_docs

extension StringX on String {
  String get capitalizeFirst => '${this[0].toUpperCase()}${substring(1)}';
  String get lowerFirst => '${this[0].toLowerCase()}${substring(1)}';
  String get public => startsWith('_') ? substring(1).lowerFirst : lowerFirst;
  String get private => startsWith('_') ? lowerFirst : '_$lowerFirst';
  String withoutSuffix(String suffix) => endsWith(suffix)
      ? substring(0, length - suffix.length).lowerFirst
      : lowerFirst;
  String withoutPrefix(String prefix) =>
      startsWith(prefix) ? substring(prefix.length).lowerFirst : lowerFirst;
}
