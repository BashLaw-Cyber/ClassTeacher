import 'package:flutter/material.dart';

void showMsg(BuildContext context, String msg) {
  showDialog(
    context: context,
    builder:
        (context) => AlertDialog(
          title: Text("Caution"),
          content: Text(msg),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Ok"),
            ),
          ],
        ),
  );
}

showSnackMsg(BuildContext context, String msg) {
  return ScaffoldMessenger.of(
    context,
  ).showSnackBar(SnackBar(content: Text(msg)));
}

String getGrade(double value) {
  if (value >= 70) {
    return "A";
  } else if (value >= 60) {
    return "B";
  } else if (value >= 50) {
    return "C";
  } else if (value >= 45) {
    return "D";
  } else if (value >= 40) {
    return "E";
  } else if (value == 0) {
    return "Abscond";
  } else {
    return "F";
  }
}

String getTeacherRemarks(double value) {
  if (value >= 80) {
    return "Excellent";
  } else if (value >= 70) {
    return "Very Good";
  } else if (value >= 60) {
    return "Good";
  } else if (value >= 50) {
    return "Credit";
  } else if (value >= 40) {
    return "Pass";
  } else if (value == 0) {
    return "Abscond";
  } else {
    return "Fair";
  }
}
