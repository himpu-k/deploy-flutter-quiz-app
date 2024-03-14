import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:project1_quiz_application/models/answer.dart';
import 'package:project1_quiz_application/models/quiz.dart';
import 'package:project1_quiz_application/screens/base_screen.dart';
import 'package:project1_quiz_application/services/quiz_service.dart';
import 'package:project1_quiz_application/services/shared_preferences_service.dart';

class GenericPracticeScreen extends StatefulWidget {
  final int topicId;
  const GenericPracticeScreen({super.key, required this.topicId});

  @override
  State<GenericPracticeScreen> createState() => _GenericPracticeScreenState();
}

class _GenericPracticeScreenState extends State<GenericPracticeScreen> {
  Quiz? quiz;
  Answer? answer;
  bool? correct;
  bool isCorrectAnswerIncreased = false;
  int? newTopicId;

  void loadQuiz(int topicId) async {
    var fetchedQuiz = await QuizService().getQuiz(topicId);
    if (mounted) {
      setState(() {
        quiz = fetchedQuiz;
        isCorrectAnswerIncreased = false;
        newTopicId = topicId;
      });
    }
  }

  void optionSelected(String option) async {
    setState(() {
      correct = null;
    });
    answer = await QuizService().sumbitAnswer(newTopicId!, quiz!.id, option);
    setState(() {
      correct = answer!.correct;
    });
    if (correct! && !isCorrectAnswerIncreased) {
      SharedPreferencesService().increaseCorrectAnswer(newTopicId!);
      isCorrectAnswerIncreased = true;
    }
  }

  void setPossibleNewTopicId() async {
    // Get the possible new topic id
    final possibleNewTopicId =
        await QuizService().getTopicWithFewestCorrectAnswers();
    setState(() {
      newTopicId = possibleNewTopicId;
    });

    loadQuiz(newTopicId!);
  }

  @override
  void initState() {
    super.initState();
    loadQuiz(widget.topicId);
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
        title: "Quiz API - Generic Practice screen",
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.bar_chart),
            onPressed: () {
              context.go('/statistics');
            },
          ),
          IconButton(
            icon: const Icon(Icons.list),
            onPressed: () {
              context.go('/');
            },
          )
        ],
        body: quiz == null
            ? const Center(child: CircularProgressIndicator())
            : Center(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        quiz!.question,
                        style: Theme.of(context).textTheme.headlineSmall,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    if (quiz!.imageUrl != null)
                      Padding(
                          padding: const EdgeInsets.all(10),
                          child: Image.network(quiz!.imageUrl!)),
                    if (correct != null)
                      Text(correct! ? "Correct answer" : "Incorrect answer",
                          style: TextStyle(
                              backgroundColor:
                                  correct! ? Colors.green : Colors.red,
                              fontSize: 20))
                    else
                      const Text(""),
                    if (correct == true && newTopicId != null)
                      TextButton(
                        child: const Text("Next question"),
                        onPressed: () {
                          correct = null;
                          answer = null;
                          setPossibleNewTopicId();
                        },
                      )
                    else
                      const TextButton(onPressed: null, child: Text("")),
                    Expanded(
                      child: ListView(
                        children: quiz!.options.map((option) {
                          return Card(
                            child: ListTile(
                              title: Text(option),
                              onTap: () {
                                optionSelected(option);
                              },
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ));
  }
}
