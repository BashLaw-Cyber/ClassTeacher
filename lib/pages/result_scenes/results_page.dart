import 'dart:io';

import 'package:classreportsheet/db/hive_db.dart';
import 'package:classreportsheet/model/behaviour_model.dart';
import 'package:classreportsheet/model/skill_model.dart';
import 'package:classreportsheet/model/student_model.dart';
import 'package:classreportsheet/model/subject_model.dart';
import 'package:classreportsheet/util/helpful_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../util/constant.dart';

class ResultsPage extends StatefulWidget {
  static final String route = "resultPage";
  final Map<String, Map<int, List<dynamic>>> mapOfClassCardReport;
  const ResultsPage({super.key, required this.mapOfClassCardReport});

  @override
  State<ResultsPage> createState() => _ResultsPageState();
}

class _ResultsPageState extends State<ResultsPage> {
  late List<String> classes = [];
  String? selectedClass;
  late Map<String, Map<int, List<dynamic>>> mapOfClassCardReport;
  bool ready = false;
  late Uint8List imageByte;

  @override
  void initState() {
    classes = getAllClasses();
    mapOfClassCardReport = widget.mapOfClassCardReport;
    //imageByte = await File(getSchoolLogoPath()).readAsBytes();
    //image = pw.MemoryImage(imageByte);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        title: Text("Results page"),
        actions: [
          DropdownButton(
            value: selectedClass,
            hint: Text("Select a class"),
            items: classes
                .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                .toList(),
            onChanged: (value) {
              setState(() {
                selectedClass = value!;
              });
            },
          ),
        ],
      ),
      body: (selectedClass == null)
          ? Center(
              child: Text("Kindly select a class from the top right conner"),
            )
          : Column(
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  onPressed: () async {
                    final studentsInClass =
                        mapOfClassCardReport[selectedClass]
                            as Map<int, List<dynamic>>;
                    try {
                      EasyLoading.show(status: "Please Wait...");
                      final pdfFile = await getClassReportCards(
                        studentsInClass,
                      );
                      EasyLoading.dismiss();
                      final result = await OpenFile.open(pdfFile.path);
                      if (result.type != ResultType.done) {
                        EasyLoading.dismiss();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("PDF saved to: ${pdfFile.path}"),
                            duration: Duration(seconds: 5),
                          ),
                        );
                      }
                    } catch (e) {
                      EasyLoading.dismiss();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Error generating PDf $e")),
                      );
                    }
                  },
                  child: Text(
                    "Generate all students result in pdf",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                _listOfStudent(selectedClass!),
              ],
            ),
    );
  }

  Widget _listOfStudent(String cls) {
    Map<int, List<dynamic>> studentsInClass =
        mapOfClassCardReport[cls] as Map<int, List<dynamic>>;

    return studentsInClass.isEmpty
        ? Center(child: Text("No student in class: $cls"))
        : Expanded(
            child: ListView.builder(
              itemCount: studentsInClass.length,
              itemBuilder: (context, index) {
                final studentRecords = studentsInClass[index];
                StudentModel student = studentRecords![0];
                return ListTile(
                  leading: CircleAvatar(
                    child: Icon(
                      (student.gender == "female")
                          ? Icons.person_outline
                          : Icons.person,
                    ),
                  ),
                  title: Text(student.name),
                  subtitle: Row(
                    children: [
                      Flexible(child: Text("Age: ${student.age} ")),
                      Flexible(child: Text("Gender: ${student.gender} ")),
                      Flexible(child: Text("Dept: ${student.department}")),
                    ],
                  ),
                  trailing: Text(student.studentClass),
                  onTap: () async {
                    try {
                      EasyLoading.show(status: "Please Wait...");
                      final pdfFile = await generateStudentReportCard(
                        studentRecords,
                        studentsInClass.length,
                      );
                      EasyLoading.dismiss();
                      final result = await OpenFile.open(pdfFile.path);
                      if (result.type != ResultType.done) {
                        EasyLoading.dismiss();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("PDF saved to: ${pdfFile.path}"),
                            duration: Duration(seconds: 5),
                          ),
                        );
                      }
                    } catch (e) {
                      EasyLoading.dismiss();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Error generating PDf $e")),
                      );
                    }
                  },
                );
              },
            ),
          );
  }

  Future<pw.Font> _loadFont() async {
    return pw.Font.ttf(
      await rootBundle.load("assets/fonts/NotoSansSymbols2-Regular.ttf"),
    );
  }

  Future<File> getClassReportCards(
    Map<int, List<dynamic>> studentsInClass,
  ) async {
    final imageByte = await File(getSchoolLogoPath()).readAsBytes();
    final image = pw.MemoryImage(imageByte);

    final font = await _loadFont();

    final pdf = pw.Document();
    final length = studentsInClass.length;

    // final watermarkTheme = pw.PageTheme(
    //       buildBackground: (context) => pw.Center(
    //         child: pw.Transform.rotate(
    //           angle: -math.pi / 4,
    //           child: pw.Opacity(
    //             opacity: 0.1,
    //             child: pw.Text(
    //               'BashLearnTech',
    //               style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold),
    //             ),
    //           ),
    //         ),
    //       ),
    //     );
    for (int index = 0; index < studentsInClass.length; index++) {
      final studentRecords = studentsInClass[index] as List<dynamic>;
      addPdfPage(pdf, studentRecords, length, font, image);
    }

    return _savePdfFile(pdf, selectedClass!);
  }

  Future<File> generateStudentReportCard(
    List<dynamic> studentRecords,
    int length,
  ) async {
    final imageByte = await File(getSchoolLogoPath()).readAsBytes();
    final image = pw.MemoryImage(imageByte);

    final StudentModel student = studentRecords[0];
    final pdf = pw.Document();
    // final watermarkTheme = pw.PageTheme(
    //   buildBackground: (context) => pw.Center(
    //     child: pw.Transform.rotate(
    //       angle: -math.pi / 4,
    //       child: pw.Opacity(
    //         opacity: 0.1,
    //         child: pw.Text(
    //           'BashLearnTech',
    //           style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold),
    //         ),
    //       ),
    //     ),
    //   ),
    // );
    final font = pw.Font.ttf(
      await rootBundle.load("assets/fonts/NotoSansSymbols2-Regular.ttf"),
    );

    addPdfPage(pdf, studentRecords, length, font, image);

    return _savePdfFile(pdf, student.name);
  }

  void addPdfPage(
    pw.Document pdf,
    List<dynamic> studentRecords,
    int length,
    pw.Font font,
    pw.MemoryImage image,
  ) {
    final StudentModel student = studentRecords[0];
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        //pageTheme: pageTheme,
        margin: pw.EdgeInsets.only(top: 10),
        build: (pw.Context context) {
          return pw.Padding(
            padding: const pw.EdgeInsets.all(20),
            child: pw.Column(
              children: [
                _buildHeader(student, image),
                pw.SizedBox(height: 10),
                _buildStudentInfo(student, length),
                pw.SizedBox(height: 10),
                _buildSubjectsTable(studentRecords, font),
                pw.SizedBox(height: 10),
                _buildSkillsAndBehaviorSection(studentRecords, font),
                pw.SizedBox(height: 10),
                _buildRemarksSection(studentRecords),
              ],
            ),
          );
        },
      ),
    );
  }

  pw.Widget _buildHeader(StudentModel student, pw.MemoryImage image) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.center,
      children: [
        pw.Text(
          getSchoolPropertyValue(schoolName).toUpperCase(),
          style: pw.TextStyle(
            fontSize: 24,
            fontWeight: pw.FontWeight.bold,
            color: PdfColors.blue800,
          ),
        ),
        pw.SizedBox(height: 5),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.center,
          children: [
            pw.Container(
              width: 60,
              height: 60,
              // decoration: pw.BoxDecoration(
              //   border: pw.Border.all(),
              //   shape: pw.BoxShape.circle,
              // ),
              child: pw.ClipOval(
                child: pw.Center(
                  child: pw.Image(
                    image,
                    fit: pw.BoxFit.contain,
                  ), //pw.Text("Logo", style: pw.TextStyle(fontSize: 10)),
                ),
              ),
            ),
            pw.SizedBox(width: 10),
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              children: [
                pw.Text(
                  getSchoolPropertyValue(schoolAddress),
                  style: pw.TextStyle(fontSize: 15, color: PdfColors.blue800),
                ),
                pw.Text(
                  getSchoolPropertyValue(schoolTel),
                  style: pw.TextStyle(fontSize: 12, color: PdfColors.blue800),
                ),
              ],
            ),
            pw.SizedBox(width: 10),
            pw.Container(
              width: 100,
              height: 30,
              decoration: pw.BoxDecoration(border: pw.Border.all()),
              child: pw.Center(
                child: pw.Text(
                  "ADM. NO: ${student.id.toString().padLeft(4, '0')}",
                  style: pw.TextStyle(fontSize: 10),
                ),
              ),
            ),
          ],
        ),
        pw.SizedBox(height: 5),
        pw.Text(
          "CONTINUOUS ASSESSMENT DOSSIER",
          style: pw.TextStyle(
            fontSize: 12,
            fontWeight: pw.FontWeight.bold,
            color: PdfColors.blue800,
          ),
        ),
      ],
    );
  }

  pw.Widget _buildStudentInfo(StudentModel student, int length) {
    return pw.Row(
      children: [
        pw.Expanded(
          child: pw.Table(
            defaultColumnWidth: const pw.IntrinsicColumnWidth(),
            border: pw.TableBorder.all(),
            children: [
              pw.TableRow(
                children: [
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(4),
                    child: pw.Text("Termly Academic Report:"),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(4),
                    child: pw.Text(getTermParameterValue(termlyReport)),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(4),
                    child: pw.Text("Term"),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(4),
                    child: pw.Text(getTermParameterValue(termIn)),
                  ),
                ],
              ),
              pw.TableRow(
                children: [
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(4),
                    child: pw.Text("Name:"),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(4),
                    child: pw.Text(student.name,softWrap: true),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(4),
                    child: pw.Text("Class"),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(4),
                    child: pw.Text(student.studentClass),
                  ),
                ],
              ),
              pw.TableRow(
                children: [
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(4),
                    child: pw.Text("Age:"),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(4),
                    child: pw.Text(student.age.toString()),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(4),
                    child: pw.Text("Average:"),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(4),
                    child: pw.Text("${student.averageScore ?? 0.0}"),
                  ),
                ],
              ),
              pw.TableRow(
                children: [
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(4),
                    child: pw.Text("No. in class: "),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(4),
                    child: pw.Text("$length"),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(4),
                    child: pw.Text("No. in Attendance: "),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(4),
                    child: pw.Text(student.noInAttendance.toString()),
                  ),
                ],
              ),
              pw.TableRow(
                children: [
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(4),
                    child: pw.Text("No. of Time School opened: "),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(4),
                    child: pw.Text(getTermParameterValue(noOfTermSchool)),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(4),
                    child: pw.Text("Next Term Begins:"),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(4),
                    child: pw.Text(getTermParameterValue(nextTermBegin)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  pw.Widget _buildSubjectsTable(List<dynamic> studentRecords, pw.Font font) {
    final List<SubjectModel> subjectsRecord = studentRecords[1];
    final StudentModel student = studentRecords[0];

    return pw.Table(
      //tableWidth: pw.TableWidth.min,
      border: pw.TableBorder.all(),
      defaultColumnWidth: const pw.IntrinsicColumnWidth(),
      children: [
        pw.TableRow(
          decoration: pw.BoxDecoration(color: PdfColors.grey300),
          children: [
            _buildTableCell("S/N", isHeader: true),
            _buildTableCell(
              "Subjects",
              isHeader: true,
              alignment: pw.Alignment.centerLeft,
            ),
            _buildTableCell("CA1 20", isHeader: true, fontSize: 7),
            _buildTableCell("CA2 20", isHeader: true, fontSize: 7),
            _buildTableCell("Exam 60", isHeader: true, fontSize: 7),
            pw.Column(
              mainAxisAlignment: pw.MainAxisAlignment.center,
              children: [
                _buildTableCell("Term", isHeader: true, fontSize: 7),
                _buildTableCell("Total", isHeader: true, fontSize: 7),
              ],
            ),
            pw.Column(
              //mainAxisAlignment: pw.MainAxisAlignment.center,
              children: [
                _buildTableCell("Class", isHeader: true, fontSize: 8),
                _buildTableCell("Average", isHeader: true, fontSize: 8),
              ],
            ),
            pw.Column(
              mainAxisAlignment: pw.MainAxisAlignment.center,
              children: [
                _buildTableCell("Highest", isHeader: true, fontSize: 8),
                _buildTableCell("in Class", isHeader: true, fontSize: 8),
              ],
            ),
            pw.Column(
              //mainAxisAlignment: pw.MainAxisAlignment.center,
              children: [
                _buildTableCell("Lowest", isHeader: true, fontSize: 8),
                _buildTableCell("in Class", isHeader: true, fontSize: 8),
              ],
            ),
            _buildTableCell("Grade", isHeader: true, fontSize: 8),
            pw.Column(
              mainAxisAlignment: pw.MainAxisAlignment.center,
              children: [
                _buildTableCell("Subject", isHeader: true, fontSize: 8),
                _buildTableCell(
                  "Teacher's Remarks",
                  isHeader: true,
                  fontSize: 8,
                ),
                _buildTableCell(
                  "(Learning Attitude)",
                  isHeader: true,
                  fontSize: 8,
                ),
              ],
            ),
          ],
        ),
        ...List.generate(subjectsRecord.length, (index) {
          final subject = subjectsRecord[index];
          return pw.TableRow(
            children: [
              _buildTableCell("${index + 1}"),
              _buildTableCell(
                subject.subjectName,
                alignment: pw.Alignment.centerLeft,
                font: font
              ),
              _buildTableCell("${subject.ca1 ?? 0.0}"),
              _buildTableCell("${subject.ca2 ?? 0.0}"),
              _buildTableCell("${subject.exam ?? 0.0}"),
              _buildTableCell("${subject.score ?? 0.0}"),
              _buildTableCell("${subject.averageInClass ?? 0.0}"),
              _buildTableCell("${subject.heighestInClass ?? 0.0}"),
              _buildTableCell("${subject.lowestInClass ?? 0.0}"),
              _buildTableCell(getGrade(subject.score ?? 0)),
              _buildTableCell(
                getTeacherRemarks(subject.score ?? 0),
                alignment: pw.Alignment.centerLeft,
              ),
            ],
          );
        }),
        pw.TableRow(
          children: [
            _buildTableCell(""),
            _buildTableCell("TOTAL", fontWeight: pw.FontWeight.bold),
            _buildTableCell(""),
            _buildTableCell(""),
            _buildTableCell(""),
            _buildTableCell("${student.totalScore ?? 0.0}", isHeader: true),
            _buildTableCell(""),
            _buildTableCell(""),
            _buildTableCell(""),
            _buildTableCell(""),
            _buildTableCell(""),
          ],
        ),
      ],
    );
  }

  pw.Widget _buildSkillsAndBehaviorSection(
    List<dynamic> studentRecords,
    pw.Font font,
  ) {
    final SkillModel skill = studentRecords[2];
    final BehaviorModel behavior = studentRecords[3];

    String checkmark = "✓"; // checkmark

    final Map<String, int> skillValue = {
      "Handwriting": skill.handwriting ?? 1,
      "Fluency": skill.fluency ?? 1,
      "Game": skill.game ?? 1,
      "Gymnastic": skill.gymnastic ?? 1,
      "Handling of Tools": skill.handlingOfTools ?? 1,
      "Drawing & Painting": skill.drawingAndPainting ?? 1,
      "Crafts": skill.crafts ?? 1,
      "Musical Skill": skill.musicalSkill ?? 1,
    };

    final Map<String, int> behaviorValue = {
      "Punctuality": behavior.punctuality ?? 1,
      "Attendance in Class": behavior.attendance ?? 1,
      "Reliability": behavior.reliability ?? 1,
      "Neatness": behavior.neatness ?? 1,
      "Politeness": behavior.politeness ?? 1,
      "Honest": behavior.honesty ?? 1,
      "Relationship with Staff": behavior.relationshipWithStaff ?? 1,
      "Relationship with Student": behavior.relationshipWithStudents ?? 1,
      "Self-control": behavior.selfControl ?? 1,
      "Spirit of Cooperation": behavior.spiritOfCooperation ?? 1,
      "Sense of Responsibility": behavior.senseOfResponsibility ?? 1,
      "Attentiveness": behavior.attentiveness ?? 1,
      "Initiative": behavior.initiative ?? 1,
      "Organization Ability": behavior.organizationAbility ?? 1,
      "Perseverance": behavior.perseverance ?? 1,
      "Physical Dev": behavior.physicalDev ?? 1,
    };

    return pw.Row(
      //crossAxisAlignment: pw.CrossAxisAlignment.center,
      mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
      //mainAxisSize: pw.MainAxisSize.max,
      children: [
        pw.Expanded(
          flex: 1,
          child: pw.Column(
            //crossAxisAlignment: pw.CrossAxisAlignment.center,
            children: [
              //pw.SizedBox(height: 5),
              pw.Table(
                tableWidth: pw.TableWidth.max,
                border: pw.TableBorder.all(),
                defaultColumnWidth: const pw.IntrinsicColumnWidth(),
                children: [
                  pw.TableRow(
                    children: [
                      // table header for skills
                      _buildTableCell(""),
                      _buildTableCell(
                        "SKILLS",
                        alignment: pw.Alignment.centerLeft,
                        isHeader: true,
                      ),
                      _buildTableCell("5", isHeader: true),
                      _buildTableCell("4", isHeader: true),
                      _buildTableCell("3", isHeader: true),
                      _buildTableCell("2", isHeader: true),
                      _buildTableCell("1", isHeader: true),
                    ],
                  ),
                  // skill rows
                  ...skillValue.entries.map((entry) {
                    return pw.TableRow(
                      children: [
                        _buildTableCell(
                          "${skillValue.keys.toList().indexOf(entry.key) + 1}",
                        ),
                        _buildTableCell(
                          entry.key,
                          alignment: pw.Alignment.centerLeft,
                        ),
                        _buildTableCell(
                          entry.value == 5 ? checkmark : "",
                          font: font,
                        ),
                        _buildTableCell(
                          entry.value == 4 ? checkmark : "",
                          font: font,
                        ),
                        _buildTableCell(
                          entry.value == 3 ? checkmark : "",
                          font: font,
                        ),
                        _buildTableCell(
                          entry.value == 2 ? checkmark : "",
                          font: font,
                        ),
                        _buildTableCell(
                          entry.value == 1 ? checkmark : "",
                          font: font,
                        ),
                      ],
                    );
                  }),
                ],
              ),
            ],
          ),
        ),
        //pw.SizedBox(width: 10),
        pw.Expanded(
          flex: 2,
          child: pw.Column(
            //crossAxisAlignment: pw.CrossAxisAlignment.center,
            children: [
              pw.Table(
                tableWidth: pw.TableWidth.max,
                border: pw.TableBorder.all(),
                defaultColumnWidth: const pw.IntrinsicColumnWidth(),

                children: [
                  pw.TableRow(
                    children: [
                      _buildTableCell(""),
                      _buildTableCell(
                        "BEHAVIOR",
                        isHeader: true,
                        alignment: pw.Alignment.centerLeft,
                      ),
                      _buildTableCell("5", isHeader: true),
                      _buildTableCell("4", isHeader: true),
                      _buildTableCell("3", isHeader: true),
                      _buildTableCell("2", isHeader: true),
                      _buildTableCell("1", isHeader: true),
                      _buildTableCell(""),
                      _buildTableCell(
                        "BEHAVIOR",
                        isHeader: true,
                        alignment: pw.Alignment.centerLeft,
                      ),
                      _buildTableCell("5", isHeader: true),
                      _buildTableCell("4", isHeader: true),
                      _buildTableCell("3", isHeader: true),
                      _buildTableCell("2", isHeader: true),
                      _buildTableCell("1", isHeader: true),
                    ],
                  ),
                  _buildBehaviorRow(
                    1,
                    "Punctuality",
                    "Self-control",
                    behaviorValue,
                    font: font,
                  ),
                  _buildBehaviorRow(
                    2,
                    "Attendance in Class",
                    "Spirit of Cooperation",
                    behaviorValue,
                    font: font,
                  ),
                  _buildBehaviorRow(
                    3,
                    "Reliability",
                    "Sense of Responsibility",
                    behaviorValue,
                    font: font,
                  ),
                  _buildBehaviorRow(
                    4,
                    "Neatness",
                    "Attentiveness",
                    behaviorValue,
                    font: font,
                  ),
                  _buildBehaviorRow(
                    5,
                    "Politeness",
                    "Initiative",
                    behaviorValue,
                    font: font,
                  ),
                  _buildBehaviorRow(
                    6,
                    "Honest",
                    "Organization Ability",
                    behaviorValue,
                    font: font,
                  ),
                  _buildBehaviorRow(
                    7,
                    "Relationship with Staff",
                    "Perseverance",
                    behaviorValue,
                    font: font,
                  ),
                  _buildBehaviorRow(
                    8,
                    "Relationship with Student",
                    "Physical Dev",
                    behaviorValue,
                    font: font,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  pw.Widget _buildTableCell(
    String name, {
    bool isHeader = false,
    pw.FontWeight? fontWeight,
    double fontSize = 8,
    pw.Font? font,
    pw.Alignment? alignment,
  }) {
    return pw.Container(
      alignment: alignment ?? pw.Alignment.center,
      padding: const pw.EdgeInsets.all(2),
      decoration: isHeader
          ? pw.BoxDecoration(
              //border: pw.Border.all(color: PdfColors.blue800, width: 0.5),
              color: PdfColors.grey300,
            )
          : null,
      child: pw.Text(
        overflow: pw.TextOverflow.clip,
        name,
        style: pw.TextStyle(
          font: font,
          fontSize: fontSize,
          fontWeight:
              fontWeight ??
              (isHeader ? pw.FontWeight.bold : pw.FontWeight.normal),
        ),
        textAlign: pw.TextAlign.center,
      ),
    );
  }

  pw.TableRow _buildBehaviorRow(
    int value,
    String leftLabel,
    String rightLabel,
    Map<String, int> behavior, {
    pw.Font? font,
  }) {
    String checkmark = "✓"; // Copy this checkmark
    return pw.TableRow(
      children: [
        _buildTableCell("$value"),
        _buildTableCell(leftLabel, alignment: pw.Alignment.centerLeft),
        _buildTableCell(behavior[leftLabel] == 5 ? checkmark : "", font: font),
        _buildTableCell(behavior[leftLabel] == 4 ? checkmark : "", font: font),
        _buildTableCell(behavior[leftLabel] == 3 ? checkmark : "", font: font),
        _buildTableCell(behavior[leftLabel] == 2 ? checkmark : "", font: font),
        _buildTableCell(behavior[leftLabel] == 1 ? checkmark : "", font: font),
        _buildTableCell("${value + 8}"),
        _buildTableCell(rightLabel, alignment: pw.Alignment.centerLeft),
        _buildTableCell(behavior[rightLabel] == 5 ? checkmark : "", font: font),
        _buildTableCell(behavior[rightLabel] == 4 ? checkmark : "", font: font),
        _buildTableCell(behavior[rightLabel] == 3 ? checkmark : "", font: font),
        _buildTableCell(behavior[rightLabel] == 2 ? checkmark : "", font: font),
        _buildTableCell(behavior[rightLabel] == 1 ? checkmark : "", font: font),
      ],
    );
  }

  pw.Widget resultSummary(List<dynamic> studentRecords) {
    final StudentModel student = studentRecords[0];
    final length = studentRecords[1].length;
    return pw.Container(
      decoration: pw.BoxDecoration(border: pw.Border.all()),
      padding: const pw.EdgeInsets.all(8),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text("Total Subjects: $length"),
          pw.Text("Total Score: ${student.totalScore ?? ""}"),
          pw.Text("Average Score: ${student.averageScore ?? ""}"),
        ],
      ),
    );
  }

  pw.Widget _buildRemarksSection(List<dynamic> studentRecords) {
    final StudentModel student = studentRecords[0];
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Row(
          children: [
            pw.Expanded(
              child: pw.Container(
                decoration: pw.BoxDecoration(border: pw.Border.all()),
                padding: const pw.EdgeInsets.all(8),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      "Form Master's Remarks: ${student.mRemark ?? ""}",
                      style: pw.TextStyle(
                        fontSize: 10,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.SizedBox(height: 10),
                    pw.Text(
                      "Signature & Date: ${student.mDate ?? ""}",
                      style: pw.TextStyle(fontSize: 10),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        pw.Row(
          children: [
            pw.Expanded(
              child: pw.Container(
                decoration: pw.BoxDecoration(border: pw.Border.all()),
                padding: const pw.EdgeInsets.all(8),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      "Form Principal's Remarks: ${student.pRemark ?? ""}",
                      style: pw.TextStyle(
                        fontSize: 10,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.SizedBox(height: 10),
                    pw.Text(
                      "Signature & Date: ${student.pDate ?? ""}",
                      style: pw.TextStyle(fontSize: 10),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Future<File> _savePdfFile(pw.Document pdf, String name) async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final String fileName =
        "reportCard_${name.replaceAll(" ", "_")}_${DateTime.now().millisecondsSinceEpoch}.pdf";
    final String filePath = "${directory.path}/$fileName";
    final File file = File(filePath);
    await file.writeAsBytes(await pdf.save());
    return file;
  }
}
