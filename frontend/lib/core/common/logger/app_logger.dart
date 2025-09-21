import 'package:logger/logger.dart';

class AppLogger {
  static final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 2,
      errorMethodCount: 5,
      lineLength: 100,
      colors: true,
      printEmojis: true,
      printTime: true,
    ),
  );

  static void i(dynamic message) {
    _logger.i('Info message\nMessage: $message');
  }

  static void d(dynamic message) {
    _logger.d('Log message with 2 methods\nMessage: $message');
  }

  static void w(dynamic message) {
    _logger.w('Just a warning!\nMessage: $message');
  }

  static void e(dynamic message, [StackTrace? stackTrace]) {
    _logger.e(
      'Error! Something bad happened\nMessage: $message',
      stackTrace: stackTrace,
    );
  }
}
