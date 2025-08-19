const String tableStudent = "tbl_student";
const String tblStudentId = "id";
const String tblStudentName = "name";
const String tblStudentAge = "age";
const String tblStudentGender = "gender";
const String tblStudentClass = "class";
const String tblStudentDepartment = "department";
const String tblStudentMasterRemark = "masterRemark";
const String tblStudentMasterRemarkDate = "masterRemarkDate";
const String tblStudentPrincipalRemark = "principalRemark";
const String tblStudentPrincipalRemarkDate = "principalRemarkDate";
const String tblStudentAverageScore = "averageScore";
const String tblStudentTotalScore = "totalScore";
const String tblStudentNoInAttendance = "noInAttendance";


class StudentModel {
  final int? id;
  final String name;
  final int age;
  final String gender;
  final String studentClass;
  final String department;
  final double? averageScore;
  final double? totalScore;
  final String? mRemark;
  final String? mDate;
  final String? pRemark;
  final String? pDate;
  final int? noInAttendance;



  StudentModel({
    this.id,
    required this.name,
    required this.age,
    required this.gender,
    required this.studentClass,
    required this.department,
    this.averageScore,
    this.totalScore,
    this.mRemark,
    this.mDate,
    this.pRemark,
    this.pDate,
    this.noInAttendance,
  });

  Map<String, dynamic> toMap() {
    return {
      tblStudentName: name,
      tblStudentAge: age,
      tblStudentGender: gender,
      tblStudentClass: studentClass,
      tblStudentDepartment: department,
    };
  }

  factory StudentModel.formMap(Map<String, dynamic> map) {
    return StudentModel(
      id: map[tblStudentId],
      name: map[tblStudentName],
      age: map[tblStudentAge],
      gender: map[tblStudentGender],
      studentClass: map[tblStudentClass],
      department: map[tblStudentDepartment],
      averageScore: map[tblStudentAverageScore],
      totalScore: map[tblStudentTotalScore],
      mRemark: map[tblStudentMasterRemark],
      mDate: map[tblStudentMasterRemarkDate],
      pRemark: map[tblStudentPrincipalRemark],
      pDate: map[tblStudentPrincipalRemarkDate],
      noInAttendance: map[tblStudentNoInAttendance]
    );
  }
}
