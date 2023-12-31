import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RatingPage extends StatefulWidget {
  @override
  _RatingPageState createState() => _RatingPageState();
}

class _RatingPageState extends State<RatingPage>  with TickerProviderStateMixin{
  double _rating = 0; // Initialize rating value
  String _email = '';
  String _name = '';
  String _uid = '';
  bool _isRatingSubmitted = false;

  late AnimationController controller;
  late Animation<double> animation;

  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;



  @override
  void initState() {
    super.initState();
    _getUserData();

    controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );

    animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        curve: Curves.easeOutBack,
        parent: controller,
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _getUserData() async {
    User? user = _auth.currentUser;
    if (user != null) {
      setState(() {
        _email = user.email ?? '';
        _name = user.displayName ?? '';
        _uid = user.uid;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Rate App and service'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            Text("Rate the app and Services",style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic,fontWeight: FontWeight.bold ),),
            SizedBox(height: 20),
            // Rating stars
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (int i = 1; i <= 5; i++)
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _rating = i.toDouble();
                      });
                    },
                    child: Icon(
                      Icons.star,
                      size: 40,
                      color: i <= _rating ? Colors.yellow : Colors.grey,
                    ),
                  ),
              ],
            ),
            SizedBox(height: 20),
            Text(
              _rating > 0 ? 'You rated $_rating stars' : 'Tap a star to rate',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () async {
                if (_rating > 0) {
                  await _firestore.collection('usersData')
                      .doc(FirebaseAuth.instance.currentUser?.uid)
                      .collection("YourRating")
                      .doc(FirebaseAuth.instance.currentUser?.uid)
                      .set({
                    'rating': _rating,
                    'email': _email,
                    'name': _name,
                    'uid': _uid,
                    'timestamp': FieldValue.serverTimestamp(),
                  });
                  setState(() {
                    _isRatingSubmitted = true;
                  });
                  _showRatingSubmittedDialog();
                }
              },
              child: Text('Submit Rating'),
            ),
          ],
        ),
      ),
    );
  }


  void _showRatingSubmittedDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AnimatedBuilder(
          animation: controller,
          builder: (BuildContext context, Widget? child) {
            return Transform.scale(
              scale: animation.value,
              child: AlertDialog(
                title: Text('Rating Submitted'),
                content: Text('Thank you for submitting your rating!'),
                actions: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pop(context); // Pop the rating page as well
                    },
                    child: Text('OK'),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
    controller.forward(); // Start the animation when dialog is shown
  }


}

