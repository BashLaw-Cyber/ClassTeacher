import 'dart:collection';

import 'package:classreportsheet/db/db_helper.dart';
import 'package:classreportsheet/db/hive_db.dart';
import 'package:classreportsheet/model/skill_model.dart';
import 'package:classreportsheet/model/student_model.dart';
import 'package:flutter/cupertino.dart';

import '../model/behaviour_model.dart';
import '../model/subject_model.dart';

class StudentProvider extends ChangeNotifier {
  String _orderBy = tblStudentName;
  Map<String, List<StudentModel>> studentList = {};
  List<SubjectModel> subjectList = [];
  SubjectModel? subjectScore;
  List<int> numberOfStudent = [];
  int totalNoStudent = 0;
  UnmodifiableListView<StudentModel> get allStudent =>
      UnmodifiableListView(studentList.values.expand((e) => e));

  final db = DbHelper();

  String get orderBy => _orderBy;

  void setOrderBy(String order) {
    if (order == _orderBy) return;
    _orderBy = order;
    // final cls = getAllClasses();
    // for (var cl in cls) {
    //   switch (_orderBy) {
    //     case tblStudentName:
    //       studentList[cl]!.toList().sort((a, b) => a.name.compareTo(b.name));
    //       break;
    //     case tblStudentId:
    //       studentList[cl]!.toList().sort((a, b) => a.id!.compareTo(b.id!));
    //       break;
    //     case tblStudentAverageScore:
    //       studentList[cl]!.toList().sort(
    //         (a, b) => a.averageScore!.compareTo(b.averageScore!),
    //       );
    //       break;
    //   }
    // }
    //notifyListeners();
    getAllStudent();
  }

  Future<void> insertStudent(StudentModel studentModel) async {
    await db.insertStudent(studentModel);
    getAllStudent();
    getTotalStudent();
  }

  Future<List<StudentModel>> getAllStudentInAClass(String cls) async {
    return db.getAllStudentInAClass(cls, _orderBy);
  }

  // New approach
  Future<void> getAllStudent() async {
    final cls = getAllClasses();
    studentList = await db.getAllStudent(cls, _orderBy);
    notifyListeners();
  }

  Future<void> deleteStudent(int id) async {
    await db.deleteStudent(id);
    await db.deleteStudentSubjects(id);
    getAllStudent();
    getTotalStudent();
  }

  Future<void> insertSubject(List<String> subjects, int studentId) async {
    await db.insertSubject(subjects, studentId);
  }

  Future<void> insertStudentBehaviour(BehaviorModel behaviourModel) async {
    await db.insertStudentBehaviour(behaviourModel);
  }

  Future<void> insertStudentSkill(SkillModel skillModel) async {
    await db.insertStudentSkill(skillModel);
  }

  Future<List<String>> getStudentSubjectById(int id) =>
      db.getStudentSubjectById(id);

  Future<int> deleteOldStudentSubject(int id, List<String> subjects) =>
      db.deleteOldStudentSubject(id, subjects);

  Future<StudentModel> getLastStudent() => db.getLastStudent();

  Future<void> updateScore(int id, String subject, List<double> scores) async {
    await db.updateScore(id, subject, scores);
  }

  Future<Map<String, List<dynamic>>> mapOfStudentSubjectRecords(
    String subject,
    List<String> cls,
  ) async {
    return db.mapOfStudentSubjectRecords(subject, cls);
  }

  Future<Map<String, Map<int, List<dynamic>>>> mapOfClassCardReport(
    List<String> cls,
  ) async {
    return db.mapOfClassCardReport(cls);
  }

  Future<void> getNumberOfStudent(List<String> subjects) async {
    numberOfStudent = await db.numberOfStudent(subjects);
    notifyListeners();
  }

  Future<int> updateSubjectClassMaxMinAndAverage(
    List<StudentModel> studentList,
    String subject,
  ) async {
    return db.updateSubjectClassMaxMinAndAverage(studentList, subject);
  }

  Future<int> updateStudentBehaviorRecord(BehaviorModel behaviourInfo) async {
    return db.updateStudentBehaviourRecord(behaviourInfo);
  }

  Future<int> updateStudentRemarks(StudentModel studentInfo) async {
    return db.updateStudentRemarks(studentInfo);
  }

  Future<int> updateStudentSkillRecord(SkillModel skillInfo) async {
    return db.updateStudentSkillRecord(skillInfo);
  }

  Future<int> updateStudentRecords(int id, StudentModel studentInfo) async {
    return db.updateStudentRecords(id, studentInfo);
  }

  Future<void> getTotalStudent() async {
    totalNoStudent = await db.totalNumberOfStudent();
    notifyListeners();
  }
}
