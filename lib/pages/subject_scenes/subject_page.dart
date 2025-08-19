import 'dart:math';

import 'package:classreportsheet/pages/subject_scenes/class_per_subject.dart';
import 'package:classreportsheet/providers/student_provider.dart';
import 'package:classreportsheet/util/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';

import '../../db/hive_db.dart';

class SubjectPage extends StatefulWidget {
  static final String route = "subject";

  const SubjectPage({super.key});

  @override
  State<SubjectPage> createState() => _SubjectPageState();
}

class _SubjectPageState extends State<SubjectPage> {
  late List<String> allSubjects;
  late List<String> classes;

  @override
  void initState() {
    allSubjects = getAllSubjects();
    allSubjects.sort();
    classes = getAllClasses();
    classes.sort();
    Provider.of<StudentProvider>(
      context,
      listen: false,
    ).getNumberOfStudent(allSubjects);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(title: Text("Subjects"), backgroundColor: backgroundColor),
      body: Consumer<StudentProvider>(
        builder:
            (context, provider, child) => ListView.builder(
              itemCount: min(
                provider.numberOfStudent.length,
                allSubjects.length,
              ),
              itemBuilder: (context, index) {
                final subject = allSubjects[index];
                return ListTile(
                  onTap: () async {
                    EasyLoading.show(status: "Please wait...");
                    Map<String, List<dynamic>> mapOfRecord = await provider
                        .mapOfStudentSubjectRecords(subject, classes);
                    EasyLoading.dismiss();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => ClassPerSubject(
                              subject: subject,
                              mapOfRecords: mapOfRecord,
                            ),
                      ),
                    );
                  },
                  leading: CircleAvatar(child: Icon(Icons.menu_book)),
                  title: Text(subject, style: normalFontStyle),
                  trailing: Text(
                    "${provider.numberOfStudent[index]}",
                    style: normalFontStyle,
                  ),
                );
              },
            ),
      ),
    );
  }
}
