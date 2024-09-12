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
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _launchURL(widget.redirectURL);
  }

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      setState(() {
        _isLoading = false;
      });
      await launchUrl(uri);
      _handleUrlResponse(url);
    } else {
      setState(() {
        _isLoading = false;
      });
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _isLoading
            ? const CircularProgressIndicator.adaptive()
            : Text('Redirecting...'),
      ),
    );
  }

  void _handleUrlResponse(String url) {
    if (url.contains('txn_response_code') &&
        url.contains('success') &&
        url.contains('id')) {
      final params = _getParamFromURL(url);
      final response = PaymobResponse.fromJson(params);
      if (widget.onPayment != null) {
        widget.onPayment!(response);
      }
      Navigator.pop(context, response);
    }
  }

  Map<String, dynamic> _getParamFromURL(String url) {
    final uri = Uri.parse(url);
    Map<String, dynamic> data = {};
    uri.queryParameters.forEach((key, value) {
      data[key] = value;
    });
    return data;
  }
}
