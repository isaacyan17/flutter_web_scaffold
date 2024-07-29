import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'webview_scaffold_platform_interface.dart';

/// An implementation of [WebviewScaffoldPlatform] that uses method channels.
class MethodChannelWebviewScaffold extends WebviewScaffoldPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('webview_scaffold');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
