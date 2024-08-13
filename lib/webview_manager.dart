import 'dart:async';
import 'dart:math';

import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';

class WebviewManger {
  static WebviewManger? _instance;
  WebviewManger._();
  factory WebviewManger() => _instance ??= WebviewManger._();

  //  controller 键值对,
  final Map<String, dynamic> _webviewController = {};

  String createControllerKey({String? key}) {
    if (_webviewController.containsKey(key)) {
      return key!;
    }

    WebViewController controller = WebViewController();

    key ??= _generateRandomKey();
    _webviewController[key] = controller;
    return key;
  }

  Future createPreloadController({
    String? key,
    required String url,
    Map<String, dynamic>? cookies,
    bool injectBridge = false,
  }) async {
    String k = createControllerKey(key: key);

    Completer completer = Completer();

    WebViewController controller = _webviewController[k] as WebViewController;

    /// 设置cookie
    if (cookies != null) {
      WebViewCookieManager cookieManager = WebViewCookieManager();
      for (var entry in cookies.entries) {
        cookieManager.setCookie(
            WebViewCookie(name: entry.key, value: entry.value, domain: url));
      }
    }

    if (controller.platform is AndroidWebViewController) {
      AndroidWebViewController.enableDebugging(true);
    }

    controller.setJavaScriptMode(JavaScriptMode.unrestricted);
    controller.addJavaScriptChannel('nativeBridge', onMessageReceived: (msg) {
      print('>>>   nativeBridge: ${msg.message}');
    });

    controller.setNavigationDelegate(NavigationDelegate(
      onProgress: (int progress) {
        print('WebView is loading (progress : $progress%)');
      },
      onPageStarted: (String url) async {
        print('Page started loading: $url');
      },
      onPageFinished: (String url) async{
        print('Page finished loading: $url');
         /// 注入js
        if (injectBridge) {
          String jsAssets =
              await rootBundle.loadString('packages/webview_scaffold/assets/jsBridgeHelper.js');

          controller.runJavaScript(jsAssets);
        }
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

  WebViewController? getController({String? key}) =>
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
