import 'package:flutter/material.dart';
import '../../../core/models/pillar_definition.dart';

class KTrackScreen extends StatefulWidget {
  const KTrackScreen({super.key});

  @override
  State<KTrackScreen> createState() => _KTrackScreenState();
}

class _KTrackScreenState extends State<KTrackScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Track today's state for each T-Pillar
  final Map<String, TrackerState> _todayStates = {
    'T1': TrackerState.partial,
    'T2': TrackerState.none,
    'T3': TrackerState.complete,
    'T4': TrackerState.partial,
    'T5': TrackerState.none,
    'T6': TrackerState.none,
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _cyclePillarState(String id) {
    setState(() {
      final current = _todayStates[id] ?? TrackerState.none;
      switch (current) {
        case TrackerState.none:
          _todayStates[id] = TrackerState.partial;
          break;
        case TrackerState.partial:
          _todayStates[id] = TrackerState.complete;
          break;
        case TrackerState.complete:
          _todayStates[id] = TrackerState.none;
          break;
      }
    });
  }

  void _showPillarDetail(TPillarModel pillar) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(22),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: pillar.completeColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      pillar.id,
                      style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      pillar.name,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text(
                'QUALIFYING PROGRESS EXAMPLE',
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 1),
              ),
              const SizedBox(height: 4),
              Text(
                pillar.qualifyingExample,
                style: const TextStyle(fontSize: 13, height: 1.3),
              ),
              const SizedBox(height: 14),
              const Text(
                'COMPLETION CRITERION',
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 1),
              ),
              const SizedBox(height: 4),
              Text(
                pillar.completionExample,
                style: const TextStyle(fontSize: 13, height: 1.3),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        setState(() => _todayStates[pillar.id] = TrackerState.partial);
                        Navigator.pop(context);
                      },
                      child: const Text('Log Progress (Base)'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: pillar.completeColor),
                      onPressed: () {
                        setState(() => _todayStates[pillar.id] = TrackerState.complete);
                        Navigator.pop(context);
                      },
                      child: const Text('Mark Complete', style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('KTrack Daily Tracker'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Today\'s 6 Pillars'),
            Tab(text: 'Derived Pixel Calendar'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Tab 1: Today's Pillars
          ListView(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
            children: [
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: theme.colorScheme.outline.withAlpha(50)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.touch_app_outlined, size: 20),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Tap any pillar to cycle state: None → Partial → Complete. Honest records only.',
                        style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurfaceVariant),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              ...TPillarModel.all.map((pillar) {
                final state = _todayStates[pillar.id] ?? TrackerState.none;
                final currentColor = pillar.getColor(state);

                String stateLabel;
                switch (state) {
                  case TrackerState.none:
                    stateLabel = 'No qualifying progress';
                    break;
                  case TrackerState.partial:
                    stateLabel = 'Progress recorded';
                    break;
                  case TrackerState.complete:
                    stateLabel = 'Completion criteria met';
                    break;
                }

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: InkWell(
                    onTap: () => _cyclePillarState(pillar.id),
                    onLongPress: () => _showPillarDetail(pillar),
                    borderRadius: BorderRadius.circular(16),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          // 3-shade color indicator
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: currentColor,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: currentColor.withAlpha(100),
                                  blurRadius: 8,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Text(
                                pillar.id,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  pillar.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 15,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Container(
                                      width: 8,
                                      height: 8,
                                      decoration: BoxDecoration(
                                        color: currentColor,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      stateLabel,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: theme.colorScheme.onSurfaceVariant,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.info_outline, size: 20),
                            onPressed: () => _showPillarDetail(pillar),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ],
          ),

          // Tab 2: Derived Pixel Calendar
          ListView(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
            children: [
              Text(
                'DERIVED PIXELS (AC-08, AC-09)',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.1,
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Pixels are strictly derived views of saved records. Past days show honest lighter shades; future days remain neutral.',
                style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurfaceVariant),
              ),
              const SizedBox(height: 16),

              // Calendar Grid (last 21 days + 7 future days)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'October 2026 • T1 Self-Trust',
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
                          } else if (dayNum % 3 == 0) {
                            pixelColor = TPillarModel.all[0].completeColor;
                          } else if (dayNum % 2 == 0) {
                            pixelColor = TPillarModel.all[0].partialColor;
                          } else {
                            pixelColor = TPillarModel.all[0].noneColor.withAlpha(160);
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
                                  color: isFuture
                                      ? theme.colorScheme.onSurfaceVariant.withAlpha(80)
                                      : Colors.white,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 14),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _legendItem(TPillarModel.all[0].noneColor, 'No progress'),
                          _legendItem(TPillarModel.all[0].partialColor, 'Partial'),
                          _legendItem(TPillarModel.all[0].completeColor, 'Complete'),
                          _legendItem(theme.colorScheme.surface.withAlpha(60), 'Future'),
                        ],
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

  Widget _legendItem(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(2)),
        ),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 11)),
      ],
    );
  }
}
