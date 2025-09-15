import 'dart:convert';
import 'package:flutter/services.dart';

/// Represents supported deployment environments.
///
/// Use this enum to control configuration switching
/// (e.g., between dev and production endpoints).
enum Environment { development, production }

/// Centralized configuration entry point for the application.
///
/// Call [MohAppConfig.init] early in the app lifecycle to load
/// and prepare environment-specific configuration (such as API URLs).
///
/// This class abstracts the environment initialization strategy
/// and ensures only one config instance is loaded during runtime.
final class MohAppConfig {
  static late APIConfig _apiConfig;
  static bool _initialized = false;

  /// Initializes the configuration for the provided [environment].
  ///
  /// Should be invoked once at app startup (e.g., in `main()`).
  /// Calling it multiple times is a no-op after first init.
  static Future<void> init({required Environment environment}) async {
    if (_initialized) return;
    _apiConfig = APIConfig(environment: environment);
    await _apiConfig.init();
    _initialized = true;
  }

  /// Returns the currently loaded [APIConfig] instance.
  ///
  /// Throws [StateError] if accessed before initialization.
  static APIConfig get api {
    if (!_initialized) {
      throw StateError(
        'MohAppConfig not initialized. Call MohAppConfig.init() first.',
      );
    }
    return _apiConfig;
  }
}

/// Defines the API configuration contract for each environment.
///
/// Implementations provide the relevant API base URL,
/// authentication paths, and tokens based on the context.
///
/// Use [APIConfig.new] to obtain the proper environment-specific instance.
///
/// ```dart
/// final config = APIConfig(environment: Environment.production);
/// ```
abstract class APIConfig {
  factory APIConfig({required Environment environment}) {
    return switch (environment) {
      Environment.development => _$Development.instance,
      Environment.production => _$Production.instance,
    };
  }

  String get apiBaseUrl;
  String get version;
  String get authentication;
  String get authToken;
  String get roles;
  String get roleDELETE;

  String get deviceCREATE;
  String get allDevices;
  String get devicesStatistics;
  String get exportDevices;
  String get patchDevice;
  String get deleteDevice;

  String get departmentsRoot;
  String get departmentTree;
  String get departmentSubtree;
  String get departmentChildren;
  String get departmentCREATE;
  String get departmentUPDATE;
  String get departmentDELETE;
  String get departmentSEARCH;
  String get exportDepartments;

  String get usersFetch;
  String get userDetails;
  String get userCREATE;
  String get userUPDATE;
  String get userDELETE;
  String get userStatistics;
  String get exportUsers;

  String get globalSearch;

  String get profile;

  /// Load and prepare any necessary configuration resources.
  ///
  /// In environments like development, this may involve
  /// reading bundled `.env`-style files from assets.
  Future<void> init();
}

/// Provides a shared JSON loader for asset-based environment files.
///
/// Intended to be mixed into dev/test config classes that load their
/// keys from bundled JSON files instead of relying on Dart defines.
///
/// Consumers must override [_path] to point to the asset path.
///
/// Example structure for the JSON:
/// ```json
/// {
///   "HOST": "https://localhost:8080",
///   "VERSION": "v1",
///   "AUTH": {
///     "signin": "/auth/signin",
///     "token": "some-token"
///   }
/// }
/// ```
mixin _$EnvironementMixin {
  late Map<String, dynamic> _vars;
  bool _initialized = false;

  /// Path to the asset JSON file for environment variables.
  ///
  /// Must be overridden by concrete class.
  final String _path = '';

  /// Loads and parses the configuration file.
  Future<void> init() async {
    String envString = await rootBundle.loadString(_path);
    _vars = jsonDecode(envString);
    _initialized = true;
  }

  /// Retrieves a configuration value from the loaded environment map.
  ///
  /// Supports both flat and nested keys using dot notation:
  ///
  /// - Flat key: `'HOST'`
  /// - Nested key: `'AUTH.token'` (resolves to `_vars['AUTH']['token']`)
  ///
  /// If the key does not exist, the original [key] string is returned as a fallback,
  /// allowing unresolved lookups to fail gracefully in non-critical contexts.
  ///
  /// Throws an [AssertionError] if called before [init].
  ///
  /// Example:
  /// ```dart
  /// final host = get(key: 'HOST'); // returns a string
  /// final token = get(key: 'AUTH.token'); // accesses nested map
  /// ```
  ///
  /// This method is primarily intended for internal use within config classes.
  String get({required String key}) {
    assert(_initialized, 'Must call \'init()\'');
    List<String> nested = key.split('.');
    // Simple flat key lookup
    if (nested.length == 1) {
      if (!_vars.containsKey(key)) return key;
      return _vars[key]!;
    }
    // Nested key traversal
    dynamic v = _vars;
    for (String k in nested) {
      if (v is! Map || !v.containsKey(k)) return key;
      v = v[k];
    }
    return v.toString();
  }
}

/// Development environment implementation of [APIConfig].
///
/// This config reads values from a JSON asset file
/// located at `lib/config/.env/devlopment.env.json`.
///
/// Use this environment when debugging locally or testing against staging servers.
final class _$Development with _$EnvironementMixin implements APIConfig {
  _$Development._();

  /// Singleton access to the development config instance.
  static final _$Development _instance = _$Development._();
  static _$Development get instance => _instance;

  @override
  String get _path => 'lib/config/.env/development.env.json';

  @override
  String get apiBaseUrl => get(key: 'HOST');

  @override
  String get version => get(key: 'VERSION');

  @override
  String get authentication => get(key: 'AUTH.signin');

  @override
  String get authToken => get(key: 'AUTH.token');

  @override
  String get roles => get(key: 'AUTH.roles');

  @override
  String get roleDELETE => get(key: 'AUTH.role_delete');

  @override
  String get deviceCREATE => get(key: 'DEVICES.create');

  @override
  String get allDevices => get(key: 'DEVICES.all');

  @override
  String get devicesStatistics => get(key: 'DEVICES.statistics');

  @override
  String get exportDevices => get(key: 'DEVICES.EXPORT');

  @override
  String get patchDevice => get(key: 'DEVICES.PATCH');

  @override
  String get deleteDevice => get(key: "DEVICES.DELETE");

  @override
  String get departmentsRoot => get(key: 'DEPARTMENTS.roots');

  @override
  String get departmentTree => get(key: 'DEPARTMENTS.tree');

  @override
  String get departmentSubtree => get(key: 'DEPARTMENTS.subtree');

  @override
  String get departmentChildren => get(key: 'DEPARTMENTS.children');

  @override
  String get departmentCREATE => get(key: 'DEPARTMENTS.create');

  @override
  String get departmentUPDATE => get(key: 'DEPARTMENTS.update');

  @override
  String get departmentDELETE => get(key: 'DEPARTMENTS.delete');

  @override
  String get departmentSEARCH => get(key: 'DEPARTMENTS.search');

  @override
  String get exportDepartments => get(key: 'DEPARTMENTS.EXPORT');

  @override
  String get usersFetch => get(key: 'USERS.FETCH_USERS');

  @override
  String get userDetails => get(key: 'USERS.FETCH_DETAILS');

  @override
  String get userCREATE => get(key: 'AUTH.create_user');

  @override
  String get userUPDATE => get(key: 'USERS.UPDATE');

  @override
  String get userDELETE => get(key: 'USERS.DELETE');

  @override
  String get userStatistics => get(key: 'USERS.STATS');

  @override
  String get exportUsers => get(key: 'USERS.EXPORT');

  @override
  String get globalSearch => get(key: 'GLOBAL_SEARCH');

  @override
  String get profile => get(key: 'PROFILE');
}

/// Production environment implementation of [APIConfig].
///
/// In production, all config values are expected to be injected via
/// Dart defines at build time using `--dart-define`.
///
/// This config avoids runtime asset loading entirely.
final class _$Production implements APIConfig {
  const _$Production._();

  /// Singleton access to the production config instance.
  static final _$Production _instance = _$Production._();
  static _$Production get instance => _instance;

  static const String _apiBaseUrl = String.fromEnvironment('API_URL');
  static const String _authToken = String.fromEnvironment('AUTH_TOKEN');
  static const String _authentication = String.fromEnvironment(
    'AUTHENTICATION',
  );
  static const String _version = String.fromEnvironment('VERSION');
  static const String _roles = String.fromEnvironment('ROLES');
  static const String _roleDELETE = String.fromEnvironment('ROLE_DELETE');
  static const String _deviceCREATE = String.fromEnvironment('DEVICE_CREATE');
  static const String _allDevices = String.fromEnvironment('DEVICES_ALL');
  static const String _devicesStatistics = String.fromEnvironment(
    'DEVICES_STATISTICS',
  );
  static const String _exportDevices = String.fromEnvironment('EXPORT_DEVICES');
  static const String _patchDevice = String.fromEnvironment('PATCH_DEVICE');
  static const String _deleteDevice = String.fromEnvironment('DELETE_DEVICE');
  static const String _departmentsRoot = String.fromEnvironment(
    'DEPARTMENT_ROOTS',
  );
  static const String _departmentTree = String.fromEnvironment(
    'DEPARTMENT_TREE',
  );
  static const String _departmentSubtree = String.fromEnvironment(
    'DEPARTMENT_SUBTREE',
  );
  static const String _departmentChildren = String.fromEnvironment(
    'DEPARTMENT_CHILDREN',
  );
  static const String _departmentCREATE = String.fromEnvironment(
    'DEPARTMENT_CREATE',
  );
  static const String _departmentUPDATE = String.fromEnvironment(
    'DEPARTMENT_UPDATE',
  );
  static const String _departmentDELETE = String.fromEnvironment(
    'DEPARTMENT_DELETE',
  );
  static const String _departmentSEARCH = String.fromEnvironment(
    'DEPARTMENT_SEARCH',
  );
  static const String _exportDepartments = String.fromEnvironment(
    'EXPORT_DEPARTMENTS',
  );
  static const String _usersFetch = String.fromEnvironment('FETCH_USERS');
  static const String _userDetails = String.fromEnvironment('USER_DETAILS');
  static const String _userCREATE = String.fromEnvironment('CREATE_USER');
  static const String _userUPDATE = String.fromEnvironment('UPDATE_USER');
  static const String _userDELETE = String.fromEnvironment('DELETE_USER');
  static const String _userStatistics = String.fromEnvironment(
    'USER_STATISTICS',
  );
  static const String _exportUsers = String.fromEnvironment('EXPORT_USERS');
  static const String _globalSearch = String.fromEnvironment('GLOBAL_SEARCH');
  static const String _profile = String.fromEnvironment('PROFILE');

  @override
  Future<void> init() async {}

  @override
  String get apiBaseUrl => _apiBaseUrl;

  @override
  String get authToken => _authToken;

  @override
  String get authentication => _authentication;

  @override
  String get version => _version;

  @override
  String get roles => _roles;

  @override
  String get roleDELETE => _roleDELETE;

  @override
  String get deviceCREATE => _deviceCREATE;

  @override
  String get allDevices => _allDevices;

  @override
  String get patchDevice => _patchDevice;

  @override
  String get deleteDevice => _deleteDevice;

  @override
  String get exportDevices => _exportDevices;

  @override
  String get devicesStatistics => _devicesStatistics;

  @override
  String get departmentsRoot => _departmentsRoot;

  @override
  String get departmentTree => _departmentTree;

  @override
  String get departmentSubtree => _departmentSubtree;

  @override
  String get departmentChildren => _departmentChildren;

  @override
  String get departmentCREATE => _departmentCREATE;

  @override
  String get departmentUPDATE => _departmentUPDATE;

  @override
  String get departmentDELETE => _departmentDELETE;

  @override
  String get departmentSEARCH => _departmentSEARCH;

  @override
  String get exportDepartments => _exportDepartments;

  @override
  String get usersFetch => _usersFetch;

  @override
  String get userDetails => _userDetails;

  @override
  String get userCREATE => _userCREATE;

  @override
  String get userUPDATE => _userUPDATE;

  @override
  String get userDELETE => _userDELETE;

  @override
  String get userStatistics => _userStatistics;

  @override
  String get exportUsers => _exportUsers;

  @override
  String get globalSearch => _globalSearch;

  @override
  String get profile => _profile;
}

/// Utility to determine the active [Environment] at runtime.
///
/// It reads the `ENVIRONMENT` Dart define set during build time.
/// Defaults to `development` if the value is not found or invalid.
///
/// ```sh
/// flutter run --dart-define=ENVIRONMENT=production
/// ```
class EnvironmentHelper {
  static Environment get current {
    const envString = String.fromEnvironment(
      'ENVIRONMENT',
      defaultValue: 'development',
    );
    return switch (envString.toLowerCase()) {
      'production' || 'prod' => Environment.production,
      'development' || 'dev' || _ => Environment.development,
    };
  }
}
