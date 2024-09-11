part of 'paymob_payment.dart';

class PaymobIFrame extends StatelessWidget {
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
  }) async {
    final completer = Completer<PaymobResponse?>();
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return PaymobIFrame(
            redirectURL: redirectURL,
            onPayment: (response) {
              completer.complete(response);
              Navigator.pop(context);
            },
          );
        },
      ),
    );
    return completer.future;
  }

  @override
  Widget build(BuildContext context) {
    _launchURL(redirectURL);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment'),
      ),
      body: const Center(
        child: CircularProgressIndicator.adaptive(),
      ),
    );
  }

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $url';
    }
  }
}
