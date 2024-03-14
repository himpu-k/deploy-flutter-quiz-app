import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:project1_quiz_application/screens/generic_practice_screen.dart';
import 'package:project1_quiz_application/screens/home_screen.dart';
import 'package:project1_quiz_application/screens/quiz_screen.dart';
import 'package:project1_quiz_application/screens/statistics_screen.dart';

final router = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (context, state) => const HomeScreen()),
    GoRoute(
        path: '/statistics',
        builder: (context, state) => const StatisticsScreen()),
    GoRoute(
        path: '/topics/:topicId/questions',
        builder: (context, state) =>
            QuizScreen(topicId: int.parse(state.pathParameters['topicId']!))),
    GoRoute(
        path: '/topics/:topicId/questions/generic-practice',
        builder: (context, state) => GenericPracticeScreen(
            topicId: int.parse(state.pathParameters['topicId']!))),
  ],
);

main() {
  runApp(MaterialApp.router(routerConfig: router));
}
