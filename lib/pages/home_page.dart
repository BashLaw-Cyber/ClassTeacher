import 'package:classreportsheet/custom_widget/dashboard_model.dart';
import 'package:classreportsheet/db/hive_db.dart';
import 'package:classreportsheet/pages/assessment_scenes/asssessments_page.dart';
import 'package:classreportsheet/pages/result_scenes/results_page.dart';
import 'package:classreportsheet/pages/setting_scenes/setting_page.dart';
import 'package:classreportsheet/pages/student_scenes/student_page.dart';
import 'package:classreportsheet/pages/subject_scenes/subject_page.dart';
import 'package:classreportsheet/pages/term_scenes/term_session_page.dart';
import 'package:classreportsheet/providers/student_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../util/constant.dart';

class HomePage extends StatefulWidget {
  static final String route = "/";

  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedValue = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        actions: [
          //IconButton(onPressed: () {}, icon: Icon(Icons.search)),
          PopupMenuButton(
            color: Colors.grey[200],
            onSelected: (value) {
              switch (value) {
                case "Class":
                  break;
                case "Student":
                  break;
                case "Results":
                  break;
                case "Setting":
                  break;
                case "Logout":
                  break;
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(value: "Class", child: Text("Class")),
              PopupMenuItem(value: "Student", child: Text("Student")),
              PopupMenuItem(value: "Results", child: Text("Result")),
              PopupMenuItem(value: "Setting", child: Text("Setting")),
              PopupMenuItem(value: "Logout", child: Text("Logout")),
            ],
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0, top: 16.0),
              child: Text(
                "Dashboard",
                style: GoogleFonts.roboto(
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16.0,
                  mainAxisSpacing: 16.0,
                  childAspectRatio: 1,
                  children: [
                    DashboardModel(
                      title: "Students",
                      icon: Icons.school,
                      onTap: () {
                        context.goNamed(StudentPage.route);
                      },
                    ),
                    DashboardModel(
                      title: "Subjects",
                      icon: Icons.menu_book,
                      onTap: () {
                        context.goNamed(SubjectPage.route);
                      },
                    ),
                    DashboardModel(
                      title: "Assessments",
                      icon: Icons.assignment,
                      onTap: () async {
                        final classes = getAllClasses();
                        final provider = Provider.of<StudentProvider>(
                          context,
                          listen: false,
                        );
                        EasyLoading.show(status: "Please wait...");
                        final mapOfClassCardReport = await provider
                            .mapOfClassCardReport(classes);
                        EasyLoading.dismiss();
                        context.goNamed(AssessmentsPage.route, extra: mapOfClassCardReport);
                      },
                    ),
                    DashboardModel(
                      title: "Results",
                      icon: Icons.assessment,
                      onTap: () async {
                        final classes = getAllClasses();
                        final provider = Provider.of<StudentProvider>(
                          context,
                          listen: false,
                        );
                        EasyLoading.show(status: "Please wait...");
                        final mapOfClassCardReport = await provider
                            .mapOfClassCardReport(classes);
                        EasyLoading.dismiss();
                        context.goNamed(ResultsPage.route, extra: mapOfClassCardReport);
                      },
                    ),
                    DashboardModel(
                      title: "Term Session",
                      icon: Icons.calendar_today,
                      onTap: () {
                        context.goNamed(TermSessionPage.route);
                      },
                    ),
                    DashboardModel(title: "Settings", icon: Icons.settings, onTap: () {
                      context.goNamed(SettingPage.route);
                    }),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        padding: EdgeInsets.zero,
        child: BottomNavigationBar(
          selectedItemColor: Colors.blue,
          currentIndex: selectedValue,
          onTap: (value) {
            setState(() {
              selectedValue = value;
            });
          },
          backgroundColor: gridColor,
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.person), label: ""),
            BottomNavigationBarItem(icon: Icon(Icons.subject_sharp), label: ""),
            BottomNavigationBarItem(icon: Icon(Icons.restart_alt), label: ""),
          ],
        ),
      ),
    );
  }
}
