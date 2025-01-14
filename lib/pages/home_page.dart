// import 'package:chor/widgets/song_card.dart';
import 'package:chor/widgets/song_card.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Home",
          style: TextStyle(
              color: Color(0xFFEEEEEE),
              fontSize: 30,
              fontWeight: FontWeight.w500),
        ),
        backgroundColor: Color(0xFF070F2B),
      ),
      backgroundColor: Color(0xFF070F2B),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Enjoy other’s songs",
              style: TextStyle(
                color: Color(0xFFEEEEEE),
                fontSize: 24,
              ),
            ),
            const SizedBox(height: 16),
            SongCard(
              coverImageUrl: 'https://via.placeholder.com/50',
              title: 'Distance',
              artist: 'k?d',
            )
            // Expanded(
            //   child: ListView.builder(
            //     itemCount: songs.length,
            //     itemBuilder: (context, index) {
            //       final song = songs[index];
            //       return Card(
            //         color: Colors.indigo[800],
            //         child: ListTile(
            //           leading: Container(
            //             width: 40,
            //             height: 40,
            //             color: Colors.white,
            //             // Placeholder for image
            //           ),
            //           title: Text(
            //             song["title"] ?? "",
            //             style: const TextStyle(color: Colors.white),
            //           ),
            //           subtitle: Text(
            //             song["artist"] ?? "",
            //             style: const TextStyle(color: Colors.white70),
            //           ),
            //           onTap: () {
            //             // Add functionality for tapping on a song
            //           },
            //         ),
            //       );
            //     },
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
