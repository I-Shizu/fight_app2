import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseController {
  
  Future<void> addUserToFirestore(User user) async {
    final usersRef = FirebaseFirestore.instance.collection('user_data');
    final userDoc = await usersRef.doc(user.uid).get();

    if (!userDoc.exists) {
      await usersRef.doc(user.uid).set({
        'uid': user.uid,
        'email': user.email,
        'displayName': user.displayName,
      });
    }
  }
}