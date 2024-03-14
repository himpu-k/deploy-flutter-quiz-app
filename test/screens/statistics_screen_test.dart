import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:project1_quiz_application/services/shared_preferences_service.dart';
import 'package:project1_quiz_application/screens/statistics_screen.dart';
import 'package:project1_quiz_application/services/quiz_service.dart';

void main() {
  group('Statistics Screen Tests', () {
    SharedPreferencesService? service;

    setUp(() async {
      QuizService().enableTestMode();
    });

    tearDown(() {
      QuizService().enableTestMode(enable: false);
    });
    testWidgets('Statistics screen has correct elements with no statistics',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: StatisticsScreen()));
      await tester.pumpAndSettle();

      expect(find.text('Quiz API - Statistics page'), findsOneWidget);
      expect(find.text('Go home'), findsOneWidget);
      expect(find.text('No statistics available.'), findsOneWidget);

      // Check for the total correct answers
      expect(find.text('Total correct answers: 0'), findsOneWidget);
    });

    testWidgets(
        'Statistics screen has correct elements with mock statistics and shared preferences has correct values',
        (WidgetTester tester) async {
      SharedPreferences.setMockInitialValues(
          {'correctAnswers': '{"1":5,"2":3}'});
      service = SharedPreferencesService();
      const int topicId1 = 1;
      const int topicId2 = 2;
      await tester.pumpWidget(const MaterialApp(home: StatisticsScreen()));
      await tester.pumpAndSettle();

      expect(find.text('Quiz API - Statistics page'), findsOneWidget);
      expect(find.text('Go home'), findsOneWidget);
      expect(find.byType(Card),
          findsNWidgets(2)); // Assuming two topics are returned
      expect(find.text('Basic arithmetics'), findsOneWidget);
      expect(find.text('5'),
          findsOneWidget); // Check for the correct count of the first topic
      expect(find.text('Countries and capitals'), findsOneWidget);
      expect(find.text('3'),
          findsOneWidget); // Check for the correct count of the second topic

      // Check for the total correct answers
      expect(find.text('Total correct answers: 8'), findsOneWidget);

      // Check if the shared preferences are correctly updated
      var correctAnswers = await service!.getCorrectAnswersByTopic();
      expect(correctAnswers.length, 2);
      expect(correctAnswers[topicId1], 5);
      expect(correctAnswers[topicId2], 3);
    });
  });
}
