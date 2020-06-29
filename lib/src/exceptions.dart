class InvalidApiModeException implements Exception {
  String mode;

  InvalidApiModeException(this.mode);

  @override
  String toString() => 'Invalid mode "$mode"';
}
