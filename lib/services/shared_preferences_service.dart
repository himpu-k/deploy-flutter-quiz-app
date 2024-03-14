import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  final correctAnswersKey = 'correctAnswers';

  Future<void> increaseCorrectAnswer(int topicId) async {
    final prefs = await SharedPreferences.getInstance();
    Map<String, int> correctAnswers = _getCorrectAnswersMap(prefs);

    // Update the value of correct answers for specific topicId
    correctAnswers.update(
      topicId.toString(),
      (value) => value + 1,
      ifAbsent: () => 1,
    );

    // Set the new encoded Map<String, int> to the prefs
    await prefs.setString(correctAnswersKey, jsonEncode(correctAnswers));
  }

  void removeSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(correctAnswersKey);
  }

  Future<Map<int, int>> getCorrectAnswersByTopic() async {
    final prefs = await SharedPreferences.getInstance();
    Map<String, int> correctAnswers = _getCorrectAnswersMap(prefs);

    return correctAnswers.map((key, value) => MapEntry(int.parse(key), value));
  }

  Map<String, int> _getCorrectAnswersMap(SharedPreferences prefs) {
    String? correctAnswersString = prefs.getString(correctAnswersKey);
    if (correctAnswersString != null) {
      Map<String, dynamic> jsonMap = jsonDecode(correctAnswersString);
      // Key = topicId, value = correct answers
      return jsonMap.map((key, value) => MapEntry(key, value as int));
    }
    return {};
  }
}
