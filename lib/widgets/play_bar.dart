import 'package:chor/pages/song_view.dart';
import 'package:chor/services/player_service.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';

class PlayBar extends StatelessWidget {
  const PlayBar({super.key});

  @override
  Widget build(BuildContext context) {
    final playerProvider = context.watch<PlayerProvider>();
    final song = playerProvider.currentSong;

    // Hide PlayBar if no song is playing
    if (song == null) {
      return const SizedBox.shrink();
    }

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                const SongView(), // Replace with your SongView constructor
          ),
        );
      },
      child: Container(
        height: 80,
        decoration: BoxDecoration(
          color: const Color(0x801B1A55),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
        ),
        child: Row(
          children: [
            // Album Art
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: CachedNetworkImage(
                    imageUrl: song.coverImageUrl,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => const Center(
                      child: CircularProgressIndicator(),
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: Colors.grey[300],
                      child: const Icon(Icons.music_note),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            // Song Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    song.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    song.artist,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            // Like Button
            IconButton(
              icon: Icon(
                playerProvider.isLiked
                    ? Icons.thumb_up_alt
                    : Icons.thumb_up_alt_outlined,
                color: const Color(0xFFEEEEEE),
              ),
              onPressed: playerProvider.toggleLike,
            ),
            // Play/Pause Button
            IconButton(
              icon: Icon(
                playerProvider.isPlaying
                    ? Icons.pause_circle_filled
                    : Icons.play_circle_filled,
                size: 40,
                color: Colors.white,
              ),
              onPressed: playerProvider.togglePlayPause,
            ),
          ],
        ),
      ),
    );
  }
}
