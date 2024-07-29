import 'dart:async';
import 'dart:math';

import 'package:webview_flutter/webview_flutter.dart';

class WebviewManger {
  static WebviewManger? _instance;
  WebviewManger._();
  factory WebviewManger() => _instance ??= WebviewManger._();

  //  controller 键值对,
  final Map<String, dynamic> _webviewController = {};

  String? createController({String? key}) {
    if (_webviewController.length > 5) {
      return null;
    }

    if (_webviewController.containsKey(key)) {
      return key;
    }

    WebViewController controller = WebViewController();

    key ??= _generateRandomKey();
    _webviewController[key] = controller;
    return key;
  }

  Future createPreloadController({String? key, required String url}) async {
    String? k = createController(key: key);
    if (k == null) {
      return null;
    }

    Completer completer = Completer();

    WebViewController controller = _webviewController[k] as WebViewController;

    controller.setJavaScriptMode(JavaScriptMode.unrestricted);
    controller.setNavigationDelegate(NavigationDelegate(
      onProgress: (int progress) {
        print('WebView is loading (progress : $progress%)');
      },
      onPageStarted: (String url) {
        print('Page started loading: $url');
      },
      onPageFinished: (String url) {
        print('Page finished loading: $url');
        if (!completer.isCompleted) {
          completer.complete(k);
        }
      },
      onWebResourceError: (WebResourceError error) {},
      onNavigationRequest: (NavigationRequest request) =>
          NavigationDecision.navigate,
      onHttpError: (error) {
        print('>>>   Http error');
        if (!completer.isCompleted) {
          completer.complete(k);
        }
      },
    ));
    await controller.loadRequest(Uri.parse(url));

    return completer.future;
  }

  WebViewController getController({required String key}) =>
      _webviewController[key];

  void destroyController({required String key}) {
    _webviewController.remove(key);
  }

  String _generateRandomKey({int length = 10}) {
    const alphabet =
        'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    var random = Random();
    return String.fromCharCodes(Iterable.generate(
      length,
      (_) => alphabet.codeUnitAt(random.nextInt(alphabet.length)),
    ));
  }
}
