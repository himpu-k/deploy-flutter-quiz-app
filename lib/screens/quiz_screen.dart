import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:project1_quiz_application/models/answer.dart';
import 'package:project1_quiz_application/models/quiz.dart';
import 'package:project1_quiz_application/screens/base_screen.dart';
import 'package:project1_quiz_application/services/quiz_service.dart';
import 'package:project1_quiz_application/services/shared_preferences_service.dart';

class QuizScreen extends StatefulWidget {
  final int topicId;
  const QuizScreen({super.key, required this.topicId});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  Quiz? quiz;
  Answer? answer;
  bool? correct;
  bool isCorrectAnswerIncreased = false;

  void loadQuiz() async {
    var fetchedQuiz = await QuizService().getQuiz(widget.topicId);
    if (mounted) {
      setState(() {
        quiz = fetchedQuiz;
        isCorrectAnswerIncreased = false;
      });
    }
  }

  void optionSelected(String option) async {
    setState(() {
      correct = null;
    });
    answer = await QuizService().sumbitAnswer(widget.topicId, quiz!.id, option);
    setState(() {
      correct = answer!.correct;
    });
    if (correct! && !isCorrectAnswerIncreased) {
      SharedPreferencesService().increaseCorrectAnswer(widget.topicId);
      isCorrectAnswerIncreased = true;
    }
  }

  @override
  void initState() {
    super.initState();
    loadQuiz();
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
        title: "Quiz API - Quiz screen",
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
                    if (correct == true)
                      TextButton(
                        child: const Text("Next question"),
                        onPressed: () {
                          correct = null;
                          answer = null;
                          loadQuiz();
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
