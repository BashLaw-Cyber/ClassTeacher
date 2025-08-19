import 'package:classreportsheet/model/subject_model.dart';
import 'package:flutter/cupertino.dart';

import '../db/db_helper.dart';

class SubjectProvider extends ChangeNotifier {
  List<SubjectModel> subjectList = [];
  final db = DbHelper();


}