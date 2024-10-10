import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:grocery_app/consts/firebase_consts.dart';
import 'package:grocery_app/widgets/text_widget.dart';

import '../fetch_screen.dart';
import '../screens/btm_bar.dart';
import '../services/global_methods.dart';

class GoogleButton extends StatelessWidget {
  GoogleButton({Key? key}) : super(key: key);

  final GoogleSignIn googleSignIn = GoogleSignIn();
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> signInWithGoogle(context) async {
    try {
      UserCredential userCredential;

      if (kIsWeb) {
        // Web-specific flow
        final GoogleAuthProvider googleProvider = GoogleAuthProvider();

        // This will trigger the Google Sign-In flow and prompt the user
        userCredential = await firebaseAuth.signInWithPopup(googleProvider);
      } else {
        // Mobile-specific flow
        final GoogleSignInAccount? googleSignInAccount =
            await googleSignIn.signIn();

        if (googleSignInAccount != null) {
          final GoogleSignInAuthentication googleSignInAuthentication =
              await googleSignInAccount.authentication;

          final AuthCredential credential = GoogleAuthProvider.credential(
            accessToken: googleSignInAuthentication.accessToken,
            idToken: googleSignInAuthentication.idToken,
          );

          userCredential = await firebaseAuth.signInWithCredential(credential);
        } else {
          return;
        }
      }
      final User? user = userCredential.user;

      if (user != null) {
        // Check if the user already exists in Firestore
        final DocumentSnapshot userDoc =
            await firestore.collection('users').doc(user.uid).get();

        if (!userDoc.exists) {
          // If the user does not exist, store user data in Firestore with the specified fields
          await firestore.collection('users').doc(user.uid).set({
            'id': user.uid,
            'name': user.displayName,
            'email': user.email,
            'shipping-address': '',
            'userWish': [],
            'userCart': [],
            'createdAt': Timestamp.now(),
          });
        }

        // Navigate to FetchScreen (or any other screen)
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => FetchScreen()));

        print("User data stored successfully in Firestore.");
      }
    } catch (e) {
      print("Error during Google sign-in: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.blue,
      child: InkWell(
        onTap: () {
          // _googleSignIn(context);
          signInWithGoogle(context);
        },
        child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
          Container(
            color: Colors.white,
            child: Image.asset(
              'assets/images/google.png',
              width: 40.0,
            ),
          ),
          const SizedBox(
            width: 8,
          ),
          TextWidget(
              text: 'Sign in with google', color: Colors.white, textSize: 18)
        ]),
      ),
    );
  }
}
