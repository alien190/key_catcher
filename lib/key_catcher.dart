import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';

abstract class KeyCatcher {
  static const _methodChannel = MethodChannel('key_catcher_method');
  static const _eventChannel = EventChannel('key_catcher_event');
  static StreamSubscription? _streamSubscription;
  static DateTime? _lastPressTimeStamp;

  static Future<void> init(VoidCallback callback) async {
    if (Platform.isIOS) {
      if (_streamSubscription == null) {
        await _methodChannel.invokeMethod('init');
      }
      _streamSubscription?.cancel();
      _streamSubscription = _eventChannel.receiveBroadcastStream().listen(
        (_) {
          final curTimestamp = DateTime.now();
          final diff = curTimestamp.microsecondsSinceEpoch -
              (_lastPressTimeStamp?.millisecondsSinceEpoch ?? 0);
          if (diff > 200) {
            callback();
            _lastPressTimeStamp = curTimestamp;
          }
        },
      );
    }
  }

  static Future<void> dispose() async {
    if (Platform.isIOS) {
      await _methodChannel.invokeMethod('dispose');
      _streamSubscription?.cancel();
      _streamSubscription = null;
    }
  }
}
