import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:moh_eam/config/logging/logger.dart';
import 'package:moh_eam/config/routing/routing_module.dart';
import 'package:moh_eam/config/utility/extensions/extensions_module.dart';
import 'package:moh_eam/core/data/sources/remote/moh_api.dart';
import 'package:moh_eam/features/auth/bloc/auth_bloc.dart';

final class AuthInterceptor extends Interceptor {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  const AuthInterceptor();

  Future<String?> _refresh() async {
    final refToken = await _secureStorage.read(key: 'ref_token');
    if (refToken == null) {
      Logger.i('No refresh token found');
      return null;
    }

    final dio = Dio(
      BaseOptions(
        baseUrl: MohAppConfig.api.apiBaseUrl,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': "Bearer $refToken",
        },
      ),
    );

    final res = await dio.get(
      MohAppConfig.api.authToken.replaceAll(
        '\$version',
        MohAppConfig.api.version,
      ),
    );
    if (res.statusCode != 200) return null;

    final String? newToken = res.data['token'];

    if (newToken == null) {
      _onRefreshFailure();
      return null;
    }
    _onTokenRefreshed(newToken);
    Logger.i('Token refreshed successfully - BloC notified');
    return newToken;
  }

  Future<Response> _retry(RequestOptions options) async {
    final newOptions = Options(
      method: options.method,
      headers: options.headers,
    );

    return await Dio().request(
      '${options.baseUrl}${options.path}',
      data: options.data,
      queryParameters: options.queryParameters,
      onReceiveProgress: options.onReceiveProgress,
      onSendProgress: options.onSendProgress,
      cancelToken: options.cancelToken,
      options: newOptions,
    );
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    Logger.e('Request Failed', error: err, tag: 'AuthInterceptor');
    if (err.response?.statusCode == 401) {
      final String? newToken = await _refresh();
      if (newToken == null) return handler.next(err);
      err.requestOptions.headers['Authorization'] = 'Bearer $newToken';
      try {
        final Response response = await _retry(err.requestOptions);
        return handler.resolve(response);
      } catch (e) {
        return handler.next(err);
      }
    }
    err.logDebug(tag: 'AuthInterceptor[onError]');
    return handler.next(err);
  }

  void _onTokenRefreshed(String newToken) {
    BuildContext? context = AppRouter.instance.navigatorKey?.currentContext;
    if (context == null) {
      Logger.w(
        'Can\'t notify BLoC through [AppRouter] - BuildContext = null',
        tag: 'AuthInterceptor',
      );
      return;
    }
    context.read<AuthBloc>().add(AccessTokenRefreshed(token: newToken));
  }

  void _onRefreshFailure() {
    BuildContext? context = AppRouter.instance.navigatorKey?.currentContext;
    if (context == null) {
      Logger.w(
        'Can\'t notify BLoC through [AppRouter] - BuildContext = null',
        tag: 'AuthInterceptor',
      );
      return;
    }
    //redirect to login
    context.go(AppRoutesInformation.signin.path);
  }
}
