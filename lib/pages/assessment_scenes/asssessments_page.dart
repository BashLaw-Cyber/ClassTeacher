import 'package:classreportsheet/model/student_model.dart';
import 'package:classreportsheet/pages/assessment_scenes/assessment_per_student.dart';
import 'package:classreportsheet/pages/assessment_scenes/batch_assessment.dart';
import 'package:flutter/material.dart';

import '../../db/hive_db.dart';
import '../../util/constant.dart';

class AssessmentsPage extends StatefulWidget {
  static final String route = "assessmentPage";
  final Map<String, Map<int, List<dynamic>>> mapOfClassRecord;

  const AssessmentsPage({super.key, required this.mapOfClassRecord});

  @override
  State<AssessmentsPage> createState() => _AssessmentsPageState();
}

class _AssessmentsPageState extends State<AssessmentsPage> {
  String? selectedClass;
  late List<String> classes;
  late Map<String, Map<int, List<dynamic>>> mapOfClassRecord;

  @override
  void initState() {
    classes = getAllClasses();
    mapOfClassRecord = widget.mapOfClassRecord;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        title: Text("Assessment page"),
        actions: [
          DropdownButton(
            value: selectedClass,
            hint: Text("Select a class"),
            items: classes
                .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                .toList(),
            onChanged: (value) {
              setState(() {
                selectedClass = value;
              });
            },
          ),
        ],
      ),
      body: (selectedClass == null)
          ? Center(child: Text("Kindly select a class from the left corner"))
          : listOfStudent(selectedClass!),
    );
  }

  Widget listOfStudent(String cls) {
    Map<int, List<dynamic>> studentsInClass =
        mapOfClassRecord[cls] as Map<int, List<dynamic>>;

    if (studentsInClass.isEmpty) {
      return Center(child: Text("No student in $selectedClass class"));
    }
    return Column(
      children: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.lightBlue),
          onPressed: () async {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    BatchAssessment(studentsInClass: studentsInClass, cls: cls),
              ),
            );
          },
          child: Text(
            "Batch assessments",
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: studentsInClass.length,
            itemBuilder: (context, index) {
              final student = studentsInClass[index]![0] as StudentModel;
              return ListTile(
                onTap: () async {
                  final student = studentsInClass[index] as List<dynamic>;
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          AssessmentPerStudent(studentRecords: student),
                    ),
                  );
                },
                leading: CircleAvatar(
                  child: Icon(
                    student.gender == "male"
                        ? Icons.person
                        : Icons.person_outline,
                  ),
                ),
                title: Text(student.name),
                trailing: Text(student.studentClass),
                subtitle: Row(
                  children: [
                    Expanded(child: Text("Gender: ${student.gender} ")),
                    Expanded(child: Text("Age: ${student.age} ")),
                    Expanded(child: Text("Dept: ${student.department} ")),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
