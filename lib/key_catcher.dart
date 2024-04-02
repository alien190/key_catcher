
import 'key_catcher_platform_interface.dart';

class KeyCatcher {
  Future<String?> getPlatformVersion() {
    return KeyCatcherPlatform.instance.getPlatformVersion();
  }
}
