import 'dart:math';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'questions.dart';
import 'dart:async';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  bool _revealed = false;
  bool _timer = false;
  DateTime? _nextQuestionTime;
  Duration _timeRemaining = Duration.zero;
  Timer? _countdownTimer;

 void save_timestamp() async {
  _nextQuestionTime = DateTime.now().add(const Duration(hours: 6));
  final prefs = await SharedPreferences.getInstance();
  await prefs.setInt('timestamp', _nextQuestionTime!.millisecondsSinceEpoch);
  }

  void _startCountdown() {
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final remaining = _nextQuestionTime!.difference(DateTime.now());
      if (remaining.isNegative) {
        timer.cancel();
        setState((){
          _timeRemaining = Duration.zero;
          _timer = false;
        });
      } else {
        setState(() {
          _timeRemaining = remaining;
        });
      }
    });
  }

  void _nextQuestion() {
    setState(() {
      _currentIndex = Random().nextInt(questions.length);
      _revealed = false;
      _timer = false;
    });
  }

  void _reveal() {
    setState(() {
      _revealed = true;
      _timer = true;
    });
    save_timestamp();
    _startCountdown();
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
              if (_revealed && _timer)
                Column(
                  children: [
                    const Text(
                      'Next question in',
                      style: TextStyle(color: Colors.white54, fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${_timeRemaining.inHours}h ${_timeRemaining.inMinutes.remainder(60)}m ${_timeRemaining.inSeconds.remainder(60)}s',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                )
              else if (_revealed)
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