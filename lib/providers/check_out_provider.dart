import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shiv/models/delivery_address_model.dart';
import 'package:shiv/models/review_cart_model.dart';


class CheckoutProvider with ChangeNotifier {
  bool isloading = false;

  TextEditingController firstName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController mobileNo = TextEditingController();
  TextEditingController alternateMobileNo = TextEditingController();
  TextEditingController society = TextEditingController();
  TextEditingController street = TextEditingController();
  TextEditingController landmark = TextEditingController();
  TextEditingController city = TextEditingController();
  TextEditingController area = TextEditingController();
  TextEditingController pinCode = TextEditingController();
  //late LocationData setLoaction;// Initialize this field

  void validator(context, myType) async {
    if (firstName.text.isEmpty) {
      Fluttertoast.showToast(msg: "firstname is empty");
    } //else if (lastName.text.isEmpty) {
     // Fluttertoast.showToast(msg: "lastname is empty");
    //}
    else if (mobileNo.text.isEmpty) {
      Fluttertoast.showToast(msg: "mobileNo is empty");
    }// else if (alternateMobileNo.text.isEmpty) {
     // Fluttertoast.showToast(msg: "alternateMobileNo is empty");
    //}
    else if (society.text.isEmpty) {
      Fluttertoast.showToast(msg: "society is empty");
    } else if (street.text.isEmpty) {
      Fluttertoast.showToast(msg: "street is empty");
    } else if (landmark.text.isEmpty) {
      Fluttertoast.showToast(msg: "landmark is empty");
    } else if (city.text.isEmpty) {
      Fluttertoast.showToast(msg: "city is empty");
    } else if (area.text.isEmpty) {
      Fluttertoast.showToast(msg: "area is empty");
    } else if (pinCode.text.isEmpty) {
      Fluttertoast.showToast(msg: "pin Code is empty");
     }// else if (setLoaction == null) {
   //   Fluttertoast.showToast(msg: "setLoaction is empty");        // commented by me
   // }
    else {
      isloading = true;
      notifyListeners();
      await FirebaseFirestore.instance
          .collection("usersData")
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .collection("deliveryAddress")
      .doc(FirebaseAuth.instance.currentUser?.uid)
          .set({
        "firstname": firstName.text,
        "lastname": lastName.text,
        "mobileNo": mobileNo.text,
        "alternateMobileNo": alternateMobileNo.text,
        "society": society.text,
        "street": street.text,
        "landmark": landmark.text,
        "city": city.text,
        "area": area.text,
        "pinCode": pinCode.text,
        "addressType": myType.toString(),
        // "longitude": setLoaction.longitude,     // commented by me
        // "latitude": setLoaction.latitude,
      }).then((value) async {
        isloading = false;
        notifyListeners();
        await Fluttertoast.showToast(msg: "Add your delivery address");
        Navigator.of(context).pop();
        notifyListeners();
      });
      notifyListeners();
    }
  }

  List<DeliveryAddressModel> deliveryAdressList = [];
  getDeliveryAddressData() async {
    List<DeliveryAddressModel> newList = [];

    DeliveryAddressModel deliveryAddressModel;
    DocumentSnapshot _db = await FirebaseFirestore.instance
    .collection("usersData")
    .doc(FirebaseAuth.instance.currentUser?.uid)
    .collection("deliveryAddress")
    .doc(FirebaseAuth.instance.currentUser?.uid)
    .get();

    if (_db.exists) {
      deliveryAddressModel = DeliveryAddressModel(
        firstName: _db.get("firstname"),
        lastName: _db.get("lastname"),
        addressType: _db.get("addressType"),
        area: _db.get("area"),
        alternateMobileNo: _db.get("alternateMobileNo"),
        city: _db.get("city"),
        landMark: _db.get("landmark"),
        mobileNo: _db.get("mobileNo"),
        pinCode: _db.get("pinCode"),
        society: _db.get("society"),
        street: _db.get("street"),
      );
      newList.add(deliveryAddressModel);
      notifyListeners();
    }

    deliveryAdressList = newList;
    notifyListeners();
  }

  List<DeliveryAddressModel> get getDeliveryAddressList {
    return deliveryAdressList;
  }

////// Order /////////

  addPlaceOderData({
    required List<ReviewCartModel> oderItemList,
    var subTotal,
    var address,
    var shipping,

  }) async {
    FirebaseFirestore.instance
        .collection("usersData")
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection("MyOrders")
        .doc()
        .set(
      {

        "subTotal": "1234",
        "Shipping Charge": "",
        "Discount": "10",
        "orderItems": oderItemList
            .map((e) => {
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
