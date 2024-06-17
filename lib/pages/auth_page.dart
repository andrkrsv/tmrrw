import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'home_page.dart';
import 'login_or_reg.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});
Future<void> checkAndAddUser() async {
  final user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    final userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    if (!userDoc.exists) {
      // Add the user to Firestore with groupId and root set to null and false respectively
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .set({'groupId': "null", 'root': false}); // Set root to false
    } else {
      // User already exists
      final data = userDoc.data();
      if (data != null) {
        final rootValue = data['root'];
        if (rootValue != true) { // Check if root is not explicitly true
          // Set root to false if it's missing, null, or any other value except true
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .update({'root': false});
        }
        // If root is true, do nothing (preserve existing value)
      }
    }
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        //если уже вошел
        if (snapshot.hasData) {
          checkAndAddUser();
          return const HomePage();
        }
        //если еще не решился
        else {
          return const LoginOrRegisterPage();
        }
      },
    ));
  }
}
