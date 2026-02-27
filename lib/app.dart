import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:focus_timer/core/di/injection.dart';
import 'package:focus_timer/theme/app_theme.dart';
import 'features/session/presentation/bloc/session_bloc.dart';
import 'features/session/presentation/screens/stats_screen.dart';
import 'features/settings/presentation/cubit/settings_cubit.dart';
import 'features/settings/presentation/cubit/settings_state.dart';
import 'features/settings/presentation/screens/settings_screen.dart';
import 'features/timer/presentation/bloc/timer_bloc.dart';
import 'features/timer/presentation/screens/timer_screen.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<SettingsCubit>(
          create: (_) => getIt<SettingsCubit>(),
        ),
        BlocProvider<SessionBloc>(
          create: (_) => getIt<SessionBloc>(),
        ),
        BlocProvider<TimerBloc>(
          create: (_) => getIt<TimerBloc>(),
        ),
      ],
      // BlocBuilder on SettingsCubit so the theme reacts to dark mode toggle
      child: BlocBuilder<SettingsCubit, SettingsState>(
        builder: (context, settingsState) {
          return MaterialApp(
            title: 'Focus Timer',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: settingsState.settings.isDarkMode
                ? ThemeMode.dark
                : ThemeMode.light,
            home: const MainShell(),
            routes: {
              '/settings': (ctx) => MultiBlocProvider(
                providers: [
                  // Pass existing blocs down to the settings route
                  BlocProvider.value(value: context.read<SettingsCubit>()),
                  BlocProvider.value(value: context.read<TimerBloc>()),
                ],
                child: const SettingsScreen(),
              ),
            },
          );
        },
      ),
    );
  }
}

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: const [
          TimerScreen(),
          StatsScreen(),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color:
              (isDark ? Colors.white : Colors.black).withOpacity(0.06),
            ),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (i) => setState(() => _currentIndex = i),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.timer_outlined),
              activeIcon: Icon(Icons.timer),
              label: 'Timer',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart_outlined),
              activeIcon: Icon(Icons.bar_chart),
              label: 'Stats',
            ),
          ],
        ),
      ),
    );
  }
}