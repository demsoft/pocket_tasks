import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pocket_tasks/main.dart';

void main() {
  testWidgets('Landing screen shows Pocket Tasks title', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: PocketTasksApp(),
      ),
    );

    expect(find.textContaining('Pocket Tasks'), findsWidgets);
  });
}