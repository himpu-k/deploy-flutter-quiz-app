import 'dart:math';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:project1_quiz_application/models/topic.dart';
import 'package:project1_quiz_application/screens/base_screen.dart';
import 'package:project1_quiz_application/services/quiz_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreen> {
  List<Topic> topics = [];

  void loadTopics() async {
    var fetchedTopics = await QuizService().getTopics();
    if (mounted) {
      setState(() {
        topics = fetchedTopics;
      });
    }
  }

  Future<int> getGenericPractice() async {
    final topicId = await QuizService()
        .getTopicWithFewestCorrectAnswers()
        .then((value) => value);

    // If there is no correct answers yet, return random topic
    if (topicId == -1) {
      var fetchedTopics = await QuizService().getTopics();
      // Select a random topic from all the topics
      Random random = Random();
      return fetchedTopics[random.nextInt(fetchedTopics.length)].id;
    } else {
      return topicId;
    }
  }

  @override
  void initState() {
    super.initState();
    loadTopics();
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
        title: "Quiz API - Home page",
        body: Column(children: [
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            TextButton(
              onPressed: () {
                context.go("/statistics");
              },
              child: const Text("See statistics"),
            ),
            TextButton(
              onPressed: () async {
                int topicId = await getGenericPractice();
                if (mounted) {
                  context.go("/topics/$topicId/questions/generic-practice");
                }
              },
              child: const Text("Generic practice"),
            )
          ]),
          Expanded(
            child: topics.isNotEmpty
                ? ListView.builder(
                    itemCount: topics.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(topics[index].name),
                        onTap: () {
                          context.go("/topics/${topics[index].id}/questions");
                        },
                      );
                    },
                  )
                : const Text("No topics available"),
          ),
        ]));
  }
}
