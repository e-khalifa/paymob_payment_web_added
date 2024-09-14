part of 'paymob_payment.dart';

class PaymobIFrame extends StatefulWidget {
  const PaymobIFrame({
    Key? key,
    required this.redirectURL,
    this.onPayment,
  }) : super(key: key);

  final String redirectURL;
  final void Function(PaymobResponse)? onPayment;

  static Future<PaymobResponse?> show({
    required BuildContext context,
    required String redirectURL,
    void Function(PaymobResponse)? onPayment,
  }) =>
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) {
            return PaymobIFrame(
              onPayment: onPayment,
              redirectURL: redirectURL,
            );
          },
        ),
      );

  @override
  State<PaymobIFrame> createState() => _PaymobIFrameState();
}

class _PaymobIFrameState extends State<PaymobIFrame> {
  WebViewXController? webviewController;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    webviewController?.dispose();
    super.dispose();
  }

  Map<String, dynamic> _getParamFromURL(String url) {
    final uri = Uri.parse(url);
    Map<String, dynamic> data = {};
    uri.queryParameters.forEach((key, value) {
      data[key] = value;
    });
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: buildWebViewX(),
      ),
    );
  }

  Widget buildWebViewX() {
    return WebViewX(
      key: const ValueKey('webviewx'),
      initialContent: widget.redirectURL,
      initialSourceType: SourceType.url,
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      onWebViewCreated: (controller) {
        webviewController = controller;
        debugPrint('webviewController initialized: $webviewController');
      },
      onPageStarted: (src) {
        debugPrint('A new page has started loading: $src');
      },
      onPageFinished: (src) {
        debugPrint('The page has finished loading: $src');
      },
      navigationDelegate: (navigation) {
        final url = navigation.content.source;
        if (url.contains('txn_response_code') &&
            url.contains('success') &&
            url.contains('id')) {
          final params = _getParamFromURL(url);
          final response = PaymobResponse.fromJson(params);
          if (widget.onPayment != null) {
            widget.onPayment!(response);
          }
          Navigator.pop(context, response);
          return NavigationDecision.prevent;
        }
        return NavigationDecision.navigate;
      },
      mobileSpecificParams: const MobileSpecificParams(
        androidEnableHybridComposition: true,
      ),
    );
  }
}
