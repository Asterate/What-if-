import 'package:flutter/material.dart';
import 'questions.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  bool _revealed = false;

  void _nextQuestion() {
    setState(() {
      _currentIndex = (_currentIndex + 1) % questions.length;
      _revealed = false;
    });
  }

  void _reveal() {
    setState(() {
      _revealed = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final q = questions[_currentIndex];

    return Scaffold(
      backgroundColor: Colors.deepPurple,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'What If?',
                style: TextStyle(
                  color: Colors.white54,
                  fontSize: 18,
                  letterSpacing: 4,
                ),
              ),
              const SizedBox(height: 40),
              Text(
                q['question']!,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 40),
              if (_revealed)
                Text(
                  q['answer']!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 18,
                  ),
                )
              else
                ElevatedButton(
                  onPressed: _reveal,
                  child: const Text('Reveal Answer'),
                ),
              const SizedBox(height: 40),
              if (_revealed)
                TextButton(
                  onPressed: _nextQuestion,
                  child: const Text(
                    'Next Question →',
                    style: TextStyle(color: Colors.white54),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}