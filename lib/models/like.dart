import 'package:chor/models/playlist.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Like extends Playlist {
  final String likedBy;
  final DateTime likedAt;

  Like({
    required super.id,
    required super.name,
    required super.createdBy,
    required super.songs,
    required super.createdAt,
    required this.likedBy,
    required this.likedAt,
  });

  // Check if a song is liked
  bool isLiked(String songId) {
    return songs.contains(songId);
  }

  // Toggle like status of a song
  Like toggleLike(String songId) {
    if (isLiked(songId)) {
      return copyWith(songs: songs.where((id) => id != songId).toList());
    } else {
      return copyWith(songs: [...songs, songId]);
    }
  }

  // Create a copy of Like with modified fields
  @override
  Like copyWith({
    String? id,
    String? name,
    String? createdBy,
    List<String>? songs,
    DateTime? createdAt,
    String? likedBy,
    DateTime? likedAt,
  }) {
    return Like(
      id: id ?? this.id,
      name: name ?? this.name,
      createdBy: createdBy ?? this.createdBy,
      songs: songs ?? this.songs,
      createdAt: createdAt ?? this.createdAt,
      likedBy: likedBy ?? this.likedBy,
      likedAt: likedAt ?? this.likedAt,
    );
  }

  // Convert to Firestore-compatible Map
  @override
  Map<String, dynamic> toFirestore() {
    final playlistData = super.toFirestore();
    return {
      ...playlistData,
      'likedBy': likedBy,
      'likedAt': likedAt.millisecondsSinceEpoch,
    };
  }

  // Create from Firestore Map
  factory Like.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return Like(
      id: doc.id,
      name: data['name'] ?? '',
      createdBy: data['createdBy'] ?? '',
      songs: List<String>.from(data['songs'] ?? []),
      createdAt: DateTime.fromMillisecondsSinceEpoch(data['createdAt']),
      likedBy: data['likedBy'] ?? '',
      likedAt: DateTime.fromMillisecondsSinceEpoch(data['likedAt']),
    );
  }
}
