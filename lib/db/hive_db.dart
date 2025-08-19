import 'dart:io';

import 'package:hive/hive.dart';

import '../util/constant.dart';

void initializeSubjects() {
  var predefinedBox = Hive.box<List>(allSubject);
  if (predefinedBox.isEmpty) {
    predefinedBox.put(predefined, predefinedSubjects);
  }
}

void addSubject(String subject) {
  var predefinedBox = Hive.box<List>(allSubject);
  List<String> mySubjects = List<String>.from(
    predefinedBox.get(predefined, defaultValue: []) as Iterable,
  );
  if (!(mySubjects.any((s) => s.toLowerCase() == subject.toLowerCase()))) {
    mySubjects.add(subject);
    predefinedBox.put(predefined, mySubjects);
  }
}

void addClass(String className) {
  var classBox = Hive.box<List>(classList);
  List<String> myClasses = List<String>.from(
    classBox.get(classes, defaultValue: []) as Iterable,
  );
  if (!myClasses.contains(className)) {
    myClasses.add(className);
    classBox.put(classes, myClasses);
  }
}

void addClassSubject(String className, String subject) {
  var classSubjectBox = Hive.box<List>(classSubjects);
  List<String> myClassSubjects = List<String>.from(
    classSubjectBox.get(className, defaultValue: []) as Iterable,
  );
  if (!myClassSubjects.contains(subject)) {
    myClassSubjects.add(subject);
    classSubjectBox.put(className, myClassSubjects);
  }
}

void addDepartment(String departmentName) {
  var departmentBox = Hive.box<List>(departmentList);
  List<String> myDepartments = List<String>.from(
    departmentBox.get(departments, defaultValue: []) as Iterable,
  );
  if (!myDepartments.contains(departmentName)) {
    myDepartments.add(departmentName);
    departmentBox.put(departments, myDepartments);
  }
}

void addSchoolProperty(String schoolPropertyArgument, dynamic value) {
  var schoolPropertyBox = Hive.box<List>(schoolProperties);
  List<String> mySchoolProperty = List<String>.from(
    schoolPropertyBox.get(schoolPropertyArgument, defaultValue: []) as Iterable,
  );
  if (mySchoolProperty.isNotEmpty) {
    mySchoolProperty.removeLast();
    mySchoolProperty.add(value);
  } else {
    mySchoolProperty.add(value);
  }
  schoolPropertyBox.put(schoolPropertyArgument, mySchoolProperty);
}

void addDepartmentSubject(String departmentName, String subject) {
  var departmentSubjectBox = Hive.box<List>(departmentSubjects);
  List<String> myDepartmentSubjects = List<String>.from(
    departmentSubjectBox.get(departmentName, defaultValue: []) as Iterable,
  );
  if (!myDepartmentSubjects.contains(subject)) {
    myDepartmentSubjects.add(subject);
    departmentSubjectBox.put(departmentName, myDepartmentSubjects);
  }
}

void saveTermsParameters(String termArgument, dynamic value) {
  var termBox = Hive.box<List>(termsParameters);
  List<String> myTermValue = List<String>.from(
    termBox.get(termArgument, defaultValue: []) as Iterable,
  );
  if (myTermValue.isNotEmpty) {
    myTermValue.removeLast();
    myTermValue.add(value);
  } else {
    myTermValue.add(value);
    //termBox.put(termArgument, myTermValue);
  }
  termBox.put(termArgument, myTermValue);
}

void saveSchoolLogo(File logoImage) {
  var schoolLogoBox = Hive.box<List>(schoolLogo);
  List<String> mySchoolLogo = List<String>.from(
    schoolLogoBox.get(schoolImage, defaultValue: []) as Iterable,
  );

  if(mySchoolLogo.isNotEmpty){
    mySchoolLogo.removeLast();
    mySchoolLogo.add(logoImage.path);
  }else{
    mySchoolLogo.add(logoImage.path);
  }

  schoolLogoBox.put(schoolImage, mySchoolLogo);
}

void removeClass(String className) {
  var classBox = Hive.box<List>(classList);
  var subjectBox = Hive.box<List>(classSubjects);
  List<String> myClasses = List<String>.from(
    classBox.get(classes, defaultValue: []) as Iterable,
  );
  if (myClasses.contains(className)) {
    myClasses.remove(className);
    classBox.put(classes, myClasses);
    subjectBox.delete(className);
  }
}

void removeClassSubject(String className, String subject) {
  var classSubjectBox = Hive.box<List>(classSubjects);
  List<String> myClassSubjects = List<String>.from(
    classSubjectBox.get(className, defaultValue: []) as Iterable,
  );
  if (myClassSubjects.contains(subject)) {
    myClassSubjects.remove(subject);
    classSubjectBox.put(className, myClassSubjects);
  }
}

void removeDepartment(String departmentName) {
  var departmentBox = Hive.box<List>(departmentList);
  var departmentSubjectBox = Hive.box<List>(departmentSubjects);
  List<String> myDepartments = List<String>.from(
    departmentBox.get(departments, defaultValue: []) as Iterable,
  );

  if (myDepartments.contains(departmentName)) {
    myDepartments.remove(departmentName);
    departmentBox.put(departments, myDepartments);
    departmentSubjectBox.delete(departmentName);
  }
}

void removerDepartmentSubject(String departmentName, String subject) {
  var departmentSubjectsBox = Hive.box<List>(departmentSubjects);
  List<String> myDepartmentSubjects = List<String>.from(
    departmentSubjectsBox.get(departmentName, defaultValue: []) as Iterable,
  );
  if (myDepartmentSubjects.contains(subject)) {
    myDepartmentSubjects.remove(subject);
    departmentSubjectsBox.put(departmentName, myDepartmentSubjects);
  }
}

List<String> getAllSubjects() {
  var predefinedBox = Hive.box<List>(allSubject);

  return List<String>.from(
    predefinedBox.get(predefined, defaultValue: []) as Iterable,
  );
}

List<String> getAllClasses() {
  var classBox = Hive.box<List>(classList);
  return List<String>.from(classBox.get(classes, defaultValue: []) as Iterable);
}

List<String> getAllClassesSubjects(String className) {
  var classSubjectBox = Hive.box<List>(classSubjects);
  return List<String>.from(
    classSubjectBox.get(className, defaultValue: []) as Iterable,
  );
}

List<String> getAllDepartments() {
  var departmentBox = Hive.box<List>(departmentList);
  return List<String>.from(
    departmentBox.get(departments, defaultValue: []) as Iterable,
  );
}

List<String> getDepartmentSubjects(String departmentName) {
  var departmentSubjectBox = Hive.box<List>(departmentSubjects);
  return List<String>.from(
    departmentSubjectBox.get(departmentName, defaultValue: []) as Iterable,
  );
}

String getTermParameterValue(String termArgument) {
  var termBox = Hive.box<List>(termsParameters);
  var myValue = List<String>.from(
    termBox.get(termArgument, defaultValue: []) as Iterable,
  );
  if (myValue.isEmpty) {
    return "";
  }
  return myValue.first;
}

String getSchoolPropertyValue(String schoolArgument) {
  var schoolPropertyBox = Hive.box<List>(schoolProperties);
  var myValue = List<String>.from(
    schoolPropertyBox.get(schoolArgument, defaultValue: []) as Iterable,
  );
  if (myValue.isEmpty) {
    return "";
  }
  return myValue.first;
}

String getSchoolLogoPath(){
  var schoolLogoBox = Hive.box<List>(schoolLogo);

  var myPath = List<String>.from(schoolLogoBox.get(schoolImage, defaultValue: [])as Iterable);
  if(myPath.isEmpty){
    return "";
  }
  return myPath.first;
}
