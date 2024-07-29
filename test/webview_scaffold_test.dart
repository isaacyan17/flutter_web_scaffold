import 'package:flutter_test/flutter_test.dart';
import 'package:webview_scaffold/webview_scaffold.dart';
import 'package:webview_scaffold/webview_scaffold_platform_interface.dart';
import 'package:webview_scaffold/webview_scaffold_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockWebviewScaffoldPlatform
    with MockPlatformInterfaceMixin
    implements WebviewScaffoldPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final WebviewScaffoldPlatform initialPlatform = WebviewScaffoldPlatform.instance;

  test('$MethodChannelWebviewScaffold is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelWebviewScaffold>());
  });

  test('getPlatformVersion', () async {
   
  });
}
