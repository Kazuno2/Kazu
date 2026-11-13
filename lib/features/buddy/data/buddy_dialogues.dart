import 'dart:math';

class BuddyDialogues {
  static final Random _random = Random();

  static const List<String> greetings = [
    "Hey! One step at a time today.",
    "Ready whenever you are. No rush.",
    "Today's plan is yours to shape.",
    "Small honest actions beat grand plans every time.",
    "I'm right here with you!",
  ];

  static const List<String> encouragements = [
    "Even 5 minutes of focused effort counts as real progress.",
    "If things didn't go as planned yesterday, today is a clean slate. No guilt.",
    "Progress isn't a straight line. What's one gentle action we can do next?",
    "Remember: a missed day doesn't erase what you've already built.",
    "Listen to what your body and mind need today.",
    "Take a breath. You don't have to carry the whole week in one afternoon.",
  ];

  static const List<String> taskReminders = [
    "Priorities look clear. Let's tackle the most useful one first.",
    "Overwhelmed? We can always reduce scope or renegotiate a deadline.",
    "Finishing one small thing gives momentum.",
  ];

  static const List<String> workoutEncouragements = [
    "Movement is for your health and vitality—not punishment.",
    "Stopping early when your body signals it is wise, not failure.",
    "Every rep counts as honest evidence.",
  ];

  static String getRandomMessage() {
    final all = [...greetings, ...encouragements, ...taskReminders];
    return all[_random.nextInt(all.length)];
  }

  static String getContextMessage(String context) {
    switch (context.toLowerCase()) {
      case 'tasks':
        return taskReminders[_random.nextInt(taskReminders.length)];
      case 'workouts':
        return workoutEncouragements[_random.nextInt(workoutEncouragements.length)];
      default:
        return encouragements[_random.nextInt(encouragements.length)];
    }
  }
}

