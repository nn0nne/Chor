import 'dart:io';

import 'package:chor/services/firebase.dart';
import 'package:chor/services/player_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SongCard extends StatelessWidget {
  final String coverImageUrl;
  final String songUrl;
  final String title;
  final String artists;
  final String songId;
  final bool isUploadedByUser;

  const SongCard({
    super.key,
    required this.coverImageUrl,
    required this.songUrl,
    required this.title,
    required this.artists,
    required this.songId,
    this.isUploadedByUser = true,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        try {
          context.read<PlayerProvider>().playSong(
                title: title,
                artist: artists,
                coverImageUrl: coverImageUrl,
                songUrl: songUrl,
              );
        } catch (e) {
          print('Error playing song: $e'); // For debugging
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error playing song: $e')),
          );
        }
      },
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
                coverImageUrl,
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
            if (isUploadedByUser)
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
                        'coverImageUrl': songData?['coverUrl'] ?? '',
                        'songFileUrl': songData?['songUrl'] ?? '',
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

void _showEditSongDialog(
    BuildContext context, String songId, Map<String, dynamic> songData) {
  final _titleController = TextEditingController(text: songData['title']);
  final _artistController = TextEditingController(text: songData['artists']);
  String? coverImageUrl = songData['coverImageUrl'];
  String? songFileUrl = songData['songFileUrl'];

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
                          (url) => songFileUrl = url,
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
                          (url) => coverImageUrl = url,
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
                                  'coverImageUrl': coverImageUrl,
                                  'songFileUrl': songFileUrl,
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
