import 'dart:async';

import 'package:flutter/material.dart';

import '../../local_database/database_helper.dart';
import '../../utils/buttons.dart';
import 'exam_result_page.dart';

class ExamPage extends StatefulWidget {
  final int examId;
  final String title;

  ExamPage({required this.examId, required this.title});

  @override
  _ExamPageState createState() => _ExamPageState();
}

class _ExamPageState extends State<ExamPage> {
  List<Map<String, dynamic>> questions = [];
  int _currentQuestionIndex = 0;
  int _correctAnswers = 0;
  int _selectedOption = -1;
  late Timer _timer;
  int _remainingTime = 120;

  @override
  void initState() {
    super.initState();
    _loadQuestions();
    _startTimer();
  }

  Future<void> _loadQuestions() async {
    final dbHelper = DatabaseHelper.instance;
    final data = await dbHelper.getQuestions(widget.examId);
    setState(() {
      questions = data;
    });
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_remainingTime > 0) {
        setState(() {
          _remainingTime--;
        });
      } else {
        _timer.cancel();
        _showResults();
      }
    });
  }

  void _submitAnswer() {
    var currentQuestion = questions[_currentQuestionIndex];

    int correctAnswer = currentQuestion['correctAnswer'];

    if (_selectedOption == correctAnswer) {
      _correctAnswers++;
    }

    if (_currentQuestionIndex < questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
        _selectedOption = -1;
      });
    } else {
      _timer.cancel();
      _showResults();
    }
  }

  void _showResults() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ExamResultsPage(
          totalQuestions: questions.length,
          correctAnswers: _correctAnswers,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (questions.isEmpty) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.teal.shade500,
          title: Text(
            widget.title,
            style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white),
          ),
        ),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    var currentQuestion = questions[_currentQuestionIndex];
    var options = currentQuestion['options'].toString().split(',');

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.teal.shade500,
        title: Text(
          widget.title,
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white),
        ),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios_new_outlined,
              color: Colors.white,
            )),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16.0),
            margin: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
                border: Border.all(color: Colors.grey, width: 0.5),
                borderRadius: BorderRadius.circular(5)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.title,
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                    ),
                    Row(
                      children: [
                        Icon(Icons.timer_outlined),
                        SizedBox(
                          width: 10,
                        ),
                        Text('$_remainingTime',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.red)),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Text('Question ${_currentQuestionIndex + 1}:',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey)),
                SizedBox(height: 10),
                Text(currentQuestion['question'],
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                SizedBox(height: 20),
                ...List.generate(options.length, (index) {
                  return RadioListTile(
                    title: Text(options[index]),
                    value: index,
                    groupValue: _selectedOption,
                    onChanged: (value) {
                      setState(() {
                        _selectedOption = value as int;
                      });
                    },
                  );
                }),
              ],
            ),
          ),
          Spacer(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ConfirmButton(
              text: "Submit Answer",
              onTap: _selectedOption == -1 ? null : _submitAnswer,
            ),
          )
        ],
      ),
    );
  }
}
