import 'package:flutter/material.dart';

class PlaylistView extends StatelessWidget {
  const PlaylistView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF070F2B), // Dark background color
      appBar: AppBar(
        backgroundColor: const Color(0xFF070F2B),
        elevation: 0,
        leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(
              Icons.arrow_back,
              color: Color(0xFFEEEEEE),
            )),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Playlist Cover
                Container(
                  width: 220,
                  height: 220,
                  decoration: BoxDecoration(
                    color: const Color(0xFFEEEEEE),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Playlist to Sleep",
                        style: TextStyle(
                          color: Color(0xFFEEEEEE),
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Created by
                      const Text(
                        "Created by Manutama",
                        style: TextStyle(
                          color: Color(0xCCEEEEEE),
                          fontSize: 16,
                        ),
                      ),
                      // const SizedBox(height: 16),
                      // Play Button
                    ],
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      onPressed: () {
                        // Play all songs logic
                      },
                      style: ElevatedButton.styleFrom(
                        shape: const CircleBorder(),
                        backgroundColor: const Color(0xFFEEEEEE),
                        padding: const EdgeInsets.all(12),
                      ),
                      child: const Icon(
                        Icons.play_arrow,
                        color: Color(0xFF1B1A55),
                        size: 32,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Song List
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                children: [
                  // SongCard(
                  //     coverImageUrl: 'https://via.placeholder.com/50',
                  //     title: "Distance",
                  //     artist: "k?d"),
                  // SizedBox(height: 16),
                  // SongCard(
                  //     coverImageUrl: 'https://via.placeholder.com/50',
                  //     title: "Life is PIANO",
                  //     artist: "Junk"),
                  // SizedBox(height: 16),
                  // SongCard(
                  //     coverImageUrl: 'https://via.placeholder.com/50',
                  //     title: "speak my lingo jowo",
                  //     artist: "Unknown artist")
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
