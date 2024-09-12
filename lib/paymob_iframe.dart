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
  @override
  void initState() {
    super.initState();
    _launchURL(widget.redirectURL);
  }

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
      if (_isPaymentResponse(uri)) {
        final params = _getParamFromURL(uri.toString());
        final response = PaymobResponse.fromJson(params);
        if (widget.onPayment != null) {
          widget.onPayment!(response);
        }
        Navigator.pop(context, response);
      }
    } else {
      throw 'Could not launch $url';
    }
  }

  bool _isPaymentResponse(Uri uri) {
    // Check if the URL contains payment response indicators
    return uri.queryParameters.containsKey('txn_response_code') &&
        uri.queryParameters.containsKey('success') &&
        uri.queryParameters.containsKey('id');
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
      appBar: AppBar(
        title: const Text('Payment'),
      ),
      body: const Center(
        child: CircularProgressIndicator.adaptive(),
      ),
    );
  }
}
