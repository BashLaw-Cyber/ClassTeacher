import 'package:classreportsheet/util/constant.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  static final String route = "searchpage";
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController nameComtroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextField(
            decoration: InputDecoration(hintText: "Enter the student name"),
            style: TextStyle(
              color: Colors.white,
              backgroundColor: backgroundColor,
            ),
          ),
        ],
      ),
    );
  }
}
