import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:pocket_tasks/features/task/domain/task.dart';

/// Inject the Hive box into the notifier for better testability
final taskListProvider = StateNotifierProvider<TaskListNotifier, List<Task>>((
  ref,
) {
  final box = Hive.box<Task>('tasksBox'); // This can be overridden in tests
  return TaskListNotifier(box);
});

class TaskListNotifier extends StateNotifier<List<Task>> {
  final Box<Task> box;

  TaskListNotifier(this.box) : super([]) {
    loadTasks();
  }

  void loadTasks() {
    state = box.values.toList();
  }

  void addTask(Task task) {
    box.put(task.id, task);
    loadTasks();
  }

  void updateTask(Task updatedTask) {
    box.put(updatedTask.id, updatedTask); // ✅ replaces the task
    loadTasks();
  }

  void deleteTask(String id) {
    box.delete(id);
    loadTasks();
  }

  void toggleComplete(Task task) {
    task.isCompleted = !task.isCompleted;
    task.save(); // Hive persists it
    loadTasks();
  }
}

/// Filtering logic
enum TaskFilter { all, active, completed }

final taskFilterProvider = StateProvider<TaskFilter>((ref) => TaskFilter.all);

/// Sorting logic
enum TaskSort { creation, due }

final taskSortProvider = StateProvider<TaskSort>((ref) => TaskSort.creation);

/// Combines filtering + sorting based on selected filters
final filteredTasksProvider = Provider<List<Task>>((ref) {
  final filter = ref.watch(taskFilterProvider);
  final sort = ref.watch(taskSortProvider);
  final allTasks = ref.watch(taskListProvider);

  List<Task> filtered = switch (filter) {
    TaskFilter.all => allTasks,
    TaskFilter.active => allTasks.where((t) => !t.isCompleted).toList(),
    TaskFilter.completed => allTasks.where((t) => t.isCompleted).toList(),
  };

  switch (sort) {
    case TaskSort.creation:
      filtered.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      break;
    case TaskSort.due:
      filtered.sort((a, b) => a.dueDate.compareTo(b.dueDate));
      break;
  }

  return filtered;
});
