import 'package:flutter/material.dart';
import '../../../core/models/user_profile.dart';
import '../../../core/models/pillar_definition.dart';

class OnboardingScreen extends StatefulWidget {
  final UserProfile initialProfile;
  final Function(UserProfile) onComplete;

  const OnboardingScreen({
    super.key,
    required this.initialProfile,
    required this.onComplete,
  });

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  late TextEditingController _nameController;
  late TextEditingController _buddyNameController;
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();

  final List<String> _selectedPillars = [];
  String? _selectedBodyFat;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(
      text: widget.initialProfile.displayName == 'Friend' ? '' : widget.initialProfile.displayName,
    );
    _buddyNameController = TextEditingController(text: widget.initialProfile.buddyName);
    _selectedPillars.addAll(widget.initialProfile.focusPillarIds);
  }

  @override
  void dispose() {
    _pageController.dispose();
    _nameController.dispose();
    _buddyNameController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < 4) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    } else {
      _finishOnboarding();
    }
  }

  void _finishOnboarding() {
    final h = double.tryParse(_heightController.text.trim());
    final w = double.tryParse(_weightController.text.trim());

    final profile = UserProfile(
      displayName: _nameController.text.trim().isEmpty ? 'Friend' : _nameController.text.trim(),
      buddyName: _buddyNameController.text.trim().isEmpty ? 'Buddy' : _buddyNameController.text.trim(),
      focusPillarIds: _selectedPillars,
      heightCm: h,
      weightKg: w,
      bodyFatSelfEstimate: _selectedBodyFat,
      isOnboardingComplete: true,
    );

    widget.onComplete(profile);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('KAZU', style: TextStyle(fontWeight: FontWeight.w800, letterSpacing: 1.2)),
        actions: [
          // FR-ON-01 / AC-01: Skippable at any point
          TextButton(
            onPressed: _finishOnboarding,
            child: const Text('Skip All'),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Step progress indicators
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: Row(
                children: List.generate(5, (index) {
                  final isDone = index <= _currentPage;
                  return Expanded(
                    child: Container(
                      height: 4,
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      decoration: BoxDecoration(
                        color: isDone
                            ? theme.colorScheme.primary
                            : theme.colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  );
                }),
              ),
            ),

            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (page) => setState(() => _currentPage = page),
                children: [
                  _buildWelcomePage(theme),
                  _buildNamesPage(theme),
                  _buildFocusAreasPage(theme),
                  _buildHealthMetricsPage(theme),
                  _buildRevealPage(theme),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Page 0: Welcome & Philosophy
  Widget _buildWelcomePage(ThemeData theme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 16),

          // Glowing Mascot Avatar
          Container(
            width: 110,
            height: 110,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(36),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFFF5288).withAlpha(160),
                  blurRadius: 28,
                  spreadRadius: 4,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(36),
              child: Image.asset(
                'assets/images/buddy.png',
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => const Icon(Icons.smart_toy, size: 60),
              ),
            ),
          ),

          const SizedBox(height: 24),
          const Text(
            'Meet Buddy & Kazu',
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Personal Growth with Zero Guilt',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: 18),

          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: theme.colorScheme.outline.withAlpha(50)),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '💡 Our Core Philosophy',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                SizedBox(height: 8),
                Text(
                  '• Action over accumulation: One small step beats endless planning.\n'
                  '• Honest progress: Partial effort and rest are recorded as valid.\n'
                  '• Recovery without guilt: A missed day never erases past achievements.',
                  style: TextStyle(fontSize: 13, height: 1.45),
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _nextPage,
              child: const Text('Get Started'),
            ),
          ),
        ],
      ),
    );
  }

  // Page 1: Personalize Names
  Widget _buildNamesPage(ThemeData theme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Personalize Your Space',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          Text(
            'How should we address you and your companion?',
            style: TextStyle(fontSize: 14, color: theme.colorScheme.onSurfaceVariant),
          ),
          const SizedBox(height: 24),

          TextField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Your Preferred Name',
              hintText: 'e.g., Kazuno',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.person_outline),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Optional. Leave blank to be called "Friend".',
            style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurfaceVariant),
          ),

          const SizedBox(height: 24),

          TextField(
            controller: _buddyNameController,
            decoration: const InputDecoration(
              labelText: 'Companion Name (FR-ON-02)',
              hintText: 'Defaults to Buddy',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.smart_toy_outlined),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'You can rename your mascot anytime in settings.',
            style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurfaceVariant),
          ),

          const SizedBox(height: 36),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: _nextPage,
                  child: const Text('Skip'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: _nextPage,
                  child: const Text('Next'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Page 2: Growth Pillars (Optional)
  Widget _buildFocusAreasPage(ThemeData theme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Your Growth Focus',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          Text(
            'Which pillars would you like to nurture first? (Optional)',
            style: TextStyle(fontSize: 14, color: theme.colorScheme.onSurfaceVariant),
          ),
          const SizedBox(height: 18),

          ...TPillarModel.all.map((pillar) {
            final isSelected = _selectedPillars.contains(pillar.id);
            return Card(
              margin: const EdgeInsets.only(bottom: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(
                  color: isSelected ? pillar.partialColor : Colors.transparent,
                  width: 1.5,
                ),
              ),
              child: CheckboxListTile(
                value: isSelected,
                activeColor: pillar.partialColor,
                title: Text(
                  '${pillar.id} • ${pillar.name}',
                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                ),
                subtitle: Text(
                  pillar.qualifyingExample,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurfaceVariant),
                ),
                onChanged: (val) {
                  setState(() {
                    if (val == true) {
                      _selectedPillars.add(pillar.id);
                    } else {
                      _selectedPillars.remove(pillar.id);
                    }
                  });
                },
              ),
            );
          }),

          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: _nextPage,
                  child: const Text('Skip this question'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: _nextPage,
                  child: const Text('Next'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Page 3: Optional Health Metrics (FR-ON-05, FR-ON-06)
  Widget _buildHealthMetricsPage(ThemeData theme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Body & Physical Vitality',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          Text(
            'Completely optional. Kazu never shares your private data.',
            style: TextStyle(fontSize: 14, color: theme.colorScheme.onSurfaceVariant),
          ),
          const SizedBox(height: 16),

          // Informational disclaimer banner
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue.withAlpha(25),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.blue.withAlpha(80)),
            ),
            child: const Row(
              children: [
                Icon(Icons.shield_outlined, color: Colors.blue, size: 20),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Informational only. Never a medical or diagnostic measurement (FR-ON-05, FR-ON-10).',
                    style: TextStyle(fontSize: 12, height: 1.3),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 18),

          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _heightController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Height (cm)',
                    hintText: 'e.g., 175',
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
                    hintText: 'e.g., 70',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),
          const Text(
            'Rough Body-Fat Self-Estimate (FR-ON-06)',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          ),
          const SizedBox(height: 4),
          Text(
            'A visual estimate only. Never required for progress.',
            style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurfaceVariant),
          ),
          const SizedBox(height: 10),

          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: ['Athletic / Lean', 'Moderate', 'Full / Soft', 'Prefer not to say'].map((label) {
              final isSelected = _selectedBodyFat == label;
              return ChoiceChip(
                label: Text(label),
                selected: isSelected,
                onSelected: (val) {
                  setState(() => _selectedBodyFat = val ? label : null);
                },
              );
            }).toList(),
          ),

          const SizedBox(height: 28),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: _nextPage,
                  child: const Text('Skip this step'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: _nextPage,
                  child: const Text('Next'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Page 4: Profile Reveal & Launch (FR-ON-08)
  Widget _buildRevealPage(ThemeData theme) {
    final name = _nameController.text.trim().isEmpty ? 'Friend' : _nameController.text.trim();
    final buddy = _buddyNameController.text.trim().isEmpty ? 'Buddy' : _buddyNameController.text.trim();

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 12),
          const Text(
            'You\'re All Set!',
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          Text(
            'Here is your personal starting foundation',
            style: TextStyle(fontSize: 14, color: theme.colorScheme.onSurfaceVariant),
          ),
          const SizedBox(height: 20),

          // Reveal Card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  theme.colorScheme.primaryContainer,
                  theme.colorScheme.surfaceContainerHighest,
                ],
              ),
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: theme.colorScheme.primary.withAlpha(100), width: 1.5),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: 58,
                      height: 58,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFFF5288).withAlpha(120),
                            blurRadius: 12,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.asset(
                          'assets/images/buddy.png',
                          fit: BoxFit.cover,
                          errorBuilder: (_, _, _) => const Icon(Icons.smart_toy),
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name,
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Guided by $buddy',
                            style: TextStyle(
                              fontSize: 13,
                              color: theme.colorScheme.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const Divider(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Focus Pillars:', style: TextStyle(fontWeight: FontWeight.w600)),
                    Text(
                      _selectedPillars.isEmpty ? 'All 12 Pillars' : '${_selectedPillars.length} Selected',
                      style: TextStyle(color: theme.colorScheme.onSurfaceVariant),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Data Storage:', style: TextStyle(fontWeight: FontWeight.w600)),
                    Text('Device-Local (Private)', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 28),

          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                const Icon(Icons.favorite_outline, color: Colors.pinkAccent),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    '"One honest step at a time. I am right here with you." — $buddy',
                    style: const TextStyle(fontSize: 13, fontStyle: FontStyle.italic),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 36),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _finishOnboarding,
              icon: const Icon(Icons.rocket_launch_outlined),
              label: const Text('Enter Kazu'),
            ),
          ),
        ],
      ),
    );
  }
}

