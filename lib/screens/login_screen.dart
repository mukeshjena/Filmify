import 'package:Filmify/screens/main.dart';
import 'package:Filmify/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF242A32),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Filmify',
              style: GoogleFonts.sacramento(
                fontSize: 100.0,
                color: Color(0xFF0296E5),
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton.icon(
              onPressed: () async {
                // Check if user is already authenticated with Google
                final currentUser = FirebaseAuth.instance.currentUser;
                if (currentUser != null && !currentUser.isAnonymous) {
                  // User is already authenticated, navigate to home screen
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Main(),
                    ),
                  );
                } else {
                  // Sign in with Google
                  final userCredential = await AuthService().signInWithGoogle();

                  if (userCredential != null) {
                    // Authentication successful, navigate to home screen
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Main(),
                      ),
                    );
                  } else {
                    // Handle authentication failure
                    // Show an error message or perform any desired actions
                  }
                }
              },
              icon: const Icon(Icons.login),
              label: const Text('Sign in with Google'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: const Color(0xFF0296E5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
