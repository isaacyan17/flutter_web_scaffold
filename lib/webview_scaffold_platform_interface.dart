import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'webview_scaffold_method_channel.dart';

abstract class WebviewScaffoldPlatform extends PlatformInterface {
  /// Constructs a WebviewScaffoldPlatform.
  WebviewScaffoldPlatform() : super(token: _token);

  static final Object _token = Object();

  static WebviewScaffoldPlatform _instance = MethodChannelWebviewScaffold();

  /// The default instance of [WebviewScaffoldPlatform] to use.
  ///
  /// Defaults to [MethodChannelWebviewScaffold].
  static WebviewScaffoldPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [WebviewScaffoldPlatform] when
  /// they register themselves.
  static set instance(WebviewScaffoldPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
