import 'package:flutter/material.dart';

class PlaylistCard extends StatelessWidget {
  final String coverImageUrl;
  final String title;
  final bool isUploadedByUser; // Determines if the edit icon should be shown
  final VoidCallback? onEdit; // Callback for the edit button
  final VoidCallback? onTap; // Callback for tapping the card

  const PlaylistCard({
    super.key,
    required this.coverImageUrl,
    required this.title,
    this.isUploadedByUser = true,
    this.onEdit,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        height: 70,
        // padding: const EdgeInsets.all(12),
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
            // Edit Icon (only visible if isUploadedByUser is true)
            if (isUploadedByUser)
              IconButton(
                icon: const Icon(
                  Icons.edit,
                  color: Colors.grey,
                ),
                onPressed: onEdit,
                tooltip: 'Edit song',
              ),
          ],
        ),
      ),
    );
  }
}
