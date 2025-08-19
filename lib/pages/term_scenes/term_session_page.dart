import 'package:classreportsheet/db/hive_db.dart';
import 'package:flutter/material.dart';

import '../../util/constant.dart';

class TermSessionPage extends StatefulWidget {
  static final String route = "termSessionPage";
  const TermSessionPage({super.key});

  @override
  State<TermSessionPage> createState() => _TermSessionPageState();
}

class _TermSessionPageState extends State<TermSessionPage> {
  bool yes = false;

  TextEditingController termController = TextEditingController();
  TextEditingController noOfTermSchoolOpenedController =
      TextEditingController();
  TextEditingController nextTermController = TextEditingController();
  TextEditingController termlyReportStateController = TextEditingController();

  @override
  void initState() {
    termlyReportStateController.text = getTermParameterValue(termlyReport);
    termController.text = getTermParameterValue(termIn);
    nextTermController.text = getTermParameterValue(nextTermBegin);
    noOfTermSchoolOpenedController.text = getTermParameterValue(noOfTermSchool);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        title: Text("Term session page"),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: Icon(Icons.comment),
            title: Text("Termly Academic Report:"),
            subtitle: TextField(
              controller: termlyReportStateController,
              decoration: InputDecoration(
                hintText: "Enter the state of this term academic report",
              ),
              onChanged: (value) {
                setState(() {
                  yes = true;
                });
              },
            ),
          ),
          ListTile(
            leading: Icon(Icons.numbers),
            title: Text("Term:"),
            subtitle: TextField(
              controller: termController,
              decoration: InputDecoration(hintText: "Enter the term"),
              onChanged: (value) {
                setState(() {
                  yes = true;
                });
              },
            ),
          ),
          ListTile(
            leading: Icon(Icons.date_range),
            title: Text("Next Term Begins"),
            subtitle: TextField(
              controller: nextTermController,
              decoration: InputDecoration(
                hintText: "Enter when next term will begins",
              ),
              onChanged: (value) {
                setState(() {
                  yes = true;
                });
              },
            ),
          ),
          ListTile(
            leading: Icon(Icons.numbers),
            title: Text("No. of times school opened:"),
            subtitle: TextField(
              controller: noOfTermSchoolOpenedController,
              decoration: InputDecoration(
                hintText: "Enter no of time school opened",
              ),
              onChanged: (value) {
                setState(() {
                  yes = true;
                });
              },
            ),
          ),
          ElevatedButton(
            onPressed: yes
                ? () {
                    saveTermsParameters(
                      termlyReport,
                      termlyReportStateController.text,
                    );
                    saveTermsParameters(termIn, termController.text);
                    saveTermsParameters(nextTermBegin, nextTermController.text);
                    saveTermsParameters(
                      noOfTermSchool,
                      noOfTermSchoolOpenedController.text,
                    );
                    Navigator.pop(context);
                  }
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              elevation: 5,
            ),
            child: Text("Save"),
          ),
        ],
      ),
    );
  }
}
