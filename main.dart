import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SafeArea(
          child: WebViewExample(),
        ),
      ),
    );
  }
}

class WebViewExample extends StatefulWidget {
  @override
  _WebViewExampleState createState() => _WebViewExampleState();
}

class _WebViewExampleState extends State<WebViewExample> {
  InAppWebViewController? _webViewController;
  bool _isLoadingPage = true;

  @override
  Widget build(BuildContext context) {
    //backpressed functionality
    return WillPopScope(
      onWillPop: () async {
        if (await _webViewController?.canGoBack() ?? false) {
          // Go back if a previous page exists in WebView's history
          _webViewController?.goBack();
          return false; // Prevent the app from closing
        }
        return true; // Let the app handle the back button normally
      },
      child: Stack(
        children: [
          InAppWebView(
            initialUrlRequest: URLRequest(url: Uri.parse('https://bard.google.com')),
            initialOptions: InAppWebViewGroupOptions(
              android: AndroidInAppWebViewOptions(
                supportMultipleWindows: false,
              ),
            ),
            onWebViewCreated: (InAppWebViewController controller) {
              _webViewController = controller;
            },
            onLoadStop: (InAppWebViewController controller, Uri? url) {
              setState(() {
                _isLoadingPage = false;
              });
            },
          ),
          if (_isLoadingPage)
            Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}
