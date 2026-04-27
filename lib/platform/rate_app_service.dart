import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class RateAppService {
  static const MethodChannel _channel = MethodChannel('hoplet/rate_app');

  static Future<void> openStoreListing() async {
    if (kIsWeb) {
      return;
    }

    await _channel.invokeMethod<void>('openStoreListing');
  }
}
