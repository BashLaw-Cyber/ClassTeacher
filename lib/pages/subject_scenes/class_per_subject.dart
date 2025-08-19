import 'dart:math';

import 'package:classreportsheet/model/student_model.dart';
import 'package:classreportsheet/model/subject_model.dart';
import 'package:classreportsheet/providers/student_provider.dart';
import 'package:classreportsheet/util/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../db/hive_db.dart';
import '../../util/helpful_functions.dart';

class ClassPerSubject extends StatefulWidget {
  static final String route = "classPerSubject";
  final String subject;
  final Map<String, List<dynamic>> mapOfRecords;

  const ClassPerSubject({
    super.key,
    required this.subject,
    required this.mapOfRecords,
  });

  @override
  State<ClassPerSubject> createState() => _ClassPerSubjectState();
}

class _ClassPerSubjectState extends State<ClassPerSubject> {
  String? selectedClass;
  late String subject;
  late List<String> classes;
  late Map<String, List<dynamic>> mapOfClassRecord;

  Map<int, TextEditingController> ca1Controller = {};
  Map<int, TextEditingController> ca2Controller = {};
  Map<int, TextEditingController> examController = {};
  Map<int, TextEditingController> totalScoreController = {};

  @override
  void initState() {
    classes = getAllClasses();
    classes.sort();
    subject = widget.subject;
    mapOfClassRecord = widget.mapOfRecords;

    for (var cl in classes) {
      if (mapOfClassRecord.containsKey(cl) &&
          mapOfClassRecord[cl]!.isNotEmpty) {
        List<StudentModel> students =
            mapOfClassRecord[cl]![0] as List<StudentModel>;
        List<SubjectModel> subjects =
            mapOfClassRecord[cl]![1] as List<SubjectModel>;

        for (int index = 0; index < students.length; index++) {
          StudentModel student = students[index];
          SubjectModel subject = subjects[index];
          ca1Controller[student.id!] = TextEditingController(
            text: "${subject.ca1 ?? ""}",
          );
          ca2Controller[student.id!] = TextEditingController(
            text: "${subject.ca2 ?? ""}",
          );
          examController[student.id!] = TextEditingController(
            text: "${subject.exam ?? ""}",
          );
          totalScoreController[student.id!] = TextEditingController(
            text: "${subject.score ?? ""}",
          );
        }
      }
    }
    super.initState();
  }

  @override
  void dispose() {
    for (final controller in ca1Controller.values) {
      controller.dispose();
    }
    for (final controller in ca2Controller.values) {
      controller.dispose();
    }
    for (final controller in examController.values) {
      controller.dispose();
    }
    for (final controller in totalScoreController.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        title: Text("Class Page"),
        actions: [
          DropdownButton(
            dropdownColor: backgroundColor,
            value: selectedClass,
            hint: Text("Select a class"),
            items: classes
                .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                .toList(),
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  selectedClass = value;
                });
              }
            },
          ),
        ],
      ),
      body: (selectedClass == null)
          ? Center(
              child: Text(
                "Kindly select a class from the  top right conner",
                style: studentDetailStyle,
              ),
            )
          : listOfStudentsByClass(),
    );
  }

  Widget listOfStudentsByClass() {
    final provider = Provider.of<StudentProvider>(context, listen: false);
    List<StudentModel> studentList;
    List<SubjectModel> subjectList;
    if (mapOfClassRecord[selectedClass!]!.isNotEmpty) {
      studentList = mapOfClassRecord[selectedClass]![0];
      subjectList = mapOfClassRecord[selectedClass]![1];
    } else {
      studentList = [];
      subjectList = [];
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  "$subject students",
                  overflow: TextOverflow.ellipsis,
                  style:
                      studentDetailStyle, //TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                onPressed: () {
                  showDialog<void>(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        backgroundColor: backgroundColor,
                        title: Text(
                          "Batch Score Entry for $subject students in $selectedClass",
                        ),
                        content: SizedBox(
                          width: double.maxFinite,
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: studentList.length,
                            itemBuilder: (context, index) {
                              final student = studentList[index];
                              return Card(
                                color: backgroundColor,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(student.name),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Flexible(
                                          child: TextField(
                                            controller:
                                                ca1Controller[student.id],
                                            decoration: InputDecoration(
                                              labelText: "1st CA",
                                            ),
                                            keyboardType: TextInputType.number,
                                            inputFormatters: [
                                              FilteringTextInputFormatter
                                                  .digitsOnly,
                                            ],
                                          ),
                                        ),
                                        Flexible(
                                          child: TextField(
                                            controller:
                                                ca2Controller[student.id],
                                            decoration: InputDecoration(
                                              labelText: "2nd CA",
                                            ),
                                            keyboardType: TextInputType.number,
                                            inputFormatters: [
                                              FilteringTextInputFormatter
                                                  .digitsOnly,
                                            ],
                                          ),
                                        ),
                                        Flexible(
                                          child: TextField(
                                            controller:
                                                examController[student.id],
                                            decoration: InputDecoration(
                                              labelText: "Exam",
                                            ),
                                            keyboardType: TextInputType.number,
                                            inputFormatters: [
                                              FilteringTextInputFormatter
                                                  .digitsOnly,
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () async {
                              for (
                                var index = 0;
                                index < studentList.length;
                                index++
                              ) {
                                final student = studentList[index];
                                var score = 0.0;
                                var test1 =
                                    double.tryParse(
                                      ca1Controller[student.id]!.text,
                                    ) ??
                                    0;
                                var test2 =
                                    double.tryParse(
                                      ca2Controller[student.id]!.text,
                                    ) ??
                                    0;
                                var examScore =
                                    double.tryParse(
                                      examController[student.id]!.text,
                                    ) ??
                                    0;

                                if (test1 > 20 ||
                                    test2 > 20 ||
                                    examScore > 60) {
                                  showMsg(
                                    context,
                                    "Check your CA and Exam score for ${student.name} carefully",
                                  );
                                  return;
                                } else {
                                  score = test1 + test2 + examScore;
                                  setState(() {
                                    totalScoreController[student.id!] =
                                        TextEditingController(text: "$score");
                                  });

                                  provider.updateScore(student.id!, subject, [
                                    test1,
                                    test2,
                                    examScore,
                                    score,
                                  ]);
                                }
                              }
                              provider.updateSubjectClassMaxMinAndAverage(
                                studentList,
                                subject,
                              );
                              //provider.
                              Navigator.pop(context);
                            },
                            child: Text("Save All"),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text("Cancel"),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: Text(
                  "Batch score entry",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: (studentList.isEmpty)
              ? Center(
                  child: Text(
                    "No Student in $selectedClass registered for $subject",
                  ),
                )
              : ListView.builder(
                  itemCount: min(studentList.length, subjectList.length),
                  itemBuilder: (context, index) {
                    final student = studentList[index];
                    return ListTile(
                      onTap: () {
                        showScoreDialog(
                          context,
                          studentList,
                          student,
                          ca1Controller[student.id]!,
                          ca2Controller[student.id]!,
                          examController[student.id]!,
                          totalScoreController[student.id]!,
                        );
                      },
                      title: Text(student.name, style: studentDetailStyle),
                      trailing: Text(
                        student.studentClass,
                        style: studentDetailStyle,
                      ),
                      subtitle: Row(
                        children: [
                          Flexible(
                            child: TextField(
                              decoration: InputDecoration(
                                label: Text(
                                  "CA1",
                                  style: TextStyle(fontSize: 15),
                                ),
                              ),
                              controller: ca1Controller[student.id],
                              enabled: false,
                            ),
                          ),
                          Flexible(
                            child: TextField(
                              decoration: InputDecoration(
                                label: Text(
                                  "CA2",
                                  style: TextStyle(fontSize: 15),
                                ),
                              ),
                              controller: ca2Controller[student.id],
                              enabled: false,
                            ),
                          ),
                          Flexible(
                            child: TextField(
                              decoration: InputDecoration(
                                label: Text(
                                  "Exam",
                                  style: TextStyle(fontSize: 15),
                                ),
                              ),
                              controller: examController[student.id],
                              enabled: false,
                            ),
                          ),
                          Flexible(
                            child: TextField(
                              decoration: InputDecoration(
                                label: Text(
                                  "TOTAL",
                                  style: TextStyle(fontSize: 15),
                                ),
                              ),
                              controller: totalScoreController[student.id],
                              enabled: false,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Future<dynamic> showScoreDialog(
    BuildContext context,
    List<StudentModel> students,
    StudentModel student,
    TextEditingController ca1,
    TextEditingController ca2,
    TextEditingController exam,
    TextEditingController totalScore,
  ) {
    final provider = Provider.of<StudentProvider>(context, listen: false);
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: backgroundColor,
          title: Text("Enter scores for ${student.name}"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: ca1,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: InputDecoration(
                  labelText: "1st CA score",
                  //hintText: "Enter 1st CA score",
                ),
              ),
              TextField(
                controller: ca2,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: InputDecoration(
                  labelText: "2nd CA score",
                  //hintText: "Enter 2nd CA score",
                ),
              ),
              TextField(
                controller: exam,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: InputDecoration(
                  labelText: "Exam score",
                  //hintText: "Enter exam score",
                ),
              ),
              Flexible(
                child: Text(
                  "Kindly press the save button to save your score",
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () async {
                var score = 0.0;
                var test1 = double.tryParse(ca1.text) ?? 0;
                var test2 = double.tryParse(ca2.text) ?? 0;
                var examScore = double.tryParse(exam.text) ?? 0;

                if (test1 > 20 || test2 > 20 || examScore > 60) {
                  showMsg(context, "Check your CA and Exam score carefully");
                  return;
                } else {
                  score = test1 + test2 + examScore;
                  setState(() {
                    totalScoreController[student.id!] = TextEditingController(
                      text: "$score",
                    );
                  });

                  provider.updateScore(student.id!, subject, [
                    test1,
                    test2,
                    examScore,
                    score,
                  ]);

                  provider.updateSubjectClassMaxMinAndAverage(
                    students,
                    subject,
                  );
                  Navigator.pop(context);
                }
              },
              child: Text("Save"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Cancel"),
            ),
          ],
        );
      },
    );
  }
}
