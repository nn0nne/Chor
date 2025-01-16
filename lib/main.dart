import 'package:chor/pages/auth/signin_or_signup.dart';
import 'package:chor/pages/home_page.dart';
import 'package:chor/pages/library_page.dart';
import 'package:chor/pages/search_page.dart';
import 'package:chor/services/firebase_auth.dart';
import 'package:chor/services/player_service.dart';
import 'package:chor/widgets/nav_bar.dart';
import 'package:chor/widgets/play_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (_) => AuthService(),
      ),
      ChangeNotifierProvider(
        create: (_) => PlayerProvider(),
      ),
    ],
    child: const RestartWidget(child: MyApp()),
  ));
}

/// Widget to wrap the app and provide restart functionality
class RestartWidget extends StatefulWidget {
  final Widget child;

  const RestartWidget({super.key, required this.child});

  @override
  RestartWidgetState createState() => RestartWidgetState();

  static void restartApp(BuildContext context) {
    context.findAncestorStateOfType<RestartWidgetState>()?.restartApp();
  }
}

class RestartWidgetState extends State<RestartWidget> {
  Key _key = UniqueKey();

  void restartApp() {
    setState(() {
      _key = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(key: _key, child: widget.child);
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    // final authService = Provider.of<AuthService>(context);

    return MaterialApp(
        title: 'Chor',
        debugShowCheckedModeBanner: false,
        home: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator(); // Show loading while checking auth state
            }

            final bool isAuthenticated = snapshot.hasData;

            if (!isAuthenticated) {
              return const SignInOrSignUp();
            }

            // Only build the main app UI if authenticated
            return const MainAppScaffold();
          },
        ));
  }
}

class MainAppScaffold extends StatefulWidget {
  const MainAppScaffold({super.key});

  @override
  _MainAppScaffoldState createState() => _MainAppScaffoldState();
}

class _MainAppScaffoldState extends State<MainAppScaffold> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const HomePage(),
    const SearchPage(),
    const LibraryPage(),
  ];

  void _onNavBarTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<String> _getUsername() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // Fetch username from Firestore Users collection
      try {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('Users')
            .doc(user.uid) // Using current user's UID
            .get();

        if (userDoc.exists) {
          // Assuming username is stored in a field called 'username'
          return userDoc['username'] ??
              'User'; // Fallback to 'User' if no username is found
        } else {
          return 'User';
        }
      } catch (e) {
        print('Error fetching username: $e');
        return 'User'; // Return default value in case of error
      }
    } else {
      return 'Guest';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: FutureBuilder<String>(
        future: _getUsername(), // Fetch username from Firestore
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child:
                    CircularProgressIndicator()); // Show loading while fetching username
          }

          if (snapshot.hasData) {
            return Drawer(
              backgroundColor: const Color(0xFF1B1A55),
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  SizedBox(
                    height: 150,
                    child: DrawerHeader(
                      decoration: const BoxDecoration(
                        color: Color(0xFF1B1A55),
                      ),
                      child: Text(
                        'Hello there, ${snapshot.data}',
                        style: const TextStyle(
                          color: Color(0xFFEEEEEE),
                          fontSize: 24,
                        ),
                      ),
                    ),
                  ),
                  ListTile(
                    title: const Text(
                      'Logout',
                      style: TextStyle(color: Color(0xFFEEEEEE)),
                    ),
                    onTap: () {
                      Provider.of<AuthService>(context, listen: false)
                          .signOut(context);
                    },
                  ),
                ],
              ),
            );
          }

          return Center(child: Text('Failed to load username'));
        },
      ),
      body: Stack(
        children: [
          _pages[_selectedIndex],
          const Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: PlayBar(),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: _selectedIndex,
        onTap: _onNavBarTap,
      ),
    );
  }
}
