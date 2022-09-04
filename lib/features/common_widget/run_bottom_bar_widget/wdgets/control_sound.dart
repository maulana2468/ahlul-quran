import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';

import '../../../../core/utils/function.dart';
import '../../../quran/presentation/bloc/quran_bloc.dart';

class ControlSound extends StatelessWidget {
  const ControlSound({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: Func.getWidth(context, 24),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BlocBuilder<QuranBloc, QuranState>(
                buildWhen: (previous, current) {
                  return previous.audioTargetNumber !=
                      current.audioTargetNumber;
                },
                builder: (context, state) {
                  return Text(
                    "${state.listSurah.where((element) => element.nomor == state.audioTargetNumber).first.nama} (${state.audioTargetNumber})",
                    style: const TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFFDA8856),
                    ),
                  );
                },
              ),
              const Text(
                "archive.org",
                style: TextStyle(
                  fontFamily: "Poppins",
                  fontSize: 11,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          BlocBuilder<QuranBloc, QuranState>(
            builder: (context, state) {
              if (state.processingState == ProcessingState.ready &&
                  state.isPlaying) {
                return Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        context.read<QuranBloc>().add(
                              const OnPauseRecite(),
                            );
                      },
                      child: Image.asset(
                        "assets/vector/pause.png",
                        width: Func.getWidth(context, 24),
                        height: Func.getWidth(context, 24),
                      ),
                    ),
                    SizedBox(
                      width: Func.getWidth(context, 7),
                    ),
                    GestureDetector(
                      onTap: () {
                        context.read<QuranBloc>().add(
                              const OnStopOrFinishRecite(),
                            );
                      },
                      child: Image.asset(
                        "assets/vector/stop.png",
                        width: Func.getWidth(context, 24),
                        height: Func.getWidth(context, 24),
                      ),
                    ),
                  ],
                );
              } else if (state.processingState == ProcessingState.ready &&
                  !state.isPlaying) {
                return Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        context.read<QuranBloc>().add(
                              const OnResumeRecite(),
                            );
                      },
                      child: Image.asset(
                        "assets/vector/play.png",
                        width: Func.getWidth(context, 24),
                        height: Func.getWidth(context, 24),
                      ),
                    ),
                    SizedBox(
                      width: Func.getWidth(context, 7),
                    ),
                    GestureDetector(
                      onTap: () {
                        context.read<QuranBloc>().add(
                              const OnStopOrFinishRecite(),
                            );
                      },
                      child: Image.asset(
                        "assets/vector/stop.png",
                        width: Func.getWidth(context, 24),
                        height: Func.getWidth(context, 24),
                      ),
                    ),
                  ],
                );
              } else if (state.processingState == ProcessingState.loading ||
                  state.processingState == ProcessingState.buffering) {
                return SizedBox(
                  width: Func.getWidth(context, 24),
                  height: Func.getWidth(context, 24),
                  child: const CircularProgressIndicator(
                    color: Color(0xFFDA8856),
                  ),
                );
              } else {
                return GestureDetector(
                  onTap: () {
                    // context.read<QuranBloc>().add(
                    //       OnStartRecite(quranData),
                    //     );
                  },
                  child: Image.asset(
                    "assets/vector/sound.png",
                    width: Func.getWidth(context, 24),
                    height: Func.getWidth(context, 24),
                  ),
                );
              }
              ;
            },
          ),
        ],
      ),
    );
  }
}
