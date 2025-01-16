import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

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

class PlayerProvider extends ChangeNotifier {
  final AudioPlayer _audioPlayer = AudioPlayer();

  // State variables
  Map<String, dynamic>? _currentSong;
  List<Map<String, dynamic>> _playlist = [];
  bool _isPlaying = false;
  bool _isLiked = false;
  bool _isShuffling = false;
  bool _isRepeating = false;
  Duration _currentPosition = Duration.zero;
  Duration _songDuration = Duration.zero;
  int _currentIndex = 0;
  List<Map<String, dynamic>> _originalPlaylist = [];
  bool _isPlaylistMode = false;

  // Getters
  bool get isPlaying => _isPlaying;
  bool get isLiked => _isLiked;
  bool get isShuffling => _isShuffling;
  bool get isRepeating => _isRepeating;
  Duration get currentPosition => _currentPosition;
  Duration get songDuration => _songDuration;
  bool get isPlaylistMode => _isPlaylistMode;
  List<Map<String, dynamic>> get playlist => _playlist;
  int get currentIndex => _currentIndex;

  CurrentSong? get currentSong {
    if (_currentSong == null) return null;

    return CurrentSong(
      title: _currentSong!['title'] ?? 'Unknown Title',
      artist: _currentSong!['artists'] ?? 'Unknown Artist',
      coverImageUrl:
          _currentSong!['coverUrl'] ?? 'https://via.placeholder.com/50',
    );
  }

  PlayerProvider() {
    _initAudioPlayer();
  }

  void _initAudioPlayer() {
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

  Future<void> playSingleOrPlaylist({
    required List<Map<String, dynamic>> playlist,
    int startIndex = 0,
  }) async {
    if (playlist.isEmpty) return;

    _originalPlaylist = List.from(playlist);
    _playlist = List.from(playlist);

    if (_isShuffling) {
      var currentSong = playlist[startIndex];
      _playlist.shuffle();
      // Ensure selected song is first
      _playlist.remove(currentSong);
      _playlist.insert(0, currentSong);
      startIndex = 0;
    }

    _currentIndex = startIndex;
    _isPlaylistMode = playlist.length > 1;
    await _playCurrentSong();
  }

  Future<void> _playCurrentSong() async {
    if (_playlist.isEmpty || _currentIndex >= _playlist.length) return;

    _currentSong = _playlist[_currentIndex];
    final songUrl = _currentSong!['songUrl'];

    try {
      await _audioPlayer.stop(); // Stop current playback
      await _audioPlayer.play(UrlSource(songUrl));
      _isPlaying = true;
      _currentPosition = Duration.zero; // Reset position
      notifyListeners();
    } catch (e) {
      debugPrint('Error playing song: $e');
      if (!_isRepeating) {
        nextSong();
      }
    }
  }

  Future<void> nextSong() async {
    if (_playlist.isEmpty || !_isPlaylistMode) return;

    if (_currentIndex < _playlist.length - 1) {
      _currentIndex++;
    } else if (!_isRepeating) {
      _currentIndex = 0; // Loop to start if not repeating current song
    }

    await _playCurrentSong();
  }

  Future<void> previousSong() async {
    if (_playlist.isEmpty || !_isPlaylistMode) return;

    if (_currentPosition.inSeconds > 3) {
      await _audioPlayer.seek(Duration.zero);
    } else {
      if (_currentIndex > 0) {
        _currentIndex--;
      } else {
        _currentIndex = _playlist.length - 1; // Loop to end
      }
      await _playCurrentSong();
    }
  }

  // Toggle shuffle mode
  void toggleShuffle() {
    _isShuffling = !_isShuffling;
    if (_isShuffling) {
      // Save current song
      final currentSong = _playlist[_currentIndex];
      _playlist.shuffle();
      // Move current song to start of shuffled playlist
      _playlist.remove(currentSong);
      _playlist.insert(0, currentSong);
      _currentIndex = 0;
    } else {
      // Find current song in original playlist
      final currentSong = _playlist[_currentIndex];
      _playlist = List.from(_originalPlaylist);
      _currentIndex = _playlist
          .indexWhere((song) => song['songUrl'] == currentSong['songUrl']);
    }
    notifyListeners();
  }

  Future<void> togglePlayPause() async {
    if (_currentSong == null) return;

    if (_isPlaying) {
      await _audioPlayer.pause();
      _isPlaying = false;
    } else {
      await _audioPlayer.resume();
      _isPlaying = true;
    }
    notifyListeners();
  }

  void toggleRepeat() {
    _isRepeating = !_isRepeating;
    notifyListeners();
  }

  void toggleLike() {
    _isLiked = !_isLiked;
    notifyListeners();
  }

  Future<void> seek(Duration position) async {
    try {
      await _audioPlayer.seek(position);
      notifyListeners();
    } catch (e) {
      debugPrint('Error seeking to position: $e');
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  // Add the new playSong method
  Future<void> playSong({
    required String title,
    required String artist,
    required String coverImageUrl,
    required String songUrl,
  }) async {
    try {
      // Create a single-song playlist
      final song = {
        'title': title,
        'artists': artist,
        'coverUrl': coverImageUrl,
        'songUrl': songUrl,
      };

      // Use playSingleOrPlaylist with a single-song playlist
      await playSingleOrPlaylist(playlist: [song], startIndex: 0);
    } catch (e) {
      debugPrint('Error in playSong: $e');
      throw Exception('Failed to play song: $e');
    }
  }
}
