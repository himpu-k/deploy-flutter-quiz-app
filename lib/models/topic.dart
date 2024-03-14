class Topic {
  final int id;
  final String name;
  final String questionPath;

  const Topic({
    required this.id,
    required this.name,
    required this.questionPath,
  });

  Topic.fromJson(Map<String, dynamic> jsonData)
      : id = jsonData['id'],
        name = jsonData['name'],
        questionPath = jsonData['question_path'];
}
