import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:shiv/models/user_model.dart';

class UserProvider with ChangeNotifier {
  late UserModel currentData;

  void addUserData({
    User? currentUser,
    String? userName,
    String? userImage,
    String? userEmail,
  }) async {
    await FirebaseFirestore.instance
        .collection("usersData")
        .doc(currentUser?.uid)
        .set(
      {
        "userName": userName,
        "userEmail": userEmail,
        "userImage": userImage,
        "userUid": currentUser?.uid,
      },
    );
  }
  //late UserModel currentData;
  void getUserData() async {
    UserModel userModel;
    var value = await FirebaseFirestore.instance
        .collection("usersData")
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .get();
    if (value.exists) {
      userModel = UserModel(
        userEmail: value.get("userEmail"),
        userImage: value.get("userImage"),
        userName: value.get("userName"),
        userUid: value.get("userUid"),
      );
      currentData = userModel;
      notifyListeners();
    }
  }
  UserModel get currentUserData {
    return currentData;
  }

  Future<void> signOut() async {
    try {
      // Perform the sign out logic here
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      // Handle any errors that occur during sign out
      print('Error during sign out: $e');
    }
  }
}

