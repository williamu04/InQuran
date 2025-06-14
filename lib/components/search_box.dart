import 'package:flutter/material.dart';

Widget searchBox() {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 16),
    decoration: BoxDecoration(
      color: Color(0xFFF5F9FE),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Row(
      children: [
        Expanded(
          child: TextField(
            decoration: InputDecoration(
              hintText: "Search by Surah, Juz, or Verse",
              hintStyle: TextStyle(
                fontSize: 12,
                color: Color.fromRGBO(0, 0, 0, 0.3),
              ),

              border: InputBorder.none,
            ),
          ),
        ),
        Icon(Icons.search, color: Colors.grey[600]),
      ],
    ),
  );
}
