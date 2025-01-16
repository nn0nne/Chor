import 'package:chor/pages/auth/signin_page.dart';
import 'package:chor/services/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future<void> _signUp(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      try {
        final authService = Provider.of<AuthService>(context, listen: false);
        await authService.signUp(_emailController.text.trim(),
            _passwordController.text.trim(), context);

        // Navigate to the SignIn page after successful signup
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const SignIn()),
        );
      } catch (e) {
        // Show error message in case of failure
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    }
  }

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
                  "Welcome!",
                  style: TextStyle(
                    color: Color(0xFFEEEEEE),
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),

                // Subheading
                Text(
                  "Register and start exploring the app!",
                  style: TextStyle(
                    color: Color(0xFFEEEEEE),
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10), // Spacing before the form container

                // Form Container
                Container(
                  margin: const EdgeInsets.only(top: 16.0),
                  padding: const EdgeInsets.all(16.0),
                  width: MediaQuery.of(context).size.width - 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    color: const Color(0x4D1B1A55),
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        // Sign-Up Text
                        const Text(
                          "Sign Up",
                          style: TextStyle(
                            color: Color(0xFFEEEEEE),
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),

                        // Email Field
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Email",
                              style: TextStyle(
                                color: Color(0xFFEEEEEE),
                                fontSize: 20,
                              ),
                            ),
                            TextFormField(
                              controller: _emailController,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: const Color(0xFFEEEEEE),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                hintText: "Enter your email",
                                hintStyle:
                                    const TextStyle(color: Color(0xFF282828)),
                              ),
                              style: const TextStyle(color: Color(0xFF282828)),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Email cannot be empty";
                                } else if (!RegExp(r'\S+@\S+\.\S+')
                                    .hasMatch(value)) {
                                  return "Enter a valid email";
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),

                            // Password Field
                            const Text(
                              "Password",
                              style: TextStyle(
                                color: Color(0xFFEEEEEE),
                                fontSize: 20,
                              ),
                            ),
                            TextFormField(
                              controller: _passwordController,
                              obscureText: true,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: const Color(0xFFEEEEEE),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                hintText: "Enter your password",
                                hintStyle:
                                    const TextStyle(color: Color(0xFF282828)),
                              ),
                              style: const TextStyle(color: Color(0xFF282828)),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Password cannot be empty";
                                } else if (value.length < 6) {
                                  return "Password must be at least 6 characters";
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 40),

                        // Sign-Up Button
                        Center(
                          child: Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () => _signUp(context),
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16.0),
                                    backgroundColor: const Color(0xFF1B1A55),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12.0),
                                    ),
                                  ),
                                  child: const Text(
                                    "Sign Up",
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
                        const SizedBox(height: 40),

                        // Navigate to SignIn
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Already have an account? ",
                              style: TextStyle(
                                color: Color(0xFFEEEEEE),
                                fontSize: 16,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const SignIn(),
                                  ),
                                );
                              },
                              child: const Text(
                                "Sign In",
                                style: TextStyle(
                                    color: Color(0xFFEEEEEE),
                                    fontSize: 16,
                                    decoration: TextDecoration.underline,
                                    decorationColor: Color(0xFFEEEEEE)),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
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

                  // child: Column(
                  //   children: [
                  //     // Sign-Up Text
                  //     Text(
                  //       "Sign Up",
                  //       style: TextStyle(
                  //         color: Color(0xFFEEEEEE),
                  //         fontSize: 30,
                  //         fontWeight: FontWeight.bold,
                  //       ),
                  //       textAlign: TextAlign.center,
                  //     ),
                  //     const SizedBox(
                  //         height: 16), // Spacing between title and fields
                  //     Column(
                  //       crossAxisAlignment: CrossAxisAlignment.start,
                  //       children: [
                  //         Text(
                  //           "Email",
                  //           style: TextStyle(
                  //               color: Color(0xFFEEEEEE), fontSize: 20),
                  //         ),
                  //         TextField(
                  //           decoration: InputDecoration(
                  //             filled: true,
                  //             fillColor:
                  //                 Color(0xFFEEEEEE), // Field background color
                  //             border: OutlineInputBorder(
                  //               borderRadius: BorderRadius.circular(12.0),
                  //             ),
                  //             hintText: "Enter your email",
                  //             hintStyle: TextStyle(color: Color(0xFF282828)),
                  //           ),
                  //           style: TextStyle(color: Color(0xFF282828)),
                  //         ),
                  //         const SizedBox(height: 16), // Spacing between fields

                  //         // Password TextField
                  //         Text(
                  //           "Password",
                  //           style: TextStyle(
                  //               color: Color(0xFFEEEEEE), fontSize: 20),
                  //         ),
                  //         TextField(
                  //           obscureText: true,
                  //           decoration: InputDecoration(
                  //             filled: true,
                  //             fillColor:
                  //                 Color(0xFFEEEEEE), // Field background color
                  //             border: OutlineInputBorder(
                  //               borderRadius: BorderRadius.circular(12.0),
                  //             ),
                  //             hintText: "Enter your password",
                  //             hintStyle: TextStyle(color: Color(0xFF282828)),
                  //           ),
                  //           style: TextStyle(color: Color(0xFF282828)),
                  //         ),
                  //       ],
                  //     ),
                  //     // Email TextField

                  //     const SizedBox(height: 40), // Spacing before the button

                  //     // Sign-Up Button
                  //     Center(
                  //       child: Row(
                  //         children: [
                  //           Expanded(
                  //             child: ElevatedButton(
                  //               onPressed: () {},
                  //               style: ElevatedButton.styleFrom(
                  //                 padding: EdgeInsets.symmetric(
                  //                     vertical: 16.0), // Button height
                  //                 backgroundColor:
                  //                     Color(0xFF1B1A55), // Button color
                  //                 shape: RoundedRectangleBorder(
                  //                   borderRadius: BorderRadius.circular(12.0),
                  //                 ),
                  //               ),
                  //               child: Text(
                  //                 "Sign Up",
                  //                 style: TextStyle(
                  //                   color: Color(0xFFEEEEEE),
                  //                   fontSize: 16,
                  //                 ),
                  //               ),
                  //             ),
                  //           ),
                  //         ],
                  //       ),
                  //     ),
                  //     SizedBox(height: 40),
                  //     Row(
                  //       mainAxisAlignment: MainAxisAlignment.center,
                  //       children: [
                  //         Text(
                  //           "Already have an account? ",
                  //           style: const TextStyle(
                  //             color: Color(0xFFEEEEEE),
                  //             fontSize: 16,
                  //             decoration: TextDecoration
                  //                 .underline, // Optional to show it's clickable
                  //           ),
                  //         ),
                  //         GestureDetector(
                  //           onTap: () {
                  //             // Navigate to the Sign Up page
                  //             Navigator.push(
                  //               context,
                  //               MaterialPageRoute(
                  //                   builder: (context) => SignIn()),
                  //             );
                  //           },
                  //           child: Text(
                  //             "Sign in",
                  //             style: const TextStyle(
                  //                 color: Color(0xFFEEEEEE),
                  //                 fontSize: 16,
                  //                 decoration: TextDecoration.underline,
                  //                 decorationColor: Color(
                  //                     0xFFEEEEEE) // Optional to show it's clickable
                  //                 ),
                  //           ),
                  //         ),
                  //       ],
                  //     ),

                  //     SizedBox(height: 10),
                  //   ],
                  // ),