import 'package:flutter/material.dart';
import '../core/theme/theme_notifier.dart';
import '../core/models/user_profile.dart';
import 'home/presentation/home_screen.dart';
import 'planning/presentation/tasks_screen.dart';
import 'ktrack/presentation/ktrack_screen.dart';
import 'challenges/presentation/challenges_screen.dart';
import 'more/presentation/more_screen.dart';
import 'buddy/presentation/buddy_mascot.dart';

class MainShell extends StatefulWidget {
  final ThemeNotifier themeNotifier;
  final UserProfile userProfile;
  final Function(UserProfile) onProfileUpdated;
  final VoidCallback onReplayOnboarding;

  const MainShell({
    super.key,
    required this.themeNotifier,
    required this.userProfile,
    required this.onProfileUpdated,
    required this.onReplayOnboarding,
  });

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;
  bool _isBuddyVisible = true;

  void _onNavigateTab(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      HomeScreen(
        onNavigateTab: _onNavigateTab,
        buddyName: widget.userProfile.buddyName,
      ),
      const TasksScreen(),
      const KTrackScreen(),
      const ChallengesScreen(),
      MoreScreen(
        themeNotifier: widget.themeNotifier,
        userProfile: widget.userProfile,
        isBuddyVisible: _isBuddyVisible,
        onDisplayNameChanged: (newName) {
          setState(() {
            widget.userProfile.displayName = newName;
          });
          widget.onProfileUpdated(widget.userProfile);
        },
        onBuddyNameChanged: (newName) {
          setState(() {
            widget.userProfile.buddyName = newName;
          });
          widget.onProfileUpdated(widget.userProfile);
        },
        onToggleBuddyVisibility: () {
          setState(() {
            _isBuddyVisible = !_isBuddyVisible;
          });
        },
        onReplayOnboarding: widget.onReplayOnboarding,
      ),
    ];

    return Scaffold(
      body: Stack(
        children: [
          // Current selected screen
          IndexedStack(
            index: _currentIndex,
            children: screens,
          ),

          // Floating interactive Buddy mascot (FR-BD-01, FR-BD-02, FR-BD-08)
          BuddyMascot(
            buddyName: widget.userProfile.buddyName,
            isVisible: _isBuddyVisible,
            onToggleVisibility: () {
              setState(() {
                _isBuddyVisible = false;
              });
            },
          ),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: _onNavigateTab,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.calendar_today_outlined),
            selectedIcon: Icon(Icons.calendar_today),
            label: 'Plan',
          ),
          NavigationDestination(
            icon: Icon(Icons.grid_view_outlined),
            selectedIcon: Icon(Icons.grid_view_rounded),
            label: 'KTrack',
          ),
          NavigationDestination(
            icon: Icon(Icons.star_outline_rounded),
            selectedIcon: Icon(Icons.star_rounded),
            label: 'Challenges',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings),
            label: 'More',
          ),
        ],
      ),
    );
  }
}
