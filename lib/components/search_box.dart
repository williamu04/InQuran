import 'package:flutter/material.dart';
import 'package:inquran/viewmodel/surah_list.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'package:inquran/common/app_color.dart';

class SearchBox extends StatefulWidget {
  const SearchBox({super.key});

  @override
  State<SearchBox> createState() => _SearchBoxState();
}

class _SearchBoxState extends State<SearchBox> {
  Timer? _debounce;

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<SurahListViewModel>(context, listen: false);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              onChanged: (value) {
                if (_debounce?.isActive ?? false) _debounce!.cancel();
                _debounce = Timer(const Duration(milliseconds: 300), () {
                  viewModel.updateSearchQuery(value);
                });
              },
              decoration: InputDecoration(
                hintText: "Cari nama Surah, Juz, atau Ayat",
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

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }
}
