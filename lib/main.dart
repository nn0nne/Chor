import 'package:chor/pages/home_page.dart';
import 'package:chor/pages/library_page.dart';
import 'package:chor/pages/search_page.dart';
import 'package:chor/pages/song_view.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chor',
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}













// TODO: 
// 4. Create playlist view (add pencil icon or a way for user to change the title of the playlist and image cover)
