class Failure {
  final String message;
  Failure([this.message = 'Something went wrong']);

  @override
  String toString() => message;
}
