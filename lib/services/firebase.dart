import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  // Firebase instances
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  get auth => _auth;
  get storage => _storage;
  get firestore => _firestore;

  // Authentication
  Future<User?> signIn(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      print('Error signing in: $e');
      return null;
    }
  }

  Future<User?> signUp(String email, String password) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      // Initialize user in Firestore (optional)
      await _firestore.collection('users').doc(userCredential.user?.uid).set({
        'email': email,
        'createdAt': DateTime.now(),
      });
      return userCredential.user;
    } catch (e) {
      print('Error signing up: $e');
      return null;
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      print('Error signing out: $e');
    }
  }

  // Firebase Storage
  // TODO maybe change this so that it handle song file and image cover for the song and playlist (format it to be like this title-artist-uploader)
  Future<String?> uploadFile(String filePath, String destinationPath) async {
    if (filePath.isEmpty) {
      print('Error: File path is null or empty');
      return null;
    }

    if (destinationPath.isEmpty) {
      print('Error: Destination path is null or empty');
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

  // Firestore - Add Data
  Future<void> addData(String collection, Map<String, dynamic> data) async {
    try {
      await _firestore.collection(collection).add(data);
    } catch (e) {
      print('Error adding data to Firestore: $e');
    }
  }

  // Firestore - Fetch Data
  Future<List<Map<String, dynamic>>> fetchData(
    String collection, {
    int limit = 10,
    DocumentSnapshot? lastDoc,
  }) async {
    try {
      Query query = _firestore.collection(collection);

      if (lastDoc != null) {
        query = query.startAfterDocument(lastDoc);
      }

      QuerySnapshot snapshot = await query.limit(limit).get();
      return snapshot.docs.map((doc) {
        return {
          'id': doc.id, // Include document ID for future edits/deletes
          ...doc.data() as Map<String, dynamic>,
        };
      }).toList();
    } catch (e) {
      print('Error fetching data: $e');
      return [];
    }
  }

  // Firestore - Edit Data
  Future<void> editData(
      String collection, String docId, Map<String, dynamic> updatedData) async {
    try {
      await _firestore.collection(collection).doc(docId).update(updatedData);
      print('Document updated successfully');
    } catch (e) {
      print('Error updating document: $e');
    }
  }

  // Firestore - Delete Data
  Future<void> deleteData(String collection, String docId) async {
    try {
      await _firestore.collection(collection).doc(docId).delete();
      print('Document deleted successfully');
    } catch (e) {
      print('Error deleting document: $e');
    }
  }
}
