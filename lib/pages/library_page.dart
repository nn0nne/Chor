import 'package:chor/widgets/playlist_card.dart';
import 'package:flutter/material.dart';

class LibraryPage extends StatefulWidget {
  const LibraryPage({super.key});

  @override
  State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Your Library",
          style: TextStyle(
              color: Color(0xFFEEEEEE),
              fontSize: 30,
              fontWeight: FontWeight.w500),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {},
            style: ButtonStyle(
                iconColor: WidgetStatePropertyAll<Color>(Color(0xFFEEEEEE)),
                iconSize: WidgetStatePropertyAll<double>(40)),
          ),
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              _showAddOptions(context);
            },
            style: ButtonStyle(
                iconColor: WidgetStatePropertyAll<Color>(Color(0xFFEEEEEE)),
                iconSize: WidgetStatePropertyAll<double>(40)),
          )
        ],
        backgroundColor: Color(0xFF070F2B),
      ),
      backgroundColor: Color(0xFF070F2B),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Your Songs",
              style: TextStyle(
                color: Color(0xFFEEEEEE),
                fontSize: 24,
              ),
            ),
            const SizedBox(height: 16),
            PlaylistCard(
                coverImageUrl: 'https://via.placeholder.com/50',
                title: 'Uploaded Songs'),
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
            const SizedBox(height: 16),
            const Text(
              "Playlists",
              style: TextStyle(
                color: Color(0xFFEEEEEE),
                fontSize: 24,
              ),
            ),
            const SizedBox(height: 16),
            PlaylistCard(
                coverImageUrl: 'https://via.placeholder.com/50',
                title: 'Liked Songs')
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

  void _showAddOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Color(0x4D1B1A55),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                leading: Icon(Icons.playlist_add, color: Color(0xFFEEEEEE)),
                title: Text(
                  "Create Playlist",
                  style: TextStyle(color: Color(0xFFEEEEEE), fontSize: 18),
                ),
                onTap: () {
                  Navigator.pop(context); // Close the modal
                  _showCreatePlaylistDialog(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.upload_file, color: Color(0xFFEEEEEE)),
                title: Text(
                  "Upload Song",
                  style: TextStyle(color: Color(0xFFEEEEEE), fontSize: 18),
                ),
                onTap: () {
                  Navigator.pop(context); // Close the modal
                  _showUploadSongDialog(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showCreatePlaylistDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Color(0x991B1A55),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Container(
            width: MediaQuery.of(context).size.width *
                0.8, // Custom width (80% of screen width)
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Create Playlist",
                  style: TextStyle(
                    color: Color(0xFFEEEEEE),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Playlist Name*",
                      style: TextStyle(
                        color: Color(0xFFEEEEEE),
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      decoration: InputDecoration(
                        hintText: "Enter playlist name",
                        filled: true,
                        fillColor: Color(0xFFEEEEEE),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        hintStyle:
                            TextStyle(color: Color(0xFF282828), fontSize: 14),
                      ),
                      style: TextStyle(color: Color(0xFF282828)),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "Playlist Cover",
                      style: TextStyle(
                        color: Color(0xFFEEEEEE),
                        fontSize: 20,
                      ),
                    ),
                    SizedBox(height: 10),
                    ElevatedButton.icon(
                      onPressed: () {
                        // Handle file selection
                      },
                      icon: Icon(Icons.image, color: Color(0xFFEEEEEE)),
                      label: Text(
                        "Choose File",
                        style: TextStyle(color: Color(0xFFEEEEEE)),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF1B1A55),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        "Cancel",
                        style: TextStyle(color: Color(0xFFEEEEEE)),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Handle playlist creation logic
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF1B1A55),
                      ),
                      child: Text(
                        "Create",
                        style: TextStyle(color: Color(0xFFEEEEEE)),
                      ),
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

  void _showUploadSongDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Color(0x991B1A55),
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
                  "Upload Song",
                  style: TextStyle(
                    color: Color(0xFFEEEEEE),
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Title*",
                      style: TextStyle(
                        color: Color(0xFFEEEEEE),
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      decoration: InputDecoration(
                        hintText: "Enter title",
                        filled: true,
                        fillColor: Color(0xFFEEEEEE),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        hintStyle:
                            TextStyle(color: Color(0xFF282828), fontSize: 14),
                      ),
                      style: TextStyle(color: Color(0xFF282828)),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "Artist (comma seperated)*",
                      style: TextStyle(
                        color: Color(0xFFEEEEEE),
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      decoration: InputDecoration(
                        hintText: "Enter artist name",
                        filled: true,
                        fillColor: Color(0xFFEEEEEE),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        hintStyle:
                            TextStyle(color: Color(0xFF282828), fontSize: 14),
                      ),
                      style: TextStyle(color: Color(0xFF282828)),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "Song File*",
                      style: TextStyle(
                        color: Color(0xFFEEEEEE),
                        fontSize: 20,
                      ),
                    ),
                    SizedBox(height: 10),
                    ElevatedButton.icon(
                      onPressed: () {
                        // Handle file selection
                      },
                      icon: Icon(Icons.upload_file, color: Color(0xFFEEEEEE)),
                      label: Text(
                        "Choose File",
                        style: TextStyle(color: Color(0xFFEEEEEE)),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF1B1A55),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "Song Cover File",
                      style: TextStyle(
                        color: Color(0xFFEEEEEE),
                        fontSize: 20,
                      ),
                    ),
                    SizedBox(height: 10),
                    ElevatedButton.icon(
                      onPressed: () {
                        // Handle image selection
                      },
                      icon: Icon(Icons.image, color: Color(0xFFEEEEEE)),
                      label: Text(
                        "Choose File",
                        style: TextStyle(color: Color(0xFFEEEEEE)),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF1B1A55),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text(
                            "Cancel",
                            style: TextStyle(color: Color(0xFFEEEEEE)),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            // Handle song upload logic
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF1B1A55),
                          ),
                          child: Text(
                            "Upload",
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
}
