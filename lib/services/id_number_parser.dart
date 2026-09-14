/// Parses Indonesian spoken numbers (digits or number words) into integers.
///
/// Supports the range needed by InQuran: 1–604 (mushaf pages), so it covers
/// juz (1–30), surah (1–114) and ayah numbers (max 286).
///
/// Grammar handled:
/// - digits: "255", "12"
/// - units: satu..sembilan, nol
/// - teens: sepuluh, sebelas, "dua belas".."sembilan belas"
/// - tens: "dua puluh", "tiga puluh lima"
/// - hundreds: seratus, "seratus lima", "dua ratus lima puluh lima"
/// - digit-by-digit ASR fallback: "dua lima lima" -> 255 (when no scale word)
class IdNumberParser {
  static const Map<String, int> _units = {
    'nol': 0,
    'satu': 1,
    'dua': 2,
    'tiga': 3,
    'empat': 4,
    'lima': 5,
    'enam': 6,
    'tujuh': 7,
    'delapan': 8,
    'sembilan': 9,
  };

  static const List<String> _scaleWords = [
    'puluh',
    'belas',
    'ratus',
    'sepuluh',
    'sebelas',
    'seratus',
  ];

  /// True if [word] can participate in a spoken number.
  static bool isNumberWord(String word) {
    final w = word.toLowerCase().trim();
    return _units.containsKey(w) ||
        _scaleWords.contains(w) ||
        int.tryParse(w) != null;
  }

  /// Parses a single token or phrase. Returns null when nothing parses.
  static int? parse(String input) {
    final trimmed = input.trim().toLowerCase();
    if (trimmed.isEmpty) return null;
    final digit = int.tryParse(trimmed);
    if (digit != null) return digit;
    return parseFromTokens(trimmed.split(RegExp(r'\s+')));
  }

  /// Parses a list of already-tokenized words. Returns null when nothing parses.
  static int? parseFromTokens(List<String> tokens) {
    final words = tokens
        .map((t) => t.toLowerCase().trim())
        .where(isNumberWord)
        .toList();
    if (words.isEmpty) return null;

    int? valueOf(String w) {
      final digit = int.tryParse(w);
      if (digit != null) return digit;
      return _units[w];
    }

    final hasScale = words.any(_scaleWords.contains);

    if (!hasScale) {
      if (words.length == 1) return valueOf(words.first);
      final digit = int.tryParse(words.map((w) => valueOf(w)!).join());
      return digit;
    }

    // Grammar path: unit words combine with the following scale word.
    int total = 0;
    for (int i = 0; i < words.length; i++) {
      final w = words[i];
      final value = valueOf(w);
      if (value == null) continue; // scale word, already applied via lookahead

      final next = i + 1 < words.length ? words[i + 1] : null;
      switch (next) {
        case 'puluh':
          total += value * 10;
          break;
        case 'ratus':
          total += value * 100;
          break;
        case 'belas':
          total += value + 10;
          break;
        default:
          total += value;
      }
    }

    // Standalone scale words with no leading unit.
    for (final w in words) {
      switch (w) {
        case 'sepuluh':
          total += 10;
          break;
        case 'sebelas':
          total += 11;
          break;
        case 'seratus':
          total += 100;
          break;
      }
    }

    return total > 0 ? total : null;
  }
}
