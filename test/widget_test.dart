// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:freshflow_app/main.dart';
import 'package:freshflow_app/features/onboarding/data/auth_repository.dart';

void main() {
  testWidgets('Shows Home with Open Chat button', (WidgetTester tester) async {
    // Build app and trigger a frame.
    final authRepo = AuthRepository();
    await tester.pumpWidget(App(authRepo: authRepo));

    // Verify Home renders the primary action.
    expect(find.text('Open Chat'), findsOneWidget);
  });
}
