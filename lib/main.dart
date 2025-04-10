import 'package:flutter/material.dart';
import 'package:test/paymentScreen.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  void testNetwork() async {
    try {
      final response = await http.get(Uri.parse("https://www.google.com"));
      print("Google Response: ${response.statusCode}");
    } catch (e) {
      print("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Merchant EvcPlus API',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: PaymentScreen(),
    );
  }
}


















// // final requestPayload = {
    //   "schemaVersion": "1.0",
    //   "requestId": DateTime.now().millisecondsSinceEpoch.toString(),
    //   "timestamp": DateTime.now().toIso8601String(),
    //   "channelName": "MOBILE",
    //   "serviceName": "API_PURCHASE",
    //   "serviceParams": {
    //     "merchantUid": merchantUid,
    //     "apiUserId": apiUserId,
    //     "apiKey": apiKey,
    //     "paymentMethod": "MWALLET_ACCOUNT",
    //     "payerInfo": {
    //       "accountNo": _accountController.text.trim(),
    //     },
    //     "transactionInfo": {
    //       "referenceId": DateTime.now()
    //           .millisecondsSinceEpoch
    //           .toString(), // Unique reference ID
    //       "invoiceId": "154", // Replace with your invoice ID
    //       "amount": double.tryParse(_amountController.text.trim()) ??
    //           0.0, // Ensure amount is a valid number
    //       "currency": "USD",
    //       "description": _descriptionController.text.trim(),
    //     }
    //   }
    // }
