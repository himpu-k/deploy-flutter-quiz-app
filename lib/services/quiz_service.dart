import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:project1_quiz_application/models/answer.dart';
import 'dart:convert';
import 'package:project1_quiz_application/models/quiz.dart';
import 'package:project1_quiz_application/models/topic.dart';
import 'package:project1_quiz_application/services/shared_preferences_service.dart';

const baseUrl = "https://dad-quiz-api.deno.dev/topics";

class QuizService {
  static final QuizService _instance = QuizService._internal();

  factory QuizService() {
    return _instance;
  }

  QuizService._internal();
  // Boolean flag to mock the service for tests.
  bool _isTestMode = false;
  void enableTestMode({bool enable = true}) {
    _isTestMode = enable;
  }

  // GET-request to get topics
  Future<List<Topic>> getTopics() async {
    if (_isTestMode) {
      List<Topic> topics = _getMocktopics();
      return topics;
    } else {
      final response = await http.get(Uri.parse(baseUrl));

      // Check for a successful response
      if (response.statusCode == 200) {
        List<dynamic> jsonList = jsonDecode(response.body);
        List<Topic> topics =
            jsonList.map((jsonItem) => Topic.fromJson(jsonItem)).toList();

        return topics;
      } else {
        // If the server did not return 200 OK response then throw an exception.
        throw Exception('Failed to get topics');
      }
    }
  }

  Future<int> getTopicWithFewestCorrectAnswers() async {
    Map<int, int> topicIdsWithCorrectAnswers =
        await SharedPreferencesService().getCorrectAnswersByTopic();
    List<Topic> allTopics = await getTopics();

    Random random = Random();
    // Find topics that have zero correct answers
    List<int> topicsWithZeroCorrectAnswers = allTopics
        .where((topic) {
          return !topicIdsWithCorrectAnswers.containsKey(topic.id);
        })
        .map((topic) => topic.id)
        .toList();

    // If there are topics with zero correct answers, randomly select one
    if (topicsWithZeroCorrectAnswers.isNotEmpty) {
      return topicsWithZeroCorrectAnswers[
          random.nextInt(topicsWithZeroCorrectAnswers.length)];
    }

    // If all topics have some correct answers, find the one with fewest answers
    if (topicIdsWithCorrectAnswers.isNotEmpty) {
      int minCorrectAnswers = topicIdsWithCorrectAnswers.values.reduce(min);
      List<int> topicsWithMinCorrectAnswers = topicIdsWithCorrectAnswers.entries
          .where((entry) => entry.value == minCorrectAnswers)
          .map((entry) => entry.key)
          .toList();

      return topicsWithMinCorrectAnswers[
          random.nextInt(topicsWithMinCorrectAnswers.length)];
    }

    // If no correct answers are available, randomly select any topic
    return allTopics[random.nextInt(allTopics.length)].id;
  }

  // GET-request to get quiz
  Future<Quiz> getQuiz(int topicId) async {
    if (_isTestMode) {
      Quiz quiz = _getMockQuiz();
      return quiz;
    } else {
      final url = '$baseUrl/$topicId/questions';
      final response = await http.get(Uri.parse(url));

      // Check for a successful response
      if (response.statusCode == 200) {
        return Quiz.fromJson(jsonDecode(response.body));
      } else {
        // If the server did not return 200 OK response then throw an exception.
        throw Exception('Failed to get topics');
      }
    }
  }

  // POST-request to submit answer
  Future<Answer> sumbitAnswer(
      int topicId, int questionId, String answer) async {
    final url = '$baseUrl/$topicId/questions/$questionId/answers';

    var body = jsonEncode({'answer': answer});
    final response = await http.post(Uri.parse(url),
        headers: {"Content-Type": "application/json"}, body: body);

    // Check for a successful response
    if (response.statusCode == 200) {
      return Answer.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return 200 OK response then throw an exception.
      throw Exception('Failed to get topics');
    }
  }
}

List<Topic> _getMocktopics() {
  return [
    const Topic(
        id: 1, name: "Basic arithmetics", questionPath: "/topics/1/questions"),
    const Topic(
        id: 2,
        name: "Countries and capitals",
        questionPath: "/topics/2/questions"),
    const Topic(
        id: 3,
        name: "Countries and continents",
        questionPath: "/topics/3/questions"),
    const Topic(id: 4, name: "Dog breeds", questionPath: "/topics/4/questions"),
  ];
}

Quiz _getMockQuiz() {
  return const Quiz(
      id: 1,
      question: "What is the outcome of 3 + 3?",
      options: ["100", "49", "200", "95", "6"],
      answerPostPath: "/topics/1/questions/4/answers");
}
