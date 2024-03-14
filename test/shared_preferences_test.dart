import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:project1_quiz_application/services/shared_preferences_service.dart';

void main() {
  SharedPreferencesService? service;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    service = SharedPreferencesService();
  });

  group('SharedPreferencesService Tests', () {
    test('increaseCorrectAnswer increases correct answers count', () async {
      const int topicId = 1;

      // Initial increase
      await service!.increaseCorrectAnswer(topicId);
      var correctAnswers = await service!.getCorrectAnswersByTopic();
      expect(correctAnswers[topicId], 1);

      // Increase again
      await service!.increaseCorrectAnswer(topicId);
      correctAnswers = await service!.getCorrectAnswersByTopic();
      expect(correctAnswers[topicId], 2);
    });

    test('removeSharedPreferences removes the stored preferences', () async {
      const int topicId = 1;

      // Increase correct answers to add some data
      await service!.increaseCorrectAnswer(topicId);
      service!.removeSharedPreferences();

      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString(service!.correctAnswersKey), isNull);
    });

    test('getCorrectAnswersByTopic returns correct map of answers', () async {
      const int topicId1 = 1;
      const int topicId2 = 2;

      // Setup initial data
      await service!.increaseCorrectAnswer(topicId1); // topicId1: 1
      await service!.increaseCorrectAnswer(topicId1); // topicId1: 2
      await service!.increaseCorrectAnswer(topicId2); // topicId2: 1

      var correctAnswers = await service!.getCorrectAnswersByTopic();

      expect(correctAnswers.length, 2);
      expect(correctAnswers[topicId1], 2);
      expect(correctAnswers[topicId2], 1);
    });
  });
}
