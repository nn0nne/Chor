import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  // Firebase instances
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  FirebaseStorage get storage => _storage;
  FirebaseFirestore get firestore => _firestore;

  /// Helper to upload a file to Firebase Storage
  Future<String?> uploadFile(String filePath, String destinationPath) async {
    if (filePath.isEmpty || destinationPath.isEmpty) {
      print('Error: File path or destination path is null or empty');
      return null;
    }

    try {
      File file = File(filePath);
      Reference ref = _storage.ref(destinationPath);
      TaskSnapshot uploadTask = await ref.putFile(file);

      // Get download URL
      String downloadURL = await uploadTask.ref.getDownloadURL();
      return downloadURL;
    } catch (e) {
      print('Error uploading file: $e');
      return null;
    }
  }

  /// Firestore - Songs
  Future<void> addSong(Map<String, dynamic> songData) async {
    try {
      await _firestore.collection('Songs').add(songData);
    } catch (e) {
      print('Error adding song: $e');
    }
  }

  Future<List<Map<String, dynamic>>> fetchSongs(
      {int limit = 10, DocumentSnapshot? lastDoc}) async {
    try {
      Query query =
          _firestore.collection('Songs').orderBy('createdAt', descending: true);

      if (lastDoc != null) {
        query = query.startAfterDocument(lastDoc);
      }

      QuerySnapshot snapshot = await query.limit(limit).get();
      return snapshot.docs.map((doc) {
        return {
          'id': doc.id,
          ...doc.data() as Map<String, dynamic>,
        };
      }).toList();
    } catch (e) {
      print('Error fetching songs: $e');
      return [];
    }
  }

  Future<void> editSong(String songId, Map<String, dynamic> updatedData) async {
    try {
      await _firestore.collection('Songs').doc(songId).update(updatedData);
      print('Song updated successfully');
    } catch (e) {
      print('Error updating song: $e');
    }
  }

  Future<void> deleteSong(String songId) async {
    try {
      await _firestore.collection('Songs').doc(songId).delete();
      print('Song deleted successfully');
    } catch (e) {
      print('Error deleting song: $e');
    }
  }

  Future<String> getUsernameById(String userId) async {
    try {
      DocumentSnapshot userDoc =
          await _firestore.collection('Users').doc(userId).get();
      if (userDoc.exists) {
        return userDoc[
            'username']; // Assuming you store username as 'username' field
      } else {
        throw Exception("User not found");
      }
    } catch (e) {
      rethrow;
    }
  }

  /// Firestore - Playlists
  Future<void> addPlaylist(Map<String, dynamic> playlistData) async {
    try {
      await _firestore.collection('Playlists').add(playlistData);
    } catch (e) {
      print('Error adding playlist: $e');
    }
  }

  Future<List<Map<String, dynamic>>> fetchPlaylists(
      {int limit = 10, DocumentSnapshot? lastDoc}) async {
    try {
      Query query = _firestore
          .collection('Playlists')
          .orderBy('createdAt', descending: true);

      if (lastDoc != null) {
        query = query.startAfterDocument(lastDoc);
      }

      QuerySnapshot snapshot = await query.limit(limit).get();
      return snapshot.docs.map((doc) {
        return {
          'id': doc.id,
          ...doc.data() as Map<String, dynamic>,
        };
      }).toList();
    } catch (e) {
      print('Error fetching playlists: $e');
      return [];
    }
  }

  Future<void> editPlaylist(
      String playlistId, Map<String, dynamic> updatedData) async {
    try {
      await _firestore
          .collection('Playlists')
          .doc(playlistId)
          .update(updatedData);
      print('Playlist updated successfully');
    } catch (e) {
      print('Error updating playlist: $e');
    }
  }

  Future<void> deletePlaylist(String playlistId) async {
    try {
      await _firestore.collection('Playlists').doc(playlistId).delete();
      print('Playlist deleted successfully');
    } catch (e) {
      print('Error deleting playlist: $e');
    }
  }

  /// Firestore - Likes
  Future<void> likeSong(String userId, String songId) async {
    try {
      await _firestore.collection('Likes').add({
        'userId': userId,
        'songId': songId,
        'likedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error liking song: $e');
    }
  }

  Future<List<String>> fetchLikedSongs(String userId) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('Likes')
          .where('userId', isEqualTo: userId)
          .get();

      return snapshot.docs.map((doc) => doc['songId'] as String).toList();
    } catch (e) {
      print('Error fetching liked songs: $e');
      return [];
    }
  }

  Future<void> unlikeSong(String likeId) async {
    try {
      await _firestore.collection('Likes').doc(likeId).delete();
      print('Song unliked successfully');
    } catch (e) {
      print('Error unliking song: $e');
    }
  }
}
