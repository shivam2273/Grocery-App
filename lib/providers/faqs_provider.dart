import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shiv/models/FAQs_model.dart';


class FAQProvider{
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<QuestionAnswer>> getFAQs() {
    return _firestore
      //.collection('usersData')
        .collection('FAQs')
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => QuestionAnswer.fromMap(doc.data() as Map<String, dynamic>))
        .toList());
  }
}
