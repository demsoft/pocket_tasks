import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:hive_test/hive_test.dart';
import 'package:pocket_tasks/features/task/domain/task.dart';
import 'package:pocket_tasks/features/task/presentation/pages/add_edit_task_page.dart';

void main() {
  setUpAll(() async {
    await setUpTestHive();
    Hive.registerAdapter(TaskAdapter());
    await Hive.openBox<Task>('tasksBox');
  });

  testWidgets('Add Task Page renders and validates input', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: MaterialApp(home: AddEditTaskPage())),
    );

    expect(find.text('Add Task'), findsOneWidget);

    // Tap the submit button without input
    await tester.tap(find.widgetWithText(ElevatedButton, 'Add Task'));
    await tester.pumpAndSettle();

    // Expect validation message
    expect(find.text('Title is required'), findsOneWidget);

    // Fill the title field
    await tester.enterText(find.byType(TextFormField).first, 'Do laundry');

    // Submit again
    await tester.tap(find.widgetWithText(ElevatedButton, 'Add Task'));
    await tester.pumpAndSettle();
  });
}
