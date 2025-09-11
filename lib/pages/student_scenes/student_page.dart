import 'dart:core';

import 'package:classreportsheet/model/behaviour_model.dart';
import 'package:classreportsheet/model/skill_model.dart';
import 'package:classreportsheet/model/student_model.dart';
import 'package:classreportsheet/pages/student_scenes/student_detail.dart';
import 'package:classreportsheet/providers/student_provider.dart';
import 'package:classreportsheet/util/constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';

import '../../db/hive_db.dart';
import '../../util/helpful_functions.dart';

enum Gender { male, female }

class StudentPage extends StatefulWidget {
  static final String route = "student";

  const StudentPage({super.key});

  @override
  State<StudentPage> createState() => _StudentPageState();
}

class _StudentPageState extends State<StudentPage> {
  late List<String> classes;
  late List<String> departments;
  Gender gender = Gender.male;
  List<String> subjects = [];
  String? currentClass;
  String? selectedClass;
  String? selectedDepartment;
  bool decision = false;
  bool decision1 = false;
  TextEditingController nameController = TextEditingController();
  TextEditingController ageController = TextEditingController();

  get provider => Provider.of<StudentProvider>(context, listen: false);

  @override
  void initState() {
    classes = getAllClasses();
    classes.sort();
    departments = getAllDepartments();
    departments.sort();
    provider.getAllStudent();
    provider.getTotalStudent();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Icon(Icons.school, color: Colors.blue),
        backgroundColor: backgroundColor,
        actions: [
          SizedBox(
            width: 130,
            child: DropdownButton(
              menuWidth: 100,
              alignment: AlignmentDirectional.centerStart,
              borderRadius: BorderRadius.circular(10),
              dropdownColor: backgroundColor,
              isExpanded: true,
              hint: Text(
                "Select a class",
                style: TextStyle(color: Colors.blue),
              ),
              value: currentClass,
              items: classes
                  .map(
                    (e) => DropdownMenuItem(
                      value: e,
                      child: Text(e, style: TextStyle(color: Colors.blue)),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                setState(() {
                  currentClass = value!;
                });
              },
            ),
          ),
          IconButton(
            onPressed: () {
              List<String> srt = [
                tblStudentName,
                tblStudentId,
                tblStudentAverageScore,
              ];
              String select = provider.orderBy;
              showDialog(
                context: context,
                builder: (context) => StatefulBuilder(
                  builder: (context, setState) => AlertDialog(
                    backgroundColor: backgroundColor,
                    title: Text("Sort by"),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Name:"),
                            Switch(
                              activeColor: Colors.blue,
                              value: select == srt[0],
                              onChanged: (value) {
                                setState(() {
                                  select = value ? srt[0] : "";
                                });
                                if (value) {
                                  Provider.of<StudentProvider>(
                                    context,
                                    listen: false,
                                  ).setOrderBy(select);
                                }
                              },
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("ID"),
                            Switch(
                              activeColor: Colors.blue,
                              value: select == srt[1],
                              onChanged: (value) {
                                setState(() {
                                  select = value ? srt[1] : "";
                                });
                                if (value) {
                                  Provider.of<StudentProvider>(
                                    context,
                                    listen: false,
                                  ).setOrderBy(select);
                                }
                              },
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Average Score"),
                            Switch(
                              activeColor: Colors.blue,
                              value: select == srt[2],
                              onChanged: (value) {
                                setState(() {
                                  select = value ? srt[2] : "";
                                });
                                if (value) {
                                  Provider.of<StudentProvider>(
                                    context,
                                    listen: false,
                                  ).setOrderBy(select);
                                }
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );

            },
            icon: Icon(Icons.sort, color: Colors.blue),
          ),
        ],
      ),
      body: (currentClass == null)
          ? Center(
              child: Text("kindly select a class from the top right corner"),
            )
          : listOfStudent(),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: () async {
          if (provider.totalNoStudent < 10) {
            addStudent(context);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Center(
                  child: Text(
                    "Record limit reached contact administrator",
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ),
            );
          }
        },
        shape: CircleBorder(),
        child: Icon(
          Icons.add,
          color: CupertinoColors.white,
          size: 34,
          weight: 34,
        ),
      ),
    );
  }

  Widget listOfStudent() {
    return Consumer<StudentProvider>(
      builder: (context, provider, child) {
        final students = provider.studentList[currentClass]!;
        return students.isEmpty
            ? Center(child: Text("No student in $currentClass registered yet"))
            : ListView.builder(
                itemCount: students.length,
                itemBuilder: (context, index) {
                  final student = students[index];
                  return Dismissible(
                    confirmDismiss: (direction) {
                      return showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text("Caution"),
                          content: Text(
                            "You are about to delete student: ${student.name} records",
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                provider.deleteStudent(student.id!);
                                Navigator.pop(context);
                              },
                              child: Text("Yes"),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text("No"),
                            ),
                          ],
                        ),
                      );
                    },
                    key: Key(student.id.toString()),
                    background: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18),
                        color: Colors.red,
                      ),
                      child: Icon(Icons.delete, color: Colors.white),
                    ),
                    direction: DismissDirection.endToStart,
                    child: ListTile(
                      leading: CircleAvatar(child: Icon(Icons.person)),
                      title: Text(student.name),
                      subtitle: Row(
                        children: [
                          Flexible(child: Text("Age: ${student.age} ")),
                          Flexible(child: Text("Gender: ${student.gender} ")),
                          Flexible(child: Text("Dept: ${student.department}")),
                        ],
                      ),
                      onTap: () async {
                        EasyLoading.show(status: "Please wait...");
                        final subjects = await provider.getStudentSubjectById(
                          student.id!,
                        );
                        EasyLoading.dismiss();
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => StudentDetail(
                              student: student,
                              subjects: subjects,
                            ),
                          ),
                        );
                        if (result == "refresh") {
                          setState(() {
                            currentClass = currentClass;
                          });
                        }
                      },
                    ),
                  );
                },
              );
      },
    );
  }

  Future<dynamic> addStudent(BuildContext context) {
    subjects.clear();
    return showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: backgroundColor,
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, builderSetState) {
            return Padding(
              padding: const EdgeInsets.all(25.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: TextField(
                      keyboardType: TextInputType.name,
                      controller: nameController,
                      decoration: InputDecoration(
                        label: Text("Name"),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.blue, width: 8),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: TextField(
                      controller: ageController,
                      keyboardType: TextInputType.phone,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: InputDecoration(
                        label: Text("Age"),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: Text("Gender"),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Radio<Gender>(
                        value: Gender.male,
                        groupValue: gender,
                        onChanged: (value) {
                          builderSetState(() {
                            gender = value!;
                          });
                        },
                      ),
                      Text("Male"),
                      Radio<Gender>(
                        value: Gender.female,
                        groupValue: gender,
                        onChanged: (value) {
                          builderSetState(() {
                            gender = value!;
                          });
                        },
                      ),
                      Text("Female"),
                    ],
                  ),
                  DropdownButton(
                    dropdownColor: CupertinoColors.white,
                    value: selectedClass,
                    hint: Text("Select the class"),
                    items: classes
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    onChanged: (value) {
                      builderSetState(() {
                        decision = getAllClassesSubjects(value!).isEmpty;
                        if (!decision) {
                          subjects = getAllClassesSubjects(value);
                          subjects.sort();
                        }
                        selectedClass = value;
                      });
                    },
                  ),
                  if (decision)
                    Text(
                      "No predefined subject for class: $selectedClass",
                      style: TextStyle(color: Colors.red),
                    ),
                  if (decision)
                    Text(
                      "Kindly select a department below",
                      style: TextStyle(color: Colors.red),
                    ),
                  if (decision)
                    DropdownButton(
                      dropdownColor: CupertinoColors.white,
                      value: selectedDepartment,
                      hint: Text("Select the department"),
                      items: departments
                          .map(
                            (e) => DropdownMenuItem(value: e, child: Text(e)),
                          )
                          .toList(),
                      onChanged: (value) {
                        builderSetState(() {
                          decision = getDepartmentSubjects(value!).isEmpty;
                          if (decision) {
                            selectedDepartment = null;
                          } else {
                            subjects = getDepartmentSubjects(value);
                            subjects.sort();
                            selectedDepartment = value;
                          }
                        });
                      },
                    ),
                  TextButton(onPressed: _save, child: Text("Save")),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _save() async {
    if (nameController.text.isEmpty ||
        ageController.text.isEmpty ||
        selectedClass == null) {
      showMsg(context, "Check all fields carefully");
      return;
    } else if (subjects.isEmpty) {
      showMsg(
        context,
        "Go to setting page to assign subjects for class: $selectedClass or department: $selectedDepartment",
      );
      return;
    } else {
      StudentModel student = StudentModel(
        name: nameController.text,
        age: int.parse(ageController.text),
        gender: gender.name,
        studentClass: selectedClass!,
        department: selectedDepartment ?? "",
      );
      provider.insertStudent(student);

      student = await provider.getLastStudent();
      provider.insertSubject(subjects, student.id!);

      // create a student skill
      SkillModel studentSkill = SkillModel(studentId: student.id!);
      provider.insertStudentSkill(studentSkill);

      // create a student behaviour record
      BehaviorModel studentBehaviour = BehaviorModel(studentId: student.id!);
      provider.insertStudentBehaviour(studentBehaviour);

      nameController.clear();
      ageController.clear();
      selectedClass = null;
      gender = Gender.male;
      selectedDepartment = null;
      decision = false;
      setState(() {
        currentClass = currentClass;
      });
      Navigator.pop(context);
    }
  }
}
