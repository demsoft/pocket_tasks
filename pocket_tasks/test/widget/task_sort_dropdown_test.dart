import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:hive_test/hive_test.dart';
import 'package:pocket_tasks/features/task/domain/task.dart';
import 'package:pocket_tasks/features/task/presentation/pages/task_list_page.dart';
import 'package:pocket_tasks/features/task/provider/task_provider.dart';

void main() {
  setUpAll(() async {
    await setUpTestHive();
    Hive.registerAdapter(TaskAdapter());
    await Hive.openBox<Task>('tasksBox');
  });

  testWidgets('Task sort dropdown renders with correct options', (
    tester,
  ) async {
    await tester.pumpWidget(
      const ProviderScope(child: MaterialApp(home: TaskListPage())),
    );

    expect(find.byType(DropdownButton<TaskSort>), findsOneWidget);
    expect(find.text('Created'), findsOneWidget);
    expect(find.text('Due'), findsOneWidget);
  });
}
