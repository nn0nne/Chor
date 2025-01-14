import 'package:cloud_firestore/cloud_firestore.dart';

class Song {
  final String _id;
  final String _title;
  final String _artist;
  final String _filePath;
  final String _createdBy;
  final String _songCover;
  final DateTime _uploadedAt;

  Song({
    required String id,
    required String title,
    required String artist,
    required String filePath,
    required String createdBy,
    required String songCover,
    required DateTime uploadedAt,
  })  : _id = id,
        _title = title,
        _artist = artist,
        _filePath = filePath,
        _createdBy = createdBy,
        _songCover = songCover,
        _uploadedAt = uploadedAt;

  // Getters for encapsulation
  String get id => _id;
  String get title => _title;
  String get artist => _artist;
  String get filePath => _filePath;
  String get createdBy => _createdBy;
  String get songCover => _songCover;
  DateTime get uploadedAt => _uploadedAt;

  // Convert to Firestore-compatible Map
  Map<String, dynamic> toFirestore() {
    return {
      'id': _id,
      'title': _title,
      'artist': _artist,
      'filePath': _filePath,
      'createdBy': _createdBy,
      'songCover': _songCover,
      'uploadedAt': Timestamp.fromDate(_uploadedAt),
    };
  }

  // Create from Firestore Map
  factory Song.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return Song(
      id: doc.id,
      title: data['title'] ?? '',
      artist: data['artist'] ?? '',
      filePath: data['filePath'] ?? '',
      createdBy: data['createdBy'] ?? '',
      songCover: data['songCover'] ?? '',
      uploadedAt: (data['uploadedAt'] as Timestamp).toDate(),
    );
  }
}
