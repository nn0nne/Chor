import 'package:chor/services/player_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SongView extends StatelessWidget {
  const SongView({super.key});

  @override
  Widget build(BuildContext context) {
    final playerProvider = context.watch<PlayerProvider>();
    final song = playerProvider.currentSong;

    // If no song is playing, return an empty placeholder or error message
    if (song == null) {
      return Scaffold(
        backgroundColor: const Color(0xFF070F2B),
        appBar: AppBar(
          backgroundColor: const Color(0xFF070F2B),
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: const Center(
          child: Text(
            "No song is currently playing",
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFF070F2B),
      appBar: AppBar(
        backgroundColor: const Color(0xFF070F2B),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            const SizedBox(height: 30),
            // Song Cover
            Container(
              height: 300,
              width: 300,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                image: DecorationImage(
                  image: NetworkImage(song.coverImageUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 30),
            // Song Title and Artist
            Column(
              children: [
                Text(
                  song.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  song.artist,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            // Progress Bar
            Column(
              children: [
                Slider(
                  value: playerProvider.currentPosition.inSeconds.toDouble(),
                  max: playerProvider.songDuration.inSeconds.toDouble(),
                  onChanged: (value) {
                    playerProvider.seek(Duration(seconds: value.toInt()));
                  },
                  activeColor: Colors.white,
                  inactiveColor: Colors.grey,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _formatDuration(playerProvider.currentPosition),
                        style:
                            const TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                      Text(
                        _formatDuration(playerProvider.songDuration),
                        style:
                            const TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            // Player Controls
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: const Icon(Icons.skip_previous, color: Colors.white),
                  onPressed: playerProvider.previousSong,
                ),
                ElevatedButton(
                  onPressed: playerProvider.togglePlayPause,
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(16),
                    backgroundColor: const Color(0xFF1B1A55),
                  ),
                  child: Icon(
                    playerProvider.currentPosition >=
                            playerProvider.songDuration
                        ? Icons.play_arrow
                        : (playerProvider.isPlaying
                            ? Icons.pause
                            : Icons.play_arrow),
                    color: Colors.white,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.skip_next, color: Colors.white),
                  onPressed: playerProvider.nextSong,
                ),
              ],
            ),
            const SizedBox(height: 30),
            // Shuffle, Repeat, and Like Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(
                    playerProvider.isShuffling
                        ? Icons.shuffle_on_outlined
                        : Icons.shuffle_outlined,
                    color: Colors.white,
                  ),
                  onPressed: playerProvider.toggleShuffle,
                ),
                const SizedBox(width: 40),
                IconButton(
                  icon: Icon(
                    playerProvider.isRepeating
                        ? Icons.repeat_one_on_outlined
                        : Icons.repeat_outlined,
                    color: Colors.white,
                  ),
                  onPressed: playerProvider.toggleRepeat,
                ),
                const SizedBox(width: 40),
                IconButton(
                  icon: Icon(
                    playerProvider.isLiked
                        ? Icons.thumb_up_alt
                        : Icons.thumb_up_alt_outlined,
                    color: Colors.white,
                  ),
                  onPressed: playerProvider.toggleLike,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }
}
