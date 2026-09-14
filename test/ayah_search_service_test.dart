import 'package:flutter_test/flutter_test.dart';
import 'package:inquran/services/ayah_search.dart';

void main() {
  final service = AyahSearchService();

  group('normalizeQuery', () {
    test('trims and collapses internal whitespace', () {
      expect(service.normalizeQuery('  aku   dan  kamu '), 'aku dan kamu');
    });

    test('blank query becomes empty', () {
      expect(service.normalizeQuery('   \t '), '');
    });

    test('plain query unchanged', () {
      expect(service.normalizeQuery('aku'), 'aku');
    });
  });

  group('tokenize', () {
    test('splits normalized query on single spaces', () {
      expect(service.tokenize('aku dan kamu'), ['aku', 'dan', 'kamu']);
    });

    test('empty query yields no tokens', () {
      expect(service.tokenize(''), isEmpty);
    });
  });

  group('escapeLike', () {
    test('escapes backslash, percent and underscore', () {
      expect(service.escapeLike(r'100\%_'), r'100\\\%\_');
    });

    test('plain text unchanged', () {
      expect(service.escapeLike('aku dan kamu'), 'aku dan kamu');
    });
  });

  group('findHighlightRanges', () {
    test('finds case-insensitive occurrences of one term', () {
      final ranges = service.findHighlightRanges('Aku dan kamu, aku.', [
        'kamu',
      ]);
      expect(ranges, [(start: 8, end: 12)]);
    });

    test('finds all occurrences of multiple terms, sorted', () {
      final ranges = service.findHighlightRanges('Aku dan kamu, aku.', [
        'aku',
        'kamu',
      ]);
      expect(ranges, [
        (start: 0, end: 3),
        (start: 8, end: 12),
        (start: 14, end: 17),
      ]);
    });

    test('drops overlapping ranges', () {
      final ranges = service.findHighlightRanges('aba', ['ab', 'ba']);
      expect(ranges, [(start: 0, end: 2)]);
    });

    test('empty terms yields no ranges', () {
      expect(service.findHighlightRanges('aku', []), isEmpty);
    });

    test('term not found yields no ranges', () {
      expect(service.findHighlightRanges('aku', ['kamu']), isEmpty);
    });
  });
}
