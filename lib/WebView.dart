import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ZaloPayWebView extends StatefulWidget {
  final String url;

  ZaloPayWebView({required this.url});

  @override
  _ZaloPayWebViewState createState() => _ZaloPayWebViewState();
}

class _ZaloPayWebViewState extends State<ZaloPayWebView> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Thanh toán qua ZaloPay'),
      ),
      body: WebViewWidget(controller: _controller),
    );
  }
}
