import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._internal();
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'exam_app.db');
    return await openDatabase(
      path,
      version: 2,
      onCreate: (db, version) {
        db.execute(
          'CREATE TABLE exams (id INTEGER PRIMARY KEY, title TEXT, level TEXT, description TEXT, time TEXT, question TEXT)',
        );
        db.execute(
          'CREATE TABLE questions (id INTEGER PRIMARY KEY, examId INTEGER, question TEXT, options TEXT, correctAnswer INTEGER)',
        );
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute('ALTER TABLE exams ADD COLUMN level TEXT');
        }
      },
    );
  }

  Future<void> insertSampleData() async {
    final db = await database;

    List<Map<String, dynamic>> existingExams = await db.query('exams');
    if (existingExams.isEmpty) {
      await db.insert('exams', {
        'id': 1,
        'title': 'Math Exam',
        'level': 'Beginner',
        'description': 'New Maths Exam For Beginners',
        'time': '4 Minutes',
        'question': '2'
      });
      await db.insert('questions', {
        'examId': 1,
        'question': 'What is 2 + 2?',
        'options': '1,2,3,4',
        'correctAnswer': 3
      });
      await db.insert('questions', {
        'examId': 1,
        'question': 'What is 10 - 5?',
        'options': '2,5,10,0',
        'correctAnswer': 1
      });

      await db.insert('exams', {
        'id': 2,
        'title': 'Science Exam',
        'level': 'Intermediate',
        'description': 'New Science Exam For Beginners',
        'time': '2 Minutes',
        'question': '1'
      });
      await db.insert('questions', {
        'examId': 2,
        'question': 'What planet is closest to the sun?',
        'options': 'Earth,Mars,Mercury,Venus',
        'correctAnswer': 2
      });
    }
  }

  Future<List<Map<String, dynamic>>> getExams() async {
    final db = await database;
    return await db.query('exams');
  }

  Future<List<Map<String, dynamic>>> getQuestions(int examId) async {
    final db = await database;
    return await db
        .query('questions', where: 'examId = ?', whereArgs: [examId]);
  }
}
