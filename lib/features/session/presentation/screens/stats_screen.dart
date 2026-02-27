import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../bloc/session_bloc.dart';
import '../bloc/session_event.dart';
import '../bloc/session_state.dart';
import '../widgets/stats_summary.dart';
import '../widgets/weekly_chart.dart';
import '../widgets/session_history_list.dart';

class StatsScreen extends StatefulWidget {
  const StatsScreen({super.key});

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  @override
  void initState() {
    super.initState();
    // Load sessions as soon as the screen mounts
    context.read<SessionBloc>().add(const LoadSessionsEvent());
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
      isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: SafeArea(
        child: BlocBuilder<SessionBloc, SessionState>(
          builder: (context, state) {
            return CustomScrollView(
              slivers: [
                // ── Page title ─────────────────────────────────────────
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
                    child: Text(
                      'Stats',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: isDark
                            ? AppColors.darkTextPrimary
                            : AppColors.lightTextPrimary,
                      ),
                    ),
                  ),
                ),

                // ── Loaded state ────────────────────────────────────────
                if (state is SessionLoaded) ...[
                  // Summary cards
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
                      child: StatsSummary(state: state),
                    ),
                  ),

                  // Chart section
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Last 7 Days',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: isDark
                                  ? AppColors.darkTextPrimary
                                  : AppColors.lightTextPrimary,
                            ),
                          ),
                          const SizedBox(height: 12),
                          WeeklyChart(weeklySessions: state.weeklySessions),
                        ],
                      ),
                    ),
                  ),

                  // History section header
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(24, 28, 24, 0),
                      child: Text(
                        AppStrings.history,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: isDark
                              ? AppColors.darkTextPrimary
                              : AppColors.lightTextPrimary,
                        ),
                      ),
                    ),
                  ),

                  // History list
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(24, 12, 24, 40),
                      child:
                      SessionHistoryList(sessions: state.allSessions),
                    ),
                  ),
                ]

                // ── Loading state ───────────────────────────────────────
                else if (state is SessionLoading) ...[
                  const SliverFillRemaining(
                    child: Center(
                      child: CircularProgressIndicator(
                        color: AppColors.workColor,
                        strokeWidth: 2,
                      ),
                    ),
                  ),
                ]

                // ── Error state ─────────────────────────────────────────
                else if (state is SessionError) ...[
                    SliverFillRemaining(
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.error_outline,
                              color: AppColors.error,
                              size: 40,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Something went wrong.\nPlease try again.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: isDark
                                    ? AppColors.darkTextSecondary
                                    : AppColors.lightTextSecondary,
                              ),
                            ),
                            const SizedBox(height: 16),
                            TextButton(
                              onPressed: () => context
                                  .read<SessionBloc>()
                                  .add(const LoadSessionsEvent()),
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ]

                  // ── Initial / empty state ───────────────────────────────
                  else ...[
                      const SliverFillRemaining(
                        child: Center(
                          child: CircularProgressIndicator(
                            color: AppColors.workColor,
                            strokeWidth: 2,
                          ),
                        ),
                      ),
                    ],
              ],
            );
          },
        ),
      ),
    );
  }
}