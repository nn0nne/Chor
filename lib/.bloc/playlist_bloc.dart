// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:equatable/equatable.dart';
// import 'package:chor/models/playlist.dart';
// import 'package:chor/services/firebase.dart';

// // Events
// abstract class PlaylistEvent extends Equatable {
//   @override
//   List<Object> get props => [];
// }

// class LoadPlaylists extends PlaylistEvent {}

// class CreatePlaylist extends PlaylistEvent {
//   final String name;
//   final String createdBy;

//   CreatePlaylist({
//     required this.name,
//     required this.createdBy,
//   });

//   @override
//   List<Object> get props => [name, createdBy];
// }

// class DeletePlaylist extends PlaylistEvent {
//   final String playlistId;

//   DeletePlaylist(this.playlistId);

//   @override
//   List<Object> get props => [playlistId];
// }

// class AddSongToPlaylist extends PlaylistEvent {
//   final String playlistId;
//   final String songId;

//   AddSongToPlaylist(this.playlistId, this.songId);

//   @override
//   List<Object> get props => [playlistId, songId];
// }

// class RemoveSongFromPlaylist extends PlaylistEvent {
//   final String playlistId;
//   final String songId;

//   RemoveSongFromPlaylist(this.playlistId, this.songId);

//   @override
//   List<Object> get props => [playlistId, songId];
// }

// // States
// abstract class PlaylistState extends Equatable {
//   @override
//   List<Object> get props => [];
// }

// class PlaylistInitial extends PlaylistState {}

// class PlaylistLoading extends PlaylistState {}

// class PlaylistsLoaded extends PlaylistState {
//   final List<Playlist> playlists;

//   PlaylistsLoaded(this.playlists);

//   @override
//   List<Object> get props => [playlists];
// }

// class PlaylistError extends PlaylistState {
//   final String message;

//   PlaylistError(this.message);

//   @override
//   List<Object> get props => [message];
// }

// // BLoC
// class PlaylistBloc extends Bloc<PlaylistEvent, PlaylistState> {
//   final FirebaseService _firebaseService;

//   PlaylistBloc({required FirebaseService firebaseService})
//       : _firebaseService = firebaseService,
//         super(PlaylistInitial()) {
//     on<LoadPlaylists>(_handleLoadPlaylists);
//     on<CreatePlaylist>(_handleCreatePlaylist);
//     on<DeletePlaylist>(_handleDeletePlaylist);
//     on<AddSongToPlaylist>(_handleAddSongToPlaylist);
//     on<RemoveSongFromPlaylist>(_handleRemoveSongFromPlaylist);
//   }

//   Future<void> _handleLoadPlaylists(
//     LoadPlaylists event,
//     Emitter<PlaylistState> emit,
//   ) async {
//     emit(PlaylistLoading());
//     try {
//       final playlistsSnapshot =
//           await _firebaseService.firestore.collection('playlists').get();

//       final playlists = playlistsSnapshot.docs
//           .map((doc) => Playlist.fromFirestore(doc))
//           .toList();

//       emit(PlaylistsLoaded(playlists));
//     } catch (e) {
//       emit(PlaylistError(e.toString()));
//     }
//   }

//   Future<void> _handleCreatePlaylist(
//     CreatePlaylist event,
//     Emitter<PlaylistState> emit,
//   ) async {
//     emit(PlaylistLoading());
//     try {
//       await _firebaseService.firestore.collection('playlists').add({
//         'name': event.name,
//         'createdBy': event.createdBy,
//         'songs': <String>[],
//         'createdAt': DateTime.now(),
//       });

//       add(LoadPlaylists());
//     } catch (e) {
//       emit(PlaylistError(e.toString()));
//     }
//   }

//   Future<void> _handleDeletePlaylist(
//     DeletePlaylist event,
//     Emitter<PlaylistState> emit,
//   ) async {
//     emit(PlaylistLoading());
//     try {
//       await _firebaseService.firestore
//           .collection('playlists')
//           .doc(event.playlistId)
//           .delete();

//       add(LoadPlaylists());
//     } catch (e) {
//       emit(PlaylistError(e.toString()));
//     }
//   }

//   Future<void> _handleAddSongToPlaylist(
//     AddSongToPlaylist event,
//     Emitter<PlaylistState> emit,
//   ) async {
//     emit(PlaylistLoading());
//     try {
//       final docSnapshot = await _firebaseService.firestore
//           .collection('playlists')
//           .doc(event.playlistId)
//           .get();

//       if (!docSnapshot.exists) {
//         throw Exception('Playlist not found');
//       }

//       final playlist = Playlist.fromFirestore(docSnapshot);
//       final updatedPlaylist = playlist.addSong(event.songId);

//       await _firebaseService.firestore
//           .collection('playlists')
//           .doc(event.playlistId)
//           .update(updatedPlaylist.toFirestore());

//       add(LoadPlaylists());
//     } catch (e) {
//       emit(PlaylistError(e.toString()));
//     }
//   }

//   Future<void> _handleRemoveSongFromPlaylist(
//     RemoveSongFromPlaylist event,
//     Emitter<PlaylistState> emit,
//   ) async {
//     emit(PlaylistLoading());
//     try {
//       final docSnapshot = await _firebaseService.firestore
//           .collection('playlists')
//           .doc(event.playlistId)
//           .get();

//       if (!docSnapshot.exists) {
//         throw Exception('Playlist not found');
//       }

//       final playlist = Playlist.fromFirestore(docSnapshot);
//       final updatedPlaylist = playlist.removeSong(event.songId);

//       await _firebaseService.firestore
//           .collection('playlists')
//           .doc(event.playlistId)
//           .update(updatedPlaylist.toFirestore());

//       add(LoadPlaylists());
//     } catch (e) {
//       emit(PlaylistError(e.toString()));
//     }
//   }
// }
