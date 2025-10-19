import 'dart:math';
import 'dart:typed_data';

import 'package:web/web.dart' as web;
import 'dart:js_interop';

String _defaultName({int len = 7}) {
  const String chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  final r = Random();
  return String.fromCharCodes(
    Iterable.generate(len, (_) => chars.codeUnitAt(r.nextInt(chars.length))),
  );
}

Future<void> export(Uint8List bytes, {String? fileName}) async {
  final jsB = bytes.toJS;
  final blob = web.Blob(
    <web.BlobPart>[jsB].toJS,
    web.BlobPropertyBag(
      type: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
    ),
  );

  final objURL = web.URL.createObjectURL(blob);

  web.HTMLAnchorElement()
    ..href = objURL
    ..download = fileName ?? _defaultName()
    ..click();

  web.URL.revokeObjectURL(objURL);
}
