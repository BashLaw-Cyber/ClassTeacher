import 'package:classreportsheet/model/student_model.dart';
import 'package:classreportsheet/pages/student_scenes/student_page.dart';
import 'package:classreportsheet/providers/student_provider.dart';
import 'package:classreportsheet/util/constant.dart';
import 'package:classreportsheet/util/helpful_functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../db/hive_db.dart';

class StudentDetail extends StatefulWidget {
  static final String route = 'student_details';
  final StudentModel student;
  final List<String> subjects;

  const StudentDetail({
    super.key,
    required this.student,
    required this.subjects,
  });

  @override
  State<StudentDetail> createState() => _StudentDetailState();
}

class _StudentDetailState extends State<StudentDetail> {
  late StudentModel student;
  late List<String> mySubjects;
  late List<String> classes;
  late List<String> departments;
  late List<String> notRegisteredSubjects = [];
  late List<String> allSubjects;

  late List<String> myTempSubjects;
  late TextEditingController nameController;
  late TextEditingController ageController;
  String? selectedDepartment;
  late String selectedClass;
  bool decision = false;

  @override
  void initState() {
    classes = getAllClasses();
    classes.sort();
    departments = getAllDepartments();
    departments.sort();
    allSubjects = getAllSubjects();

    allSubjects.sort();
    student = widget.student;
    mySubjects = widget.subjects;
    myTempSubjects = [...mySubjects];
    for (var subject in allSubjects) {
      if (!mySubjects.contains(subject)) {
        notRegisteredSubjects.add(subject);
      }
    }
    notRegisteredSubjects.sort();

    nameController = TextEditingController();
    ageController = TextEditingController();
    nameController.text = student.name;
    ageController.text = "${student.age}";
    selectedClass = student.studentClass;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${student.name} Detail"),
        actions: [
          IconButton(
            onPressed: _onSaveUpdate,
            icon: Icon(Icons.done, size: 24),
          ),
        ],
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: nameController,
              decoration: InputDecoration(
                label: Text("Student Name"),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButton(
              borderRadius: BorderRadius.circular(10),
              value: selectedClass,
              items:
                  classes
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
              onChanged: (value) {
                setState(() {
                  decision = getAllClassesSubjects(value!).isEmpty;
                  if (!decision) {
                    mySubjects = getAllClassesSubjects(value);
                    mySubjects.sort();
                  }
                  selectedClass = value;
                });
              },
            ),
          ),
          if (decision)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "No predefined subject for class: $selectedClass",
                style: TextStyle(color: Colors.red),
              ),
            ),
          if (decision)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Kindly select a department below",
                style: TextStyle(color: Colors.red),
              ),
            ),
          if (decision)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: DropdownButton(
                dropdownColor: CupertinoColors.white,
                value: selectedDepartment,
                hint: Text("Select the department"),
                items:
                    departments
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                onChanged: (value) {
                  setState(() {
                    decision = getDepartmentSubjects(value!).isEmpty;
                    if (!decision) {
                      mySubjects = getDepartmentSubjects(value);
                      mySubjects.sort();
                      selectedDepartment = value;
                    } else {
                      selectedDepartment = null;
                    }
                  });
                },
              ),
            ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: ageController,
              decoration: InputDecoration(
                label: Text("Student Age"),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          Center(
            child: Text(
              "List of student registered subjects",
              style: studentDetailStyle,
            ),
          ),
          if (!decision)
            Wrap(
              spacing: 10,
              //runSpacing: 10,
              children:
                  mySubjects.map((subject) {
                    return FilterChip(
                      label: Text(subject, style: studentDetailStyle),
                      onSelected: (selected) {
                        showDeleteDialog(context, subject);
                      },
                    );
                  }).toList(),
            ),
          if (!decision)
            Center(
              child: DropdownButton(
                //value: others,
                hint: Text("Add other subject"),
                items:
                    notRegisteredSubjects
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                onChanged: (value) {
                  setState(() {
                    //others = value!;
                    mySubjects.add(value!);
                    mySubjects.sort();
                    notRegisteredSubjects.remove(value);
                    //notRegisteredSubjects.sort();
                    //others = null;
                  });
                },
              ),
            ),
        ],
      ),
    );
  }

  Future<dynamic> showDeleteDialog(BuildContext context, String subject) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Caution", style: studentDetailStyle),
          content: Text(
            "Your are about delete $subject for ${nameController.text}",
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  mySubjects.remove(subject);
                  notRegisteredSubjects.add(subject);
                  notRegisteredSubjects.sort();
                });
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
        );
      },
    );
  }

  void _onSaveUpdate() {
    final provider = Provider.of<StudentProvider>(context, listen: false);

    List<String> removeSubjects = [];
    List<String> newSubjects = [];

    // if new class department is assign
    if (!decision) {
      // checking for new subjects
      for (var subject in mySubjects) {
        if (!myTempSubjects.contains(subject)) {
          newSubjects.add(subject);
        }
      }
      // checking for subject to remove
      for (var subject in myTempSubjects) {
        if (!mySubjects.contains(subject)) {
          removeSubjects.add(subject);
        }
      }
    } else {
      showMsg(
        context,
        "Kindly select class: ${widget.student.studentClass} or department ${widget.student.department}, since the new class or department selected do not have subjects assign to them",
      );
      return;
    }

    StudentModel student = StudentModel(
      name: nameController.text,
      age: int.tryParse(ageController.text) ?? 0,
      gender: widget.student.gender,
      studentClass: selectedClass,
      department: selectedDepartment ?? widget.student.department,
    );
    setState(() {
      provider.updateStudentRecords(widget.student.id!, student);
    });

    if (removeSubjects.isNotEmpty) {
      provider.deleteOldStudentSubject(widget.student.id!, removeSubjects);
    }
    if (newSubjects.isNotEmpty) {
      provider.insertSubject(newSubjects, widget.student.id!);
    }
    provider.getAllStudent();
    Navigator.pop(context,"refresh");
  }
}
