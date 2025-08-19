import 'package:classreportsheet/model/behaviour_model.dart';
import 'package:classreportsheet/model/skill_model.dart';
import 'package:classreportsheet/model/student_model.dart';
import 'package:classreportsheet/model/subject_model.dart';
import 'package:classreportsheet/providers/student_provider.dart';
import 'package:classreportsheet/util/helpful_functions.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class BatchAssessment extends StatefulWidget {
  final Map<int, List<dynamic>> studentsInClass;
  final String cls;
  const BatchAssessment({
    super.key,
    required this.studentsInClass,
    required this.cls,
  });
  @override
  State<BatchAssessment> createState() => _BatchAssessmentState();
}

class _BatchAssessmentState extends State<BatchAssessment> {
  late String cls;
  late Map<int, List<dynamic>> studentsInClass;
  int index = 0;

  List<String> skillName = [
    "Handwriting",
    "Fluency",
    "Game",
    "Sport",
    "Gymnastic",
    "Handling oof tools",
    "Drawing & Painting",
    "Crafts",
    "Musical Skill",
  ];

  List<String> behaviourName = [
    "Punctuality",
    "Attendance at class",
    "Reliability",
    "Neatness",
    "Politeness",
    "Honesty",
    "Relationship with staff",
    "Relationship with other students",
    "Self-control",
    "Spirit of co-operation",
    "Sense of Responsibility",
    "Attentiveness",
    "Initiative",
    "Organization Ability",
    "Perseverance",
    "Physical Dev",
  ];

  late Map<int, List<int>> skillValues = {};
  late Map<int, List<int>> behaviorValues = {};
  double totalMarks = 0.0;
  double average = 0.0;

  late final Map<int, TextEditingController> _masterRemarksController = {};
  late final Map<int, TextEditingController> _principalRemarksController = {};
  late final Map<int, TextEditingController> _masterRemarksControllerDate = {};
  late final Map<int, TextEditingController> _principalRemarksControllerDate =
      {};
  late final Map<int, TextEditingController> _studentNoInAttendanceController =
      {};

  @override
  void initState() {
    cls = widget.cls;
    studentsInClass = widget.studentsInClass;
    for (int index = 0; index < studentsInClass.length; index++) {
      final student = studentsInClass[index]![0];
      final skill = studentsInClass[index]![2];
      final behavior = studentsInClass[index]![3];
      skillValues[index] = [
        skill.handwriting ?? 1,
        skill.fluency ?? 1,
        skill.game ?? 1,
        skill.sport ?? 1,
        skill.gymnastic ?? 1,
        skill.handlingOfTools ?? 1,
        skill.drawingAndPainting ?? 1,
        skill.crafts ?? 1,
        skill.musicalSkill ?? 1,
      ];
      behaviorValues[index] = [
        behavior.punctuality ?? 1,
        behavior.attendance ?? 1,
        behavior.reliability ?? 1,
        behavior.neatness ?? 1,
        behavior.politeness ?? 1,
        behavior.honesty ?? 1,
        behavior.relationshipWithStaff ?? 1,
        behavior.relationshipWithStudents ?? 1,
        behavior.selfControl ?? 1,
        behavior.spiritOfCooperation ?? 1,
        behavior.senseOfResponsibility ?? 1,
        behavior.attentiveness ?? 1,
        behavior.initiative ?? 1,
        behavior.organizationAbility ?? 1,
        behavior.perseverance ?? 1,
        behavior.physicalDev ?? 1,
      ];

      _masterRemarksController[index] = TextEditingController(
        text: student.mRemark ?? "",
      );
      _principalRemarksController[index] = TextEditingController(
        text: student.pRemark ?? "",
      );
      _principalRemarksControllerDate[index] = TextEditingController(
        text: student.pDate ?? "",
      );
      _masterRemarksControllerDate[index] = TextEditingController(
        text: student.mDate ?? "",
      );
      _studentNoInAttendanceController[index] = TextEditingController(
        text: student.noInAttendance.toString(),
      );
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("$cls students assessments")),
      body: Column(
        children: [
          _buildStudentInfoSection(index),
          currentStudentAssessments(index),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: index > 0
                    ? () {
                        // perform some operation
                        final currentStudent = studentsInClass[index]![0];
                        updateAllRecords(index, currentStudent);
                        setState(() {
                          index--;
                        });
                      }
                    : null,
                icon: Icon(Icons.arrow_back_ios_new_sharp),
              ),
              IconButton(
                onPressed: index < (studentsInClass.length - 1)
                    ? () {
                        // perform some operation
                        final currentStudent = studentsInClass[index]![0];
                        updateAllRecords(index, currentStudent);
                        setState(() {
                          index++;
                        });
                      }
                    : null,
                icon: Icon(Icons.arrow_forward_ios_sharp),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget currentStudentAssessments(int index) {
    List<SubjectModel> subjects = studentsInClass[index]![1];
    return Expanded(
      child: ListView(
        children: [
          const SizedBox(height: 24),
          _buildResultTable(subjects),
          const SizedBox(height: 24),
          _buildSkillAssessmentSection(context, skillValues, index),
          const SizedBox(height: 24),
          _buildBehaviorAssessmentSection(context, behaviorValues, index),
          const SizedBox(height: 24),
          _buildSummarySection(subjects),
          const SizedBox(height: 24),
          _buildMasterRemarks(index),
          const SizedBox(height: 24),
          _buildPrincipalRemarks(index),
        ],
      ),
    );
  }

  void updateAllRecords(int index, StudentModel currentStudent) {
    final provider = Provider.of<StudentProvider>(context, listen: false);
    SkillModel skillInfo = SkillModel(
      studentId: currentStudent.id!,
      handwriting: skillValues[index]![0],
      fluency: skillValues[index]![1],
      game: skillValues[index]![2],
      sport: skillValues[index]![3],
      gymnastic: skillValues[index]![4],
      handlingOfTools: skillValues[index]![5],
      drawingAndPainting: skillValues[index]![6],
      crafts: skillValues[index]![7],
      musicalSkill: skillValues[index]![8],
    );

    BehaviorModel behaviorInfo = BehaviorModel(
      studentId: currentStudent.id!,
      punctuality: behaviorValues[index]![0],
      attendance: behaviorValues[index]![1],
      reliability: behaviorValues[index]![2],
      neatness: behaviorValues[index]![3],
      politeness: behaviorValues[index]![4],
      honesty: behaviorValues[index]![5],
      relationshipWithStaff: behaviorValues[index]![6],
      relationshipWithStudents: behaviorValues[index]![7],
      selfControl: behaviorValues[index]![8],
      spiritOfCooperation: behaviorValues[index]![9],
      senseOfResponsibility: behaviorValues[index]![10],
      attentiveness: behaviorValues[index]![11],
      initiative: behaviorValues[index]![12],
      organizationAbility: behaviorValues[index]![13],
      perseverance: behaviorValues[index]![14],
      physicalDev: behaviorValues[index]![15],
    );

    StudentModel studentInfo = StudentModel(
      id: currentStudent.id,
      name: currentStudent.name,
      age: currentStudent.age,
      gender: currentStudent.gender,
      studentClass: currentStudent.studentClass,
      department: currentStudent.department,
      mRemark: _masterRemarksController[index]!.text,
      mDate: _masterRemarksControllerDate[index]!.text,
      pRemark: _principalRemarksController[index]!.text,
      pDate: _principalRemarksControllerDate[index]!.text,
      totalScore: totalMarks,
      averageScore: average,
      noInAttendance: int.tryParse(_studentNoInAttendanceController[index]!.text)
    );

    provider.updateStudentSkillRecord(skillInfo);
    provider.updateStudentBehaviorRecord(behaviorInfo);
    provider.updateStudentRemarks(studentInfo);
  }

  Widget _buildStudentInfoSection(int index) {
    StudentModel student = studentsInClass[index]![0];
    return Card(
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Student Information",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const Divider(),
            const SizedBox(height: 8),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Wrap(
                spacing: 16,
                runSpacing: 8,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Name: "),
                      Text(student.name),
                      Text(" Class: "),
                      Text(student.studentClass),
                      Text(" Year: "),
                      Text("${DateTime.now().year}"),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Age: "),
                      Text("${student.age}"),
                      Text(" No. in class: "),
                      Text("${DateTime.now().day}"),
                      Text(" No. in Attendance: "),
                      Text(student.id.toString()),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultTable(List<SubjectModel> subjects) {
    return Card(
      elevation: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Academic Performance",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const Divider(),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columnSpacing: 20.0,
              headingRowColor: WidgetStateProperty.all(Colors.blue.shade100),
              columns: const [
                DataColumn(
                  label: Text(
                    "S/N",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                DataColumn(
                  label: Text(
                    "Subjects",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                DataColumn(
                  label: Text(
                    "CA1 20%",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                DataColumn(
                  label: Text(
                    "CA2 20%",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                DataColumn(
                  label: Text(
                    "EXAM 60%",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                DataColumn(
                  label: Text(
                    "TERM TOTAL",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                DataColumn(
                  label: Text(
                    "HIGHEST IN CLASS",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                DataColumn(
                  label: Text(
                    "LOWEST IN CLASS",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                DataColumn(
                  label: Text(
                    "GRADE",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                DataColumn(
                  label: Text(
                    "Teacher's Remarks",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
              rows: List.generate(
                subjects.length,
                (index) => DataRow(
                  cells: [
                    DataCell(Text("${index + 1}")),
                    DataCell(Text(subjects[index].subjectName)),
                    DataCell(
                      Center(child: Text("${subjects[index].ca1 ?? 0}")),
                    ),
                    DataCell(
                      Center(child: Text("${subjects[index].ca2 ?? 0}")),
                    ),
                    DataCell(
                      Center(child: Text("${subjects[index].exam ?? 0}")),
                    ),
                    DataCell(
                      Center(child: Text("${subjects[index].score ?? 0}")),
                    ),
                    DataCell(
                      Center(
                        child: Text("${subjects[index].heighestInClass ?? 0}"),
                      ),
                    ),
                    DataCell(
                      Center(
                        child: Text("${subjects[index].lowestInClass ?? 0}"),
                      ),
                    ),
                    DataCell(
                      Center(child: Text(getGrade(subjects[index].score ?? 0))),
                    ),
                    DataCell(
                      Center(
                        child: Text(
                          getTeacherRemarks(subjects[index].score ?? 0),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSkillAssessmentSection(
    BuildContext context,
    Map<int, List<int>> skillValues,
    int currentIndex,
  ) {
    return Card(
      elevation: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            "Skill Assessment",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const Divider(),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columnSpacing: 0.5,
              headingRowColor: WidgetStateProperty.all(Colors.blue.shade100),
              columns: [
                DataColumn(
                  label: Text(
                    "Skills",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                DataColumn(
                  label: Text(
                    "5",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                DataColumn(
                  label: Text(
                    "4",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                DataColumn(
                  label: Text(
                    "3",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                DataColumn(
                  label: Text(
                    "2",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                DataColumn(
                  label: Text(
                    "1",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
              rows: List.generate(
                skillName.length,
                (index) => DataRow(
                  cells: [
                    DataCell(Text(skillName[index])),
                    DataCell(
                      Checkbox(
                        value: skillValues[currentIndex]![index] == 5,
                        onChanged: (value) {
                          setState(() {
                            skillValues[currentIndex]![index] = 5;
                          });
                        },
                      ),
                    ),
                    DataCell(
                      Checkbox(
                        value: skillValues[currentIndex]![index] == 4,
                        onChanged: (value) {
                          setState(() {
                            skillValues[currentIndex]![index] = 4;
                          });
                        },
                      ),
                    ),
                    DataCell(
                      Checkbox(
                        value: skillValues[currentIndex]![index] == 3,
                        onChanged: (value) {
                          setState(() {
                            skillValues[currentIndex]![index] = 3;
                          });
                        },
                      ),
                    ),
                    DataCell(
                      Checkbox(
                        value: skillValues[currentIndex]![index] == 2,
                        onChanged: (value) {
                          setState(() {
                            skillValues[currentIndex]![index] = 2;
                          });
                        },
                      ),
                    ),
                    DataCell(
                      Checkbox(
                        value: skillValues[currentIndex]![index] == 1,
                        onChanged: (value) {
                          setState(() {
                            skillValues[currentIndex]![index] = 1;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBehaviorAssessmentSection(
    BuildContext context,
    Map<int, List<int>> behaviorValues,
    int currentIndex,
  ) {
    return Card(
      elevation: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            "Behavior Assessment",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const Divider(),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columnSpacing: 0.5,
              headingRowColor: WidgetStateProperty.all(Colors.blue.shade100),
              columns: [
                DataColumn(
                  label: Text(
                    "Behaviour",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                DataColumn(
                  label: Text(
                    "5",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                DataColumn(
                  label: Text(
                    "4",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                DataColumn(
                  label: Text(
                    "3",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                DataColumn(
                  label: Text(
                    "2",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                DataColumn(
                  label: Text(
                    "1",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
              rows: List.generate(
                behaviourName.length,
                (index) => DataRow(
                  cells: [
                    DataCell(Text(behaviourName[index])),
                    DataCell(
                      Checkbox(
                        value: behaviorValues[currentIndex]![index] == 5,
                        onChanged: (value) {
                          setState(() {
                            behaviorValues[currentIndex]![index] = 5;
                          });
                        },
                      ),
                    ),
                    DataCell(
                      Checkbox(
                        value: behaviorValues[currentIndex]![index] == 4,
                        onChanged: (value) {
                          setState(() {
                            behaviorValues[currentIndex]![index] = 4;
                          });
                        },
                      ),
                    ),
                    DataCell(
                      Checkbox(
                        value: behaviorValues[currentIndex]![index] == 3,
                        onChanged: (value) {
                          setState(() {
                            behaviorValues[currentIndex]![index] = 3;
                          });
                        },
                      ),
                    ),
                    DataCell(
                      Checkbox(
                        value: behaviorValues[currentIndex]![index] == 2,
                        onChanged: (value) {
                          setState(() {
                            behaviorValues[currentIndex]![index] = 2;
                          });
                        },
                      ),
                    ),
                    DataCell(
                      Checkbox(
                        value: behaviorValues[currentIndex]![index] == 1,
                        onChanged: (value) {
                          setState(() {
                            behaviorValues[currentIndex]![index] = 1;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummarySection(List<SubjectModel> subjects) {
    totalMarks = subjects.fold<double>(
      0,
      (sum, subject) => sum + (subject.score ?? 0),
    );
    average =
        double.tryParse((totalMarks / subjects.length).toStringAsFixed(2)) ??
        0.0;
    return Card(
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Result Summary",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const Divider(),
            const SizedBox(height: 8),
            Wrap(
              spacing: 16,
              runSpacing: 8.0,
              children: [
                Row(
                  children: [
                    const Text(
                      "Total Subjects: ",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text("${subjects.length}"),
                  ],
                ),
                Row(
                  children: [
                    const Text(
                      "Total Score: ",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text("$totalMarks"),
                  ],
                ),
                Row(
                  children: [
                    const Text(
                      "Average Score: ",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text("$average %"),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMasterRemarks(int index) {
    _masterRemarksControllerDate[index]!.text = DateFormat(
      "dd-MM-yyyy",
    ).format(DateTime.now());
    return Card(
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _studentNoInAttendanceController[index],
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "No. in Attendance",
              ),
            ),
            const Text(
              "Form Master's Remarks: ",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const Divider(),
            const SizedBox(height: 8),
            TextField(
              controller: _masterRemarksController[index],
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: "Enter remarks here...",
                border: OutlineInputBorder(),
              ),
            ),
            const Text(
              "Date: ",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const Divider(),
            const SizedBox(height: 8),
            TextField(
              controller: _masterRemarksControllerDate[index],
              maxLines: 1,
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPrincipalRemarks(int index) {
    _principalRemarksControllerDate[index]!.text = DateFormat(
      "dd-MM-yyyy",
    ).format(DateTime.now()); //DateTime.now();
    return Card(
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Principal's Remarks: ",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const Divider(),
            const SizedBox(height: 8),
            TextField(
              controller: _principalRemarksController[index],
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: "Enter remarks here...",
                border: OutlineInputBorder(),
              ),
            ),
            const Text(
              "Date: ",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const Divider(),
            const SizedBox(height: 8),
            TextField(
              controller: _principalRemarksControllerDate[index],
              maxLines: 1,
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}
