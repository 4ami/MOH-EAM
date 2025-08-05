part of 'extensions_module.dart';

extension LoggerExtension on Object {
  void logDebug({String? tag}) => Logger.d(toString(), tag: tag);
  void logInfo({String? tag}) => Logger.i(toString(), tag: tag);
  void logWarning({String? tag}) => Logger.w(toString(), tag: tag);
  void logError({String? tag}) => Logger.e(toString(), tag: tag);
}
