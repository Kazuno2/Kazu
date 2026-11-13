class ChallengeModel {
  final String id;
  final String pillarId;
  final String title;
  final String instructions;
  final String completionCriteria;
  final String? reflectionPrompt;
  bool isCompleted;
  bool isActive;
  int attemptsUsed; // 0 to 3 max per session

  ChallengeModel({
    required this.id,
    required this.pillarId,
    required this.title,
    required this.instructions,
    required this.completionCriteria,
    this.reflectionPrompt,
    this.isCompleted = false,
    this.isActive = true,
    this.attemptsUsed = 0,
  });

  bool get canAttempt => attemptsUsed < 3 && !isCompleted;
}

