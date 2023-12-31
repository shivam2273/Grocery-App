import 'package:flutter/material.dart';
import 'package:shiv/config/colors.dart';
import 'package:shiv/models/product_model.dart';
import 'package:shiv/models/review_cart_model.dart';
import 'package:shiv/providers/review_cart_provider.dart';
import 'package:shiv/providers/wishlist_provider.dart';
import 'package:shiv/widgets/single_item.dart';
import 'package:provider/provider.dart';

class WishLsit extends StatefulWidget {
  @override
  _WishLsitState createState() => _WishLsitState();
}

class _WishLsitState extends State<WishLsit> {
  late WishListProvider wishListProvider;
  showAlertDialog(BuildContext context, ProductModel delete) {
    // set up the buttons
    Widget cancelButton =TextButton(
      child: Text("No"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = TextButton(
      child: Text("Yes"),
      onPressed: () {
        wishListProvider.deleteWishtList(delete.productId);
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("WishList Product"),
      content: Text("Are you sure you want to delete the wishList Product?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    wishListProvider = Provider.of(context);
    wishListProvider.getWishtListData();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "WishList",
          style: TextStyle(color: textColor, fontSize: 18),
        ),
      ),
      body: ListView.builder(
        itemCount: wishListProvider.getWishList.length,
        itemBuilder: (context, index) {
          ProductModel data = wishListProvider.getWishList[index];
          return Column(
            children: [
              SizedBox(
                height: 10,
              ),
              SingleItem(
                isBool: true,
                productImage: data.productImage,
                productName: data.productName,
                productPrice: data.productPrice,
                productId: data.productId,
                productQuantity: data.productQuantity,
                onDelete: () {
                  showAlertDialog(context,data);
                },
              ),
            ],
          );
        },
      ),
    );
  }
}


