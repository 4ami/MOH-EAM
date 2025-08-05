import 'dart:io';
import 'package:flutter/foundation.dart';

/// Describes the severity of a log message.
///
/// Each level has an associated numeric priority, an emoji symbol,
/// and a canonical name string. The lower the [level] value, the
/// less severe the log is considered.
///
/// Used to filter log messages based on configured threshold.
enum LogLevel {
  debug(0, '🐛', 'DEBUG'),
  info(1, 'ℹ️', 'INFO'),
  warning(2, '⚠️', 'WARNING'),
  error(3, '❌', 'ERROR'),
  critical(4, '💥', 'CRITICAL');

  const LogLevel(this.level, this.emoji, this.name);
  final int level;
  final String emoji, name;
}

/// Defines the target destination(s) for log output.
enum LogOut {
  /// Logs are printed to stdout (debugPrint).
  console,

  /// Logs are written to a file only.
  file,

  /// Logs are both printed to stdout and written to file.
  both,
}

/// Configuration options that control the behavior of the [Logger].
///
/// All parameters are immutable and can be replaced using [copyWith].
/// Use this class to customize log destinations, formatting, rotation,
/// verbosity, and error handling policies.
class LogConfig {
  final LogLevel level;
  final LogOut output;
  final bool useColor, useEmoji, includeStackTrace;
  final int maxFileSize, maxFiles;
  final String? logDir;
  final bool enableLogRotation, silentFailures, enableProductionLogging;
  final String dateFormat;

  /// Creates a custom logging configuration.
  ///
  /// This constructor supports full customization of logger features.
  const LogConfig({
    this.level = LogLevel.debug,
    this.output = LogOut.console,
    this.useColor = true,
    this.useEmoji = true,
    this.includeStackTrace = false,
    this.maxFileSize = 10 * (1024 ^ 2),
    this.maxFiles = 5,
    this.logDir,
    this.enableLogRotation = true,
    this.silentFailures = false,
    this.enableProductionLogging = true,
    this.dateFormat = 'yyyy-MM-dd HH:mm:ss.SSS',
  });

  /// Returns a new [LogConfig] with selected overrides.
  LogConfig copyWith({
    LogLevel? level,
    LogOut? output,
    bool? useColor,
    bool? useEmoji,
    bool? includeStackTrace,
    int? maxFileSize,
    int? maxFiles,
    String? logDir,
    bool? enableLogRotation,
    bool? silentFailures,
    bool? enableProductionLogging,
    String? dateFormat,
  }) {
    return LogConfig(
      level: level ?? this.level,
      output: output ?? this.output,
      useColor: useColor ?? this.useColor,
      useEmoji: useEmoji ?? this.useEmoji,
      includeStackTrace: includeStackTrace ?? this.includeStackTrace,
      maxFileSize: maxFileSize ?? this.maxFileSize,
      maxFiles: maxFiles ?? this.maxFiles,
      logDir: logDir,
      enableLogRotation: enableLogRotation ?? this.enableLogRotation,
      silentFailures: silentFailures ?? this.silentFailures,
      enableProductionLogging: enableLogRotation ?? this.silentFailures,
      dateFormat: dateFormat ?? this.dateFormat,
    );
  }

  @override
  String toString() {
    return "LogConfig(level: $level, output: $output, useColor: $useColor, useEmoji: $useEmoji, maxFiles: $maxFiles, maxFileSize: ${maxFileSize ~/ 1024}KB, productionLogging: $enableProductionLogging)";
  }
}

/// A singleton, environment-aware logging engine with support for:
/// - Console & file output
/// - Log rotation based on file size
/// - ANSI color & emoji formatting
/// - Dynamic configuration at runtime
///
/// Supports short static aliases (`Logger.d()`, `Logger.e()`, etc.)
/// and direct control via [Logger.instance].
///
/// Example usage:
/// ```dart
/// await Logger.instance.initLog(config: LoggerPresets.development);
/// Logger.i("App started");
/// ```
class Logger {
  // Singleton accessor
  static Logger? _instance;
  static Logger get instance => _instance ??= Logger._internal();

  Logger._internal();

  LogConfig _config = const LogConfig();
  File? _currentFile;
  String? _logDir;

  static const String _reset = '\x1B[0m';
  static const String _red = '\x1B[31m';
  static const String _yellow = '\x1B[33m';
  // static const String _blue = '\x1B[34m';
  static const String _green = '\x1B[32m';
  // static const String _purple = '\x1B[35m';
  static const String _cyan = '\x1B[36m';
  // static const String _white = '\x1B[37m';
  static const String _bold = '\x1B[1m';

  void _safePrint(String message, {bool isInternalError = false}) {
    if (kReleaseMode && !_config.enableProductionLogging) return;
    if (_config.silentFailures && isInternalError) return;
    if (kDebugMode) debugPrint(message);
  }

  /// Initializes the logger with the provided [config].
  ///
  /// Should be called once at application startup. If no config is provided,
  /// [LoggerPresets.development] is effectively used by default.
  ///
  /// If the output destination is file or both, this method will also
  /// create the log directory and initialize log rotation.
  Future<void> initLog({LogConfig? config}) async {
    _config = config ?? const LogConfig();

    if (_config.output == LogOut.console) {
      info('Logger initialized with config: ${_config.toString()}');
      return;
    }

    await _initializeFileLogging();
    info('Logger initialized with config: ${_config.toString()}');
  }

  /// Updates the current logger configuration at runtime.
  ///
  /// This can be used to reconfigure output destination or filters dynamically,
  /// such as toggling between verbose and silent logging.
  Future<void> configure(LogConfig config) async {
    _config = config;
    if (_config.output == LogOut.console) return;
    await _initializeFileLogging();
  }

  /// Ensures the log directory exists and prepares the current log file.
  ///
  /// This is triggered when file or both output types are selected.
  /// Also performs rotation if enabled.
  Future<void> _initializeFileLogging() async {
    if (kIsWeb) {
      _safePrint('File logging is not supported on the web.');
      return;
    }
    try {
      final String baseDir = _config.logDir ?? Directory.current.path;
      _logDir = "$baseDir/logs";
      final Directory logDir = Directory(_logDir!);

      if (!await logDir.exists()) {
        await logDir.create(recursive: true);
      }

      _currentFile = await _getCurrentFile();

      if (_config.enableLogRotation) {
        await _rotateLogsIfNeeded();
      }
    } catch (e) {
      _safePrint('Failed to initialize file logging:$e', isInternalError: true);
    }
  }

  /// Generates a new log file with timestamp in filename.
  ///
  /// Timestamp format is based on [LogConfig.dateFormat].
  Future<File> _getCurrentFile() async {
    final String timestamp = _format(DateTime.now(), _config.dateFormat);
    final String fileName = "app_log_$timestamp.log";
    return File('$_logDir/$fileName');
  }

  String _format(DateTime t, String format) {
    final y = t.year.toString();
    final mon = t.month.toString().padLeft(2, '0');
    final d = t.day.toString().padLeft(2, '0');
    final h = t.hour.toString().padLeft(2, '0');
    final m = t.minute.toString().padLeft(2, '0');
    final s = t.second.toString().padLeft(2, '0');
    final ms = t.millisecond.toString().padLeft(3, '0');
    return format
        .replaceAll('yyyy', y)
        .replaceAll('MM', mon)
        .replaceAll('dd', d)
        .replaceAll('HH', h)
        .replaceAll('mm', m)
        .replaceAll('ss', s)
        .replaceAll('SSS', ms);
  }

  /// Performs rotation if the current log file exceeds [LogConfig.maxFileSize].
  Future<void> _rotateLogsIfNeeded() async {
    if (_currentFile == null) return;
    try {
      final fileSize = await _currentFile!.length();
      if (fileSize > _config.maxFileSize) {
        await _rotate();
      }
    } catch (e) {
      _safePrint('Failed to check rotation need:$e', isInternalError: true);
    }
  }

  /// Deletes the oldest log file if the max file count is exceeded.
  ///
  /// After deletion, a new file is created and logging continues.
  Future<void> _rotate() async {
    if (_logDir == null) return;
    try {
      final dir = Directory(_logDir!);
      final files = await dir
          .list()
          .where((file) => file.path.endsWith('.log'))
          .cast<File>()
          .toList();

      if (files.length < _config.maxFiles || files.isEmpty) return;

      files.sort(
        (a, b) => b.lastModifiedSync().compareTo(a.lastModifiedSync()),
      );

      try {
        await files[0].delete();
        _safePrint('Deleted old log file: ${files[0].path}');
      } catch (e) {
        _safePrint(
          'Failed to delete old log file ${files[0].path}: $e',
          isInternalError: true,
        );
      }

      _currentFile = await _getCurrentFile();
      _safePrint('Log file rotated. New file: ${_currentFile?.path}');
    } catch (e) {
      _safePrint('Error rotating logs: $e', isInternalError: true);
    }
  }

  /// Logs a message with a specific [LogLevel] and optional metadata.
  ///
  /// Includes timestamp, optional tag (caller location by default),
  /// optional error object, and optional stack trace (depending on config).
  void _log(
    LogLevel level,
    String msg, {
    String? tag,
    dynamic error,
    StackTrace? stackTrace,
  }) {
    if (level.level < _config.level.level) return;
    final ts = _format(DateTime.now(), _config.dateFormat);
    final logTag = tag ?? _getCallerInfo();

    final logMSG = _formatMessage(
      timestamp: ts,
      level: level,
      tag: logTag,
      message: msg,
      error: error,
      stackTrace: stackTrace,
    );

    if (_config.output == LogOut.console || _config.output == LogOut.both) {
      _writeConsol(logMSG, level);
    }

    if (_config.output == LogOut.file || _config.output == LogOut.both) {
      _writeFile(logMSG, level);
    }
  }

  /// Builds a human-readable log line including optional error and stack trace.
  String _formatMessage({
    required String timestamp,
    required LogLevel level,
    required String tag,
    required String message,
    dynamic error,
    StackTrace? stackTrace,
  }) {
    final buffer = StringBuffer();

    buffer.write('[$timestamp]');

    if (_config.useEmoji) {
      buffer.write('[${level.emoji}]');
    }

    buffer.write('[${level.name}]');

    buffer.write('[$tag]');

    if (message.length > 1000) {
      buffer.write(
        '${message.substring(0, 1000)}...[truncated ${message.length - 1000} chars]',
      );
    } else {
      buffer.write(message);
    }

    if (error != null) {
      buffer.write('\nError: $error');
    }

    if ((_config.includeStackTrace ||
            level == LogLevel.error ||
            level == LogLevel.critical) &&
        stackTrace != null) {
      buffer.write('\nStack Trace: $stackTrace');
    }

    return buffer.toString();
  }

  /// Applies ANSI color codes based on [LogLevel] if color output is enabled.
  String _colorizeMessage(String message, LogLevel level) {
    String color;
    switch (level) {
      case LogLevel.debug:
        color = _cyan;
        break;
      case LogLevel.info:
        color = _green;
        break;
      case LogLevel.warning:
        color = _yellow;
        break;
      case LogLevel.error:
        color = _red;
        break;
      case LogLevel.critical:
        color = '$_red$_bold';
        break;
    }
    return '$color$message$_reset';
  }

  /// Writes a log message to console (stdout).
  ///
  /// Honors [LogConfig.useColor] and [enableProductionLogging] settings.
  void _writeConsol(String message, LogLevel level) {
    if (kReleaseMode && !_config.enableProductionLogging) return;
    if (_config.useColor) {
      final coloredMessage = _colorizeMessage(message, level);
      _safePrint(coloredMessage);
    } else {
      _safePrint(message);
    }
  }

  /// Appends the log message to the current log file.
  ///
  /// If [LogConfig.enableLogRotation] is true, file size is monitored.
  void _writeFile(String message, LogLevel level) {
    if (_currentFile == null) return;
    try {
      _currentFile!.writeAsStringSync('$message\n', mode: FileMode.append);

      if (_config.enableLogRotation) _rotateLogsIfNeeded();
    } catch (e) {
      _safePrint('Failed to write to log file: $e', isInternalError: true);
    }
  }

  /// Attempts to resolve the file and line number of the original caller.
  ///
  /// Used as the default tag if none is provided.
  String _getCallerInfo() {
    final stackTrace = StackTrace.current;
    final lines = stackTrace.toString().split('\n');
    for (int i = 2; i < lines.length; i++) {
      final line = lines[i];
      if (line.contains('.dart') && !line.contains('logger.dart')) {
        final match = RegExp(r'(\w+\.dart):(\d+)').firstMatch(line);
        if (match != null) {
          return '${match.group(1)}:${match.group(2)}';
        }
      }
    }
    return 'Unknown';
  }

  /// Log a [debug]-level message.
  void debug(
    String message, {
    String? tag,
    dynamic error,
    StackTrace? stackTrace,
  }) {
    _log(
      LogLevel.debug,
      message,
      tag: tag,
      error: error,
      stackTrace: stackTrace,
    );
  }

  /// Log an [info]-level message.
  void info(
    String message, {
    String? tag,
    dynamic error,
    StackTrace? stackTrace,
  }) {
    _log(
      LogLevel.info,
      message,
      tag: tag,
      error: error,
      stackTrace: stackTrace,
    );
  }

  /// Log a [warning]-level message.
  void warning(
    String message, {
    String? tag,
    dynamic error,
    StackTrace? stackTrace,
  }) {
    _log(
      LogLevel.warning,
      message,
      tag: tag,
      error: error,
      stackTrace: stackTrace,
    );
  }

  /// Log an [error]-level message.
  void error(
    String message, {
    String? tag,
    dynamic error,
    StackTrace? stackTrace,
  }) {
    _log(
      LogLevel.error,
      message,
      tag: tag,
      error: error,
      stackTrace: stackTrace,
    );
  }

  /// Log a [critical]-level message.
  void critical(
    String message, {
    String? tag,
    dynamic error,
    StackTrace? stackTrace,
  }) {
    _log(
      LogLevel.critical,
      message,
      tag: tag,
      error: error,
      stackTrace: stackTrace,
    );
  }

  /// Returns a list of all log files, sorted by last modified descending.
  Future<List<File>> getLogFiles() async {
    if (_logDir == null) return [];

    try {
      final logDir = Directory(_logDir!);
      if (!await logDir.exists()) return [];

      final files = await logDir
          .list()
          .where((file) => file.path.endsWith('.log'))
          .cast<File>()
          .toList();

      files.sort(
        (a, b) => b.lastModifiedSync().compareTo(a.lastModifiedSync()),
      );

      return files;
    } catch (e) {
      error('Failed to get log files: $e');
      return [];
    }
  }

  /// Returns the content of the current or specified log file.
  Future<String> getLogContent({File? logFile}) async {
    final file = logFile ?? _currentFile;
    if (file == null) return '';

    try {
      return await file.readAsString();
    } catch (e) {
      error('Failed to read log file: $e');
      return '';
    }
  }

  /// Deletes all logs and reinitializes the current file.
  Future<void> clearLogs() async {
    if (_logDir == null) return;

    try {
      final logDir = Directory(_logDir!);
      if (await logDir.exists()) {
        await logDir.delete(recursive: true);
        await _initializeFileLogging();
      }
    } catch (e) {
      error('Failed to clear logs: $e');
    }
  }

  /// Exports all logs to a specified single file [outputPath].
  Future<void> exportLogs(String outputPath) async {
    final logFiles = await getLogFiles();
    if (logFiles.isEmpty) return;

    try {
      final exportFile = File(outputPath);
      final sink = exportFile.openWrite();

      for (final file in logFiles) {
        final content = await file.readAsString();
        sink.write(content);
        sink.write('\n--- End of ${file.path} ---\n\n');
      }

      await sink.close();
      info('Logs exported to: $outputPath');
    } catch (e) {
      error('Failed to export logs: $e');
    }
  }

  /// Returns the current active log file size in bytes.
  Future<int> getCurrentLogFileSize() async {
    if (_currentFile == null) return 0;
    try {
      return await _currentFile!.length();
    } catch (e) {
      return 0;
    }
  }

  /// Forces a manual log rotation regardless of file size.
  Future<void> forceRotation() async {
    await _rotate();
  }

  static void d(
    String message, {
    String? tag,
    dynamic error,
    StackTrace? stackTrace,
  }) {
    instance.debug(message, tag: tag, error: error, stackTrace: stackTrace);
  }

  static void i(
    String message, {
    String? tag,
    dynamic error,
    StackTrace? stackTrace,
  }) {
    instance.info(message, tag: tag, error: error, stackTrace: stackTrace);
  }

  static void w(
    String message, {
    String? tag,
    dynamic error,
    StackTrace? stackTrace,
  }) {
    instance.warning(message, tag: tag, error: error, stackTrace: stackTrace);
  }

  static void e(
    String message, {
    String? tag,
    dynamic error,
    StackTrace? stackTrace,
  }) {
    instance.error(message, tag: tag, error: error, stackTrace: stackTrace);
  }

  static void c(
    String message, {
    String? tag,
    dynamic error,
    StackTrace? stackTrace,
  }) {
    instance.critical(message, tag: tag, error: error, stackTrace: stackTrace);
  }
}

class LoggerPresets {
  /// Development configuration - Full logging with colors and emojis
  static const LogConfig development = LogConfig(
    level: LogLevel.debug,
    output: LogOut.both,
    useColor: true,
    useEmoji: true,
    includeStackTrace: true,
    enableProductionLogging: true,
    silentFailures: false,
  );

  /// Production configuration - File-only logging, no console output
  /// This prevents sensitive information from appearing in production logs
  /// that might be accessible to users or in crash reports
  static const LogConfig production = LogConfig(
    level: LogLevel.warning, // Only log warnings and above
    output: LogOut.file, // File only - no console output
    useColor: false, // No colors in production
    useEmoji: false, // No emojis in production
    includeStackTrace: false, // No stack traces for performance
    enableProductionLogging: false, // Disable console prints
    silentFailures: true, // Don't print internal errors
    maxFileSize: 5 * 1024 * 1024, // Smaller files for production
    maxFiles: 3, // Fewer files to save space
  );

  /// Production with console - For debugging production issues
  /// Use this temporarily when you need to see logs in production
  static const LogConfig productionDebug = LogConfig(
    level: LogLevel.info,
    output: LogOut.both,
    useColor: false,
    useEmoji: false,
    includeStackTrace: false,
    enableProductionLogging: true, // Enable console output
    silentFailures: false,
    maxFileSize: 10 * 1024 * 1024,
    maxFiles: 5,
  );

  /// Testing configuration - Console only for fast testing
  static const LogConfig testing = LogConfig(
    level: LogLevel.info,
    output: LogOut.console,
    useColor: false,
    useEmoji: false,
    includeStackTrace: true,
    enableProductionLogging: true,
    silentFailures: false,
  );

  /// Silent production - Only critical errors to file
  static const LogConfig productionSilent = LogConfig(
    level: LogLevel.critical,
    output: LogOut.file,
    useColor: false,
    useEmoji: false,
    includeStackTrace: true, // Keep stack traces for critical errors
    enableProductionLogging: false,
    silentFailures: true,
    maxFileSize: 2 * 1024 * 1024, // 2MB
    maxFiles: 2,
  );
}
