import 'package:chor/services/firebase.dart';
import 'package:chor/widgets/song_card.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> songs = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadSongs();
  }

  Future<void> loadSongs() async {
    FirebaseService firebaseService = FirebaseService();
    List<Map<String, dynamic>> fetchedSongs =
        await firebaseService.fetchSongs();
    setState(() {
      songs = fetchedSongs;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.person, color: Color(0xFFEEEEEE)),
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
        ),
        title: const Text(
          "Home",
          style: TextStyle(
              color: Color(0xFFEEEEEE),
              fontSize: 30,
              fontWeight: FontWeight.w500),
        ),
        backgroundColor: const Color(0xFF070F2B),
      ),
      backgroundColor: const Color(0xFF070F2B),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : songs.isEmpty
              ? const Center(
                  child: Text(
                    "No songs available.",
                    style: TextStyle(
                      color: Color(0xFFEEEEEE),
                      fontSize: 18,
                    ),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Enjoy other’s songs!",
                        style: TextStyle(
                          color: Color(0xFFEEEEEE),
                          fontSize: 24,
                        ),
                      ),
                      const SizedBox(
                          height:
                              16), // Adds spacing between the header and the list
                      Expanded(
                        // Ensures the ListView.builder takes up remaining space
                        child: ListView.builder(
                          itemCount: songs.length,
                          itemBuilder: (context, index) {
                            final song = songs[index];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 16.0),
                              child: SongCard(
                                coverImageUrl: song['coverUrl'] ??
                                    'https://via.placeholder.com/50',
                                title: song['title'] ?? 'Unknown Title',
                                artists: song['artists'] ?? 'Unknown Artist',
                                songUrl: song['songUrl'] ?? '',
                                songId: song['id'],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }
}
