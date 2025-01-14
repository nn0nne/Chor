import 'package:flutter/material.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  @override
  Widget build(BuildContext context) {
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
                            decoration: InputDecoration(
                              filled: true,
                              fillColor:
                                  Color(0xFFEEEEEE), // Field background color
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              labelText: "Enter your email",
                              labelStyle: TextStyle(color: Color(0xFF282828)),
                            ),
                            style: TextStyle(color: Color(0xFFEEEEEE)),
                          ),
                          const SizedBox(height: 16), // Spacing between fields

                          // Password TextField
                          Text(
                            "Password",
                            style: TextStyle(
                                color: Color(0xFFEEEEEE), fontSize: 20),
                          ),
                          TextField(
                            obscureText: true,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor:
                                  Color(0xFFEEEEEE), // Field background color
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              labelText: "Enter your password",
                              labelStyle: TextStyle(color: Color(0xFF282828)),
                            ),
                            style: TextStyle(color: Color(0xFFEEEEEE)),
                          ),
                        ],
                      ),
                      // Email TextField

                      const SizedBox(height: 40), // Spacing before the button

                      // Sign-Up Button
                      Center(
                        child: Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 16.0), // Button height
                                  backgroundColor:
                                      Color(0xFF1B1A55), // Button color
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                ),
                                child: Text(
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
                      ),
                      SizedBox(height: 40),
                      Text(
                        "Don't have an acount? Sign up",
                        style:
                            TextStyle(color: Color(0xFFEEEEEE), fontSize: 16),
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
