import 'dart:async';

import 'package:flutter/material.dart';
import 'package:inquran/common/app_color.dart';

class AyahSearchBox extends StatefulWidget {
  final ValueChanged<String> onChanged;
  final String hint;

  const AyahSearchBox({
    super.key,
    required this.onChanged,
    this.hint = "Cari isi ayat…",
  });

  @override
  State<AyahSearchBox> createState() => _AyahSearchBoxState();
}

class _AyahSearchBoxState extends State<AyahSearchBox> {
  final TextEditingController _controller = TextEditingController();
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _onChanged(String value) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      widget.onChanged(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Semantics(
              label: 'Kotak pencarian ayat',
              hint: widget.hint,
              textField: true,
              child: TextField(
                controller: _controller,
                onChanged: _onChanged,
                decoration: InputDecoration(
                  hintText: widget.hint,
                  hintStyle: const TextStyle(
                    fontSize: 12,
                    color: Color.fromRGBO(0, 0, 0, 0.3),
                  ),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          ValueListenableBuilder<TextEditingValue>(
            valueListenable: _controller,
            builder: (context, value, _) {
              if (value.text.isEmpty) return const SizedBox.shrink();
              return IconButton(
                visualDensity: VisualDensity.compact,
                tooltip: 'Hapus pencarian',
                onPressed: () {
                  _debounce?.cancel();
                  _controller.clear();
                  widget.onChanged('');
                },
                icon: const Icon(Icons.close, color: AppColors.textMuted),
              );
            },
          ),
          const ExcludeSemantics(
            child: Icon(Icons.search, color: AppColors.textMuted),
          ),
        ],
      ),
    );
  }
}
