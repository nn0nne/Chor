import 'package:chor/pages/auth/signup_page.dart';
import 'package:chor/pages/home_page.dart';
import 'package:chor/services/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    return Scaffold(
      backgroundColor: Color(0xFF070F2B),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Welcome Text
                Text(
                  "Hello Again!",
                  style: TextStyle(
                    color: Color(0xFFEEEEEE),
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),

                // Subheading
                Text(
                  "It’s nice to see you again!",
                  style: TextStyle(
                    color: Color(0xFFEEEEEE),
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),

                // Subheading
                Text(
                  "Please sign in to your account!",
                  style: TextStyle(
                    color: Color(0xFFEEEEEE),
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10), // Spacing before the form container

                // Form Container
                Container(
                  margin: EdgeInsets.only(top: 16.0),
                  padding: EdgeInsets.all(16.0),
                  width: MediaQuery.of(context).size.width - 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    color: Color(0x4D1B1A55), // Semi-transparent color
                  ),
                  child: Column(
                    children: [
                      // Sign-Up Text
                      Text(
                        "Sign In",
                        style: TextStyle(
                          color: Color(0xFFEEEEEE),
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(
                          height: 16), // Spacing between title and fields
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Email",
                            style: TextStyle(
                                color: Color(0xFFEEEEEE), fontSize: 20),
                          ),
                          TextField(
                            controller: _emailController,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor:
                                  Color(0xFFEEEEEE), // Field background color
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              hintText: "Enter your email",
                              hintStyle: TextStyle(color: Color(0xFF282828)),
                            ),
                            style: TextStyle(color: Color(0xFF282828)),
                          ),
                          const SizedBox(height: 16), // Spacing between fields

                          // Password TextField
                          Text(
                            "Password",
                            style: TextStyle(
                                color: Color(0xFFEEEEEE), fontSize: 20),
                          ),
                          TextField(
                            controller: _passwordController,
                            obscureText: true,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor:
                                  Color(0xFFEEEEEE), // Field background color
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              hintText: "Enter your password",
                              hintStyle: TextStyle(color: Color(0xFF282828)),
                            ),
                            style: TextStyle(color: Color(0xFF282828)),
                          ),
                          if (_errorMessage != null)
                            Text(
                              _errorMessage!,
                              style: const TextStyle(color: Colors.red),
                            ),

                          const SizedBox(height: 40),

                          // Sign-In Button
                          _isLoading
                              ? Center(child: const CircularProgressIndicator())
                              : Row(
                                  children: [
                                    Expanded(
                                      child: ElevatedButton(
                                        onPressed: () async {
                                          setState(() {
                                            _isLoading = true;
                                            _errorMessage = null;
                                          });

                                          try {
                                            bool signInSuccess =
                                                await authService.signIn(
                                                    _emailController.text
                                                        .trim(),
                                                    _passwordController.text
                                                        .trim(),
                                                    context);
                                            // Navigate to HomePage and remove all previous routes
                                            if (signInSuccess) {
                                              // Navigate to HomePage and remove all previous routes
                                              Navigator.pushAndRemoveUntil(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        HomePage()),
                                                (route) =>
                                                    false, // Remove all previous routes
                                              );
                                            }
                                          } catch (e) {
                                            setState(() {
                                              _errorMessage = e.toString();
                                            });
                                          } finally {
                                            setState(() {
                                              _isLoading = false;
                                            });
                                          }
                                        },
                                        style: ElevatedButton.styleFrom(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 16.0), // Button height
                                          backgroundColor:
                                              Color(0xFF1B1A55), // Button color
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12.0),
                                          ),
                                        ),
                                        child: const Text(
                                          "Sign In",
                                          style: TextStyle(
                                            color: Color(0xFFEEEEEE),
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                        ],
                      ),
                      SizedBox(height: 40),
                      // Sign-Up Link
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Don't have an account? ",
                            style: const TextStyle(
                              color: Color(0xFFEEEEEE),
                              fontSize: 16,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              // Navigate to the Sign Up page
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SignUp()),
                              );
                            },
                            child: Text(
                              "Sign up",
                              style: const TextStyle(
                                  color: Color(0xFFEEEEEE),
                                  fontSize: 16,
                                  decoration: TextDecoration.underline,
                                  decorationColor: Color(
                                      0xFFEEEEEE) // Optional to show it's clickable
                                  ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
