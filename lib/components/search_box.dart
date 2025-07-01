import 'package:flutter/material.dart';
import 'package:mtqmnuns/viewmodel/book_viewmodel.dart';
import 'package:provider/provider.dart';

Widget searchBox(BuildContext context) {
  final viewModel = Provider.of<BookViewModel>(context, listen: false);

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
            onChanged: (value) => viewModel.setSearchQuery(value),
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
