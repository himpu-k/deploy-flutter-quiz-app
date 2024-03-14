import 'package:flutter_test/flutter_test.dart';
import 'package:project1_quiz_application/services/quiz_service.dart';

void main() {
  group('QuizService Tests', () {
    setUp(() {
      QuizService().enableTestMode();
    });

    tearDown(() {
      QuizService().enableTestMode(enable: false);
    });
    test('getTopics returns a list of topics', () async {
      var topics = await QuizService().getTopics();

      // Verify the result
      expect(topics.length, 4);
      expect(topics[0].name, 'Basic arithmetics');
      expect(topics[1].name, 'Countries and capitals');
      expect(topics[2].name, 'Countries and continents');
      expect(topics[3].name, 'Dog breeds');
    });

    test('getQuiz returns a quiz', () async {
      var quiz = await QuizService().getQuiz(1);

      // Verify the result
      expect(quiz.question, 'What is the outcome of 3 + 3?');
      expect(quiz.options, ['100', '49', '200', '95', '6']);
    });

    test('getAnswer returns an answer', () async {
      var answer = await QuizService().sumbitAnswer(1, 4, '6');

      // Verify the result
      expect(answer.correct, true);
    });
  });
}
