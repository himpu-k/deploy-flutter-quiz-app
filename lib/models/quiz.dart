class Quiz {
  final int id;
  final String? imageUrl;
  final String question;
  final List<String> options;
  final String answerPostPath;

  const Quiz(
      {required this.id,
      this.imageUrl,
      required this.question,
      required this.options,
      required this.answerPostPath});

  Quiz.fromJson(Map<String, dynamic> jsonData)
      : id = jsonData['id'],
        imageUrl = jsonData['image_url'],
        question = jsonData['question'],
        options = List<String>.from(jsonData['options']),
        answerPostPath = jsonData['answer_post_path'];
}
