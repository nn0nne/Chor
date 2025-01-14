import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';

class User {
  final String _id;
  final String _username;
  final String _email;
  final String _hashedPassword;

  User({
    required String id,
    required String username,
    required String email,
    required String password,
  })  : _id = id,
        _username = username,
        _email = email,
        _hashedPassword = _hashPassword(password);

  // Getters for encapsulation
  String get id => _id;
  String get username => _username;
  String get email => _email;
  String get hashedPassword => _hashedPassword;

  // Hashing the password
  static String _hashPassword(String password) {
    final bytes = utf8.encode(password); // Convert password to bytes
    return sha256.convert(bytes).toString(); // Hash using SHA-256
  }

  // Convert to Firestore-compatible Map
  Map<String, dynamic> toFirestore() {
    return {
      'id': _id,
      'username': _username,
      'email': _email,
      'hashedPassword': _hashedPassword, // Use hashed password
    };
  }

  // Create from Firestore Map
  factory User.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return User(
      id: doc.id,
      username: data['username'] ?? '',
      email: data['email'] ?? '',
      password: '', // Password isn't needed here
    );
  }

  // Verify if a given password matches the hashed password
  bool verifyPassword(String password) {
    return _hashedPassword == _hashPassword(password);
  }
}
