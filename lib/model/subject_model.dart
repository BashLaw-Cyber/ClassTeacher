const String tableSubject = "tbl_subject";
const String tblSubjectId = "id";
const String tblSubjectStudentId = "studentId";
const String tblSubjectName = "subjectName";
const String tblSubject1CA = "subject1CA";
const String tblSubject2CA = "subject2CA";
const String tblSubjectExam = "subjectExam";
const String tblSubjectScore = "subjectScore";
const String tblSubjectHighestInClass = "heighestInClass";
const String tblSubjectLowestInClass = "lowestInClass";
const String tblSubjectAverageInClass = "averageInClass";

class SubjectModel {
  final int? id;
  final int studentId;
  final String subjectName;
  double? ca1;
  double? ca2;
  double? exam;
  double? score;
  double? heighestInClass;
  double? lowestInClass;
  double? averageInClass;

  SubjectModel({
    this.id,
    required this.studentId,
    required this.subjectName,
    this.ca1,
    this.ca2,
    this.exam,
    this.score,
    this.heighestInClass,
    this.lowestInClass,
    this.averageInClass,
  });

  Map<String, dynamic> toMap() {
    return {tblSubjectStudentId: studentId, tblSubjectName: subjectName};
  }

  factory SubjectModel.fromMap(Map<String, dynamic> map) {
    return SubjectModel(
      id: map[tblSubjectId],
      studentId: map[tblSubjectStudentId],
      subjectName: map[tblSubjectName],
      ca1: map[tblSubject1CA],
      ca2: map[tblSubject2CA],
      exam: map[tblSubjectExam],
      score: map[tblSubjectScore],
      heighestInClass: map[tblSubjectHighestInClass],
      lowestInClass: map[tblSubjectLowestInClass],
      averageInClass: map[tblSubjectAverageInClass],
    );
  }
}
