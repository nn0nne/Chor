import 'package:chor/services/firebase.dart';
import 'package:flutter/material.dart';
import 'package:chor/widgets/song_card.dart';
import 'package:chor/widgets/playlist_card.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final FirebaseService _firebaseService = FirebaseService();
  TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _songs = [];
  List<Map<String, dynamic>> _playlists = [];
  String _searchQuery = '';
  bool _isSongsSelected = true; // Default to Songs selected
  bool _isPlaylistsSelected = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  // Function to search for songs and playlists based on query
  void _search() async {
    List<Map<String, dynamic>> songs = [];
    List<Map<String, dynamic>> playlists = [];

    setState(() {
      _isLoading = true;
    });

    // Convert search query to lowercase for case-insensitive comparison
    String lowerCaseQuery = _searchQuery.toLowerCase();

    // Search songs and playlists based on the search query
    if (_searchQuery.isNotEmpty) {
      if (_isSongsSelected) {
        songs = await _firebaseService.fetchSongsByTitle(lowerCaseQuery);
      }
      if (_isPlaylistsSelected) {
        playlists =
            await _firebaseService.fetchPlaylistsByTitle(lowerCaseQuery);
      }
    }

    // Convert titles to uppercase after fetching them
    songs = songs.map((song) {
      song['title'] = song['title']; // Convert song title to uppercase
      return song;
    }).toList();

    playlists = playlists.map((playlist) {
      playlist['name'] = playlist['name']; // Convert playlist name to uppercase
      return playlist;
    }).toList();

    setState(() {
      _songs = songs;
      _playlists = playlists;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.person, color: Color(0xFFEEEEEE)),
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
        ),
        title: Text(
          "Search",
          style: TextStyle(
              color: Color(0xFFEEEEEE),
              fontSize: 30,
              fontWeight: FontWeight.w500),
        ),
        backgroundColor: Color(0xFF070F2B),
      ),
      backgroundColor: Color(0xFF070F2B),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Got anything in mind?",
                  fillColor: Color(0xFFEEEEEE),
                  filled: true,
                  hintStyle: TextStyle(color: Color(0xFF282828)),
                  prefixIcon: Icon(Icons.search)),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
                _search();
              },
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _isSongsSelected = true;
                      _isPlaylistsSelected = false;
                    });
                    _search();
                  },
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Color(0x801B1A55)),
                  ),
                  child: Text(
                    "Songs",
                    style: TextStyle(
                      color: _isSongsSelected
                          ? Color(0xFFEEEEEE)
                          : Color(0xFF9290C3),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _isPlaylistsSelected = true;
                      _isSongsSelected = false;
                    });
                    _search();
                  },
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Color(0x801B1A55)),
                  ),
                  child: Text(
                    "Playlists",
                    style: TextStyle(
                      color: _isPlaylistsSelected
                          ? Color(0xFFEEEEEE)
                          : Color(0xFF9290C3),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Display the results using ListView.separated
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      itemCount: _isSongsSelected
                          ? _songs.length
                          : _isPlaylistsSelected
                              ? _playlists.length
                              : 0, // Only show results based on selection
                      itemBuilder: (context, index) {
                        if (_isSongsSelected) {
                          var song = _songs[index];
                          return Padding(
                            padding: const EdgeInsets.only(
                                bottom: 16.0), // Add spacing
                            child: SongCard(
                              coverUrl: song['coverUrl'],
                              songUrl: song['songUrl'],
                              title: song['title'],
                              artists: song['artists'],
                              songId: song['id'],
                              userId: song['uploadedBy'],
                            ),
                          );
                        } else if (_isPlaylistsSelected) {
                          var playlist = _playlists[index];
                          return Padding(
                            padding: const EdgeInsets.only(
                                bottom: 16.0), // Add spacing
                            child: PlaylistCard(
                              playlistId: playlist['id'],
                              coverImageUrl: playlist['coverUrl'],
                              title: playlist['name'],
                              createdBy: playlist['createdBy'],
                              createdById: playlist['createdById'],
                            ),
                          );
                        }
                      },
                    ),
            )
          ],
        ),
      ),
    );
  }
}
