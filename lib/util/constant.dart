import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final gridColor = Colors.white;
final backgroundColor = Color(0xFFF8F8F8);
final String science = "Science";
final String art = "Art";
final String commercial = "Commercial";
final String all = "All";
bool onTap = false;
final normalFontStyle = GoogleFonts.roboto(
  fontSize: 20,
  color: Colors.black,
  fontWeight: FontWeight.bold,
);

// Hive database name
final String classList = "classList";
final String departmentList = "departmentList";
final String classSubjects = "classSubjects";
final String departmentSubjects = "departmentSubjects";
final String allSubject = "allSubjects";
final String termsParameters = " termsparameters";
final String schoolProperties = "schoolProperties";
final String schoolLogo = "schoolLogo";

// term arguments
final String termlyReport = 'termlyReport';
final String termIn = "termIn";
final String noOfTermSchool = "noOfTermSchool";
final String nextTermBegin = "nextTermBegin";

// school properties argument
final String schoolName = "schoolName";
final String schoolAddress = "schoolAddress";
final String schoolTel = "schoolTelephone";
final String schoolImage = "schoolLogo";


// Hive keys
final String classes = "classes";
final String predefined = "predefined";
final String departments = "departments";

final studentDetailStyle = GoogleFonts.roboto(fontSize: 16, color: Colors.black);

final oldDepartments = ["Art", "Commercial", "Science"];

final List<String> myClasses = [
  "ALL",
  "JSS1",
  "JSS2",
  "JSS3",
  "SSS1",
  "SSS2",
  "SSS3",
];

final classes1 = ["JSS1", "JSS2", "JSS3", "SSS1", "SSS2", "SSS3"];

final List<String> predefinedSubjects = [
  "English Language",
  "Mathematics",
  "Biology",
  "Chemistry",
  "Physics",
  "Geography",
  "Government",
  "Computer Science",
  "Agricultural Science",
  "Home Economics",
  "Civic Education",
  "Hausa",
  "Toiletries",
  "Commerce",
  "Economics",
  "Religion",
  "Marketing",
  "Music",
  "Accounting",
  "Literature in English",
  "Diction",
];

Map<String, List<String>> departmentDefaults = {
  all: [
    "English Language",
    "Mathematics",
    "Computer Science",
    "Agricultural Science / Food & Nutrition",
    "Home Economics",
    "Civic Education",
    "Hausa",
    "Toiletries",
    "Religion",
    "Diction",
  ],
  oldDepartments[2]: [
    "English Language",
    "Mathematics",
    "Physics",
    "Chemistry",
    "Biology",
    "Agricultural Science / Food & Nutrition",
    "Civic Education",
    "Marketing",
    "Diction",
  ],
  oldDepartments[0]: [
    "English Language",
    "Mathematics",
    "Government",
    "Civic Education",
    "Economics",
    "Religion",
    "Marketing",
    "Literature in English",
    "Diction",
  ],
  oldDepartments[1]: [
    "English Language",
    "Mathematics",
    "Civic Education",
    "Commerce",
    "Economics",
    "Accounting",
    "Marketing",
    "Diction",
  ],
};

