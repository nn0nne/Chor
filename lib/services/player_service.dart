import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class PlayerProvider extends ChangeNotifier {
  final AudioPlayer _audioPlayer = AudioPlayer();

  // State variables
  String? _title;
  String? _artist;
  String? _coverImageUrl;
  String? _songUrl;
  bool _isPlaying = false;
  bool _isLiked = false;
  bool _isShuffling = false;
  bool _isRepeating = false;
  Duration _currentPosition = Duration.zero;
  Duration _songDuration = Duration.zero;

  // Getters
  String? get title => _title;
  String? get artist => _artist;
  String? get coverImageUrl => _coverImageUrl;
  String? get songUrl => _songUrl;
  bool get isPlaying => _isPlaying;
  bool get isLiked => _isLiked;
  bool get isShuffling => _isShuffling;
  bool get isRepeating => _isRepeating;
  Duration get currentPosition => _currentPosition;
  Duration get songDuration => _songDuration;

  // Get the currently loaded song details
  CurrentSong? get currentSong {
    if (_title == null || _artist == null || _coverImageUrl == null) {
      return null;
    }
    return CurrentSong(
      title: _title!,
      artist: _artist!,
      coverImageUrl: _coverImageUrl!,
    );
  }

  // Initialize PlayerProvider
  PlayerProvider() {
    _audioPlayer.onPositionChanged.listen((position) {
      _currentPosition = position;
      notifyListeners();
    });

    _audioPlayer.onDurationChanged.listen((duration) {
      _songDuration = duration;
      notifyListeners();
    });

    _audioPlayer.onPlayerComplete.listen((_) {
      if (_isRepeating) {
        _audioPlayer.seek(Duration.zero);
        _audioPlayer.resume();
      } else {
        nextSong();
      }
    });
  }

  // Play a song
  Future<void> playSong({
    required String title,
    required String artist,
    required String coverImageUrl,
    required String songUrl,
  }) async {
    try {
      await _audioPlayer.play(UrlSource(songUrl));
      _title = title;
      _artist = artist;
      _coverImageUrl = coverImageUrl;
      _songUrl = songUrl;
      _isPlaying = true;
      notifyListeners();
    } catch (e) {
      debugPrint('Error playing song: $e');
    }
  }

  // Pause the song
  Future<void> pauseSong() async {
    try {
      await _audioPlayer.pause();
      _isPlaying = false;
      notifyListeners();
    } catch (e) {
      debugPrint('Error pausing song: $e');
    }
  }

  // Toggle between play and pause
  Future<void> togglePlayPause() async {
    if (_isPlaying) {
      await pauseSong();
    } else if (_songUrl != null) {
      await _audioPlayer.resume();
      _isPlaying = true;
      notifyListeners();
    } else {
      debugPrint('No song is loaded to play.');
    }
  }

  // Seek to a specific position
  Future<void> seek(Duration position) async {
    try {
      await _audioPlayer.seek(position);
      notifyListeners();
    } catch (e) {
      debugPrint('Error seeking to position: $e');
    }
  }

  // Toggle like state
  void toggleLike() {
    _isLiked = !_isLiked;
    notifyListeners();
  }

  // Toggle shuffle state
  void toggleShuffle() {
    _isShuffling = !_isShuffling;
    notifyListeners();
  }

  // Toggle repeat state
  void toggleRepeat() {
    _isRepeating = !_isRepeating;
    notifyListeners();
  }

  // Navigate to previous song
  Future<void> previousSong() async {
    // Implementation depends on your playlist management
    // This is a placeholder for the actual implementation
    debugPrint('Previous song requested');
    // Add your playlist navigation logic here
  }

  // Navigate to next song
  Future<void> nextSong() async {
    // Implementation depends on your playlist management
    // This is a placeholder for the actual implementation
    debugPrint('Next song requested');
    // Add your playlist navigation logic here
  }

  // Dispose the audio player
  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }
}

// Class to represent the current song details
class CurrentSong {
  final String title;
  final String artist;
  final String coverImageUrl;

  CurrentSong({
    required this.title,
    required this.artist,
    required this.coverImageUrl,
  });
}
