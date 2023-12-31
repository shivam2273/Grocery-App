import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shiv/models/review_cart_model.dart';

class MyOrderPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Orders'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('usersData')
            .doc(FirebaseAuth.instance.currentUser?.uid)
            .collection('MyOrders')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                // You can customize the color, background, and strokeWidth here.
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue), // Customize the color.
                backgroundColor: Colors.white, // Customize the background color.
                strokeWidth: 4.0, // Customize the stroke width.
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text('No Orders available.'),
            );
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              QueryDocumentSnapshot order = snapshot.data!.docs[index];
              List<dynamic> orderItems = order['orderItems'];

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Order ${index + 1}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  Container(
                    height: 80, // Adjust the height as needed
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: orderItems.length,
                      itemBuilder: (context, itemIndex) {
                        Map<String, dynamic> item = orderItems[itemIndex];

                        return Container(
                          width: 370, // Adjust the width as needed
                          margin: EdgeInsets.symmetric(horizontal: 8),
                          child: OrderItem(e: ReviewCartModel(
                            cartImage: item["orderImage"],
                            cartName: item["orderName"],
                            cartUnit: item["orderUnit"],
                            cartPrice: item["orderPrice"],
                            cartQuantity: item["orderQuantity"],
                          )),
                        );
                      },
                    ),
                  ),
                  Divider(), // Add a divider between orders
                ],
              );
            },
          );
        },
      ),
    );
  }
}


class OrderItem extends StatelessWidget {
  final ReviewCartModel e;
  OrderItem({required this.e});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.all(0), // Remove default padding
      leading: SizedBox( // Wrap leading with SizedBox to set a specific width
        width: 90,
        child: Image.network(
          e.cartImage!,
          fit: BoxFit.cover, // Adjust image fit as needed
        ),
      ),
      title: Text(
        e.cartName!,
        style: TextStyle(
          color: Colors.grey[600],
        ),
      ),
      subtitle: Text(e.cartQuantity.toString()),
      trailing: Text('\₹${e.cartPrice}'),
    );
  }
}

