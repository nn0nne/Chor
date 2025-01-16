import 'package:flutter/material.dart';

class PlaylistView extends StatelessWidget {
  final String title;
  final String createdBy;
  final String coverImageUrl;
  final bool isUploadedByUser; // Determines if the edit icon should be shown

  const PlaylistView({
    super.key,
    required this.coverImageUrl,
    required this.title,
    required this.createdBy,
    this.isUploadedByUser = true,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF070F2B), // Dark background color
      appBar: AppBar(
        backgroundColor: const Color(0xFF070F2B),
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back,
            color: Color(0xFFEEEEEE),
          ),
        ),
        actions: [
          if (isUploadedByUser)
            IconButton(
              icon: const Icon(
                Icons.edit,
                color: Colors.grey,
              ),
              onPressed: () {
                _showEditSongDialog(context, title);
              },
              tooltip: 'Edit song',
            ),
        ],
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
                    image: DecorationImage(
                      image: NetworkImage(coverImageUrl),
                      fit: BoxFit.cover,
                    ),
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
                      // Dynamic Playlist Title
                      Text(
                        title,
                        style: const TextStyle(
                          color: Color(0xFFEEEEEE),
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Dynamic Created By
                      Text(
                        "Created by $createdBy",
                        style: const TextStyle(
                          color: Color(0xCCEEEEEE),
                          fontSize: 16,
                        ),
                      ),
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
                  // Add dynamic song cards here
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void _showEditSongDialog(BuildContext context, String currentTitle) {
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
                "Edit Playlist",
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
                  const Text(
                    "Cover Image File",
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
