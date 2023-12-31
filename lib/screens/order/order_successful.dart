import 'package:flutter/material.dart';

class OrderSuccessfulPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Successful'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.check_circle_outline,
              size: 80,
              color: Colors.green,
            ),
            SizedBox(height: 20),
            Text(
              'Order Placed Successfully!',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Thank you for your order.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                // Navigate back to home or another screen
                Navigator.popUntil(context, (route) => route.isFirst);
              },
              child: Text("Continue Shopping"),
            ),
          ],
        ),
      ),
    );
  }
}
