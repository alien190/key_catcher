import 'package:flutter_test/flutter_test.dart';
import 'package:key_catcher/key_catcher.dart';
import 'package:key_catcher/key_catcher_platform_interface.dart';
import 'package:key_catcher/key_catcher_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockKeyCatcherPlatform
    with MockPlatformInterfaceMixin
    implements KeyCatcherPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final KeyCatcherPlatform initialPlatform = KeyCatcherPlatform.instance;

  test('$MethodChannelKeyCatcher is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelKeyCatcher>());
  });

  test('getPlatformVersion', () async {
    KeyCatcher keyCatcherPlugin = KeyCatcher();
    MockKeyCatcherPlatform fakePlatform = MockKeyCatcherPlatform();
    KeyCatcherPlatform.instance = fakePlatform;

    expect(await keyCatcherPlugin.getPlatformVersion(), '42');
  });
}
