import 'package:classreportsheet/model/behaviour_model.dart';
import 'package:classreportsheet/model/skill_model.dart';
import 'package:classreportsheet/model/student_model.dart';
import 'package:classreportsheet/model/subject_model.dart';
import 'package:classreportsheet/pages/student_scenes/student_detail.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;
import 'package:sqflite/utils/utils.dart' as sqflite;

class DbHelper {
  final String _createSkillTable =
      """create table $tableSkill(
  $tblSkillId integer primary key autoincrement,
  $tblSkillStudentId integer,
  $tblSkillHandwriting integer,
  $tblSkillFluency integer,
  $tblSkillGame integer,
  $tblSkillSport integer,
  $tblSkillGymnastic integer,
  $tblSkillHandlingOfTools integer,
  $tblSkillDrawingAndPainting integer,
  $tblSkillCrafts integer,
  $tblSkillMusicalSkill integer,
  foreign key ($tblSkillStudentId) references $tableStudent($tblStudentId) on delete cascade
  )
  """;

  final String _createBehaviourTable =
      """create table $tableBehaviour(
  $tblBehaviourId integer primary key autoincrement,
  $tblBehaviourStudentId integer,
  $tblBehaviourPunctuality integer,
  $tblBehaviourAttendance integer,
  $tblBehaviourReliability integer,
  $tblBehaviourNeatness integer,
  $tblBehaviourPoliteness integer,
  $tblBehaviourHonesty integer,
  $tblBehaviourRelationshipWithStaff integer,
  $tblBehaviourRelationshipWithStudents integer,
  $tblBehaviourSelfControl integer,
  $tblBehaviourSpiritOfCooperation integer,
  $tblBehaviourSenseOfResponsibility integer,
  $tblBehaviourAttentiveness integer,
  $tblBehaviourInitiative integer,
  $tblBehaviourOrganisationAbility integer,
  $tblBehaviourPerserverance integer,
  $tblBehaviourPhysicalDev integer,
  
  foreign key ($tblBehaviourStudentId) references $tableStudent($tblStudentId) on delete cascade
  
  )
  """;

  final String _createStudentTable =
      """create table $tableStudent(
      $tblStudentId integer primary key autoincrement, 
      $tblStudentName text, 
      $tblStudentAge integer,
      $tblStudentGender text,
      $tblStudentClass text,
      $tblStudentDepartment text,
      $tblStudentAverageScore double,
      $tblStudentTotalScore double,
      $tblStudentMasterRemark text,
      $tblStudentMasterRemarkDate text,
      $tblStudentPrincipalRemark text,
      $tblStudentPrincipalRemarkDate text,
      $tblStudentNoInAttendance integer
      )""";

  final String _createSubjectTable =
      """create table $tableSubject(
  $tblSubjectId integer primary key autoincrement,
  $tblSubjectStudentId integer,
  $tblSubjectName text,
  $tblSubject1CA double,
  $tblSubject2CA double,
  $tblSubjectExam double,
  $tblSubjectScore double,
  $tblSubjectHighestInClass double,
  $tblSubjectLowestInClass double,
  $tblSubjectAverageInClass double,
  foreign key($tblSubjectStudentId) references $tableStudent($tblStudentId) on delete cascade)""";

  Future<Database> _openSkillDb() async {
    final root = await getDatabasesPath();
    String dbPath = p.join(root, "skill.db");

    return openDatabase(
      dbPath,
      version: 1,
      onCreate: (db, version) {
        db.execute(_createSkillTable);
      },
    );
  }

  Future<Database> _openBehaviourDb() async {
    final root = await getDatabasesPath();
    String dbPath = p.join(root, "behaviour.db");

    return openDatabase(
      dbPath,
      version: 1,
      onCreate: (db, version) {
        db.execute(_createBehaviourTable);
      },
    );
  }

  Future<Database> _openStudentDb() async {
    final root = await getDatabasesPath();
    String dbPath = p.join(root, "student.db");

    return openDatabase(
      dbPath,
      version: 1,
      onCreate: (db, version) {
        db.execute(_createStudentTable);
      },
    );
  }

  Future<Database> _openSubjectDb() async {
    final root = await getDatabasesPath();
    String dbPath = p.join(root, "subject.db");

    return openDatabase(
      dbPath,
      version: 1,
      onCreate: (db, version) {
        db.execute(_createSubjectTable);
      },
    );
  }

  Future<int> insertStudentSkill(SkillModel skillModel) async {
    Database db = await _openSkillDb();
    return db.insert(tableSkill, skillModel.toMap());
  }

  Future<int> insertStudentBehaviour(BehaviorModel behaviourModel) async {
    Database db = await _openBehaviourDb();
    return db.insert(tableBehaviour, behaviourModel.toMap());
  }

  Future<int> insertStudent(StudentModel studentModel) async {
    Database db = await _openStudentDb();
    return db.insert(tableStudent, studentModel.toMap());
  }

  Future<void> insertSubject(List<String> subjects, int studentId) async {
    Database db = await _openSubjectDb();
    for (var subject in subjects) {
      final subjectModel = SubjectModel(
        studentId: studentId,
        subjectName: subject,
      );
      await db.insert(tableSubject, subjectModel.toMap());
    }
  }

  Future<List<StudentModel>> getAllStudentInAClass(String cls, String order) async {
    final db = await _openStudentDb();

    final mapList = await db.query(
      tableStudent,
      where: "$tblStudentClass = ?",
      whereArgs: [cls],
      orderBy: order,
    );
    return mapList.map((e) => StudentModel.formMap(e)).toList();
  }

  Future<int> deleteStudent(int id) async {
    Database db = await _openStudentDb();
    return db.delete(tableStudent, where: "$tblStudentId = ?", whereArgs: [id]);
  }

  Future<StudentModel> getLastStudent() async {
    Database db = await _openStudentDb();
    final mapList = await db.query(tableStudent);
    return StudentModel.formMap(mapList.last);
  }

  Future<List<String>> getStudentSubjectById(int id) async {
    Database db = await _openSubjectDb();
    final List<Map<String, dynamic>> mapList = await db.query(
      columns: [tblSubjectName],
      tableSubject,
      where: "$tblSubjectStudentId = ?",
      whereArgs: [id],
    );
    return List.generate(
      mapList.length,
      (index) => mapList[index][tblSubjectName] as String,
    );
  }

  Future<int> deleteStudentSubjects(int id) async {
    Database db = await _openSubjectDb();
    return db.delete(
      tableSubject,
      where: "$tblSubjectStudentId = ?",
      whereArgs: [id],
    );
  }

  Future<int> deleteOldStudentSubject(int id, List<String> subjects) async {
    final db = await _openSubjectDb();
    final placeHolder = List.filled(subjects.length, "?").join(",");

    return db.delete(
      tableSubject,
      where: "$tblSubjectName in ($placeHolder) and $tblSubjectStudentId = ?",
      whereArgs: [...subjects, id],
    );
  }

  Future<List<int>> _getIdBySubject(
    String subject,
    List<int> studentIds,
  ) async {
    Database db = await _openSubjectDb();

    final placeHolder = List.filled(studentIds.length, "?").join(",");

    final mapList = await db.query(
      tableSubject,
      columns: [tblSubjectStudentId],
      where: "$tblSubjectStudentId in ($placeHolder) and $tblSubjectName = ?",
      whereArgs: [...studentIds, subject],
    );
    return mapList.map((e) => e[tblSubjectStudentId] as int).toList();
  }

  Future<List<int>> _getIdByClass(Database db, String cls) async {
    //Database db = await _openStudentDb();
    final mapList = await db.query(
      tableStudent,
      columns: [tblStudentId],
      where: "$tblStudentClass = ?",
      whereArgs: [cls],
    );
    if (mapList.isEmpty) return [];
    return mapList.map((e) => e[tblStudentId] as int).toList();
  }

  Future<Map<int, List<dynamic>>> _getClassReportCard(String cls) async {
    Database studentDb = await _openStudentDb();
    Database subjectDb = await _openSubjectDb();
    Database skillDb = await _openSkillDb();
    Database behaviourDb = await _openBehaviourDb();

    Map<int, List<dynamic>> classData = {};

    List<int> studentIds = await _getIdByClass(studentDb, cls);

    if (studentIds.isEmpty) return classData;
    int index = 0;
    for (var id in studentIds) {
      classData[index] = [
        await _getStudentById(studentDb, id),
        await _getStudentSubjectData(subjectDb, id),
        await _getStudentSkill(skillDb, id),
        await _getStudentBehaviour(behaviourDb, id),
      ];
      index++;
    }

    return classData;
  }

  Future<List<SubjectModel>> _getStudentSubjectData(Database db, int id) async {
    final mapList = await db.query(
      tableSubject,
      where: "$tblSubjectStudentId = ?",
      whereArgs: [id],
    );
    return mapList.map((e) => SubjectModel.fromMap(e)).toList();
  }

  Future<StudentModel> _getStudentById(Database db, int id) async {
    final mapList = await db.query(
      tableStudent,
      where: "$tblStudentId = ?",
      whereArgs: [id],
    );
    return StudentModel.formMap(mapList.first);
  }

  Future<SkillModel> _getStudentSkill(Database db, int id) async {
    final mapList = await db.query(
      tableSkill,
      where: "$tblSkillStudentId = ?",
      whereArgs: [id],
    );
    return SkillModel.fromMap(mapList.first);
  }

  Future<BehaviorModel> _getStudentBehaviour(Database db, int id) async {
    final mapList = await db.query(
      tableBehaviour,
      where: "$tblBehaviourStudentId = ?",
      whereArgs: [id],
    );
    return BehaviorModel.fromMap(mapList.first);
  }

  Future<List<dynamic>> getStudentSubjectRecords(
    String subject,
    String cls,
  ) async {
    Database studentDb = await _openStudentDb();
    Database subjectDb = await _openSubjectDb();
    List<dynamic> data = [];
    List<int> studentIds = await _getIdByClass(studentDb, cls);

    if (studentIds.isEmpty) return [];

    studentIds = await _getIdBySubject(subject, studentIds);

    if (studentIds.isEmpty) return [];

    final placeHolder = List.filled(studentIds.length, "?").join(",");
    final studentList = await studentDb.query(
      tableStudent,
      where: "$tblStudentId in ($placeHolder) and $tblStudentClass = ?",
      orderBy: tblStudentId,
      whereArgs: [...studentIds, cls],
    );

    final subjectsScoreList = await subjectDb.query(
      tableSubject,
      where: "$tblSubjectStudentId in ($placeHolder) and $tblSubjectName = ?",
      whereArgs: [...studentIds, subject],
      orderBy: tblSubjectStudentId,
    );
    data.add(studentList.map((e) => StudentModel.formMap(e)).toList());
    data.add(subjectsScoreList.map((e) => SubjectModel.fromMap(e)).toList());

    return data;
  }

  double _getMinOfScores(List<double> scores) {
    return (scores.reduce((a, b) => a < b ? a : b));
  }

  double _getMaxOfScores(List<double> scores) {
    return (scores.reduce((a, b) => a > b ? a : b));
  }

  double _getAverageOfScores(List<double> scores) {
    final total = scores.fold<double>(0, (sum, score) => sum + score);
    final avg = double.tryParse((total / scores.length).toStringAsFixed(2));
    return avg!;
  }

  Future<int> updateSubjectClassMaxMinAndAverage(
    List<StudentModel> studentList,
    String subject,
  ) async {
    // Database studentDb = await _openStudentDb();
    Database subjectDb = await _openSubjectDb();
    List<int> studentIds = [];
    for (var student in studentList) {
      studentIds.add(student.id!);
    }
    final placeHolder = List.filled(studentIds.length, "?").join(",");

    final subjectsScoreList = await subjectDb.query(
      tableSubject,
      columns: [tblSubjectScore],
      where: "$tblSubjectStudentId in ($placeHolder) and $tblSubjectName = ?",
      whereArgs: [...studentIds, subject],
    );

    final List<double> listOfScores = subjectsScoreList.map((e) {
      if (e[tblSubjectScore] != null) {
        return e[tblSubjectScore] as double;
      }
      return 0.0;
    }).toList();

    final max = _getMaxOfScores(listOfScores);
    final min = _getMinOfScores(listOfScores);
    final avg = _getAverageOfScores(listOfScores);

    return subjectDb.update(
      tableSubject,
      {
        tblSubjectHighestInClass: max,
        tblSubjectLowestInClass: min,
        tblSubjectAverageInClass: avg,
      },
      where: "$tblSubjectStudentId in ($placeHolder) and $tblSubjectName = ?",
      whereArgs: [...studentIds, subject],
    );
  }

  Future<Map<String, List<dynamic>>> mapOfStudentSubjectRecords(
    String subject,
    List<String> classes,
  ) async {
    Map<String, List<dynamic>> records = {};
    for (var cl in classes) {
      await getStudentSubjectRecords(subject, cl).then((value) {
        if (value.isNotEmpty) {
          records[cl] = value;
        } else {
          records[cl] = [];
        }
      });
    }
    return records;
  }

  Future<Map<String, Map<int, List<dynamic>>>> mapOfClassCardReport(
    List<String> cls,
  ) async {
    Map<String, Map<int, List<dynamic>>> records = {};
    Map<int, List<dynamic>> emptyRecord = {};

    for (var cl in cls) {
      await _getClassReportCard(cl).then((value) {
        if (value.isNotEmpty) {
          records[cl] = value;
        } else {
          records[cl] = emptyRecord;
        }
      });
    }

    return records;
  }

  Future<int> updateScore(int id, String subject, List<double> scores) async {
    final db = await _openSubjectDb();
    return db.update(
      tableSubject,
      {
        tblSubject1CA: scores[0],
        tblSubject2CA: scores[1],
        tblSubjectExam: scores[2],
        tblSubjectScore: scores[3],
      },
      where: "$tblSubjectStudentId = ? and $tblSubjectName = ?",
      whereArgs: [id, subject],
    );
  }

  Future<int> updateStudentRecords(int id, StudentModel studentInfo) async {
    final db = await _openStudentDb();
    return db.update(
      tableStudent,
      studentInfo.toMap(),
      where: "$tblStudentId = ?",
      whereArgs: [id],
    );
  }

  Future<int> updateStudentSkillRecord(SkillModel skillInfo) async {
    Database db = await _openSkillDb();
    return db.update(
      tableSkill,
      {
        tblSkillHandwriting: skillInfo.handwriting,
        tblSkillFluency: skillInfo.fluency,
        tblSkillGame: skillInfo.game,
        tblSkillSport: skillInfo.sport,
        tblSkillGymnastic: skillInfo.gymnastic,
        tblSkillHandlingOfTools: skillInfo.handlingOfTools,
        tblSkillDrawingAndPainting: skillInfo.drawingAndPainting,
        tblSkillCrafts: skillInfo.crafts,
        tblSkillMusicalSkill: skillInfo.musicalSkill,
      },
      where: "$tblSkillStudentId = ?",
      whereArgs: [skillInfo.studentId],
    );
  }

  Future<int> updateStudentBehaviourRecord(BehaviorModel behaviourInfo) async {
    Database db = await _openBehaviourDb();

    return db.update(
      tableBehaviour,
      {
        tblBehaviourPunctuality: behaviourInfo.punctuality,
        tblBehaviourAttendance: behaviourInfo.attendance,
        tblBehaviourReliability: behaviourInfo.reliability,
        tblBehaviourNeatness: behaviourInfo.neatness,
        tblBehaviourPoliteness: behaviourInfo.politeness,
        tblBehaviourHonesty: behaviourInfo.honesty,
        tblBehaviourRelationshipWithStaff: behaviourInfo.relationshipWithStaff,
        tblBehaviourRelationshipWithStudents:
            behaviourInfo.relationshipWithStudents,
        tblBehaviourSelfControl: behaviourInfo.selfControl,
        tblBehaviourSpiritOfCooperation: behaviourInfo.spiritOfCooperation,
        tblBehaviourSenseOfResponsibility: behaviourInfo.senseOfResponsibility,
        tblBehaviourAttentiveness: behaviourInfo.attentiveness,
        tblBehaviourInitiative: behaviourInfo.initiative,
        tblBehaviourOrganisationAbility: behaviourInfo.organizationAbility,
        tblBehaviourPerserverance: behaviourInfo.perseverance,
        tblBehaviourPhysicalDev: behaviourInfo.physicalDev,
      },
      where: "$tblBehaviourStudentId = ?",
      whereArgs: [behaviourInfo.studentId],
    );
  }

  Future<int> updateStudentRemarks(StudentModel studentInfo) async {
    Database db = await _openStudentDb();

    return db.update(
      tableStudent,
      {
        tblStudentPrincipalRemark: studentInfo.pRemark,
        tblStudentPrincipalRemarkDate: studentInfo.pDate,
        tblStudentMasterRemark: studentInfo.mRemark,
        tblStudentMasterRemarkDate: studentInfo.mDate,
        tblStudentTotalScore: studentInfo.totalScore,
        tblStudentAverageScore: studentInfo.averageScore,
        tblStudentNoInAttendance: studentInfo.noInAttendance,
      },
      where: "$tblStudentId = ?",
      whereArgs: [studentInfo.id],
    );
  }

  Future<List<int>> numberOfStudent(List<String> subjects) async {
    final db = await _openSubjectDb();
    List<int> num = [];
    for (var subject in subjects) {
      final mapList = await db.query(
        tableSubject,
        where: "$tblSubjectName = ?",
        whereArgs: [subject],
      );
      num.add(mapList.length);
    }
    return num;
  }

  Future<int> totalNumberOfStudent() async {
    final db = await _openStudentDb();
    final total = sqflite.firstIntValue(
      await db.rawQuery("select count (*) from $tableStudent"),
    );
    return total ?? 0;
  }

  Future<Map<String, List<StudentModel>>> getAllStudent(
    List<String> cls,
    String order
  ) async {
    Map<String, List<StudentModel>> studentList = {};
    //final db = await _openStudentDb();
    for (var cl in cls) {
      studentList[cl] = await getAllStudentInAClass(cl, order);
    }

    return studentList;
  }
}
