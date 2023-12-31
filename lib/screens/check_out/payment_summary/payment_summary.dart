import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shiv/config/colors.dart';
import 'package:shiv/models/delivery_address_model.dart';
import 'package:shiv/providers/review_cart_provider.dart';
import 'package:shiv/screens/check_out/delivery_details/single_delivery_item.dart';
import 'package:shiv/screens/check_out/payment_summary/confirmation_dialog.dart';
import 'package:shiv/screens/check_out/payment_summary/order_item.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shiv/providers/upi.dart';
import 'package:uuid/uuid.dart';
import '../../../models/review_cart_model.dart';
import '../../order/order_successful.dart';

class PaymentSummary extends StatefulWidget {
  final DeliveryAddressModel? deliverAddressList;
  PaymentSummary({this.deliverAddressList});

  @override
  _PaymentSummaryState createState() => _PaymentSummaryState();
}

enum AddressTypes {
  Home,
  OnlinePayment,
}

class _PaymentSummaryState extends State<PaymentSummary> {
  var myType = AddressTypes.Home;

  @override
  Widget build(BuildContext context) {
    ReviewCartProvider reviewCartProvider = Provider.of(context);
    reviewCartProvider.getReviewCartData();

    double discount = 30;
    double? discountValue;
    double shippingChanrge = 3.7;
    double total;
    double totalPrice = reviewCartProvider.getTotalPrice();
    if (totalPrice > 300) {
      double discountValue = (totalPrice * discount) / 100;
      total = totalPrice - discountValue + shippingChanrge;
    } else {
      total = totalPrice + shippingChanrge;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Payment Summary",
          style: TextStyle(fontSize: 18),
        ),
      ),
      bottomNavigationBar: ListTile(
        title: Text("Total Amount"),
        subtitle: Text(
          "\₹ ${total != null ? total + 5 : totalPrice}",
          style: TextStyle(
            color: Colors.green[900],
            fontWeight: FontWeight.bold,
            fontSize: 17,
          ),
        ),
        trailing: Container(
          width: 160,
          child: MaterialButton(
            onPressed: () async {
              // Initialize Firebase (add this if not done already)
              await Firebase.initializeApp();


              if (myType == AddressTypes.OnlinePayment) {

                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) =>HomePage1()
                    ,
                ),
                );


              } else if (myType == AddressTypes.Home) {
                // Show the confirmation dialog
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return ConfirmationDialog(
                      onConfirm: () async {
                        // Add order data to Firebase and navigate to Order Successful Page
                        placeAndCancelOrder(
                            oderItemList: reviewCartProvider
                                .getReviewCartDataList,
                            subTotal: total,
                            context: context // Pass the correct subTotal here
                        );
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => OrderSuccessfulPage(),
                          ),
                        );
                      },
                    );
                  },
                );
              }

            },

            child: Text(
              "Place Order",
              style: TextStyle(
                color: textColor,
              ),
            ),
            color: primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),

          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: ListView.builder(
          itemCount: 1,
          itemBuilder: (context, index) {
            return Column(
              children: [
                SingleDeliveryItem(
                  address:
                  "area, ${widget.deliverAddressList?.area}, street, ${widget
                      .deliverAddressList?.street}, society ${widget
                      .deliverAddressList?.society}, pinCode ${widget
                      .deliverAddressList?.pinCode}",
                  title:
                  "${widget.deliverAddressList?.firstName} ${widget
                      .deliverAddressList?.lastName}",
                  number: widget.deliverAddressList?.mobileNo,
                  addressType: widget.deliverAddressList?.addressType ==
                      "AddressTypes.Home"
                      ? "Home"
                      : widget.deliverAddressList?.addressType ==
                      "AddressTypes.Other"
                      ? "Other"
                      : "Work",
                ),
                Divider(),
                ExpansionTile(
                  children: reviewCartProvider.getReviewCartDataList.map((e) {
                    return OrderItem(
                      e: e,
                    );
                  }).toList(),
                  title: Text(
                      "Order Items ${reviewCartProvider.getReviewCartDataList
                          .length}"),
                ),
                Divider(),
                ListTile(
                  minVerticalPadding: 5,
                  leading: Text(
                    "Sub Total",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  trailing: Text(
                    "\₹${totalPrice + 5}",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                ListTile(
                  minVerticalPadding: 5,
                  leading: Text(
                    "Shipping Charge",
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  trailing: Text(
                    "\₹$discountValue",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                ListTile(
                  minVerticalPadding: 5,
                  leading: Text(
                    "Coupon Discount",
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  trailing: Text(
                    "\₹ 0",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Divider(),
                ListTile(
                  leading: Text("Payment Options"),
                ),
                RadioListTile(
                  value: AddressTypes.Home,
                  groupValue: myType,
                  title: Text("Cash on Delivery"),
                  onChanged: (AddressTypes? value) {
                    setState(() {
                      myType = value!;
                    });
                  },
                  secondary: Icon(
                    Icons.home_outlined,
                    color: primaryColor,
                  ),
                ),
                RadioListTile(
                  value: AddressTypes.OnlinePayment,
                  groupValue: myType,
                  title: Text("Online Payment"),
                  onChanged: (AddressTypes? value) {
                    setState(() {
                      myType = value!;
                    });
                  },
                  secondary: Icon(
                    Icons.phone_android_outlined,
                    color: primaryColor,
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }


  void placeAndCancelOrder({
    required List<ReviewCartModel> oderItemList,

    required double subTotal,
    BuildContext? context
  }) async {

      var uuid = Uuid();
      var orderId = uuid.v4(); // Generate a unique ID

      await FirebaseFirestore.instance
          .collection("usersData")
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .collection("MyOrders")
          .doc(orderId) // Use the generated orderId
          .set(
        {
          "orderId": orderId, // Add the orderId field to the document
          "subTotal": "1234",
          "Shipping Charge": "",
          "Discount": "10",
          "orderItems": oderItemList
              .map((e) =>
          {
            "orderTime": DateTime.now(),
            "orderImage": e.cartImage,
            "orderName": e.cartName,
            "orderUnit": e.cartUnit,
            "orderPrice": e.cartPrice,
            "orderQuantity": e.cartQuantity
          })
              .toList(),
        },
      );

    }
  }
