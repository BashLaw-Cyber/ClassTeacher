import 'package:classreportsheet/util/constant.dart';
import 'package:flutter/material.dart';

class DashboardModel extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;
  const DashboardModel({super.key, required this.title, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: gridColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 55,
              color: Colors.blue,
            ),
            SizedBox(height: 10,),
            Text(title, style: normalFontStyle,)
          ],
        ),
      ),
    );
  }
}