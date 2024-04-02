import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'key_catcher_method_channel.dart';

abstract class KeyCatcherPlatform extends PlatformInterface {
  /// Constructs a KeyCatcherPlatform.
  KeyCatcherPlatform() : super(token: _token);

  static final Object _token = Object();

  static KeyCatcherPlatform _instance = MethodChannelKeyCatcher();

  /// The default instance of [KeyCatcherPlatform] to use.
  ///
  /// Defaults to [MethodChannelKeyCatcher].
  static KeyCatcherPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [KeyCatcherPlatform] when
  /// they register themselves.
  static set instance(KeyCatcherPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
