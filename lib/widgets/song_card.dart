import 'package:flutter/material.dart';

class SongCard extends StatelessWidget {
  final String coverImageUrl;
  final String title;
  final String artist;
  final bool isUploadedByUser; // Determines if the edit icon should be shown
  final VoidCallback? onEdit; // Callback for the edit button
  final VoidCallback? onTap; // Callback for tapping the card

  const SongCard({
    super.key,
    required this.coverImageUrl,
    required this.title,
    required this.artist,
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
                  const SizedBox(height: 12),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFEEEEEE),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    artist,
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xCCEEEEEE),
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
                onPressed: () {
                  _showEditSongDialog(context, title, artist);
                },
                tooltip: 'Edit song',
              ),
          ],
        ),
      ),
    );
  }
}

void _showEditSongDialog(
    BuildContext context, String currentTitle, String currentArtist) {
  showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        backgroundColor: const Color(0x991B1A55),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.8, // Custom width
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Edit Song",
                style: const TextStyle(
                  color: Color(0xFFEEEEEE),
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  const Text(
                    "Title",
                    style: TextStyle(
                      color: Color(0xFFEEEEEE),
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: TextEditingController(text: currentTitle),
                    decoration: InputDecoration(
                      hintText: "Enter title",
                      filled: true,
                      fillColor: const Color(0xFFEEEEEE),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      hintStyle: const TextStyle(
                        color: Color(0xFF282828),
                        fontSize: 14,
                      ),
                    ),
                    style: const TextStyle(color: Color(0xFF282828)),
                  ),
                  const SizedBox(height: 16),
                  // Artist
                  const Text(
                    "Artist (comma separated)",
                    style: TextStyle(
                      color: Color(0xFFEEEEEE),
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: TextEditingController(text: currentArtist),
                    decoration: InputDecoration(
                      hintText: "Enter artist name",
                      filled: true,
                      fillColor: const Color(0xFFEEEEEE),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      hintStyle: const TextStyle(
                        color: Color(0xFF282828),
                        fontSize: 14,
                      ),
                    ),
                    style: const TextStyle(color: Color(0xFF282828)),
                  ),
                  const SizedBox(height: 16),
                  // Song File
                  const Text(
                    "Song File",
                    style: TextStyle(
                      color: Color(0xFFEEEEEE),
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton.icon(
                    onPressed: () {
                      // Handle file selection
                    },
                    icon:
                        const Icon(Icons.upload_file, color: Color(0xFFEEEEEE)),
                    label: const Text(
                      "Choose File",
                      style: TextStyle(color: Color(0xFFEEEEEE)),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1B1A55),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Song Cover File
                  const Text(
                    "Song Cover File",
                    style: TextStyle(
                      color: Color(0xFFEEEEEE),
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton.icon(
                    onPressed: () {
                      // Handle image selection
                    },
                    icon: const Icon(Icons.image, color: Color(0xFFEEEEEE)),
                    label: const Text(
                      "Choose File",
                      style: TextStyle(color: Color(0xFFEEEEEE)),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1B1A55),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Action Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text(
                          "Cancel",
                          style: TextStyle(color: Color(0xFFEEEEEE)),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // Handle song update logic
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1B1A55),
                        ),
                        child: const Text(
                          "Save",
                          style: TextStyle(color: Color(0xFFEEEEEE)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}
