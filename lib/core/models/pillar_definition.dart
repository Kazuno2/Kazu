import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

enum TrackerState {
  none,     // No recorded qualifying progress (lighter shade)
  partial,  // Progress, not complete (base shade)
  complete, // Completion criteria met (intensified shade)
}

enum PillarType {
  tPillar, // KTrack daily tracker
  cPillar, // Jar of Challenges & CTracker
}

class TPillarModel {
  final String id;
  final String name;
  final String qualifyingExample;
  final String completionExample;
  final Color noneColor;
  final Color partialColor;
  final Color completeColor;

  const TPillarModel({
    required this.id,
    required this.name,
    required this.qualifyingExample,
    required this.completionExample,
    required this.noneColor,
    required this.partialColor,
    required this.completeColor,
  });

  Color getColor(TrackerState state) {
    switch (state) {
      case TrackerState.none:
        return noneColor;
      case TrackerState.partial:
        return partialColor;
      case TrackerState.complete:
        return completeColor;
    }
  }

  static const List<TPillarModel> all = [
    TPillarModel(
      id: 'T1',
      name: 'Self-Trust',
      qualifyingExample: 'Record or review a realistic promise to yourself.',
      completionExample: 'Meet the day\'s chosen promise or deliberately renegotiate it in line with the defined rule.',
      noneColor: AppPillarColors.t1None,
      partialColor: AppPillarColors.t1Partial,
      completeColor: AppPillarColors.t1Complete,
    ),
    TPillarModel(
      id: 'T2',
      name: 'Body, Health, and Strength',
      qualifyingExample: 'Record a personally chosen movement, recovery, or health-supporting action.',
      completionExample: 'Meet the day\'s selected health/strength target. (Separated from arbitrary workout completion).',
      noneColor: AppPillarColors.t2None,
      partialColor: AppPillarColors.t2Partial,
      completeColor: AppPillarColors.t2Complete,
    ),
    TPillarModel(
      id: 'T3',
      name: 'Anxiety and Emotional Regulation',
      qualifyingExample: 'Name an emotion and try a regulation or reflection practice.',
      completionExample: 'Complete the selected regulation practice or configured goal.',
      noneColor: AppPillarColors.t3None,
      partialColor: AppPillarColors.t3Partial,
      completeColor: AppPillarColors.t3Complete,
    ),
    TPillarModel(
      id: 'T4',
      name: 'Responsibility and Discipline',
      qualifyingExample: 'Make a meaningful start on a responsibility.',
      completionExample: 'Meet the day\'s chosen priority/commitment criterion.',
      noneColor: AppPillarColors.t4None,
      partialColor: AppPillarColors.t4Partial,
      completeColor: AppPillarColors.t4Complete,
    ),
    TPillarModel(
      id: 'T5',
      name: 'Confidence and Self-Advocacy',
      qualifyingExample: 'Practice a clear request, boundary, or self-advocating action.',
      completionExample: 'Complete the selected self-advocacy practice.',
      noneColor: AppPillarColors.t5None,
      partialColor: AppPillarColors.t5Partial,
      completeColor: AppPillarColors.t5Complete,
    ),
    TPillarModel(
      id: 'T6',
      name: 'Faith, Purpose, and Values',
      qualifyingExample: 'Record a values-aligned action or chosen reflection/practice.',
      completionExample: 'Complete the user\'s selected values/faith practice without dogmatic assumption.',
      noneColor: AppPillarColors.t6None,
      partialColor: AppPillarColors.t6Partial,
      completeColor: AppPillarColors.t6Complete,
    ),
  ];
}

class CPillarModel {
  final String id;
  final String name;
  final Color starColor;

  const CPillarModel({
    required this.id,
    required this.name,
    required this.starColor,
  });

  static const List<CPillarModel> all = [
    CPillarModel(
      id: 'C1',
      name: 'Decision-Making',
      starColor: AppPillarColors.c1Decision,
    ),
    CPillarModel(
      id: 'C2',
      name: 'Jealousy and Comparison',
      starColor: AppPillarColors.c2Jealousy,
    ),
    CPillarModel(
      id: 'C3',
      name: 'Making Peace with the Past',
      starColor: AppPillarColors.c3Past,
    ),
    CPillarModel(
      id: 'C4',
      name: 'Trusting People and Boundaries',
      starColor: AppPillarColors.c4Trust,
    ),
    CPillarModel(
      id: 'C5',
      name: 'Insecurity and Self-Acceptance',
      starColor: AppPillarColors.c5Insecurity,
    ),
    CPillarModel(
      id: 'C6',
      name: 'Emotional Independence',
      starColor: AppPillarColors.c6Independence,
    ),
  ];
}

