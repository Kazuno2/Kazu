enum TaskPriority { low, medium, high, urgent }

class TaskModel {
  final String id;
  String title;
  String? details;
  TaskPriority priority;
  DateTime createdDate;
  DateTime originalDueDate;
  DateTime plannedDate;
  int? estimatedMinutes;
  bool isCompleted;
  int rolloverCount;
  int userRescheduleCount;

  TaskModel({
    required this.id,
    required this.title,
    this.details,
    this.priority = TaskPriority.medium,
    required this.createdDate,
    required this.originalDueDate,
    required this.plannedDate,
    this.estimatedMinutes,
    this.isCompleted = false,
    this.rolloverCount = 0,
    this.userRescheduleCount = 0,
  });

  bool get isOverdue {
    if (isCompleted) return false;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final due = DateTime(originalDueDate.year, originalDueDate.month, originalDueDate.day);
    return today.isAfter(due);
  }
}

