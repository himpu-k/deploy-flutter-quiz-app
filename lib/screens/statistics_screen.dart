import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:project1_quiz_application/screens/base_screen.dart';
import 'package:project1_quiz_application/services/quiz_service.dart';
import 'package:project1_quiz_application/services/shared_preferences_service.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  Map<String, int>? topicsAndAnswers;
  int totalCorrectAnswers = 0;

  void getTopicsAndAnswers() async {
    var fetchedTopics = await QuizService().getTopics();
    var fetchedAnswers =
        await SharedPreferencesService().getCorrectAnswersByTopic();

    Map<String, int> tempTopicsAndAnswers = {};
    int tempTotalCorrectAnswers = 0;

    fetchedAnswers.forEach((topicId, count) {
      var matchingTopic = fetchedTopics.firstWhere(
        (topic) => topic.id == topicId,
      );

      tempTopicsAndAnswers[matchingTopic.name] = count;
      tempTotalCorrectAnswers += count;
    });

    // Sort the map by correct answer count in descending order
    tempTopicsAndAnswers = Map.fromEntries(
      tempTopicsAndAnswers.entries.toList()
        ..sort((a, b) => b.value.compareTo(a.value)),
    );

    if (mounted) {
      setState(() {
        topicsAndAnswers = tempTopicsAndAnswers;
        totalCorrectAnswers = tempTotalCorrectAnswers;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getTopicsAndAnswers();
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
        title: "Quiz API - Statistics page",
        body: Center(
            child: Column(children: [
          TextButton(
            onPressed: () => context.go("/"),
            child: const Text("Go home"),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("Total correct answers: $totalCorrectAnswers"),
          ),
          Expanded(
            child: topicsAndAnswers != null && topicsAndAnswers!.isNotEmpty
                ? ListView.builder(
                    itemCount: topicsAndAnswers!.length,
                    itemBuilder: (context, index) {
                      String topicName =
                          topicsAndAnswers!.keys.elementAt(index);
                      int correctCount = topicsAndAnswers![topicName]!;
                      return Card(
                        child: ListTile(
                          title: Text(topicName),
                          trailing: Text(correctCount.toString()),
                        ),
                      );
                    },
                  )
                : const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text("No statistics available."),
                  ),
          )
        ])));
  }
}
