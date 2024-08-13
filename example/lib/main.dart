import 'package:flutter/material.dart';
import 'package:webview_scaffold/webview_scaffold.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String webkey = '';
  @override
  void initState() {
    super.initState();
    webkey = WebviewManger().createControllerKey(key: 'web');
    WebviewManger().createPreloadController(
      url: 'http://192.168.1.116:3000',
      key: webkey,
      injectBridge: true,
    );
  }

  // Platform messages are asynchronous, so we initialize in an async method.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: WebViewWidget(
          controller: WebviewManger().getController(key: webkey)!,
        ),
      ),
    );
  }
}
