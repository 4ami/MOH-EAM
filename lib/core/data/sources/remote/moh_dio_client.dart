import 'package:dio/dio.dart';
import 'package:moh_eam/config/logging/logger.dart';
import 'package:moh_eam/config/utility/helpers/export_helper.dart';
import 'package:moh_eam/core/data/model/api_error.dart';
import 'package:moh_eam/core/data/model/base_request.dart';
import 'package:moh_eam/core/data/model/base_response.dart';
import 'package:moh_eam/core/data/sources/remote/interceptors/auth_interceptor.dart';
import 'package:moh_eam/core/data/sources/remote/moh_api.dart';

class MOHDioClient {
  static MOHDioClient? _instance;
  static MOHDioClient get instance => _instance ??= MOHDioClient._internal();

  late Dio _mohDio;

  /// [sendTimeout] not applicable on web
  MOHDioClient._internal() {
    _mohDio = Dio(
      BaseOptions(
        baseUrl: MohAppConfig.api.apiBaseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        // sendTimeout: const Duration(seconds: 30),
        headers: {'Content-Type': 'application/json'},
      ),
    );

    _interceptorsInit();
  }

  void _interceptorsInit() {
    _mohDio.interceptors.clear();
    _mohDio.interceptors.add(AuthInterceptor());
  }

  String _processPathParams(String endpoint, Map<String, dynamic>? pathParams) {
    if (pathParams == null) return endpoint;
    pathParams.forEach((k, v) {
      endpoint.replaceAll('\$$k', Uri.encodeComponent(v.toString()));
    });
    return endpoint;
  }

  Options _addAuthHeader(Options? options, String? token) {
    final headers = <String, dynamic>{};
    if (options?.headers != null) {
      headers.addAll(options!.headers!);
    }

    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }

    return Options(
      headers: headers,
      method: options?.method,
      sendTimeout: options?.sendTimeout,
      receiveTimeout: options?.receiveTimeout,
      extra: options?.extra,
      responseType: options?.responseType,
      contentType: options?.contentType,
      validateStatus: options?.validateStatus,
      receiveDataWhenStatusError: options?.receiveDataWhenStatusError,
      followRedirects: options?.followRedirects,
      maxRedirects: options?.maxRedirects,
      requestEncoder: options?.requestEncoder,
      responseDecoder: options?.responseDecoder,
      listFormat: options?.listFormat,
    );
  }

  ApiException _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return ApiException(
          message: 'Connection timeout',
          statusCode: -1,
          type: ApiExceptionType.timeout,
        );
      case DioExceptionType.badResponse:
        return ApiException(
          key: error.response?.data['message_key'] ?? 'general_error_message',
          message: error.response?.data['message'] ?? 'Server error',
          statusCode: error.response?.statusCode ?? -1,
          type: ApiExceptionType.server,
          data: error.response?.data,
        );
      case DioExceptionType.cancel:
        return ApiException(
          message: 'Request was cancelled',
          statusCode: -1,
          type: ApiExceptionType.cancel,
        );
      case DioExceptionType.unknown:
      default:
        return ApiException(
          message: 'Network error occurred',
          statusCode: -1,
          type: ApiExceptionType.network,
        );
    }
  }

  Future<T> get<T extends BaseResponse>({
    required String endpoint,
    required T Function(dynamic) parser,
    Map<String, dynamic>? queryParams,
    Map<String, dynamic>? pathParams,
    Options? options,
    String? token,
  }) async {
    try {
      final response = await _mohDio.get(
        _processPathParams(endpoint, pathParams),
        queryParameters: queryParams,
        options: _addAuthHeader(options, token),
      );
      return parser(response.data);
    } on DioException catch (e) {
      Logger.e('Request Failed', tag: 'Client[GET]', error: e);
      throw _handleDioError(e);
    }
  }

  Future<T> post<T extends BaseResponse>({
    required String endpoint,
    required BaseRequest body,
    required T Function(dynamic) parser,
    Map<String, dynamic>? pathParams,
    Options? options,
    String? token,
  }) async {
    try {
      final response = await _mohDio.post(
        _processPathParams(endpoint, pathParams),
        data: body.encoded,
        options: _addAuthHeader(options, token),
      );
      return parser(response.data);
    } on DioException catch (e) {
      Logger.e('Request Failed', tag: 'Client[POST]', error: e);
      throw _handleDioError(e);
    }
  }

  Future<T> put<T extends BaseResponse>({
    required String endpoint,
    required BaseRequest body,
    required T Function(dynamic) parser,
    Map<String, dynamic>? pathParams,
    Options? options,
    String? token,
  }) async {
    try {
      final response = await _mohDio.put(
        _processPathParams(endpoint, pathParams),
        data: body.encoded,
        options: _addAuthHeader(options, token),
      );
      return parser(response.data);
    } on DioException catch (e) {
      Logger.e('Request Failed', tag: 'Client[PUT]', error: e);
      throw _handleDioError(e);
    }
  }

  Future<T> patch<T extends BaseResponse>({
    required String endpoint,
    required BaseRequest body,
    required T Function(dynamic) parser,
    Map<String, dynamic>? pathParams,
    Options? options,
    String? token,
  }) async {
    try {
      final response = await _mohDio.patch(
        _processPathParams(endpoint, pathParams),
        data: body.encoded,
        options: _addAuthHeader(options, token),
      );
      return parser(response.data);
    } on DioException catch (e) {
      Logger.e('Request Failed', tag: 'Client[POST]', error: e);
      throw _handleDioError(e);
    }
  }

  Future<T> delete<T extends BaseResponse>({
    required String endpoint,
    BaseRequest? body,
    required T Function(dynamic) parser,
    Map<String, dynamic>? pathParams,
    Options? options,
    String? token,
  }) async {
    try {
      final response = await _mohDio.delete(
        _processPathParams(endpoint, pathParams),
        data: body?.encoded,
        options: _addAuthHeader(options, token),
      );
      return parser(response.data);
    } on DioException catch (e) {
      Logger.e('Request Failed', tag: 'Client[DELETE]', error: e);
      throw _handleDioError(e);
    }
  }

  Future<void> download({
    required String endpoint,
    Map<String, dynamic>? queryParams,
    Map<String, dynamic>? pathParams,
    ProgressCallback? onProgress,
    void Function()? onError,
    void Function()? onSuccess,
    Options? options,
    String? token,
  }) async {
    try {
      final res = await _mohDio.get(
        _processPathParams(endpoint, pathParams),
        queryParameters: queryParams,
        onReceiveProgress: onProgress,
        options: _addAuthHeader(options, token),
      );

      if (res.statusCode != 200) {
        if (onError != null) onError();
        return;
      }
      String? fileName;
      final disp = res.headers.value('content-disposition');
      if (disp != null && disp.contains('filename=')) {
        fileName = disp.split('filename=')[1].replaceAll('"', '');
      }

      await export(res.data, fileName: fileName);
      if (onSuccess != null) onSuccess();
    } on DioException catch (e) {
      Logger.e('Request Failed', tag: 'Client[DOWNLOAD]', error: e);
      throw _handleDioError(e);
    }
  }
}
