class Answer {
  final bool correct;

  const Answer({
    required this.correct,
  });

  Answer.fromJson(Map<String, dynamic> jsonData)
      : correct = jsonData['correct'];
}
