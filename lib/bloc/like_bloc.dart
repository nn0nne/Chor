// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:equatable/equatable.dart';
// import 'package:chor/models/like.dart';
// import 'package:chor/services/firebase.dart';

// // Events
// abstract class LikeEvent extends Equatable {
//   @override
//   List<Object> get props => [];
// }

// class LoadLikes extends LikeEvent {
//   final String userId;
//   LoadLikes(this.userId);

//   @override
//   List<Object> get props => [userId];
// }

// class ToggleLikeSong extends LikeEvent {
//   final String songId;
//   final String userId;

//   ToggleLikeSong({
//     required this.songId,
//     required this.userId,
//   });

//   @override
//   List<Object> get props => [songId, userId];
// }

// // States
// abstract class LikeState extends Equatable {
//   @override
//   List<Object> get props => [];
// }

// class LikeInitial extends LikeState {}

// class LikeLoading extends LikeState {}

// class LikeLoaded extends LikeState {
//   final Like userLikes;
//   final List<String> likedSongs;

//   LikeLoaded({
//     required this.userLikes,
//     required this.likedSongs,
//   });

//   @override
//   List<Object> get props => [userLikes, likedSongs];
// }

// class LikeError extends LikeState {
//   final String message;

//   LikeError(this.message);

//   @override
//   List<Object> get props => [message];
// }

// // BLoC
// class LikeBloc extends Bloc<LikeEvent, LikeState> {
//   final FirebaseService _firebaseService;

//   LikeBloc({required FirebaseService firebaseService})
//       : _firebaseService = firebaseService,
//         super(LikeInitial()) {
//     on<LoadLikes>(_handleLoadLikes);
//     on<ToggleLikeSong>(_handleToggleLikeSong);
//   }

//   Future<void> _handleLoadLikes(
//     LoadLikes event,
//     Emitter<LikeState> emit,
//   ) async {
//     emit(LikeLoading());
//     try {
//       final likeDoc = await _firebaseService.firestore
//           .collection('likes')
//           .doc(event.userId)
//           .get();

//       if (!likeDoc.exists) {
//         // Create new likes document for user
//         final newLike = Like(
//           id: event.userId,
//           name: 'Liked Songs',
//           createdBy: event.userId,
//           songs: [],
//           createdAt: DateTime.now(),
//           likedBy: event.userId,
//           likedAt: DateTime.now(),
//         );

//         await _firebaseService.firestore
//             .collection('likes')
//             .doc(event.userId)
//             .set(newLike.toFirestore());

//         emit(LikeLoaded(
//           userLikes: newLike,
//           likedSongs: [],
//         ));
//       } else {
//         final like = Like.fromFirestore(likeDoc);
//         emit(LikeLoaded(
//           userLikes: like,
//           likedSongs: like.songs,
//         ));
//       }
//     } catch (e) {
//       emit(LikeError(e.toString()));
//     }
//   }

//   Future<void> _handleToggleLikeSong(
//     ToggleLikeSong event,
//     Emitter<LikeState> emit,
//   ) async {
//     try {
//       if (state is LikeLoaded) {
//         final currentState = state as LikeLoaded;
//         final updatedLike = currentState.userLikes.toggleLike(event.songId);

//         await _firebaseService.firestore
//             .collection('likes')
//             .doc(event.userId)
//             .update(updatedLike.toFirestore());

//         emit(LikeLoaded(
//           userLikes: updatedLike,
//           likedSongs: updatedLike.songs,
//         ));
//       }
//     } catch (e) {
//       emit(LikeError(e.toString()));
//     }
//   }
// }
