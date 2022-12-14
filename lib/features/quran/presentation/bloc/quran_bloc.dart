// ignore_for_file: constant_identifier_names

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/quran_data.dart';
import '../../domain/usecases/get_quran_data.dart';

part 'quran_event.dart';
part 'quran_state.dart';

const String SERVER_FAILURE_MESSAGE = 'Server Failure';
const String CACHE_FAILURE_MESSAGE = 'Cache Failure';

class QuranBloc extends Bloc<QuranEvent, QuranState> {
  QuranBloc({
    required GetQuranData getQuranData,
  })  : _getQuranData = getQuranData,
        super(QuranState()) {
    on<OnGetData>(_onGetData);
    on<OnSearch>(_onSearch);
    on<OnStartRecite>(_onStartRecite);
    on<OnPauseRecite>(_onPauseRecite);
    on<OnStopOrFinishRecite>(_onStopOrFinishRecite);
    on<OnResumeRecite>(_onResumeRecite);
    on<OnPositionStream>(_onPositionStream);
    on<OnBufferedPositionStream>(_onBufferedPositionStream);
    on<OnDurationStream>(_onDurationStream);
    on<OnPlayingStream>(_onPlayingStream);
    on<OnProcessingStream>(_onProcessingStream);
    on<OnDragValueSlider>(_onDragValueSlider);
    on<OnSeekEndChanged>(_onSeekEndChanged);
    on<OnReversedList>(_onReversedList);
    on<OnIndexStream>(_onIndexStream);
  }

  final GetQuranData _getQuranData;
  final AudioPlayer _audioPlayer = AudioPlayer();

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return SERVER_FAILURE_MESSAGE;
      case CacheFailure:
        return CACHE_FAILURE_MESSAGE;
      default:
        return 'Unexpected error';
    }
  }

  void _onReversedList(
    OnReversedList event,
    Emitter<QuranState> emit,
  ) {
    if (state.loadStatus == LoadStatus.loaded) {
      emit(state.copyWith(
        listSurah: state.listSurah.reversed.toList(),
        listSurahNew: state.listSurahNew.reversed.toList(),
        isListReversed: !state.isListReversed,
      ));
    }
  }

  void _onGetData(
    OnGetData event,
    Emitter<QuranState> emit,
  ) async {
    emit(state.copyWith(loadStatus: LoadStatus.loading));

    final failureOrData = await _getQuranData(NoParams());
    failureOrData.fold(
      (error) {
        emit(
          state.copyWith(
            errorMessage: _mapFailureToMessage(error),
            loadStatus: LoadStatus.error,
          ),
        );
      },
      (qData) {
        final List<AudioSource> listAudioSource = [];

        for (int i = 0; i < qData.length; i++) {
          listAudioSource.add(
            AudioSource.uri(
              Uri.parse(qData[i].audio).replace(scheme: "https"),
              tag: MediaItem(
                id: i.toString(),
                title: qData[i].nama,
                artist: "archive.org",
              ),
            ),
          );
        }

        _audioPlayer.setAudioSource(
          ConcatenatingAudioSource(
            useLazyPreparation: true,
            children: listAudioSource,
          ),
        );

        emit(
          state.copyWith(
            listSurah: qData,
            listSurahNew: qData,
            loadStatus: LoadStatus.loaded,
          ),
        );
      },
    );

    add(const OnPositionStream());
    add(const OnBufferedPositionStream());
    add(const OnDurationStream());
    add(const OnPlayingStream());
    add(const OnProcessingStream());
    add(const OnIndexStream());
  }

  void _onSearch(
    OnSearch event,
    Emitter<QuranState> emit,
  ) {
    if (event.valueSearch == "") {
      emit(state.copyWith(listSurahNew: state.listSurah));
    } else {
      List<QuranData> newData = state.listSurah
          .where((e) =>
              e.nama.toLowerCase().contains(event.valueSearch) ||
              e.nomor.toLowerCase().contains(event.valueSearch) ||
              e.nama.toLowerCase().startsWith(event.valueSearch) ||
              e.nomor.toLowerCase().startsWith(event.valueSearch))
          .toList();

      emit(state.copyWith(listSurahNew: newData));
    }
  }

  void _onStartRecite(
    OnStartRecite event,
    Emitter<QuranState> emit,
  ) async {
    _audioPlayer.seek(
      Duration.zero,
      index: (int.tryParse(event.quranData.nomor) ?? 0) - 1,
    );

    // emit(state.copyWith(
    //   audioTargetNumber: int.tryParse(event.quranData.nomor),
    // ));

    _audioPlayer.play();
  }

  void _onPositionStream(
    OnPositionStream event,
    Emitter<QuranState> emit,
  ) async {
    await emit.forEach<Duration>(
      _audioPlayer.positionStream,
      onData: (position) => state.copyWith(
        position: position.inMilliseconds,
      ),
    );
  }

  void _onBufferedPositionStream(
    OnBufferedPositionStream event,
    Emitter<QuranState> emit,
  ) async {
    await emit.forEach<Duration>(
      _audioPlayer.bufferedPositionStream,
      onData: (bPosition) => state.copyWith(
        bufferedPosition: bPosition.inMilliseconds,
      ),
    );
  }

  void _onDurationStream(
    OnDurationStream event,
    Emitter<QuranState> emit,
  ) async {
    await emit.forEach<Duration?>(
      _audioPlayer.durationStream,
      onData: (duration) => state.copyWith(
        duration: duration?.inMilliseconds ?? 0,
      ),
    );
  }

  void _onPlayingStream(
    OnPlayingStream event,
    Emitter<QuranState> emit,
  ) async {
    await emit.forEach<bool>(
      _audioPlayer.playingStream,
      onData: (play) => state.copyWith(
        isPlaying: play,
      ),
    );
  }

  void _onProcessingStream(
    OnProcessingStream event,
    Emitter<QuranState> emit,
  ) async {
    await emit.forEach<ProcessingState>(
      _audioPlayer.processingStateStream,
      onData: (process) => state.copyWith(
        processingState: process,
      ),
    );
  }

  void _onIndexStream(
    OnIndexStream event,
    Emitter<QuranState> emit,
  ) async {
    await emit.forEach<int?>(
      _audioPlayer.currentIndexStream,
      onData: (index) => state.copyWith(audioTargetNumber: (index ?? 0) + 1),
    );
  }

  void _onStopOrFinishRecite(
    OnStopOrFinishRecite event,
    Emitter<QuranState> emit,
  ) async {
    await _audioPlayer.stop();
    emit(state.copyWith(
      audioTargetNumber: 999,
      dragValue: -1,
      position: 0,
      duration: 0,
      processingState: ProcessingState.idle,
      bufferedPosition: 0,
      isPlaying: false,
    ));
  }

  void _onSeekEndChanged(
    OnSeekEndChanged event,
    Emitter<QuranState> emit,
  ) {
    _audioPlayer.seek(Duration(milliseconds: event.val.round()));
    emit(state.copyWith(dragValue: -1));
  }

  void _onDragValueSlider(
    OnDragValueSlider event,
    Emitter<QuranState> emit,
  ) {
    emit(state.copyWith(dragValue: event.val));
  }

  void _onPauseRecite(
    OnPauseRecite event,
    Emitter<QuranState> emit,
  ) {
    _audioPlayer.pause();
  }

  void _onResumeRecite(
    OnResumeRecite event,
    Emitter<QuranState> emit,
  ) {
    _audioPlayer.play();
  }

  @override
  Future<void> close() {
    // ignore: todo
    // TODO: implement close
    _audioPlayer.dispose();
    return super.close();
  }
}
