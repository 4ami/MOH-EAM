import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:moh_eam/core/data/model/base_request.dart';
import 'package:moh_eam/core/data/model/base_response.dart';

class AuthModel extends BaseResponse {
  const AuthModel({
    super.code,
    super.message,
    super.messageKey,
    required this.token,
    required this.refToken,
  });

  final String token, refToken;

  factory AuthModel.fromJSON(dynamic json) {
    return AuthModel(
      code: json['code'] ?? -1,
      message: json['message'] ?? '',
      messageKey: json['message_key'] ?? '',
      token: json['token'] ?? '',
      refToken: json['ref_token'] ?? '',
    );
  }

  String getRole() {
    if (JwtDecoder.tryDecode(token) == null) return 'guest';
    return JwtDecoder.decode(token)['role'] ?? 'guest';
  }
}

class AuthRequest extends BaseRequest {
  const AuthRequest({required this.username, required this.password});
  final String username, password;

  @override
  Map<String, dynamic> toJson() {
    return {'username': username, 'password': password};
  }
}