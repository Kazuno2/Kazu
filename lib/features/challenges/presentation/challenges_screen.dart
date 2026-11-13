import 'dart:math';
import 'package:flutter/material.dart';
import '../../../core/models/pillar_definition.dart';
import '../../../core/models/challenge_model.dart';

class ChallengesScreen extends StatefulWidget {
  const ChallengesScreen({super.key});

  @override
  State<ChallengesScreen> createState() => _ChallengesScreenState();
}

class _ChallengesScreenState extends State<ChallengesScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<ChallengeModel> _challenges = [
    ChallengeModel(
      id: 'ch-1',
      pillarId: 'C1',
      title: 'The 2-Minute Decision',
      instructions: 'Choose one small decision you have delayed (e.g. what book to read, meal choice, replying to an email). Make the decision within 2 minutes and commit without second-guessing.',
      completionCriteria: 'Decision is made within 2 minutes and acted upon without seeking external reassurance.',
      reflectionPrompt: 'How did it feel in your body to finalize the choice quickly?',
    ),
    ChallengeModel(
      id: 'ch-2',
      pillarId: 'C4',
      title: 'Gentle Boundary Practice',
      instructions: 'Deliver a clear, polite "no" or request space without apologizing for having a limit.',
      completionCriteria: 'A real-world boundary was clearly expressed without over-explaining.',
      reflectionPrompt: 'Did you notice any urge to apologize for setting a limit?',
    ),
    ChallengeModel(
      id: 'ch-3',
      pillarId: 'C6',
      title: 'Solo Coffee & Observation',
      instructions: 'Spend 20 minutes alone at a cafe or park bench without looking at your phone.',
      completionCriteria: '20 minutes spent in personal presence without digital distraction.',
    ),
    ChallengeModel(
      id: 'ch-4',
      pillarId: 'C2',
      title: 'Celebrate Someone Silently',
      instructions: 'When comparison arises, deliberately wish that person genuine success.',
      completionCriteria: 'Replaced a comparison thought with a generous intention at least once today.',
    ),
  ];

  ChallengeModel? _selectedChallenge;
  bool _isAttemptInProgress = false;
  int _sessionAttemptCount = 0; // max 3 per session

  void _shuffleAndDraw() {
    final active = _challenges.where((c) => c.isActive && !c.isCompleted).toList();
    if (active.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('All challenges completed! You can restore them anytime.')),
      );
      return;
    }
    final drawn = active[Random().nextInt(active.length)];
    setState(() {
      _selectedChallenge = drawn;
    });
  }

  void _startAttempt() {
    if (_sessionAttemptCount >= 3) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Session Limit (FR-CH-05)'),
          content: const Text(
            'You have used all 3 started attempts for this session. The challenge remains available '
            'in a fresh session whenever you are ready.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                setState(() {
                  _sessionAttemptCount = 0; // Fresh session
                });
              },
              child: const Text('Start Fresh Session'),
            ),
          ],
        ),
      );
      return;
    }

    setState(() {
      _sessionAttemptCount++;
      _isAttemptInProgress = true;
    });
  }

  void _concludeAttempt(bool success) {
    setState(() {
      _isAttemptInProgress = false;
      if (success && _selectedChallenge != null) {
        _selectedChallenge!.isCompleted = true;
        _selectedChallenge!.isActive = false;
      }
    });

    if (success) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Challenge Completed! ⭐'),
          content: const Text(
            'Completion event saved to history and CTracker. The challenge has left the active pool '
            'and can be restored at any time.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Wonderful'),
            ),
          ],
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _selectedChallenge = _challenges.first;
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Jar of Challenges & CTracker'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Origami Star Jar'),
            Tab(text: 'CTracker Pixels'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Tab 1: Jar of Challenges
          ListView(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
            children: [
              // Origami Star Jar Visual
              Center(
                child: Container(
                  width: 140,
                  height: 150,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHighest,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(20),
                      bottom: Radius.circular(40),
                    ),
                    border: Border.all(
                      color: theme.colorScheme.primary.withAlpha(120),
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: theme.colorScheme.primary.withAlpha(40),
                        blurRadius: 18,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Cork lid
                      Positioned(
                        top: 0,
                        child: Container(
                          width: 80,
                          height: 14,
                          decoration: BoxDecoration(
                            color: const Color(0xFFC49A6C),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                      // Colored origami stars inside jar
                      Positioned(
                        top: 35,
                        left: 28,
                        child: _origamiStar(CPillarModel.all[0].starColor, 24),
                      ),
                      Positioned(
                        top: 48,
                        right: 30,
                        child: _origamiStar(CPillarModel.all[1].starColor, 22),
                      ),
                      Positioned(
                        top: 75,
                        left: 45,
                        child: _origamiStar(CPillarModel.all[3].starColor, 26),
                      ),
                      Positioned(
                        bottom: 20,
                        left: 30,
                        child: _origamiStar(CPillarModel.all[5].starColor, 24),
                      ),
                      Positioned(
                        bottom: 25,
                        right: 32,
                        child: _origamiStar(CPillarModel.all[2].starColor, 20),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              Center(
                child: OutlinedButton.icon(
                  onPressed: _shuffleAndDraw,
                  icon: const Icon(Icons.shuffle),
                  label: const Text('Shuffle & Draw Star (No Attempt Consumed)'),
                ),
              ),

              const SizedBox(height: 18),

              // Selected Challenge Card
              if (_selectedChallenge != null) ...[
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: _getPillarColor(_selectedChallenge!.pillarId),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                _selectedChallenge!.pillarId,
                                style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 11),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              _getPillarName(_selectedChallenge!.pillarId),
                              style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurfaceVariant),
                            ),
                            const Spacer(),
                            Text(
                              'Attempt $_sessionAttemptCount of 3',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: _sessionAttemptCount >= 3 ? Colors.red : theme.colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          _selectedChallenge!.title,
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _selectedChallenge!.instructions,
                          style: const TextStyle(fontSize: 13, height: 1.4),
                        ),
                        const SizedBox(height: 14),
                        const Text(
                          'COMPLETION CRITERIA (Visible Before Start)',
                          style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 0.8),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _selectedChallenge!.completionCriteria,
                          style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurfaceVariant),
                        ),
                        const SizedBox(height: 18),

                        if (!_isAttemptInProgress) ...[
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: _startAttempt,
                              icon: const Icon(Icons.play_arrow),
                              label: const Text('Start Attempt (Consumes 1 Attempt)'),
                            ),
                          ),
                        ] else ...[
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.green.withAlpha(30),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Row(
                              children: [
                                Icon(Icons.timer_outlined, color: Colors.green),
                                SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    'Attempt in progress. You can pause or step away—it survives app restart.',
                                    style: TextStyle(fontSize: 12),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: () => _concludeAttempt(false),
                                  child: const Text('Not Yet Completed'),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                                  onPressed: () => _concludeAttempt(true),
                                  child: const Text('Complete!', style: TextStyle(color: Colors.white)),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),

          // Tab 2: CTracker Pixels
          ListView(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
            children: [
              Text(
                'CTRACKER DAILY PIXELS (AC-17)',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.1,
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Each pixel reflects challenge completion history. The earliest completed challenge by time sets the date\'s star color.',
                style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurfaceVariant),
              ),
              const SizedBox(height: 16),

              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Challenge Completions • October 2026',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                      const SizedBox(height: 12),
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: 28,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 7,
                          crossAxisSpacing: 6,
                          mainAxisSpacing: 6,
                        ),
                        itemBuilder: (context, idx) {
                          final dayNum = idx + 1;
                          final isToday = dayNum == 24;
                          final isFuture = dayNum > 24;

                          Color pixelColor;
                          if (isFuture) {
                            pixelColor = theme.colorScheme.surface.withAlpha(60);
                          } else if (dayNum == 20 || dayNum == 22 || dayNum == 24) {
                            pixelColor = CPillarModel.all[(dayNum % 6)].starColor;
                          } else {
                            pixelColor = theme.colorScheme.surfaceContainerHighest;
                          }

                          return Container(
                            decoration: BoxDecoration(
                              color: pixelColor,
                              borderRadius: BorderRadius.circular(6),
                              border: isToday
                                  ? Border.all(color: theme.colorScheme.primary, width: 2)
                                  : null,
                            ),
                            child: Center(
                              child: Text(
                                '$dayNum',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  color: (dayNum == 20 || dayNum == 22 || dayNum == 24)
                                      ? Colors.white
                                      : theme.colorScheme.onSurfaceVariant.withAlpha(120),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _origamiStar(Color color, double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: color.withAlpha(120),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: const Center(
        child: Text('✦', style: TextStyle(color: Colors.white, fontSize: 12)),
      ),
    );
  }

  Color _getPillarColor(String id) {
    return CPillarModel.all.firstWhere((p) => p.id == id, orElse: () => CPillarModel.all.first).starColor;
  }

  String _getPillarName(String id) {
    return CPillarModel.all.firstWhere((p) => p.id == id, orElse: () => CPillarModel.all.first).name;
  }
}

