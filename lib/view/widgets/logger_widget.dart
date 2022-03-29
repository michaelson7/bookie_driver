import 'package:logger/logger.dart';

loggerInfo({required String message}) {
  Logger logger = Logger();
  logger.i(message);
}

loggerAccent({required String message}) {
  Logger logger = Logger();
  logger.wtf(message);
}

loggerError({required String message}) {
  Logger logger = Logger();
  logger.e(message);
}
