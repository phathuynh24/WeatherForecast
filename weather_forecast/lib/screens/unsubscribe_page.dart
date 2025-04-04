import 'package:flutter/material.dart';
import 'package:cloud_functions/cloud_functions.dart';

class UnsubscribePage extends StatefulWidget {
  final String? token;
  const UnsubscribePage({super.key, this.token});

  @override
  State<UnsubscribePage> createState() => _UnsubscribePageState();
}

class _UnsubscribePageState extends State<UnsubscribePage> {
  String message = 'Processing your unsubscribe request...';
  bool isSuccess = false;

  @override
  void initState() {
    super.initState();
    _handleUnsubscribe();
  }

  Future<void> _handleUnsubscribe() async {
    final token = widget.token;

    if (token == null || token.isEmpty) {
      setState(() {
        message = 'Invalid unsubscribe link.';
        isSuccess = false;
      });
      return;
    }

    try {
      final callable = FirebaseFunctions.instance
          .httpsCallable('unsubscribeFromWeatherForecast');
      final response = await callable.call({'token': token});

      setState(() {
        isSuccess = true;
        message = response.data['message'] ?? 'You have been unsubscribed.';
      });
    } catch (e) {
      setState(() {
        message = 'Unsubscribe failed (may be you have already unsubscribed!): $e';
        isSuccess = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Card(
          elevation: 6,
          margin: const EdgeInsets.all(32),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              message,
              style: TextStyle(
                fontSize: 18,
                color: isSuccess ? Colors.green : Colors.red,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
