import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../bloc/timer_bloc.dart';
import '../bloc/timer_event.dart';
import '../bloc/timer_state.dart';

class TimerControls extends StatelessWidget {
  final TimerState state;
  const TimerControls({super.key, required this.state});

  Color get _sessionColor {
    switch (state.sessionType) {
      case SessionType.work:
        return AppColors.workColor;
      case SessionType.shortBreak:
        return AppColors.shortBreakColor;
      case SessionType.longBreak:
        return AppColors.longBreakColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<TimerBloc>();

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _CircleIconButton(
          icon: Icons.replay_rounded,
          onTap: () => bloc.add(const TimerReset()),
          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4),
        ),
        const SizedBox(width: 24),
        _PlayPauseButton(
          state: state,
          color: _sessionColor,
          onTap: () {
            if (state is TimerInitial || state is TimerComplete) {
              bloc.add(TimerStarted(state.remainingSeconds));
            } else if (state is TimerRunning) {
              bloc.add(const TimerPaused());
            } else if (state is TimerPausedState) {
              bloc.add(const TimerResumed());
            }
          },
        ),
        const SizedBox(width: 24),
        _CircleIconButton(
          icon: Icons.skip_next_rounded,
          onTap: () => bloc.add(const TimerSkipped()),
          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4),
        ),
      ],
    );
  }
}

class _PlayPauseButton extends StatelessWidget {
  final TimerState state;
  final Color color;
  final VoidCallback onTap;

  const _PlayPauseButton({
    required this.state,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.4),
              blurRadius: 24,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Icon(
          state is TimerRunning
              ? Icons.pause_rounded
              : Icons.play_arrow_rounded,
          color: Colors.white,
          size: 36,
        ),
      ),
    );
  }
}

class _CircleIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final Color color;

  const _CircleIconButton({
    required this.icon,
    required this.onTap,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color.withOpacity(0.1),
        ),
        child: Icon(icon, color: color, size: 22),
      ),
    );
  }
}