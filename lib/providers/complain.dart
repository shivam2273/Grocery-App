import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


class RaiseComplain extends StatefulWidget {
  const RaiseComplain({Key? key}) : super(key: key);

  @override
  _RaiseComplainState createState() => _RaiseComplainState();
}

class _RaiseComplainState extends State<RaiseComplain> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _complaintController = TextEditingController();

  String? _errorText;

  Future<void> _submitComplaint(BuildContext context) async {
    // Get the current user
    final User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      final String name = _nameController.text.trim();
      final String email = _emailController.text.trim();
      final String description = _complaintController.text.trim();

      try {
        // Add the complaint to the "Complaints" collection
        await FirebaseFirestore.instance.collection('usersData').
        doc(FirebaseAuth.instance.currentUser?.uid)
            .collection("User Complains")
            .doc().set({
          'userId': user.uid,
          'name': name,
          'email': email,
          'description': description,
          'timestamp': FieldValue.serverTimestamp(),
        });

        // Clear the input fields
        _nameController.clear();
        _emailController.clear();
        _complaintController.clear();

        // Show a success message or navigate to another screen
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Complaint submitted successfully!'),
            duration: Duration(seconds: 3),
          ),
        );
      } catch (e) {
        // Handle any errors that occur during the submission
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('An error occurred. Please try again later.'),
            duration: Duration(seconds: 3),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold( // Wrap with Scaffold
      appBar: AppBar(
        title: Text('Complaint Form'),
      ),
      body: Material( // Wrap with Material
        child: Column(
          children: [
            const Text(
              'Register a Complain',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 15),
            SizedBox(
              width: 420,
             // height: 500,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0xFFC4ACA1),
                      blurRadius: 4,
                      spreadRadius: 2,
                    )
                  ],
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.white,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Name',
                        style: TextStyle(
                          color: Color(0xFF4756DF),
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: TextField(
                          controller: _nameController,
                          decoration: InputDecoration(
                            hintText: 'Enter Your Name',
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0xFF4756DF),
                              ),
                            ),
                            contentPadding: EdgeInsets.symmetric(horizontal: 10),
                          ),
                        ),
                      ),
                      const Text(
                        'Email',
                        style: TextStyle(
                          color: Color(0xFF4756DF),
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: TextField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            hintText: 'Enter Your Email',
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0xFF4756DF),
                              ),
                            ),
                            contentPadding: EdgeInsets.symmetric(horizontal: 10),
                          ),
                        ),
                      ),
                      const Text(
                        'Complain in description',
                        style: TextStyle(
                          color: Color(0xFF4756DF),
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: TextField(
                          controller: _complaintController,
                          minLines: 5,
                          maxLines: 7,
                          decoration: InputDecoration(
                            hintText: 'Enter Your complain in detail',
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0xFF4756DF),
                              ),
                            ),
                            contentPadding: EdgeInsets.all(9.0),
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                // Validate email input and then attempt submission.
                                if (RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$')
                                    .hasMatch(_emailController.text)) {
                                  _submitComplaint(context);
                                } else {
                                  // Handle invalid email format (e.g., show an error message).
                                  setState(() {
                                    _errorText = 'Invalid email address';
                                  });
                                }
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Submit',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


