import 'package:cloud_firestore/cloud_firestore.dart';

class Playlist {
  final String _id;
  final String _name;
  final String _createdBy;
  final List<String> _songs; // List of song IDs
  final DateTime _createdAt;

  Playlist({
    required String id,
    required String name,
    required String createdBy,
    required List<String> songs,
    required DateTime createdAt,
  })  : _id = id,
        _name = name,
        _createdBy = createdBy,
        _songs = songs,
        _createdAt = createdAt {
    if (_name.trim().isEmpty) {
      throw Exception('Playlist name cannot be empty');
    }
  }

  // Getters for encapsulation
  String get id => _id;
  String get name => _name;
  String get createdBy => _createdBy;
  List<String> get songs =>
      List.unmodifiable(_songs); // Prevent direct modification
  DateTime get createdAt => _createdAt;

  // Add a song to the playlist
  Playlist addSong(String songId) {
    if (_songs.contains(songId)) {
      throw Exception('Song already exists in the playlist');
    }
    return copyWith(songs: [..._songs, songId]);
  }

  // Remove a song from the playlist
  Playlist removeSong(String songId) {
    if (!_songs.contains(songId)) {
      throw Exception('Song not found in the playlist');
    }
    return copyWith(songs: _songs.where((id) => id != songId).toList());
  }

  // Convert to Firestore-compatible Map
  Map<String, dynamic> toFirestore() {
    return {
      'id': _id,
      'name': _name,
      'createdBy': _createdBy,
      'songs': _songs,
      'createdAt': _createdAt.millisecondsSinceEpoch,
    };
  }

  // Create from Firestore Map
  factory Playlist.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return Playlist(
      id: doc.id,
      name: data['name'] ?? '',
      createdBy: data['createdBy'] ?? '',
      songs: List<String>.from(data['songs'] ?? []),
      createdAt: DateTime.fromMillisecondsSinceEpoch(data['createdAt']),
    );
  }

  // Create a copy of the playlist with modified fields
  Playlist copyWith({
    String? id,
    String? name,
    String? createdBy,
    List<String>? songs,
    DateTime? createdAt,
  }) {
    return Playlist(
      id: id ?? this.id,
      name: name ?? this.name,
      createdBy: createdBy ?? this.createdBy,
      songs: songs ?? this.songs,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
