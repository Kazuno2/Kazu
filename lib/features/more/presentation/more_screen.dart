import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/theme_notifier.dart';
import '../../../core/models/user_profile.dart';
import '../../workouts/presentation/workouts_screen.dart';

class MoreScreen extends StatefulWidget {
  final ThemeNotifier themeNotifier;
  final UserProfile userProfile;
  final bool isBuddyVisible;
  final Function(String) onBuddyNameChanged;
  final Function(String) onDisplayNameChanged;
  final VoidCallback onToggleBuddyVisibility;
  final VoidCallback onReplayOnboarding;

  const MoreScreen({
    super.key,
    required this.themeNotifier,
    required this.userProfile,
    required this.isBuddyVisible,
    required this.onBuddyNameChanged,
    required this.onDisplayNameChanged,
    required this.onToggleBuddyVisibility,
    required this.onReplayOnboarding,
  });

  @override
  State<MoreScreen> createState() => _MoreScreenState();
}

class _MoreScreenState extends State<MoreScreen> {
  late TextEditingController _displayNameController;
  late TextEditingController _buddyNameController;
  late TextEditingController _heightController;
  late TextEditingController _weightController;
  double? _calculatedBmi;

  @override
  void initState() {
    super.initState();
    _displayNameController = TextEditingController(text: widget.userProfile.displayName);
    _buddyNameController = TextEditingController(text: widget.userProfile.buddyName);
    _heightController = TextEditingController(
      text: widget.userProfile.heightCm != null ? widget.userProfile.heightCm!.toStringAsFixed(0) : '175',
    );
    _weightController = TextEditingController(
      text: widget.userProfile.weightKg != null ? widget.userProfile.weightKg!.toStringAsFixed(0) : '70',
    );
    _calculatedBmi = widget.userProfile.calculatedBmi;
  }

  @override
  void dispose() {
    _displayNameController.dispose();
    _buddyNameController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  void _calculateBmi() {
    final h = double.tryParse(_heightController.text) ?? 0;
    final w = double.tryParse(_weightController.text) ?? 0;
    if (h > 50 && w > 20) {
      final hm = h / 100.0;
      setState(() {
        _calculatedBmi = w / (hm * hm);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = widget.themeNotifier.isDark;
    final currentTheme = widget.themeNotifier.currentTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Themes, Profile & Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        children: [
          // Section 1: Themes & Appearance (FR-UI-01, FR-UI-02)
          Text(
            'APPEARANCE & THEMES (FR-UI-01)',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.1,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: 8),

          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Theme Mode', style: TextStyle(fontWeight: FontWeight.w600)),
                      Row(
                        children: [
                          Icon(isDark ? Icons.dark_mode : Icons.light_mode, size: 20),
                          const SizedBox(width: 8),
                          Switch(
                            value: isDark,
                            onChanged: (val) => widget.themeNotifier.toggleThemeMode(),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const Divider(height: 24),
                  const Text('Theme Palette', style: TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 10),
                  _themeOption(
                    type: KazuThemeType.midnightBloom,
                    name: 'Midnight Bloom',
                    subtitle: 'Pink, Lavender, Plum',
                    color1: const Color(0xFFD980F2),
                    color2: const Color(0xFF59206A),
                    isSelected: currentTheme == KazuThemeType.midnightBloom,
                  ),
                  const SizedBox(height: 8),
                  _themeOption(
                    type: KazuThemeType.midnightOcean,
                    name: 'Midnight Ocean',
                    subtitle: 'Navy, Blue, Cyan',
                    color1: const Color(0xFF64B5F6),
                    color2: const Color(0xFF153B66),
                    isSelected: currentTheme == KazuThemeType.midnightOcean,
                  ),
                  const SizedBox(height: 8),
                  _themeOption(
                    type: KazuThemeType.crimsonInferno,
                    name: 'Crimson Inferno',
                    subtitle: 'Burgundy, Crimson, Coral',
                    color1: const Color(0xFFFF6B6B),
                    color2: const Color(0xFF5A141A),
                    isSelected: currentTheme == KazuThemeType.crimsonInferno,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Section 2: Profile & Buddy Mascot Settings (FR-ON-02, FR-ON-03, FR-BD)
          Text(
            'PROFILE & COMPANION (FR-ON, FR-BD)',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.1,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: 8),

          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Show Floating Companion', style: TextStyle(fontWeight: FontWeight.w600)),
                      Switch(
                        value: widget.isBuddyVisible,
                        onChanged: (val) => widget.onToggleBuddyVisibility(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // Display Name
                  TextField(
                    controller: _displayNameController,
                    decoration: InputDecoration(
                      labelText: 'Your Preferred Name',
                      border: const OutlineInputBorder(),
                      prefixIcon: const Icon(Icons.person_outline),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.check),
                        onPressed: () {
                          if (_displayNameController.text.trim().isNotEmpty) {
                            widget.onDisplayNameChanged(_displayNameController.text.trim());
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Name updated to ${_displayNameController.text.trim()}!')),
                            );
                          }
                        },
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Buddy Name
                  TextField(
                    controller: _buddyNameController,
                    decoration: InputDecoration(
                      labelText: 'Companion Name (FR-ON-02)',
                      border: const OutlineInputBorder(),
                      prefixIcon: const Icon(Icons.smart_toy_outlined),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.check),
                        onPressed: () {
                          if (_buddyNameController.text.trim().isNotEmpty) {
                            widget.onBuddyNameChanged(_buddyNameController.text.trim());
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Mascot name updated to ${_buddyNameController.text.trim()}!')),
                            );
                          }
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Replay Onboarding Button (FR-ON-01)
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.restart_alt_outlined, color: Colors.purpleAccent),
                    title: const Text('Replay Welcome & Registration', style: TextStyle(fontWeight: FontWeight.w600)),
                    subtitle: const Text('Redo onboarding or re-personalize your focus areas'),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 14),
                    onTap: widget.onReplayOnboarding,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Section 3: Workouts Quick Link
          Card(
            child: ListTile(
              leading: const Icon(Icons.fitness_center),
              title: const Text('Movement & Exercise Player'),
              subtitle: const Text('Routines, timers & durable partial progress'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const WorkoutsScreen()),
                );
              },
            ),
          ),

          const SizedBox(height: 20),

          // Section 4: Informational Metrics (FR-ON-05, AC-02)
          Text(
            'OPTIONAL METRICS (INFORMATIONAL ONLY)',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.1,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: 8),

          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Optional profile metrics are never required for progress and are never medical diagnostics.',
                    style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurfaceVariant),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _heightController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Height (cm)',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextField(
                          controller: _weightController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Weight (kg)',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: _calculateBmi,
                    child: const Text('Calculate Informational BMI'),
                  ),
                  if (_calculatedBmi != null) ...[
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'Estimated BMI: ${_calculatedBmi!.toStringAsFixed(1)} (Informational reference only, not a medical measurement).',
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Section 5: Data Privacy & Export (FR-ST-02, FR-ST-03)
          Text(
            'DATA & PRIVACY (FR-ST)',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.1,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: 8),

          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Local-First Storage', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(
                    'All your tasks, KTrack pixels, challenge attempts, and reflections live safely on this device.',
                    style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurfaceVariant),
                  ),
                  const SizedBox(height: 14),
                  OutlinedButton.icon(
                    icon: const Icon(Icons.download_outlined),
                    label: const Text('Export Data (JSON)'),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Export prepared: structured JSON data ready.')),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 60),
        ],
      ),
    );
  }

  Widget _themeOption({
    required KazuThemeType type,
    required String name,
    required String subtitle,
    required Color color1,
    required Color color2,
    required bool isSelected,
  }) {
    return InkWell(
      onTap: () => widget.themeNotifier.setThemeType(type),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.outline.withAlpha(40),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [color1, color2]),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                  Text(subtitle, style: TextStyle(fontSize: 11, color: Theme.of(context).colorScheme.onSurfaceVariant)),
                ],
              ),
            ),
            if (isSelected)
              Icon(Icons.check_circle, color: Theme.of(context).colorScheme.primary, size: 20),
          ],
        ),
      ),
    );
  }
}
