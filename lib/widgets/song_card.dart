import 'dart:io';

import 'package:chor/services/firebase.dart';
import 'package:chor/services/player_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SongCard extends StatelessWidget {
  final String coverUrl;
  final String songUrl;
  final String title;
  final String artists;
  final String songId;
  final String userId;
  // final bool isUploadedByUser;

  const SongCard({
    super.key,
    required this.coverUrl,
    required this.songUrl,
    required this.title,
    required this.artists,
    required this.songId,
    required this.userId,
    // this.isUploadedByUser = false,
  });

  @override
  Widget build(BuildContext context) {
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;

    return InkWell(
      onTap: () {
        try {
          context.read<PlayerProvider>().playSong(
                title: title,
                artist: artists,
                coverImageUrl: coverUrl,
                songUrl: songUrl,
              );
        } catch (e) {
          print('Error playing song: $e'); // For debugging
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error playing song: $e')),
          );
        }
      },
      onLongPress: () => _showPlaylistDialog(context, songId, title),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        height: 70,
        decoration: BoxDecoration(
          color: const Color(0x801B1A55),
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
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                coverUrl,
                width: 70,
                height: 70,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: const Color(0xFFEEEEEE),
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
                    artists,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xCCEEEEEE),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            if (userId == currentUserId)
              IconButton(
                icon: const Icon(
                  Icons.edit,
                  color: Colors.grey,
                ),
                onPressed: () async {
                  try {
                    final songDoc = await FirebaseFirestore.instance
                        .collection('Songs')
                        .doc(songId)
                        .get();

                    if (songDoc.exists) {
                      final songData =
                          songDoc.data(); // Get the map of song data
                      _showEditSongDialog(context, songId, {
                        'title': songData?['title'] ?? '',
                        'artists': songData?['artists'] ?? '',
                        'coverUrl': songData?['coverUrl'] ?? '',
                        'songUrl': songData?['songUrl'] ?? '',
                      });
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Song not found.")),
                      );
                    }
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Error fetching song data: $e")),
                    );
                  }
                },
                tooltip: 'Edit song',
              ),
          ],
        ),
      ),
    );
  }
}

void _showPlaylistDialog(
    BuildContext context, String songId, String songTitle) {
  showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        backgroundColor: const Color(0xFF1B1A55),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: FutureBuilder<QuerySnapshot>(
          future: FirebaseFirestore.instance
              .collection('Playlists')
              .where('createdById',
                  isEqualTo: FirebaseAuth.instance.currentUser?.uid)
              .get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return const Center(child: Text('Error loading playlists'));
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return SizedBox(
                height: 100,
                child: const Center(
                  child: Text(
                    'No playlists found',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              );
            }

            final playlists = snapshot.data!.docs;

            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'Manage Playlist',
                    style: TextStyle(
                      color: Color(0xFFEEEEEE),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: playlists.length,
                  itemBuilder: (context, index) {
                    final playlist = playlists[index];
                    final playlistName = playlist['name'];
                    final playlistId = playlist.id;
                    final List songs = playlist['songs'] ?? [];

                    final isSongInPlaylist = songs.contains(songId);

                    return ListTile(
                      title: Text(
                        playlistName,
                        style: const TextStyle(color: Colors.white),
                      ),
                      subtitle: Text(
                        isSongInPlaylist
                            ? 'Song is in this playlist'
                            : 'Song not in this playlist',
                        style: TextStyle(
                          color: isSongInPlaylist
                              ? Colors.greenAccent
                              : Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                      trailing: isSongInPlaylist
                          ? IconButton(
                              icon: const Icon(Icons.remove_circle,
                                  color: Colors.redAccent),
                              onPressed: () async {
                                try {
                                  await FirebaseFirestore.instance
                                      .collection('Playlists')
                                      .doc(playlistId)
                                      .update({
                                    'songs': FieldValue.arrayRemove([songId]),
                                  });

                                  Navigator.pop(context);

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                          '$songTitle removed from $playlistName playlist'),
                                    ),
                                  );
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Error removing song: $e'),
                                    ),
                                  );
                                }
                              },
                            )
                          : IconButton(
                              icon: const Icon(Icons.add_circle,
                                  color: Colors.greenAccent),
                              onPressed: () async {
                                try {
                                  await FirebaseFirestore.instance
                                      .collection('Playlists')
                                      .doc(playlistId)
                                      .update({
                                    'songs': FieldValue.arrayUnion([songId]),
                                  });

                                  Navigator.pop(context);

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                          '$songTitle added to $playlistName playlist'),
                                    ),
                                  );
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Error adding song: $e'),
                                    ),
                                  );
                                }
                              },
                            ),
                    );
                  },
                ),
              ],
            );
          },
        ),
      );
    },
  );
}

void _showEditSongDialog(
    BuildContext context, String songId, Map<String, dynamic> songData) {
  final _titleController = TextEditingController(text: songData['title']);
  final _artistController = TextEditingController(text: songData['artists']);
  String? coverUrl = songData['coverUrl'];
  String? songUrl = songData['songUrl'];

  void _pickFile(
      {required FileType fileType, required Function(File) onSelected}) async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(type: fileType);
    if (result != null) {
      onSelected(File(result.files.single.path!));
    }
  }

  void _uploadFile(
      File file, String storagePath, Function(String) onComplete) async {
    try {
      final url =
          await FirebaseService().uploadFile(file as String, storagePath);
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
          width: MediaQuery.of(context).size.width * 0.8,
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Edit Song",
                style: TextStyle(
                  color: Color(0xFFEEEEEE),
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              // Title
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Title",
                    style: TextStyle(color: Color(0xFFEEEEEE), fontSize: 20),
                  ),
                  SizedBox(
                    height: 10,
                  ),
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
                        hintStyle:
                            TextStyle(color: Color(0xFF282828), fontSize: 14)),
                    style: const TextStyle(color: Color(0xFF282828)),
                  ),
                  const SizedBox(height: 16),
                  // Artists
                  const Text(
                    "Artists",
                    style: TextStyle(color: Color(0xFFEEEEEE), fontSize: 20),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextField(
                    controller: _artistController,
                    decoration: InputDecoration(
                        hintText: "Enter artist name",
                        filled: true,
                        fillColor: const Color(0xFFEEEEEE),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        hintStyle:
                            TextStyle(color: Color(0xFF282828), fontSize: 14)),
                    style: const TextStyle(color: Color(0xFF282828)),
                  ),
                  const SizedBox(height: 16),
                  // Song File
                  const Text(
                    "Song File",
                    style: TextStyle(color: Color(0xFFEEEEEE), fontSize: 20),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  ElevatedButton.icon(
                    onPressed: () => _pickFile(
                      fileType: FileType.audio,
                      onSelected: (file) {
                        _uploadFile(
                          file,
                          'songs/${file.path.split('/').last}',
                          (url) => songUrl = url,
                        );
                      },
                    ),
                    icon:
                        const Icon(Icons.upload_file, color: Color(0xFF282828)),
                    label: const Text(
                      "Choose File",
                      style: TextStyle(color: Color(0xFF282828)),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Cover Image File
                  const Text(
                    "Cover Image File",
                    style: TextStyle(color: Color(0xFFEEEEEE), fontSize: 20),
                  ),
                  ElevatedButton.icon(
                    onPressed: () => _pickFile(
                      fileType: FileType.image,
                      onSelected: (file) {
                        _uploadFile(
                          file,
                          'covers/${file.path.split('/').last}',
                          (url) => coverUrl = url,
                        );
                      },
                    ),
                    icon: const Icon(Icons.image, color: Color(0xFF282828)),
                    label: const Text(
                      "Choose File",
                      style: TextStyle(color: Color(0xFF282828)),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Action Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          try {
                            await FirebaseService().deleteSong(songId);
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
                          backgroundColor: const Color.fromARGB(200, 255, 0, 0),
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
                                await FirebaseService().editSong(songId, {
                                  'title': _titleController.text.trim(),
                                  'artists': _artistController.text.trim(),
                                  'coverUrl': coverUrl,
                                  'songUrl': songUrl,
                                });
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content:
                                          Text("Song updated successfully")),
                                );
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text("Error updating song: $e")),
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
