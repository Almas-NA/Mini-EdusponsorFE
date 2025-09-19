import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class RazorpayTrialPage extends StatefulWidget {
  const RazorpayTrialPage({Key? key}) : super(key: key);

  @override
  State<RazorpayTrialPage> createState() => _RazorpayTrialPageState();
}

class _RazorpayTrialPageState extends State<RazorpayTrialPage> {
  late Razorpay _razorpay;
  final _amountController = TextEditingController(text: '100'); // in INR
  final _nameController = TextEditingController(text: 'Test User');
  final _contactController = TextEditingController(text: '9999999999');
  final _emailController = TextEditingController(text: 'test@example.com');

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();

    // Attach listeners
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    // dispose controller and razorpay instance
    _razorpay.clear(); // removes all listeners
    _amountController.dispose();
    _nameController.dispose();
    _contactController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    // response.paymentId, response.orderId, response.signature
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Payment successful: ${response.paymentId}')),
    );
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Payment failed: ${response.code} - ${response.message}',
        ),
      ),
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('External wallet selected: ${response.walletName}')),
    );
  }

  void _openCheckout() {
    final int inr = int.tryParse(_amountController.text) ?? 0;
    if (inr <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter a valid amount in INR')),
      );
      return;
    }

    // amount in paise
    final int amountPaise = inr * 100;

    var options = {
      'key': 'rzp_test_RJ2ya09RhfrpXB',
      'amount': amountPaise, // in paise
      'name': _nameController.text,
      'description': 'Test payment',
      'prefill': {
        'contact': _contactController.text,
        'email': _emailController.text,
      },
      'theme': {
        'color': '#528FF0'
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Error opening Razorpay: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Razorpay Trial Checkout')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Amount (INR)',
                hintText: 'Enter amount in INR (e.g. 100)',
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _contactController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(labelText: 'Contact'),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _openCheckout,
              child: const Text('Pay (test)'),
            ),
          ],
        ),
      ),
    );
  }
}
