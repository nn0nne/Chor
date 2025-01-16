import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

class PlayerBloc extends Bloc<PlayerEvent, PlayerState> {
  final AudioPlayer audioPlayer = AudioPlayer();

  PlayerBloc() : super(const PlayerInitial()) {
    on<PlaySong>((event, emit) async {
      try {
        await audioPlayer.play(UrlSource(event.songUrl));

        emit(PlayerPlaying(
          song: event.song,
          artist: event.artist,
          coverImageUrl: event.coverImageUrl,
          songUrl: event.songUrl,
          isLiked: state.isLiked,
          isShuffle: state.isShuffle,
          isRepeat: state.isRepeat,
        ));
      } catch (e) {
        print('Error playing song: $e');
        // Consider emitting an error state here
      }
    });

    on<PauseSong>((event, emit) async {
      try {
        await audioPlayer.pause();
        if (state is PlayerPlaying) {
          final currentState = state as PlayerPlaying;
          emit(PlayerPaused(
            song: currentState.song ?? "Unknown Song",
            artist: currentState.artist ?? "Unknown Artist",
            coverImageUrl: currentState.coverImageUrl ?? "",
            songUrl: currentState.songUrl ?? "",
            isLiked: currentState.isLiked,
            isShuffle: currentState.isShuffle,
            isRepeat: currentState.isRepeat,
          ));
        }
      } catch (e) {
        print('Error pausing song: $e');
      }
    });

    on<ToggleLike>((event, emit) {
      emit(state.copyWith(isLiked: !state.isLiked));
    });

    on<ShuffleSong>((event, emit) {
      emit(state.copyWith(isShuffle: event.enable));
    });

    on<RepeatSong>((event, emit) {
      emit(state.copyWith(isRepeat: event.enable));
    });

    on<DisposePlayer>((event, emit) async {
      await audioPlayer.dispose();
      emit(const PlayerInitial());
    });
  }

  @override
  Future<void> close() async {
    await audioPlayer.dispose();
    return super.close();
  }
}

// Events
abstract class PlayerEvent extends Equatable {
  const PlayerEvent();

  @override
  List<Object?> get props => [];
}

class PlaySong extends PlayerEvent {
  final String song;
  final String artist;
  final String coverImageUrl;
  final String songUrl;

  const PlaySong({
    required this.song,
    required this.artist,
    required this.coverImageUrl,
    required this.songUrl,
  });

  @override
  List<Object?> get props => [song, artist, coverImageUrl, songUrl];
}

class PauseSong extends PlayerEvent {}

class ToggleLike extends PlayerEvent {}

class DisposePlayer extends PlayerEvent {}

class ShuffleSong extends PlayerEvent {
  final bool enable;
  const ShuffleSong({required this.enable});

  @override
  List<Object?> get props => [enable];
}

class RepeatSong extends PlayerEvent {
  final bool enable;
  const RepeatSong({required this.enable});

  @override
  List<Object?> get props => [enable];
}

// States
abstract class PlayerState extends Equatable {
  final String? song;
  final String? artist;
  final String? coverImageUrl;
  final String? songUrl;
  final bool isShuffle;
  final bool isRepeat;
  final bool isLiked;

  const PlayerState({
    this.song,
    this.artist,
    this.coverImageUrl,
    this.songUrl,
    this.isShuffle = false,
    this.isRepeat = false,
    this.isLiked = false,
  });

  PlayerState copyWith({
    String? song,
    String? artist,
    String? coverImageUrl,
    String? songUrl,
    bool? isShuffle,
    bool? isRepeat,
    bool? isLiked,
  }) {
    if (this is PlayerPlaying) {
      return PlayerPlaying(
        song: song ?? this.song!,
        artist: artist ?? this.artist!,
        coverImageUrl: coverImageUrl ?? this.coverImageUrl!,
        songUrl: songUrl ?? this.songUrl!,
        isLiked: isLiked ?? this.isLiked,
        isShuffle: isShuffle ?? this.isShuffle,
        isRepeat: isRepeat ?? this.isRepeat,
      );
    } else if (this is PlayerPaused) {
      return PlayerPaused(
        song: song ?? this.song!,
        artist: artist ?? this.artist!,
        coverImageUrl: coverImageUrl ?? this.coverImageUrl!,
        songUrl: songUrl ?? this.songUrl!,
        isLiked: isLiked ?? this.isLiked,
        isShuffle: isShuffle ?? this.isShuffle,
        isRepeat: isRepeat ?? this.isRepeat,
      );
    }
    return PlayerInitial(isLiked: isLiked ?? this.isLiked);
  }

  @override
  List<Object?> get props =>
      [song, artist, coverImageUrl, songUrl, isShuffle, isRepeat, isLiked];
}

class PlayerInitial extends PlayerState {
  const PlayerInitial({bool? isLiked}) : super(isLiked: isLiked ?? false);
}

class PlayerPlaying extends PlayerState {
  const PlayerPlaying({
    required String super.song,
    required String super.artist,
    required String super.coverImageUrl,
    required String super.songUrl,
    super.isLiked,
    super.isShuffle,
    super.isRepeat,
  });
}

class PlayerPaused extends PlayerState {
  const PlayerPaused({
    required String super.song,
    required String super.artist,
    required String super.coverImageUrl,
    required String super.songUrl,
    super.isLiked,
    super.isShuffle,
    super.isRepeat,
  });
}
