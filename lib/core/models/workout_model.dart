enum WorkoutSessionState { notStarted, inProgress, partial, completed, stopped }

class ExerciseModel {
  final String id;
  final String name;
  final String instructions;
  final int targetSeconds;
  final int? targetReps;
  final int restSeconds;

  const ExerciseModel({
    required this.id,
    required this.name,
    required this.instructions,
    this.targetSeconds = 30,
    this.targetReps,
    this.restSeconds = 15,
  });
}

class WorkoutRoutineModel {
  final String id;
  final String title;
  final String description;
  final List<ExerciseModel> exercises;

  const WorkoutRoutineModel({
    required this.id,
    required this.title,
    required this.description,
    required this.exercises,
  });
}

