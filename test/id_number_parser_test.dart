import 'package:flutter_test/flutter_test.dart';
import 'package:inquran/services/id_number_parser.dart';

void main() {
  group('IdNumberParser', () {
    test('parses digits', () {
      expect(IdNumberParser.parse('255'), 255);
      expect(IdNumberParser.parse(' 12 '), 12);
      expect(IdNumberParser.parse('1'), 1);
      expect(IdNumberParser.parse('604'), 604);
      expect(IdNumberParser.parse('abc'), isNull);
      expect(IdNumberParser.parse(''), isNull);
    });

    test('parses unit words', () {
      expect(IdNumberParser.parse('satu'), 1);
      expect(IdNumberParser.parse('sembilan'), 9);
      expect(IdNumberParser.parse('nol'), 0);
    });

    test('parses tens', () {
      expect(IdNumberParser.parse('dua puluh'), 20);
      expect(IdNumberParser.parse('tiga puluh'), 30);
      expect(IdNumberParser.parse('dua puluh lima'), 25);
      expect(IdNumberParser.parse('tiga puluh dua'), 32);
      expect(IdNumberParser.parse('sembilan puluh sembilan'), 99);
    });

    test('parses teens', () {
      expect(IdNumberParser.parse('sepuluh'), 10);
      expect(IdNumberParser.parse('sebelas'), 11);
      expect(IdNumberParser.parse('dua belas'), 12);
      expect(IdNumberParser.parse('lima belas'), 15);
      expect(IdNumberParser.parse('sembilan belas'), 19);
    });

    test('parses hundreds', () {
      expect(IdNumberParser.parse('seratus'), 100);
      expect(IdNumberParser.parse('seratus lima'), 105);
      expect(IdNumberParser.parse('seratus lima puluh'), 150);
      expect(IdNumberParser.parse('seratus dua puluh tiga'), 123);
      expect(IdNumberParser.parse('seratus sebelas'), 111);
      expect(IdNumberParser.parse('dua ratus lima puluh lima'), 255);
      expect(IdNumberParser.parse('enam ratus empat'), 604);
      expect(IdNumberParser.parse('tiga ratus'), 300);
      expect(IdNumberParser.parse('delapan ratus dua puluh delapan'), 828);
    });

    test('parses digit-by-digit ASR fallback', () {
      expect(IdNumberParser.parse('dua lima lima'), 255);
      expect(IdNumberParser.parse('dua tiga'), 23);
      expect(IdNumberParser.parse('2 5 5'), 255);
    });

    test('parses tokens with digits mixed with words', () {
      expect(IdNumberParser.parseFromTokens(['2', 'puluh']), 20);
      expect(IdNumberParser.parseFromTokens(['dua', 'puluh', '5']), 25);
    });

    test('isNumberWord', () {
      expect(IdNumberParser.isNumberWord('juz'), false);
      expect(IdNumberParser.isNumberWord('ayat'), false);
      expect(IdNumberParser.isNumberWord('puluh'), true);
      expect(IdNumberParser.isNumberWord('ratus'), true);
      expect(IdNumberParser.isNumberWord('lima'), true);
      expect(IdNumberParser.isNumberWord('12'), true);
    });

    test('returns null for empty/garbage tokens', () {
      expect(IdNumberParser.parseFromTokens(['juz']), isNull);
      expect(IdNumberParser.parseFromTokens([]), isNull);
      expect(IdNumberParser.parse('kata kunci acak'), isNull);
    });

    test('returns null for zero results (invalid targets)', () {
      expect(IdNumberParser.parse('nol'), 0);
      // callers must treat 0 as invalid
    });
  });
}
