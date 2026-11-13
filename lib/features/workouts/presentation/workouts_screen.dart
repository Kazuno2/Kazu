import 'dart:async';
import 'package:flutter/material.dart';
import '../../../core/models/workout_model.dart';

class WorkoutsScreen extends StatefulWidget {
  const WorkoutsScreen({super.key});

  @override
  State<WorkoutsScreen> createState() => _WorkoutsScreenState();
}

class _WorkoutsScreenState extends State<WorkoutsScreen> {
  final List<WorkoutRoutineModel> _routines = [
    const WorkoutRoutineModel(
      id: 'routine-1',
      title: 'Morning Mobility & Posture',
      description: 'Gentle spine, shoulder and hip mobility to awaken the body without strain.',
      exercises: [
        ExerciseModel(id: 'ex-1', name: 'Cat-Cow Breathing', instructions: 'Inhale arch back, exhale round gently.', targetSeconds: 30),
        ExerciseModel(id: 'ex-2', name: 'Shoulder Rolls & Openers', instructions: 'Smooth circular movements back and down.', targetSeconds: 30),
        ExerciseModel(id: 'ex-3', name: 'Deep Squat Hold / Pry', instructions: 'Hold comfortable squat depth.', targetSeconds: 30),
      ],
    ),
    const WorkoutRoutineModel(
      id: 'routine-2',
      title: 'Strength Primer (Core & Stability)',
      description: 'Focused bodyweight strength. Work within personal honest capacity.',
      exercises: [
        ExerciseModel(id: 'ex-4', name: 'Controlled Pushups', instructions: 'Slow descent, push firmly through palms.', targetSeconds: 40, targetReps: 10),
        ExerciseModel(id: 'ex-5', name: 'Dead Bug Core Bracing', instructions: 'Keep lower back glued to floor.', targetSeconds: 45),
        ExerciseModel(id: 'ex-6', name: 'Reverse Lunges', instructions: 'Controlled steps back with upright torso.', targetSeconds: 45),
      ],
    ),
  ];

  WorkoutRoutineModel? _activeRoutine;
  int _currentExerciseIndex = 0;
  int _secondsRemaining = 0;
  bool _isPlaying = false;
  Timer? _timer;
  int _completedExercisesCount = 0;

  void _startWorkout(WorkoutRoutineModel routine) {
    setState(() {
      _activeRoutine = routine;
      _currentExerciseIndex = 0;
      _completedExercisesCount = 0;
      _secondsRemaining = routine.exercises.first.targetSeconds;
      _isPlaying = true;
    });
    _runTimer();
  }

  void _runTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!_isPlaying) return;
      if (_secondsRemaining > 0) {
        setState(() {
          _secondsRemaining--;
        });
      } else {
        _nextExercise();
      }
    });
  }

  void _togglePlayPause() {
    setState(() {
      _isPlaying = !_isPlaying;
    });
  }

  void _nextExercise() {
    if (_activeRoutine == null) return;
    setState(() {
      _completedExercisesCount++;
      if (_currentExerciseIndex < _activeRoutine!.exercises.length - 1) {
        _currentExerciseIndex++;
        _secondsRemaining = _activeRoutine!.exercises[_currentExerciseIndex].targetSeconds;
      } else {
        _finishWorkout(isFullCompletion: true);
      }
    });
  }

  void _stopWorkoutEarly() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Preserve Partial Progress (FR-EX-07)'),
        content: Text(
          'Stopping early saves $_completedExercisesCount completed exercises to history. '
          'Stopping when your body signals it is wise—never a failure or penalty.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Resume Routine'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _finishWorkout(isFullCompletion: false);
            },
            child: const Text('Save & Stop'),
          ),
        ],
      ),
    );
  }

  void _finishWorkout({required bool isFullCompletion}) {
    _timer?.cancel();
    final routineTitle = _activeRoutine?.title ?? 'Routine';
    setState(() {
      _activeRoutine = null;
      _isPlaying = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isFullCompletion
              ? '🎉 $routineTitle completed! Evidence saved for T2.'
              : '💾 Partial progress saved ($_completedExercisesCount exercises). Recorded honestly!',
        ),
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (_activeRoutine != null) {
      final currentExercise = _activeRoutine!.exercises[_currentExerciseIndex];

      return Scaffold(
        appBar: AppBar(
          title: Text(_activeRoutine!.title),
          actions: [
            TextButton.icon(
              icon: const Icon(Icons.stop_circle_outlined, color: Colors.red),
              label: const Text('Stop Early', style: TextStyle(color: Colors.red)),
              onPressed: _stopWorkoutEarly,
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Exercise ${_currentExerciseIndex + 1} of ${_activeRoutine!.exercises.length}',
                style: TextStyle(fontSize: 13, color: theme.colorScheme.onSurfaceVariant),
              ),
              const SizedBox(height: 8),
              Text(
                currentExercise.name,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                currentExercise.instructions,
                style: TextStyle(fontSize: 14, color: theme.colorScheme.onSurfaceVariant),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),

              // Countdown circle
              Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: theme.colorScheme.surfaceContainerHighest,
                  border: Border.all(color: theme.colorScheme.primary, width: 4),
                ),
                child: Center(
                  child: Text(
                    '$_secondsRemaining',
                    style: TextStyle(
                      fontSize: 44,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 36),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton.filledTonal(
                    iconSize: 36,
                    icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
                    onPressed: _togglePlayPause,
                  ),
                  const SizedBox(width: 24),
                  IconButton.filled(
                    iconSize: 36,
                    icon: const Icon(Icons.skip_next),
                    onPressed: _nextExercise,
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Movement & Workouts'),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        children: [
          // T2 Evidence Note (FR-EX-09, AC-20)
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFE07A5F).withAlpha(30),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE07A5F).withAlpha(100)),
            ),
            child: const Row(
              children: [
                Icon(Icons.info_outline, color: Color(0xFFE07A5F)),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Workout evidence contributes to T2 Body, Health & Strength, but T2 is marked complete '
                    'only when your configured criteria are met. No arbitrary workout blindly marks the whole day complete.',
                    style: TextStyle(fontSize: 12, height: 1.35),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 18),

          Text(
            'SAVED ROUTINES',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.1,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: 8),

          ..._routines.map((routine) {
            final totalTimeSeconds = routine.exercises.fold(0, (sum, e) => sum + e.targetSeconds);
            final minutes = (totalTimeSeconds / 60).ceil();

            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          routine.title,
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '~$minutes min',
                          style: TextStyle(fontSize: 12, color: theme.colorScheme.primary, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      routine.description,
                      style: TextStyle(fontSize: 13, color: theme.colorScheme.onSurfaceVariant),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '${routine.exercises.length} Exercises: ${routine.exercises.map((e) => e.name).join(", ")}',
                      style: TextStyle(fontSize: 11, color: theme.colorScheme.onSurfaceVariant.withAlpha(180)),
                    ),
                    const SizedBox(height: 14),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.play_arrow),
                        label: const Text('Start Routine'),
                        onPressed: () => _startWorkout(routine),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}

