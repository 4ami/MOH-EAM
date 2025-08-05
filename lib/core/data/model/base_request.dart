import 'dart:convert';

abstract class BaseRequest {
  const BaseRequest();
  Map<String, dynamic> toJson();
  String get encoded => jsonEncode(toJson());
}
