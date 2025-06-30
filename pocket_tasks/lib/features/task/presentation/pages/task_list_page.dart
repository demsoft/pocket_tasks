import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocket_tasks/features/task/presentation/pages/add_edit_task_page.dart';
import 'package:pocket_tasks/features/task/provider/theme_provider.dart';
import '../../provider/task_provider.dart';

class TaskListPage extends ConsumerWidget {
  const TaskListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasks = ref.watch(filteredTasksProvider);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorScheme.primary,
        title: const Text(
          "Pocket Tasks",
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          Row(
            children: [
              const Icon(Icons.light_mode, color: Colors.white),
              Switch(
                value: ref.watch(themeProvider) == ThemeMode.dark,
                onChanged: (isDark) {
                  ref.read(themeProvider.notifier).state =
                      isDark ? ThemeMode.dark : ThemeMode.light;
                },
              ),
              const Icon(Icons.dark_mode, color: Colors.white),
            ],
          ),
        ],
      ),
      body: Container(
        color: theme.scaffoldBackgroundColor,
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Wrap(
                spacing: 8,
                children:
                    TaskFilter.values.map((filter) {
                      final isSelected =
                          ref.watch(taskFilterProvider) == filter;
                      return ChoiceChip(
                        label: Text(
                          filter.name[0].toUpperCase() +
                              filter.name.substring(1),
                          style: TextStyle(
                            color:
                                isSelected
                                    ? Colors.white
                                    : theme.textTheme.bodyMedium?.color,
                          ),
                        ),
                        selected: isSelected,
                        selectedColor: colorScheme.primary,
                        backgroundColor: colorScheme.secondary.withOpacity(0.2),
                        onSelected:
                            (_) =>
                                ref.read(taskFilterProvider.notifier).state =
                                    filter,
                      );
                    }).toList(),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Text("Sort by: "),
                DropdownButton<TaskSort>(
                  value: ref.watch(taskSortProvider),
                  items:
                      TaskSort.values.map((sort) {
                        return DropdownMenuItem(
                          value: sort,
                          child: Text(
                            sort == TaskSort.creation ? 'Created' : 'Due',
                          ),
                        );
                      }).toList(),
                  onChanged: (val) {
                    if (val != null) {
                      ref.read(taskSortProvider.notifier).state = val;
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 10),
            Expanded(
              child:
                  tasks.isEmpty
                      ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.inbox,
                              size: 80,
                              color: Colors.grey.shade400,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No tasks yet!',
                              style: TextStyle(
                                fontSize: 18,
                                color:
                                    Theme.of(
                                      context,
                                    ).textTheme.bodyMedium?.color,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Tap the "+" button to add your first task.',
                              style: TextStyle(color: Colors.grey.shade600),
                            ),
                          ],
                        ),
                      )
                      : ListView.builder(
                        itemCount: tasks.length,
                        itemBuilder: (_, index) {
                          final task = tasks[index];
                          return Dismissible(
                            key: Key(task.id),
                            direction: DismissDirection.endToStart,
                            background: Container(
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                              ),
                              color: Colors.red,
                              child: const Icon(
                                Icons.delete,
                                color: Colors.white,
                              ),
                            ),
                            onDismissed: (_) {
                              ref
                                  .read(taskListProvider.notifier)
                                  .deleteTask(task.id);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: const Text('Task deleted'),
                                  action: SnackBarAction(
                                    label: 'Undo',
                                    onPressed: () {
                                      ref
                                          .read(taskListProvider.notifier)
                                          .addTask(task);
                                    },
                                  ),
                                ),
                              );
                            },
                            child: Card(
                              color: theme.cardColor,
                              margin: const EdgeInsets.symmetric(vertical: 8),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: ListTile(
                                title: Text(
                                  task.title,
                                  style: TextStyle(
                                    decoration:
                                        task.isCompleted
                                            ? TextDecoration.lineThrough
                                            : null,
                                  ),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(task.note),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.event,
                                          size: 16,
                                          color: colorScheme.primary,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          'Due: ${task.dueDate.toLocal().toString().split(' ')[0]}',
                                        ),
                                        // const SizedBox(width: 12),
                                        // Icon(
                                        //   Icons.calendar_today,
                                        //   size: 16,
                                        //   color: colorScheme.primary,
                                        // ),
                                        // const SizedBox(width: 4),
                                        // Text(
                                        //   'Created: ${task.createdAt.toLocal().toString().split(' ')[0]}',
                                        // ),
                                      ],
                                    ),
                                  ],
                                ),
                                leading: Checkbox(
                                  value: task.isCompleted,
                                  onChanged:
                                      (_) => ref
                                          .read(taskListProvider.notifier)
                                          .toggleComplete(task),
                                  activeColor: colorScheme.primary,
                                ),
                                trailing: const Icon(Icons.chevron_right),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (_) => AddEditTaskPage(task: task),
                                    ),
                                  );
                                },
                              ),
                            ),
                          );
                        },
                      ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: colorScheme.primary,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddEditTaskPage()),
          );
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
