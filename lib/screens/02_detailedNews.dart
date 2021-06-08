import 'package:flutter/material.dart';
import 'dart:io';

import 'package:webview_flutter/webview_flutter.dart';

class DetailedNewsScreen extends StatefulWidget {
  final String webUrl;
  DetailedNewsScreen({this.webUrl});
  _DetailedNewsScreenState createState() => _DetailedNewsScreenState();
}

class _DetailedNewsScreenState extends State<DetailedNewsScreen> {
  bool _isLoading = true;

  @override
  void initState() {
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF111827),
        title: Text(_isLoading ? 'Loading' : 'Articles'),
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: WebView(
              onPageStarted: (valu01) {
                setState(() {
                  _isLoading = false;
                });
              },
              initialUrl: widget.webUrl,
            ),
          ),
          _isLoading ? CircularProgressIndicator() : Container(),
        ],
      ),
    );
  }
}
