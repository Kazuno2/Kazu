import 'package:flutter/material.dart';
import '../../../core/models/task_model.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  // Sample seed tasks demonstrating SRS principles
  final List<TaskModel> _tasks = [
    TaskModel(
      id: 'task-1',
      title: 'Review today\'s T1 Self-Trust commitment',
      details: 'Keep promise realistic and explicitly renegotiate if day circumstances shift.',
      priority: TaskPriority.high,
      createdDate: DateTime.now().subtract(const Duration(days: 1)),
      originalDueDate: DateTime.now(),
      plannedDate: DateTime.now(),
      estimatedMinutes: 20,
      isCompleted: false,
    ),
    TaskModel(
      id: 'task-2',
      title: 'Complete 15-minute mobility routine',
      details: 'Focus on gentle hip & shoulder mobility.',
      priority: TaskPriority.medium,
      createdDate: DateTime.now(),
      originalDueDate: DateTime.now(),
      plannedDate: DateTime.now(),
      estimatedMinutes: 15,
      isCompleted: true,
    ),
    TaskModel(
      id: 'task-3',
      title: 'Draft next phase milestone outline',
      details: 'Break large work into small, honest units.',
      priority: TaskPriority.urgent,
      createdDate: DateTime.now().subtract(const Duration(days: 3)),
      originalDueDate: DateTime.now().subtract(const Duration(days: 1)), // Overdue
      plannedDate: DateTime.now(),
      estimatedMinutes: 45,
      rolloverCount: 2,
      userRescheduleCount: 1,
      isCompleted: false,
    ),
  ];

  final int _dailyBudgetMinutes = 300; // 5 hours availability

  int get _scheduledMinutes => _tasks
      .where((t) => !t.isCompleted)
      .fold(0, (sum, t) => sum + (t.estimatedMinutes ?? 30));

  void _showAddTaskDialog() {
    final titleController = TextEditingController();
    final detailsController = TextEditingController();
    final minutesController = TextEditingController(text: '30');
    TaskPriority selectedPriority = TaskPriority.medium;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'New Daily Plan Task',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: titleController,
                    decoration: const InputDecoration(
                      labelText: 'Task Title',
                      hintText: 'e.g., Read documentation for 25 min',
                      border: OutlineInputBorder(),
                    ),
                    autofocus: true,
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: detailsController,
                    decoration: const InputDecoration(
                      labelText: 'Details / Context (Optional)',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 2,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: minutesController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Est. Minutes',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: DropdownButtonFormField<TaskPriority>(
                          initialValue: selectedPriority,
                          decoration: const InputDecoration(
                            labelText: 'Priority',
                            border: OutlineInputBorder(),
                          ),
                          items: TaskPriority.values.map((p) {
                            return DropdownMenuItem(
                              value: p,
                              child: Text(p.name.toUpperCase()),
                            );
                          }).toList(),
                          onChanged: (val) {
                            if (val != null) {
                              setModalState(() => selectedPriority = val);
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (titleController.text.trim().isEmpty) return;
                        final minutes = int.tryParse(minutesController.text.trim()) ?? 30;
                        setState(() {
                          _tasks.add(
                            TaskModel(
                              id: 'task-${DateTime.now().millisecondsSinceEpoch}',
                              title: titleController.text.trim(),
                              details: detailsController.text.trim().isEmpty ? null : detailsController.text.trim(),
                              priority: selectedPriority,
                              createdDate: DateTime.now(),
                              originalDueDate: DateTime.now(),
                              plannedDate: DateTime.now(),
                              estimatedMinutes: minutes,
                            ),
                          );
                        });
                        Navigator.pop(context);
                      },
                      child: const Text('Add to Plan'),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final remainingBudget = _dailyBudgetMinutes - _scheduledMinutes;
    final isOverloaded = remainingBudget < 0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Plan & Tasks'),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            tooltip: 'Non-punitive Rollover Rules',
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Non-Punitive Rollover'),
                  content: const Text(
                    'Kazu preserves all past history. Unfinished tasks carry forward automatically '
                    'into tomorrow without creating duplicates. Overdue status is visible honestly, '
                    'but never accompanied by guilt or streak shaming.',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Got it'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTaskDialog,
        backgroundColor: theme.colorScheme.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        children: [
          // Time Budget Card (FR-PL-01, FR-PL-05)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isOverloaded
                  ? Colors.red.withAlpha(25)
                  : theme.colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isOverloaded
                    ? Colors.red.withAlpha(120)
                    : theme.colorScheme.outline.withAlpha(60),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'DAILY TIME BUDGET',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.1,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    Text(
                      '${_scheduledMinutes}m / ${_dailyBudgetMinutes}m',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isOverloaded ? Colors.red : theme.colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: (_scheduledMinutes / _dailyBudgetMinutes).clamp(0.0, 1.0),
                    minHeight: 8,
                    backgroundColor: theme.colorScheme.surface,
                    valueColor: AlwaysStoppedAnimation(
                      isOverloaded ? Colors.red : theme.colorScheme.primary,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  isOverloaded
                      ? '⚠️ Over budget by ${-remainingBudget}m. Consider rescheduling or reducing scope.'
                      : 'Remaining time budget: ${remainingBudget}m available today.',
                  style: TextStyle(
                    fontSize: 12,
                    color: isOverloaded ? Colors.red : theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 18),

          Text(
            'TODAY\'S TASKS (${_tasks.where((t) => !t.isCompleted).length} remaining)',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.1,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: 8),

          ..._tasks.map((task) {
            Color priorityColor;
            switch (task.priority) {
              case TaskPriority.urgent:
                priorityColor = Colors.red;
                break;
              case TaskPriority.high:
                priorityColor = Colors.orange;
                break;
              case TaskPriority.medium:
                priorityColor = Colors.blue;
                break;
              case TaskPriority.low:
                priorityColor = Colors.green;
                break;
            }

            return Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                leading: Checkbox(
                  value: task.isCompleted,
                  onChanged: (val) {
                    setState(() {
                      task.isCompleted = val ?? false;
                    });
                  },
                ),
                title: Row(
                  children: [
                    Expanded(
                      child: Text(
                        task.title,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                          color: task.isCompleted
                              ? theme.colorScheme.onSurfaceVariant.withAlpha(140)
                              : theme.colorScheme.onSurface,
                        ),
                      ),
                    ),
                    if (task.isOverdue) ...[
                      const SizedBox(width: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.red.withAlpha(40),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          'Overdue',
                          style: TextStyle(fontSize: 10, color: Colors.red, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ],
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (task.details != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        task.details!,
                        style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurfaceVariant),
                      ),
                    ],
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: priorityColor.withAlpha(35),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            task.priority.name.toUpperCase(),
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: priorityColor,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${task.estimatedMinutes ?? 30} min',
                          style: TextStyle(fontSize: 11, color: theme.colorScheme.onSurfaceVariant),
                        ),
                        if (task.rolloverCount > 0) ...[
                          const SizedBox(width: 8),
                          Text(
                            '• Rolled ${task.rolloverCount}x',
                            style: TextStyle(
                              fontSize: 11,
                              color: theme.colorScheme.onSurfaceVariant.withAlpha(180),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
                trailing: PopupMenuButton<String>(
                  onSelected: (val) {
                    if (val == 'delete') {
                      setState(() {
                        _tasks.removeWhere((t) => t.id == task.id);
                      });
                    } else if (val == 'reschedule') {
                      setState(() {
                        task.userRescheduleCount++;
                        task.plannedDate = DateTime.now().add(const Duration(days: 1));
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Rescheduled for tomorrow. No guilt!')),
                      );
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'reschedule',
                      child: Text('Reschedule for tomorrow'),
                    ),
                    const PopupMenuItem(
                      value: 'delete',
                      child: Text('Delete task'),
                    ),
                  ],
                ),
              ),
            );
          }),

          const SizedBox(height: 60),
        ],
      ),
    );
  }
}
