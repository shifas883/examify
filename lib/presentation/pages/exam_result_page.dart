import 'package:exam_app/presentation/pages/exam_list_page.dart';
import 'package:exam_app/utils/buttons.dart';
import 'package:flutter/material.dart';

class ExamResultsPage extends StatelessWidget {
  final int totalQuestions;
  final int correctAnswers;

  ExamResultsPage({required this.totalQuestions, required this.correctAnswers});

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    double percentageScore = (correctAnswers / totalQuestions) * 100;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.teal.shade500,
        title: Text(
          "Exam Result",
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white),
        ),
        leading: IconButton(
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => ExamListPage()),
                (route) => false,
              );
            },
            icon: Icon(
              Icons.arrow_back_ios_new_outlined,
              color: Colors.white,
            )),
      ),
      body: Column(
        children: [
          Center(
            child: Container(
              width: width,
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(width: 0.5, color: Colors.grey),
                  borderRadius: BorderRadius.circular(10)),
              margin: const EdgeInsets.all(16.0),
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Your Score: ${percentageScore.toStringAsFixed(2)}%',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Text('Correct Answers: $correctAnswers',
                      style: TextStyle(fontSize: 16)),
                  Text('Total Questions: $totalQuestions',
                      style: TextStyle(fontSize: 16)),
                  SizedBox(height: 20),
                  Container(
                    width: width / 2.5,
                    child: ConfirmButton(
                      onTap: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ExamListPage()),
                          (route) => false,
                        );
                      },
                      text: 'Back to Exam List',
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
