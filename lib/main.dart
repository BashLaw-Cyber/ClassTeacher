import 'package:classreportsheet/pages/assessment_scenes/asssessments_page.dart';
import 'package:classreportsheet/pages/home_page.dart';
import 'package:classreportsheet/pages/result_scenes/results_page.dart';
import 'package:classreportsheet/pages/search_page.dart';
import 'package:classreportsheet/pages/setting_scenes/setting_page.dart';
import 'package:classreportsheet/pages/student_scenes/student_page.dart';
import 'package:classreportsheet/pages/subject_scenes/subject_page.dart';
import 'package:classreportsheet/pages/term_scenes/term_session_page.dart';
import 'package:classreportsheet/providers/student_provider.dart';
import 'package:classreportsheet/util/constant.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox<List>(classList);
  await Hive.openBox<List>(departmentList);
  await Hive.openBox<List>(classSubjects);
  await Hive.openBox<List>(departmentSubjects);
  await Hive.openBox<List>(allSubject);
  await Hive.openBox<List>(termsParameters);
  await Hive.openBox<List>(schoolProperties);
  await Hive.openBox<List>(schoolLogo);

  runApp(
    ChangeNotifierProvider(
      create: (context) => StudentProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: router,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      builder: EasyLoading.init(),
    );
  }

  final router = GoRouter(
    initialLocation: HomePage.route,
    routes: [
      GoRoute(
        name: HomePage.route,
        path: HomePage.route,
        builder: (context, state) => HomePage(),
        routes: [
          GoRoute(
            name: StudentPage.route,
            path: StudentPage.route,
            builder: (context, state) => StudentPage(),
            routes: [
              GoRoute(
                path: SearchPage.route,
                name: SearchPage.route,
                builder: (context, state) {
                  return StudentPage();
                },
              ),
            ],
          ),
          GoRoute(
            name: SubjectPage.route,
            path: SubjectPage.route,
            builder: (context, state) => SubjectPage(),
          ),
          GoRoute(
            path: AssessmentsPage.route,
            name: AssessmentsPage.route,
            builder: (context, state) => AssessmentsPage(
              mapOfClassRecord:
                  state.extra as Map<String, Map<int, List<dynamic>>>,
            ),
          ),
          GoRoute(
            path: ResultsPage.route,
            name: ResultsPage.route,
            builder: (context, state) => ResultsPage(
              mapOfClassCardReport:
                  state.extra as Map<String, Map<int, List<dynamic>>>,
            ),
          ),
          GoRoute(
            path: SettingPage.route,
            name: SettingPage.route,
            builder: (context, state) => SettingPage(),
          ),

          GoRoute(
            path: TermSessionPage.route,
            name: TermSessionPage.route,
            builder: (context, state) => TermSessionPage(),
          ),
        ],
      ),
    ],
  );
}
