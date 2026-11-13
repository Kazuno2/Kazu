import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';
import '../core/theme/theme_notifier.dart';
import '../core/models/user_profile.dart';
import '../features/main_shell.dart';
import '../features/onboarding/presentation/onboarding_screen.dart';

class KazuApp extends StatefulWidget {
  const KazuApp({super.key});

  @override
  State<KazuApp> createState() => _KazuAppState();
}

class _KazuAppState extends State<KazuApp> {
  final ThemeNotifier _themeNotifier = ThemeNotifier();
  UserProfile _userProfile = UserProfile(
    displayName: 'Friend',
    buddyName: 'Buddy',
    isOnboardingComplete: false, // Launches directly into onboarding for first run!
  );

  @override
  void initState() {
    super.initState();
    _themeNotifier.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _themeNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kazu',
      debugShowCheckedModeBanner: false,
      theme: AppThemes.getTheme(
        themeType: _themeNotifier.currentTheme,
        isDark: false,
      ),
      darkTheme: AppThemes.getTheme(
        themeType: _themeNotifier.currentTheme,
        isDark: true,
      ),
      themeMode: _themeNotifier.themeMode,
      home: _userProfile.isOnboardingComplete
          ? MainShell(
              themeNotifier: _themeNotifier,
              userProfile: _userProfile,
              onProfileUpdated: (updated) {
                setState(() {
                  _userProfile = updated;
                });
              },
              onReplayOnboarding: () {
                setState(() {
                  _userProfile.isOnboardingComplete = false;
                });
              },
            )
          : OnboardingScreen(
              initialProfile: _userProfile,
              onComplete: (completedProfile) {
                setState(() {
                  _userProfile = completedProfile;
                });
              },
            ),
    );
  }
}
