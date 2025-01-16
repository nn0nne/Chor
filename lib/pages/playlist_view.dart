import 'dart:io';
import 'package:chor/services/firebase.dart';
import 'package:chor/services/player_service.dart';
import 'package:chor/widgets/play_bar.dart';
import 'package:chor/widgets/song_card.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PlaylistView extends StatefulWidget {
  final String playlistId; // Unique playlist ID
  final String title;
  final String createdBy;
  final String coverImageUrl;
  final String createdById; // Determines if the edit icon should be shown

  const PlaylistView({
    super.key,
    required this.playlistId,
    required this.coverImageUrl,
    required this.title,
    required this.createdBy,
    required this.createdById,
  });

  @override
  State<PlaylistView> createState() => _PlaylistViewState();
}

class _PlaylistViewState extends State<PlaylistView> {
  final FirebaseService _firebaseService = FirebaseService();
  List<Map<String, dynamic>> _songs = []; // List to hold song data
  bool isLoading = true;
  final String? currentUserId = FirebaseAuth.instance.currentUser?.uid;

  @override
  void initState() {
    super.initState();
    if (widget.playlistId == 'your_songs') {
      _loadUserSongs();
    } else {
      _loadPlaylistSongs();
    }
    _fetchSongs();
  }

  Future<List<Map<String, dynamic>>> fetchPlaylistSongs(
      String playlistId) async {
    try {
      var allSongs = await _firebaseService.fetchSongs();
      if (playlistId == 'your_songs') {
        return allSongs
            .where((song) => song['uploadedBy'] == currentUserId)
            .toList();
      } else if (playlistId == 'liked_songs') {
        return allSongs
            .where((song) => (song['likedBy'] ?? []).contains(currentUserId))
            .toList();
      } else {
        return allSongs; // Return all songs for other playlists
      }
    } catch (e) {
      // Log the error and return an empty list
      debugPrint('Error fetching playlist songs: $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: const Color(0xFF070F2B),
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
              if (widget.createdById == currentUserId)
                IconButton(
                  icon: const Icon(
                    Icons.edit,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    // Fetch playlist data and show the edit dialog
                    _showEditPlaylistDialog(context, widget.playlistId, {
                      'title': widget.title,
                      'coverUrl': widget.coverImageUrl,
                    });
                  },
                  tooltip: 'Edit song',
                ),
            ],
          ),
          body: isLoading
              ? const Center(child: CircularProgressIndicator())
              : SafeArea(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: 220,
                            height: 220,
                            decoration: BoxDecoration(
                              color: const Color(0xFFEEEEEE),
                              borderRadius: BorderRadius.circular(8),
                              image: DecorationImage(
                                image: NetworkImage(widget.coverImageUrl),
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
                                Text(
                                  widget.title,
                                  style: const TextStyle(
                                    color: Color(0xFFEEEEEE),
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  "Created by ${widget.createdBy}",
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
                                  final playerProvider =
                                      Provider.of<PlayerProvider>(context,
                                          listen: false);
                                  playerProvider.playSingleOrPlaylist(
                                    playlist: _songs,
                                    startIndex: 0,
                                  );
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
                      Expanded(
                        child: ListView.builder(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16.0), // Horizontal padding
                          itemCount: _songs.length,
                          itemBuilder: (context, index) {
                            final song = _songs[index];
                            return Padding(
                              padding: const EdgeInsets.only(
                                  bottom: 16.0), // Add spacing between cards
                              child: SongCard(
                                coverUrl: song['coverUrl'],
                                songUrl: song['songUrl'],
                                title: song['title'] ?? 'Unknown Title',
                                artists: song['artists'] ?? 'Unknown Artist',
                                songId: song['id'],
                                userId: song['uploadedBy'],
                              ),
                            );
                          },
                        ),
                      )
                    ],
                  ),
                ),
        ),
        const Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: PlayBar(),
        ),
      ],
    );
  }

  Future<void> _fetchSongs() async {
    try {
      // Fetch songs using playlistId
      _songs = await FirebaseService().getSongsFromPlaylist(widget.playlistId);
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      // Handle errors
      print("Error fetching songs: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  // Load songs uploaded by the current user (Your Songs)
  Future<void> _loadUserSongs() async {
    String userId = widget.createdById;
    var songs = await _firebaseService.fetchSongs();
    var userSongs =
        songs.where((song) => song['uploadedBy'] == userId).toList();

    if (mounted) {
      setState(() {
        _songs = userSongs;
      });
    }
  }

  // Load songs from a playlist (if applicable)
  void _loadPlaylistSongs() async {
    setState(() {
      isLoading = true;
    });
    _songs = await fetchPlaylistSongs(widget.playlistId);
    setState(() {
      isLoading = false;
    });
  }

  void _showEditPlaylistDialog(BuildContext context, String playlistId,
      Map<String, dynamic> playlistData) {
    final _titleController = TextEditingController(text: playlistData['title']);
    String? coverUrl = playlistData['coverUrl'];

    void _pickFile(
        {required FileType fileType,
        required Function(File) onSelected}) async {
      FilePickerResult? result =
          await FilePicker.platform.pickFiles(type: fileType);
      if (result != null) {
        onSelected(File(result.files.single.path!));
      }
    }

    void _uploadFile(
        File file, String storagePath, Function(String) onComplete) async {
      try {
        final url = await FirebaseService().uploadFile(file.path, storagePath);
        onComplete(url!);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error uploading file: $e")),
        );
      }
    }

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: const Color(0xFF1B1A55),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8, // Custom width
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Edit Playlist",
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
                    const Text(
                      "Title",
                      style: TextStyle(
                        color: Color(0xFFEEEEEE),
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _titleController,
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
                        _pickFile(
                          fileType: FileType.image,
                          onSelected: (file) {
                            _uploadFile(
                              file,
                              'covers/${file.path.split('/').last}',
                              (url) => coverUrl = url,
                            );
                          },
                        );
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            try {
                              await FirebaseService()
                                  .deletePlaylist(playlistId);
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text("Song deleted successfully")),
                              );
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text("Error deleting song: $e")),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(200, 255, 0, 0),
                          ),
                          child: const Text(
                            "Remove",
                            style: TextStyle(color: Color(0xFFEEEEEE)),
                          ),
                        ),
                        Row(
                          children: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text(
                                "Cancel",
                                style: TextStyle(color: Color(0xFFEEEEEE)),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                try {
                                  await FirebaseService()
                                      .editPlaylist(playlistId, {
                                    'name': _titleController.text.trim(),
                                    'coverUrl': coverUrl,
                                  });
                                  Navigator.pop(context);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content:
                                          Text("Playlist updated successfully"),
                                    ),
                                  );
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content:
                                          Text("Error updating playlist: $e"),
                                    ),
                                  );
                                }
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
              ],
            ),
          ),
        );
      },
    );
  }
}
