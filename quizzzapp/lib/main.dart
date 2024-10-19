import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(QuizApp());
}

class QuizApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vibrant Quiz App',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.purpleAccent,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: QuizPage(),
    );
  }
}

class QuizPage extends StatefulWidget {
  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  List<Question> _trueFalseQuestions = [
    Question('Flutter is developed by Google?', true),
    Question('Dart is a programming language?', true),
    Question('Widgets are a core part of Flutter?', true),
    Question('Flutter is only for iOS development?', false),
  ];

  List<MCQuestion> _mcqQuestions = [
    MCQuestion('What is the capital of France?', [
      'Berlin',
      'Madrid',
      'Paris',
      'Rome'
    ], 2),
    MCQuestion('Which planet is known as the Red Planet?', [
      'Earth',
      'Mars',
      'Jupiter',
      'Saturn'
    ], 1),
    MCQuestion('What is the largest ocean on Earth?', [
      'Atlantic Ocean',
      'Indian Ocean',
      'Arctic Ocean',
      'Pacific Ocean'
    ], 3),
    MCQuestion('What is 2 + 2?', ['3', '4', '5', '6'], 1),
  ];

  List<Question> _questions = [];
  int _currentQuestionIndex = 0;
  int _score = 0;
  bool _showIcon = false;
  IconData? _feedbackIcon;
  Timer? _timer;
  int _timeLeft = 5;
  bool _isMcq = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    setState(() {
      _timeLeft = 5;
    });
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _timeLeft--;
        if (_timeLeft <= 0) {
          _timer?.cancel();
          _nextQuestion();
        }
      });
    });
  }

  void _checkAnswer(bool userAnswer) {
    if (!_isMcq) {
      if (userAnswer == _questions[_currentQuestionIndex].answer) {
        setState(() {
          _score++;
          _feedbackIcon = Icons.check_circle;
          _showIcon = true;
        });
      } else {
        setState(() {
          _feedbackIcon = Icons.cancel;
          _showIcon = true;
        });
      }
    }
    _timer?.cancel();
    Future.delayed(Duration(seconds: 1), () {
      _nextQuestion();
    });
  }

  void _checkMcqAnswer(int selectedIndex) {
    MCQuestion question = _mcqQuestions[_currentQuestionIndex];
    if (selectedIndex == question.correctOptionIndex) {
      setState(() {
        _score++;
        _feedbackIcon = Icons.check_circle;
        _showIcon = true;
      });
    } else {
      setState(() {
        _feedbackIcon = Icons.cancel;
        _showIcon = true;
      });
    }
    _timer?.cancel();
    Future.delayed(Duration(seconds: 1), () {
      _nextQuestion();
    });
  }

  void _nextQuestion() {
    if (_currentQuestionIndex < _questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
        _showIcon = false;
        _startTimer();
      });
    } else {
      _showResult();
    }
  }

  void _showResult() {
    _timer?.cancel();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(
          'Quiz Finished!',
          style: TextStyle(color: Colors.white),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Your score is $_score out of ${_questions.length}.',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _resetQuiz();
            },
            child: Text('Restart', style: TextStyle(color: Colors.purpleAccent)),
          )
        ],
      ),
    );
  }

  void _resetQuiz() {
    setState(() {
      _score = 0;
      _currentQuestionIndex = 0;
      _showIcon = false;
      _startTimer();
    });
  }

  void _selectQuestionType(bool isMcq) {
    setState(() {
      _isMcq = isMcq;
      _questions = isMcq ? _mcqQuestions : _trueFalseQuestions;
      _currentQuestionIndex = 0;
      _score = 0;
      _showIcon = false;
      _startTimer();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Vibrant Quiz App'),
        backgroundColor: Colors.black,
      ),
      body: TweenAnimationBuilder(
        tween: ColorTween(
          begin: Colors.purpleAccent,
          end: Colors.blueAccent,
        ),
        duration: Duration(seconds: 3),
        builder: (context, Color? color, _) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [color!, Colors.purple],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Choose Question Type:',
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              onPressed: () => _selectQuestionType(false),
                              child: Text('True/False'),
                            ),
                            ElevatedButton(
                              onPressed: () => _selectQuestionType(true),
                              child: Text('MCQs'),
                            ),
                          ],
                        ),
                        SizedBox(height: 40),
                        if (_questions.isNotEmpty)
                          Column(
                            children: [
                              Text(
                                'Question ${_currentQuestionIndex + 1} of ${_questions.length}',
                                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 20),
                              Text(
                                _questions[_currentQuestionIndex].questionText,
                                style: TextStyle(fontSize: 20, color: Colors.white),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 20),
                              Text(
                                'Time Left: $_timeLeft seconds',
                                style: TextStyle(fontSize: 18, color: Colors.redAccent),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 20),
                              if (_isMcq)
                                ...(_questions[_currentQuestionIndex] as MCQuestion)
                                    .options
                                    .asMap()
                                    .entries
                                    .map((entry) {
                                  int index = entry.key;
                                  String option = entry.value;
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 5),
                                    child: ElevatedButton(
                                      onPressed: () => _checkMcqAnswer(index),
                                      child: Text(option),
                                    ),
                                  );
                                }).toList()
                              else ...[
                                ElevatedButton(
                                  onPressed: () => _checkAnswer(true),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.black,
                                    padding: EdgeInsets.symmetric(vertical: 15),
                                  ),
                                  child: Text('True', style: TextStyle(fontSize: 18, color: Colors.white)),
                                ),
                                SizedBox(height: 10),
                                ElevatedButton(
                                  onPressed: () => _checkAnswer(false),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.black,
                                    padding: EdgeInsets.symmetric(vertical: 15),
                                  ),
                                  child: Text('False', style: TextStyle(fontSize: 18, color: Colors.white)),
                                ),
                              ],
                              SizedBox(height: 20),
                              if (_showIcon)
                                Icon(
                                  _feedbackIcon,
                                  color: _feedbackIcon == Icons.check_circle ? Colors.green : Colors.red,
                                  size: 60,
                                ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

class Question {
  String questionText;
  bool answer;

  Question(this.questionText, this.answer);
}

class MCQuestion extends Question {
  List<String> options;
  int correctOptionIndex;

  MCQuestion(String questionText, this.options, this.correctOptionIndex)
      : super(questionText, true);
}
