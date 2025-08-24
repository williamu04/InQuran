import 'package:flutter/material.dart';
import 'package:mtqmnuns/viewmodel/surah_list.dart';
import 'package:provider/provider.dart';

Widget searchBox(BuildContext context) {
  final viewModel = Provider.of<SurahListViewModel>(context, listen: false);

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
            onChanged: (value) => viewModel.updateSearchQuery(value),
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
