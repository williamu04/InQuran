class AyahSearchService {
  String normalizeQuery(String raw) {
    return raw.trim().replaceAll(RegExp(r'\s+'), ' ');
  }

  List<String> tokenize(String normalized) {
    if (normalized.isEmpty) return const [];
    return normalized.split(' ').where((token) => token.isNotEmpty).toList();
  }

  String escapeLike(String token) {
    return token
        .replaceAll('\\', '\\\\')
        .replaceAll('%', '\\%')
        .replaceAll('_', '\\_');
  }

  List<({int start, int end})> findHighlightRanges(String text, List<String> terms) {
    final lowerText = text.toLowerCase();
    final matches = <({int start, int end})>{};

    for (final term in terms) {
      final needle = term.trim().toLowerCase();
      if (needle.isEmpty) continue;

      var from = 0;
      while (true) {
        final index = lowerText.indexOf(needle, from);
        if (index < 0) break;
        matches.add((start: index, end: index + needle.length));
        from = index + needle.length;
      }
    }

    final ordered = matches.toList()
      ..sort((a, b) => a.start.compareTo(b.start));

    final merged = <({int start, int end})>[];
    for (final range in ordered) {
      if (merged.isNotEmpty && range.start < merged.last.end) continue;
      merged.add(range);
    }
    return merged;
  }
}
