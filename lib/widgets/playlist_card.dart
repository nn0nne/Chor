import 'package:flutter/material.dart';
import 'package:chor/pages/playlist_view.dart'; // Import the PlaylistView page

class PlaylistCard extends StatelessWidget {
  final String playlistId;
  final String coverImageUrl;
  final String title;
  final String createdBy;
  final String createdById;

  const PlaylistCard({
    super.key,
    required this.playlistId,
    required this.coverImageUrl,
    required this.title,
    required this.createdBy,
    required this.createdById,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        if (playlistId == 'your_songs') {
          // Navigate to a specific "Your Songs" page
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PlaylistView(
                playlistId: playlistId,
                coverImageUrl: coverImageUrl,
                title: "Your Songs",
                createdBy: createdBy,
                createdById: createdById,
              ),
            ),
          );
        } else if (playlistId == 'liked_songs') {
          // Navigate to a specific "Liked Songs" page
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PlaylistView(
                playlistId: playlistId,
                coverImageUrl: coverImageUrl,
                title: "Liked Songs",
                createdBy: createdBy,
                createdById: createdById,
              ),
            ),
          );
        } else {
          // General behavior for other playlists
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PlaylistView(
                playlistId: playlistId,
                coverImageUrl: coverImageUrl,
                title: title,
                createdBy: createdBy,
                createdById: createdById,
              ),
            ),
          );
        }
      },
      borderRadius: BorderRadius.circular(8),
      child: Container(
        height: 70,
        decoration: BoxDecoration(
          color: Color(0x801B1A55),
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Cover Image
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                coverImageUrl,
                width: 70,
                height: 70,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: Color(0xFFEEEEEE),
                  width: 70,
                  height: 70,
                  child: const Icon(
                    Icons.image_not_supported,
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            // Title and Artist
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 22),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFFEEEEEE),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
