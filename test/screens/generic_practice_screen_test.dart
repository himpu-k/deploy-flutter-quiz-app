import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:project1_quiz_application/screens/generic_practice_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:project1_quiz_application/services/shared_preferences_service.dart';
import 'package:project1_quiz_application/services/quiz_service.dart';

void main() {
  group('Generic practice screen Tests', () {
    SharedPreferencesService? service;

    setUp(() {
      QuizService().enableTestMode();
      SharedPreferences.setMockInitialValues(
          {'correctAnswers': '{"2":5,"3":3,"4":2}'});
      service = SharedPreferencesService();
    });

    tearDown(() {
      QuizService().enableTestMode(enable: false);
    });

    testWidgets(
        'Generic practice screen shows the topic with fewest correct answers',
        (WidgetTester tester) async {
      int topicWithFewestCorrectAnswers =
          await QuizService().getTopicWithFewestCorrectAnswers();
      const int topicId2 = 2;
      const int topicId3 = 3;
      const int topicId4 = 4;
      await tester.pumpWidget(MaterialApp(
          home: GenericPracticeScreen(
        topicId: topicWithFewestCorrectAnswers,
      )));
      await tester.pumpAndSettle();

      // Check for the shared preferences to store the correct answer amounts
      var correctAnswers = await service!.getCorrectAnswersByTopic();
      expect(correctAnswers.length, 3);
      expect(correctAnswers[topicId2], 5);
      expect(correctAnswers[topicId3], 3);
      expect(correctAnswers[topicId4], 2);

      // Verify the GenericPracticeScreen is displayed with the expected content
      expect(find.text("Quiz API - Generic Practice screen"), findsOneWidget);
      // Question from topic with fewest correct answers
      expect(find.text('What is the outcome of 3 + 3?'), findsWidgets);
    });
  });
}
