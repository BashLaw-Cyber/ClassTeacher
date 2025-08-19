
import 'package:classreportsheet/db/db_helper.dart';
import 'package:classreportsheet/model/skill_model.dart';
import 'package:classreportsheet/model/student_model.dart';
import 'package:flutter/cupertino.dart';

import '../model/behaviour_model.dart';
import '../model/subject_model.dart';

class StudentProvider extends ChangeNotifier {
  List<StudentModel> studentList = [];
  List<SubjectModel> subjectList = [];
  SubjectModel? subjectScore;
  List<int> numberOfStudent = [];
  int? totalNoStudent;

  final db = DbHelper();

  Future<void> insertStudent(StudentModel studentModel) async {
    await db.insertStudent(studentModel);
    // getAllStudent();
    // notifyListeners();
  }

  Future<List<StudentModel>> getAllStudentInAClass(String cls) async {
    return db.getAllStudentInAClass(cls);
  }

  Future<void> deleteStudent(int id) async {
    await db.deleteStudent(id);
    await db.deleteStudentSubjects(id);
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

  Future<Map<String, Map<int,List<dynamic>>>> mapOfClassCardReport(List<String> cls)async {
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

  Future<int> totalStudent()async {
    return await db.totalNumberOfStudent();
  }
  get getTotal=> totalNoStudent;
}
