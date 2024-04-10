
import 'dart:async';

import 'package:flutter/services.dart';


abstract class KeyCatcher {
  static const _methodChannel = MethodChannel('key_catcher_method');
  static const _eventChannel = EventChannel('key_catcher_event');
  static StreamSubscription? _streamSubscription;

 static Future<void> init(VoidCallback callback) async {
    await _methodChannel.invokeMethod('init');
    _streamSubscription?.cancel();
    _streamSubscription = _eventChannel.receiveBroadcastStream().listen((_) => callback());
  }

  static Future<void> dispose() async {
    await _methodChannel.invokeMethod('dispose');
    _streamSubscription?.cancel();
    _streamSubscription = null;
  }
}
