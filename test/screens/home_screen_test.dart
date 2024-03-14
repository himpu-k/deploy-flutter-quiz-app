import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:project1_quiz_application/screens/home_screen.dart';
import 'package:project1_quiz_application/services/quiz_service.dart';

void main() {
  group('Home screen Tests', () {
    setUp(() {
      QuizService().enableTestMode();
    });

    tearDown(() {
      QuizService().enableTestMode(enable: false);
    });
    testWidgets('Home screen has correct elements',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: HomeScreen()));
      await tester.pumpAndSettle();

      expect(find.text('Quiz API - Home page'), findsOneWidget);
      expect(find.text('Basic arithmetics'), findsOneWidget);
      expect(find.text('Countries and capitals'), findsOneWidget);
      expect(find.text('Countries and continents'), findsOneWidget);
      expect(find.text('Dog breeds'), findsOneWidget);
    });
  });
}
