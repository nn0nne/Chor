import 'dart:io';

import 'package:chor/services/firebase.dart';
import 'package:chor/widgets/playlist_card.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LibraryPage extends StatefulWidget {
  const LibraryPage({super.key});

  @override
  State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  final FirebaseService _firebaseService = FirebaseService();
  List<Map<String, dynamic>> _playlists = [];
  List<Map<String, dynamic>> _userSongs = [];
  List<String> _likedSongs = [];
  late String userId;
  String searchQuery = "";
  bool isSearching = false;

  @override
  void initState() {
    super.initState();
    userId = FirebaseAuth.instance.currentUser?.uid ?? '';
    _loadData();
  }

  Future<void> _loadData() async {
    var songs = await _firebaseService.fetchSongs();
    var userSongs =
        songs.where((song) => song['uploadedBy'] == userId).toList();
    var playlists = await _firebaseService.fetchPlaylists();
    var likedSongs = await _firebaseService.fetchLikedSongs(userId);

    if (mounted) {
      setState(() {
        _userSongs = userSongs;
        _playlists = playlists;
        _likedSongs = likedSongs;
      });
    }
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
          "Your Library",
          style: TextStyle(
              color: Color(0xFFEEEEEE),
              fontSize: 30,
              fontWeight: FontWeight.w500),
        ),
        actions: [
          IconButton(
            icon: Icon(isSearching ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                isSearching = !isSearching;
                if (!isSearching) {
                  searchQuery = ""; // Reset search query when search is closed
                }
              });
            },
            style: const ButtonStyle(
              iconColor: MaterialStatePropertyAll<Color>(Color(0xFFEEEEEE)),
              iconSize: MaterialStatePropertyAll<double>(40),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              _showAddOptions(context);
            },
            style: const ButtonStyle(
              iconColor: MaterialStatePropertyAll<Color>(Color(0xFFEEEEEE)),
              iconSize: MaterialStatePropertyAll<double>(40),
            ),
          )
        ],
        backgroundColor: const Color(0xFF070F2B),
      ),
      backgroundColor: const Color(0xFF070F2B),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isSearching)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: TextField(
                  autofocus: true,
                  cursorColor: const Color(0xFFEEEEEE),
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    hintText: "Search your playlists...",
                    hintStyle: TextStyle(color: Colors.white54),
                    filled: true,
                    fillColor: Color(0xFF1A1A2E),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onChanged: (query) {
                    setState(() {
                      searchQuery = query.trim();
                    });
                  },
                ),
              ),
            if (isSearching)
              Expanded(
                child: ListView.separated(
                  padding: EdgeInsets.zero,
                  itemCount: _playlists
                      .where((playlist) =>
                          playlist['createdById'] == userId &&
                          playlist['name']
                              .toString()
                              .toLowerCase()
                              .contains(searchQuery.toLowerCase()))
                      .length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final filteredPlaylists = _playlists
                        .where((playlist) =>
                            playlist['createdById'] == userId &&
                            playlist['name']
                                .toString()
                                .toLowerCase()
                                .contains(searchQuery.toLowerCase()))
                        .toList();
                    final playlist = filteredPlaylists[index];
                    return PlaylistCard(
                      coverImageUrl: playlist['coverUrl'] ??
                          'https://via.placeholder.com/50',
                      title: playlist['name'],
                      createdBy: playlist['createdBy'],
                      createdById: playlist['createdById'],
                      playlistId: playlist['id'],
                    );
                  },
                ),
              ),
            if (!isSearching) ...[
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
                title: 'Your Songs',
                createdBy: 'You',
                createdById: 'You',
                playlistId: 'your_songs',
              ),
              const SizedBox(height: 16),
              const Text(
                "Playlists",
                style: TextStyle(
                  color: Color(0xFFEEEEEE),
                  fontSize: 24,
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.separated(
                  padding: EdgeInsets.zero,
                  itemCount: _playlists
                          .where(
                              (playlist) => playlist['createdById'] == userId)
                          .length +
                      1, // Include "Liked Songs"
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return PlaylistCard(
                        coverImageUrl: 'https://via.placeholder.com/50',
                        title: 'Liked Songs',
                        createdBy: 'You',
                        createdById: 'You',
                        playlistId: 'liked_songs',
                      );
                    }
                    final playlist = _playlists
                        .where((playlist) => playlist['createdById'] == userId)
                        .toList()[index - 1];
                    return PlaylistCard(
                      coverImageUrl: playlist['coverUrl'] ??
                          'https://via.placeholder.com/50',
                      createdById: playlist['createdById'],
                      title: playlist['name'],
                      createdBy: playlist['createdBy'],
                      playlistId: playlist['id'],
                    );
                  },
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _showAddOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Color(0xFF1B1A55),
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

  Future<void> _createPlaylist(String name, File? coverImage) async {
    if (name.isEmpty) return;

    try {
      String? coverUrl;
      if (coverImage != null) {
        // Upload cover image to Firebase Storage
        coverUrl = await _firebaseService.uploadFile(
          coverImage.path,
          'playlist_covers/${DateTime.now().millisecondsSinceEpoch}_${coverImage.path.split('/').last}',
        );
      }

      String username = await _firebaseService.getUsernameById(userId);

      // Create playlist document in Firestore with playlistId
      await _firebaseService.addPlaylist({
        'name': name,
        'lowerCaseName': name.toLowerCase(),
        'coverUrl': coverUrl ?? "https://via.placeholder.com/50",
        'createdBy': username,
        'createdById': userId,
        'createdAt': DateTime.now().toIso8601String(),
        'songs': [], // Initialize with an empty list of songs
      });

      // Reload data
      _loadData();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Playlist created successfully!')),
        );
      }
    } catch (e) {
      print('Error creating playlist: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error creating playlist: $e')),
        );
      }
    }
  }

  void _showCreatePlaylistDialog(BuildContext context) {
    final TextEditingController playlistNameController =
        TextEditingController();
    File? selectedCoverImage;

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Color(0xFF1B1A55),
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
                      controller: playlistNameController,
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
                      onPressed: () async {
                        FilePickerResult? result =
                            await FilePicker.platform.pickFiles(
                          type: FileType.image,
                        );
                        if (result != null) {
                          selectedCoverImage = File(result.files.single.path!);
                        }
                      },
                      icon: Icon(Icons.image, color: Color(0xFF282828)),
                      label: Text(
                        "Choose File",
                        style: TextStyle(color: Color(0xFF282828)),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFEEEEEE),
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
                        _createPlaylist(
                          playlistNameController.text,
                          selectedCoverImage,
                        );
                        Navigator.pop(context);
                      },
                      child: Text(
                        "Create",
                        style: TextStyle(
                          color: Color(0xFF282828),
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _uploadSong(
    String title,
    String artists,
    File songFile,
    File? coverImage,
  ) async {
    if (title.isEmpty || artists.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Title and artists cannot be empty')),
        );
      }
      return;
    }

    try {
      // Upload song file
      final songFileName =
          'songs/${DateTime.now().millisecondsSinceEpoch}_${songFile.path.split('/').last}';
      String? songUrl =
          await _firebaseService.uploadFile(songFile.path, songFileName);

      String? coverUrl;
      if (coverImage != null) {
        // Upload cover image
        final coverFileName =
            'song_covers/${DateTime.now().millisecondsSinceEpoch}_${coverImage.path.split('/').last}';
        coverUrl =
            await _firebaseService.uploadFile(coverImage.path, coverFileName);
      }

      if (songUrl != null) {
        // Add song data with songId
        await _firebaseService.addSong({
          'title': title,
          'lowerCaseTitle': title.toLowerCase(),
          'artists': artists, // Single string for all artists
          'songUrl': songUrl,
          'coverUrl': coverUrl ?? "https://via.placeholder.com/50",
          'uploadedBy': userId,
          'createdAt': DateTime.now().toIso8601String(),
        });

        // Reload the data
        await _loadData();

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Song uploaded successfully!')),
          );
        }
      } else {
        throw 'Failed to upload the song file.';
      }
    } catch (e) {
      print('Error during song upload: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  void _showUploadSongDialog(BuildContext context) {
    final TextEditingController _titleController = TextEditingController();
    final TextEditingController _artistsController = TextEditingController();
    File? selectedSongFile;
    File? selectedCoverImage;

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Color(0xFF1B1A55),
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
                      controller: _titleController,
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
                      controller: _artistsController,
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
                      onPressed: () async {
                        FilePickerResult? result =
                            await FilePicker.platform.pickFiles(
                          type: FileType.audio,
                        );
                        if (result != null) {
                          selectedSongFile = File(result.files.single.path!);
                        }
                      },
                      icon: Icon(
                        Icons.upload_file,
                        color: Color(0xFF282828),
                      ),
                      label: Text("Choose Song File"),
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
                      onPressed: () async {
                        FilePickerResult? result =
                            await FilePicker.platform.pickFiles(
                          type: FileType.image,
                        );
                        if (result != null) {
                          selectedCoverImage = File(result.files.single.path!);
                        }
                      },
                      icon: Icon(
                        Icons.image,
                        color: Color(0xFF282828),
                      ),
                      label: Text("Choose Cover Image"),
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
                            if (selectedSongFile != null) {
                              _uploadSong(
                                _titleController.text,
                                _artistsController.text,
                                selectedSongFile!,
                                selectedCoverImage,
                              );
                            }
                            Navigator.pop(context);
                          },
                          child: Text(
                            "Upload",
                            style: TextStyle(
                              color: Color(0xFF282828),
                            ),
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
