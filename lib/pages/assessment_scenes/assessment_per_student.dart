import 'package:classreportsheet/model/behaviour_model.dart';
import 'package:classreportsheet/model/skill_model.dart';
import 'package:classreportsheet/model/student_model.dart';
import 'package:classreportsheet/model/subject_model.dart';
import 'package:classreportsheet/providers/student_provider.dart';
import 'package:classreportsheet/util/helpful_functions.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class AssessmentPerStudent extends StatefulWidget {
  static final String route = "assessmentPerStudent";
  final List<dynamic> studentRecords;

  const AssessmentPerStudent({super.key, required this.studentRecords});

  @override
  State<AssessmentPerStudent> createState() => _AssessmentPerStudentState();
}

class _AssessmentPerStudentState extends State<AssessmentPerStudent> {
  late StudentModel student;
  late List<SubjectModel> subjects;
  late SkillModel skill;
  late BehaviorModel behavior;
  double totalMarks = 0.0;
  double average = 0.0;

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

  List<String> behaviorName = [
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
  late List<int> skillValues;
  late List<int> behaviorValues;

  late TextEditingController _masterRemarksController = TextEditingController();
  late TextEditingController _principalRemarksController =
      TextEditingController();
  late TextEditingController _masterRemarksControllerDate =
      TextEditingController();
  late TextEditingController _principalRemarksControllerDate =
      TextEditingController();
  late TextEditingController _studentNoInAttendanceController = TextEditingController();

  DateTime? mSelectedDate;
  DateTime? pSelectedDate;

  @override
  void initState() {
    student = widget.studentRecords[0];
    subjects = widget.studentRecords[1];
    skill = widget.studentRecords[2];
    behavior = widget.studentRecords[3];
    skillValues = [
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
    behaviorValues = [
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

    _masterRemarksController = TextEditingController(
      text: student.mRemark ?? "",
    );
    _principalRemarksController = TextEditingController(
      text: student.pRemark ?? "",
    );
    _principalRemarksControllerDate = TextEditingController(
      text: student.pDate ?? "",
    );
    _masterRemarksControllerDate = TextEditingController(
      text: student.mDate ?? "",
    );
    _studentNoInAttendanceController = TextEditingController(
      text: student.noInAttendance.toString(),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Assessment/Student"),
        actions: [
          IconButton(
            onPressed: () {
              final provider = Provider.of<StudentProvider>(
                context,
                listen: false,
              );
              SkillModel skillInfo = SkillModel(
                studentId: student.id!,
                handwriting: skillValues[0],
                fluency: skillValues[1],
                game: skillValues[2],
                sport: skillValues[3],
                gymnastic: skillValues[4],
                handlingOfTools: skillValues[5],
                drawingAndPainting: skillValues[6],
                crafts: skillValues[7],
                musicalSkill: skillValues[8],
              );

              BehaviorModel behaviorInfo = BehaviorModel(
                studentId: student.id!,
                punctuality: behaviorValues[0],
                attendance: behaviorValues[1],
                reliability: behaviorValues[2],
                neatness: behaviorValues[3],
                politeness: behaviorValues[4],
                honesty: behaviorValues[5],
                relationshipWithStaff: behaviorValues[6],
                relationshipWithStudents: behaviorValues[7],
                selfControl: behaviorValues[8],
                spiritOfCooperation: behaviorValues[9],
                senseOfResponsibility: behaviorValues[10],
                attentiveness: behaviorValues[11],
                initiative: behaviorValues[12],
                organizationAbility: behaviorValues[13],
                perseverance: behaviorValues[14],
                physicalDev: behaviorValues[15],
              );
              StudentModel studentInfo = StudentModel(
                id: student.id,
                name: student.name,
                age: student.age,
                gender: student.gender,
                studentClass: student.studentClass,
                department: student.department,
                mRemark: _masterRemarksController.text,
                mDate: _masterRemarksControllerDate.text,
                pRemark: _principalRemarksController.text,
                pDate: _principalRemarksControllerDate.text,
                totalScore: totalMarks,
                averageScore: average,
                noInAttendance: int.tryParse(_studentNoInAttendanceController.text)
              );

              provider.updateStudentSkillRecord(skillInfo);
              provider.updateStudentBehaviorRecord(behaviorInfo);
              provider.updateStudentRemarks(studentInfo);
              Navigator.pop(context);
            },
            icon: Icon(Icons.done),
          ),
        ],
      ),
      body: Consumer<StudentProvider>(
        builder: (context, provider, child) => SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildStudentInfoSection(),
              const SizedBox(height: 24),
              _buildResultTable(),
              const SizedBox(height: 24),
              _buildSkillAssessmentSection(),
              const SizedBox(height: 24),
              _buildBehaviorAssessmentSection(),
              const SizedBox(height: 24),
              _buildSummarySection(),
              const SizedBox(height: 24),
              _buildMasterRemarks(),
              const SizedBox(height: 24),
              _buildPrincipalRemarks(),
              const SizedBox(height: 24),
              _buildSignatureSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStudentInfoSection() {
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

  Widget _buildResultTable() {
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
              columnSpacing: 2.0,
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
                    DataCell(Text("${subjects[index].ca1 ?? 0}")),
                    DataCell(Text("${subjects[index].ca2 ?? 0}")),
                    DataCell(Text("${subjects[index].exam ?? 0}")),
                    DataCell(Text("${subjects[index].score ?? 0}")),
                    DataCell(Text("${subjects[index].heighestInClass ?? 0}")),
                    DataCell(Text("${subjects[index].lowestInClass ?? 0}")),
                    DataCell(Text(getGrade(subjects[index].score ?? 0))),
                    DataCell(
                      Text(getTeacherRemarks(subjects[index].score ?? 0)),
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

  Widget _buildSkillAssessmentSection() {
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
              columnSpacing: 1.0,
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
                    DataCell(
                      Text(skillName[index], overflow: TextOverflow.ellipsis),
                    ),
                    DataCell(
                      Checkbox(
                        value: skillValues[index] == 5,
                        onChanged: (value) {
                          setState(() {
                            skillValues[index] = 5;
                          });
                        },
                      ),
                    ),
                    DataCell(
                      Checkbox(
                        value: skillValues[index] == 4,
                        onChanged: (value) {
                          setState(() {
                            skillValues[index] = 4;
                          });
                        },
                      ),
                    ),
                    DataCell(
                      Checkbox(
                        value: skillValues[index] == 3,
                        onChanged: (value) {
                          setState(() {
                            skillValues[index] = 3;
                          });
                        },
                      ),
                    ),
                    DataCell(
                      Checkbox(
                        value: skillValues[index] == 2,
                        onChanged: (value) {
                          setState(() {
                            skillValues[index] = 2;
                          });
                        },
                      ),
                    ),
                    DataCell(
                      Checkbox(
                        value: skillValues[index] == 1,
                        onChanged: (value) {
                          setState(() {
                            skillValues[index] = 1;
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

  Widget _buildBehaviorAssessmentSection() {
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
                    "Behavior",
                    style: TextStyle(fontWeight: FontWeight.bold),
                    textAlign: TextAlign.left,
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
                behaviorName.length,
                (index) => DataRow(
                  cells: [
                    DataCell(
                      Text(
                        behaviorName[index],
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    DataCell(
                      Checkbox(
                        value: behaviorValues[index] == 5,
                        onChanged: (value) {
                          setState(() {
                            behaviorValues[index] = 5;
                          });
                        },
                      ),
                    ),
                    DataCell(
                      Checkbox(
                        value: behaviorValues[index] == 4,
                        onChanged: (value) {
                          setState(() {
                            behaviorValues[index] = 4;
                          });
                        },
                      ),
                    ),
                    DataCell(
                      Checkbox(
                        value: behaviorValues[index] == 3,
                        onChanged: (value) {
                          setState(() {
                            behaviorValues[index] = 3;
                          });
                        },
                      ),
                    ),
                    DataCell(
                      Checkbox(
                        value: behaviorValues[index] == 2,
                        onChanged: (value) {
                          setState(() {
                            behaviorValues[index] = 2;
                          });
                        },
                      ),
                    ),
                    DataCell(
                      Checkbox(
                        value: behaviorValues[index] == 1,
                        onChanged: (value) {
                          setState(() {
                            behaviorValues[index] = 1;
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

  Widget _buildSummarySection() {
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

  Widget _buildMasterRemarks() {
    _masterRemarksControllerDate.text = DateFormat(
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
              controller: _studentNoInAttendanceController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: "No. in Attendance",
              ),
            ),
            const Text(
              "Form Master's Remarks: ",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const Divider(),
            const SizedBox(height: 8),
            TextField(
              controller: _masterRemarksController,
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
              controller: _masterRemarksControllerDate,
              maxLines: 1,
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPrincipalRemarks() {
    _principalRemarksControllerDate.text = DateFormat(
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
              controller: _principalRemarksController,
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
              controller: _principalRemarksControllerDate,
              maxLines: 1,
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSignatureSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildSignatureLine("Master"),
        _buildSignatureLine("Principal"),
        _buildSignatureLine("Parent/Guardian"),
      ],
    );
  }

  Widget _buildSignatureLine(String title) {
    return Column(
      children: [
        Container(width: 100, height: 1, color: Colors.black),
        const SizedBox(height: 4),
        Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      ],
    );
  }
}
