import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<User?> signUpUser(String email, String password) async {
  try {
    UserCredential userCredential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
    // Store user data in Firestore
    FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).set({
      'email': email,
      'password': password
    });
    print('User signed up and data stored in Firebase.');
    return userCredential.user;
  } catch (e) {
    print('Error: $e');
  }
}

final FirebaseAuth _auth = FirebaseAuth.instance;

Future<User?> login(String email,String password) async {
  try {
    await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return _auth.currentUser;
  } catch (e) {
    throw Exception("No internet access!");
  }
}
