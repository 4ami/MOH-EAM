abstract class BaseResponse {
  final int code;
  final String message;
  final String messageKey;
  const BaseResponse({this.code = -1, this.message = '', this.messageKey = ''});
}
