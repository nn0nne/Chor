// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:equatable/equatable.dart';
// import 'package:chor/models/song.dart';
// import 'package:chor/services/firebase.dart';

// // Events
// abstract class SongEvent extends Equatable {
//   @override
//   List<Object> get props => [];
// }

// class LoadSongs extends SongEvent {}

// class UploadSong extends SongEvent {
//   final String title;
//   final String artist;
//   final String filePath;
//   final String songCover;
//   final String createdBy;

//   UploadSong({
//     required this.title,
//     required this.artist,
//     required this.filePath,
//     required this.songCover,
//     required this.createdBy,
//   });

//   @override
//   List<Object> get props => [title, artist, filePath, songCover, createdBy];
// }

// class DeleteSong extends SongEvent {
//   final String songId;

//   DeleteSong(this.songId);

//   @override
//   List<Object> get props => [songId];
// }

// class SearchSongs extends SongEvent {
//   final String query;

//   SearchSongs(this.query);

//   @override
//   List<Object> get props => [query];
// }

// // States
// abstract class SongState extends Equatable {
//   @override
//   List<Object> get props => [];
// }

// class SongInitial extends SongState {}

// class SongLoading extends SongState {}

// class SongsLoaded extends SongState {
//   final List<Song> songs;

//   SongsLoaded(this.songs);

//   @override
//   List<Object> get props => [songs];
// }

// class SongError extends SongState {
//   final String message;

//   SongError(this.message);

//   @override
//   List<Object> get props => [message];
// }

// class SongUploading extends SongState {
//   final double progress;

//   SongUploading(this.progress);

//   @override
//   List<Object> get props => [progress];
// }

// // BLoC
// class SongBloc extends Bloc<SongEvent, SongState> {
//   final FirebaseService _firebaseService;

//   SongBloc({required FirebaseService firebaseService})
//       : _firebaseService = firebaseService,
//         super(SongInitial()) {
//     on<LoadSongs>(_handleLoadSongs);
//     on<UploadSong>(_handleUploadSong);
//     on<DeleteSong>(_handleDeleteSong);
//     on<SearchSongs>(_handleSearchSongs);
//   }

//   Future<void> _handleLoadSongs(
//     LoadSongs event,
//     Emitter<SongState> emit,
//   ) async {
//     emit(SongLoading());
//     try {
//       final songsSnapshot =
//           await _firebaseService.firestore.collection('songs').get();

//       final songs =
//           songsSnapshot.docs.map((doc) => Song.fromFirestore(doc)).toList();

//       emit(SongsLoaded(songs));
//     } catch (e) {
//       emit(SongError(e.toString()));
//     }
//   }

//   Future<void> _handleUploadSong(
//     UploadSong event,
//     Emitter<SongState> emit,
//   ) async {
//     try {
//       // Upload song file
//       emit(SongUploading(0.0));
//       final songPath = '${event.createdBy}/${event.title}-${event.artist}';
//       final songUrl = await _firebaseService.uploadFile(
//         event.filePath,
//         'songs/$songPath',
//       );

//       emit(SongUploading(0.5));

//       // Upload cover image
//       final coverPath =
//           '${event.createdBy}/${event.title}-${event.artist}-cover';
//       final coverUrl = await _firebaseService.uploadFile(
//         event.songCover,
//         'covers/$coverPath',
//       );

//       emit(SongUploading(0.8));

//       if (songUrl != null && coverUrl != null) {
//         // Create new song document
//         await _firebaseService.firestore.collection('songs').add({
//           'title': event.title,
//           'artist': event.artist,
//           'filePath': songUrl,
//           'createdBy': event.createdBy,
//           'songCover': coverUrl,
//           'uploadedAt': DateTime.now(),
//         });

//         add(LoadSongs());
//       } else {
//         emit(SongError('Failed to upload song or cover'));
//       }
//     } catch (e) {
//       emit(SongError(e.toString()));
//     }
//   }

//   Future<void> _handleDeleteSong(
//     DeleteSong event,
//     Emitter<SongState> emit,
//   ) async {
//     emit(SongLoading());
//     try {
//       await _firebaseService.firestore
//           .collection('songs')
//           .doc(event.songId)
//           .delete();

//       add(LoadSongs());
//     } catch (e) {
//       emit(SongError(e.toString()));
//     }
//   }

//   Future<void> _handleSearchSongs(
//     SearchSongs event,
//     Emitter<SongState> emit,
//   ) async {
//     emit(SongLoading());
//     try {
//       final songsSnapshot =
//           await _firebaseService.firestore.collection('songs').get();

//       final songs = songsSnapshot.docs
//           .map((doc) => Song.fromFirestore(doc))
//           .where((song) =>
//               song.title.toLowerCase().contains(event.query.toLowerCase()) ||
//               song.artist.toLowerCase().contains(event.query.toLowerCase()))
//           .toList();

//       emit(SongsLoaded(songs));
//     } catch (e) {
//       emit(SongError(e.toString()));
//     }
//   }
// }
