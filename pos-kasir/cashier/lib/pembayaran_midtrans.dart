import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MidtransPayment extends StatefulWidget {
  final String midtrans_url;

  const MidtransPayment({super.key, required this.midtrans_url});

  @override
  _MidtransPaymentState createState() => _MidtransPaymentState();
}

class _MidtransPaymentState extends State<MidtransPayment> {
  late final WebViewController controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(widget.midtrans_url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Midtrans Payment Gateway'),
      ),
      body: WebViewWidget(controller: controller),
    );
  }
}
