// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:equatable/equatable.dart';
// import 'package:chor/models/song.dart';
// import 'package:audioplayers/audioplayers.dart';

// // Events
// abstract class PlayerEvent extends Equatable {
//   @override
//   List<Object?> get props => [];
// }

// class LoadSong extends PlayerEvent {
//   final Song song;
//   LoadSong(this.song);

//   @override
//   List<Object> get props => [song];
// }

// class PlaySong extends PlayerEvent {}

// class PauseSong extends PlayerEvent {}

// class SeekTo extends PlayerEvent {
//   final Duration position;
//   SeekTo(this.position);

//   @override
//   List<Object> get props => [position];
// }

// class ToggleShuffle extends PlayerEvent {}

// class ToggleRepeat extends PlayerEvent {}

// class NextSong extends PlayerEvent {}

// class PreviousSong extends PlayerEvent {}

// // States
// abstract class PlayerState extends Equatable {
//   @override
//   List<Object?> get props => [];
// }

// class PlayerInitial extends PlayerState {}

// class PlayerLoading extends PlayerState {}

// class PlayerReady extends PlayerState {
//   final Song song;
//   final bool isPlaying;
//   final Duration position;
//   final Duration duration;
//   final bool isShuffleEnabled;
//   final bool isRepeatEnabled;

//   PlayerReady({
//     required this.song,
//     required this.isPlaying,
//     required this.position,
//     required this.duration,
//     required this.isShuffleEnabled,
//     required this.isRepeatEnabled,
//   });

//   @override
//   List<Object?> get props => [
//         song,
//         isPlaying,
//         position,
//         duration,
//         isShuffleEnabled,
//         isRepeatEnabled,
//       ];

//   PlayerReady copyWith({
//     Song? song,
//     bool? isPlaying,
//     Duration? position,
//     Duration? duration,
//     bool? isShuffleEnabled,
//     bool? isRepeatEnabled,
//   }) {
//     return PlayerReady(
//       song: song ?? this.song,
//       isPlaying: isPlaying ?? this.isPlaying,
//       position: position ?? this.position,
//       duration: duration ?? this.duration,
//       isShuffleEnabled: isShuffleEnabled ?? this.isShuffleEnabled,
//       isRepeatEnabled: isRepeatEnabled ?? this.isRepeatEnabled,
//     );
//   }
// }

// class PlayerError extends PlayerState {
//   final String message;
//   PlayerError(this.message);

//   @override
//   List<Object> get props => [message];
// }

// // BLoC
// class PlayerBloc extends Bloc<PlayerEvent, PlayerState> {
//   // Add your audio player service/plugin here
//   final AudioPlayer _audioPlayer;

//   PlayerBloc(this._audioPlayer) : super(PlayerInitial()) {
//     on<LoadSong>(_handleLoadSong);
//     on<PlaySong>(_handlePlaySong);
//     on<PauseSong>(_handlePauseSong);
//     on<SeekTo>(_handleSeekTo);
//     on<ToggleShuffle>(_handleToggleShuffle);
//     on<ToggleRepeat>(_handleToggleRepeat);
//     on<NextSong>(_handleNextSong);
//     on<PreviousSong>(_handlePreviousSong);
//   }

//   Future<void> _handleLoadSong(
//     LoadSong event,
//     Emitter<PlayerState> emit,
//   ) async {
//     emit(PlayerLoading());
//     try {
//       // Initialize audio player with song
//       await _audioPlayer.setSourceUrl(event.song.filePath);
//       emit(PlayerReady(
//         song: event.song,
//         isPlaying: false,
//         position: Duration.zero,
//         duration: Duration.zero, // Get actual duration from audio player
//         isShuffleEnabled: false,
//         isRepeatEnabled: false,
//       ));
//     } catch (e) {
//       emit(PlayerError(e.toString()));
//     }
//   }

//   Future<void> _handlePlaySong(
//     PlaySong event,
//     Emitter<PlayerState> emit,
//   ) async {
//     if (state is PlayerReady) {
//       final currentState = state as PlayerReady;
//       try {
//         // await _audioPlayer.play(source: currentState.song.filePath);
//         emit(currentState.copyWith(isPlaying: true));
//       } catch (e) {
//         emit(PlayerError(e.toString()));
//       }
//     }
//   }

//   Future<void> _handlePauseSong(
//     PauseSong event,
//     Emitter<PlayerState> emit,
//   ) async {
//     if (state is PlayerReady) {
//       final currentState = state as PlayerReady;
//       try {
//         await _audioPlayer.pause();
//         emit(currentState.copyWith(isPlaying: false));
//       } catch (e) {
//         emit(PlayerError(e.toString()));
//       }
//     }
//   }

//   Future<void> _handleSeekTo(
//     SeekTo event,
//     Emitter<PlayerState> emit,
//   ) async {
//     if (state is PlayerReady) {
//       final currentState = state as PlayerReady;
//       try {
//         await _audioPlayer.seek(event.position);
//         emit(currentState.copyWith(position: event.position));
//       } catch (e) {
//         emit(PlayerError(e.toString()));
//       }
//     }
//   }

//   Future<void> _handleToggleShuffle(
//     ToggleShuffle event,
//     Emitter<PlayerState> emit,
//   ) async {
//     if (state is PlayerReady) {
//       final currentState = state as PlayerReady;
//       emit(currentState.copyWith(
//         isShuffleEnabled: !currentState.isShuffleEnabled,
//       ));
//     }
//   }

//   Future<void> _handleToggleRepeat(
//     ToggleRepeat event,
//     Emitter<PlayerState> emit,
//   ) async {
//     if (state is PlayerReady) {
//       final currentState = state as PlayerReady;
//       emit(currentState.copyWith(
//         isRepeatEnabled: !currentState.isRepeatEnabled,
//       ));
//     }
//   }

//   Future<void> _handleNextSong(
//     NextSong event,
//     Emitter<PlayerState> emit,
//   ) async {
//     // Implement next song logic
//   }

//   Future<void> _handlePreviousSong(
//     PreviousSong event,
//     Emitter<PlayerState> emit,
//   ) async {
//     // Implement previous song logic
//   }
// }
