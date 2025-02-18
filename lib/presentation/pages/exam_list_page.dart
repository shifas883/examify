import 'package:exam_app/presentation/pages/exam_page.dart';
import 'package:flutter/material.dart';
import '../../local_database/database_helper.dart';
import '../../utils/exam_card.dart';

class ExamListPage extends StatefulWidget {
  @override
  _ExamListPageState createState() => _ExamListPageState();
}

class _ExamListPageState extends State<ExamListPage> {
  List<Map<String, dynamic>> exams = [];
  String _searchQuery = '';
  String _selectedLevel = 'All Levels';

  final List<String> levels = [
    'All Levels',
    'Beginner',
    'Intermediate',
    'Advanced'
  ];

  @override
  void initState() {
    super.initState();
    _loadExams();
  }

  Future<void> _loadExams() async {
    final dbHelper = DatabaseHelper.instance;
    await dbHelper.insertSampleData();
    final data = await dbHelper.getExams();
    print("Exams from database: $data");
    setState(() {
      exams = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    final filteredExams = exams.where((exam) {
      final matchesSearch =
          exam['title'].toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesLevel =
          _selectedLevel == 'All Levels' || exam['level'] == _selectedLevel;
      return matchesSearch && matchesLevel;
    }).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.teal.shade500,
        title: Text(
          'Exam List',
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                SizedBox(
                    width: 200,
                    height: 50,
                    child: TextField(
                      onChanged: (value) {
                        setState(() {
                          _searchQuery = value;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'Search Exams...',
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.blue,
                              width: 2.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.teal.shade500,
                              width: 1.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.grey,
                              width: 0.5),
                        ),
                      ),
                    )
                    ),
                SizedBox(
                  width: 10,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(width: 0.5,color: Colors.grey)
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      DropdownButton<String>(
                        dropdownColor: Colors.white,
                        underline: Container(),
                        value: _selectedLevel,
                        onChanged: (value) {
                          setState(() {
                            _selectedLevel = value!;
                          });
                        },
                        items: levels.map((level) {
                          return DropdownMenuItem(
                            value: level,
                            child: Text(level),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Expanded(
              child: filteredExams.isEmpty
                  ? Center(child: Text('No exams found.'))
                  : ListView.builder(
                      itemCount: filteredExams.length,
                      itemBuilder: (context, index) {
                        return ExamCard(
                          question: filteredExams[index]['question'],
                          time: filteredExams[index]['time'],
                          title: filteredExams[index]['title'],
                          leval: filteredExams[index]['level'],
                          decription: filteredExams[index]['description'],
                          onTap: (){
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ExamPage(
                                  examId: filteredExams[index]['id'],
                                  title: filteredExams[index]['title'],
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
