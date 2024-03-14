import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:project1_quiz_application/screens/quiz_screen.dart';
import 'package:project1_quiz_application/services/quiz_service.dart';

void main() {
  group('Quiz screen Tests', () {
    setUp(() {
      QuizService().enableTestMode();
    });

    tearDown(() {
      QuizService().enableTestMode(enable: false);
    });

    testWidgets('Quiz screen has correct elements',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(
          home: QuizScreen(
        topicId: 1,
      )));
      await tester.pumpAndSettle();

      // Verify the QuizScreen is displayed with the expected content
      expect(find.text("Quiz API - Quiz screen"), findsOneWidget);
      expect(find.text('What is the outcome of 3 + 3?'), findsWidgets);
    });
  });
}
