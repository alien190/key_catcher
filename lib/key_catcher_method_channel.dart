import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'key_catcher_platform_interface.dart';

/// An implementation of [KeyCatcherPlatform] that uses method channels.
class MethodChannelKeyCatcher extends KeyCatcherPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('key_catcher');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
