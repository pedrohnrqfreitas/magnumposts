class Failure {
  final String message;
  final String? code;
  final dynamic data;

  Failure({
    required this.message,
    this.code,
    this.data,
  });

  @override
  String toString() => message;
}