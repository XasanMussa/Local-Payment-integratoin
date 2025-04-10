import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PaymentScreen extends StatefulWidget {
  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final _accountController = TextEditingController();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();

  // Replace with your credentials
  final String merchantUid = "M0910291";
  final String apiUserId = "1000416";
  final String apiKey = "API-675418888AHX";
  void testNetwork() async {
    try {
      final response =
          await http.get(Uri.parse("https://api.waafipay.com/asm"));
      print("waafi Response: ${response.statusCode}");
    } catch (e) {
      print("Error: $e");
    }
  }

  Future<void> makePayment() async {
    final url = Uri.parse('https://api.waafipay.net/asm');
    final id = DateTime.now().millisecondsSinceEpoch.toString();
    final time = DateTime.now().toIso8601String();
    final ref = DateTime.now().millisecondsSinceEpoch.toString();
    final requestPayLoad = {
      "schemaVersion": "1.0",
      "requestId": DateTime.now().millisecondsSinceEpoch.toString(),
      "timestamp": DateTime.now().toIso8601String(),
      "channelName": "WEB",
      "serviceName": "API_PURCHASE",
      "serviceParams": {
        "merchantUid": merchantUid,
        "apiUserId": apiUserId,
        "apiKey": apiKey,
        "paymentMethod": "MWALLET_ACCOUNT",
        "payerInfo": {
          "accountNo": _accountController.text.trim(),
        },
        "transactionInfo": {
          "referenceId": DateTime.now()
              .millisecondsSinceEpoch
              .toString(), // Unique reference ID
          "invoiceId": "154", // Replace with your invoice ID
          "amount": double.tryParse(_amountController.text.trim()) ??
              0.0, // Ensure amount is a valid number
          "currency": "USD",
          "description": _descriptionController.text.trim(),
        }
      }
    };

    // final requestPayLoad = {
    //   "schemaVersion": "1.0",
    //   "requestId": "{{$id}}",
    //   "timestamp": "{{$time}}",
    //   "channelName": "MOBILE",
    //   "serviceName": "API_PURCHASE",
    //   "serviceParams": {
    //     "merchantUid": {
    //       {"M0910291"}
    //     },
    //     "apiUserId": {
    //       {1000416}
    //     },
    //     "apiKey": {
    //       {"675418888AHX"}
    //     },
    //     "paymentMethod": "MWALLET_ACCOUNT",
    //     "payerInfo": {"accountNo": "252616451975"},
    //     "transactionInfo": {
    //       "referenceId": "{{$ref}}",
    //       "invoiceId": "154",
    //       "amount": "10",
    //       "currency": "USD",
    //       "description": "{{testing}}"
    //     }
    //   }
    // };

    // Debugging: print the request payload
    print("Request Payload: ${json.encode(requestPayLoad)}");

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: json.encode(requestPayLoad),
      );

      // Debugging: print the response status and body
      print("Response Status: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final responseMsg = responseData['responseMsg'];
        final transactionId = responseData['params']['transactionId'];

        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('Payment Status'),
            content: Text(
                'Payment Successful! Transaction ID: $transactionId\nMessage: $responseMsg'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
              ),
            ],
          ),
        );
      } else {
        throw Exception('Payment failed');
      }
    } catch (error) {
      print("Error: $error"); // Debugging: print the error
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('Error'),
          content: Text('Something went wrong. Please try again.'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(ctx).pop();
              },
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("WaafiPay Payment"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _accountController,
              decoration: InputDecoration(labelText: "Account Number"),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _amountController,
              decoration: InputDecoration(labelText: "Amount"),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: "Description"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: makePayment,
              child: Text("Pay Now"),
            ),
          ],
        ),
      ),
    );
  }
}
