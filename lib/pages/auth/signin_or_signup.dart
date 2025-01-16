import 'package:chor/pages/auth/signin_page.dart';
import 'package:chor/pages/auth/signup_page.dart';
import 'package:flutter/material.dart';

class SignInOrSignUp extends StatefulWidget {
  const SignInOrSignUp({super.key});

  @override
  State<SignInOrSignUp> createState() => _SignInOrSignUpState();
}

class _SignInOrSignUpState extends State<SignInOrSignUp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF070F2B), // Dark blue background
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.8,
          padding: const EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            // color: const Color(0x4D1B1A55), // Slightly lighter dark blue
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'assets/chor_logo_no_box.png',
                width: 200,
                // height: 300,
                fit: BoxFit.cover,
              ),
              SizedBox(
                height: 72,
              ),
              const Text(
                'Hello There!',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFEEEEEE),
                ),
              ),
              const SizedBox(height: 8.0),
              const Text(
                'Welcome to Chor',
                style: TextStyle(
                  fontSize: 32,
                  color: Color(0xFFEEEEEE),
                ),
              ),
              const SizedBox(height: 36.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        // Navigate to Sign Up page
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => SignUp()));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color(0xFF1B1A55), // Darker button color
                        padding: const EdgeInsets.all(12.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      child: const Text(
                        'Sign Up',
                        style: TextStyle(color: Color(0xFFEEEEEE)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 30.0),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        // Navigate to Sign In page
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => SignIn()));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color(0x4D1B1A55), // Darker button color
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      child: const Text(
                        'Sign In',
                        style: TextStyle(color: Color(0xFFEEEEEE)),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
