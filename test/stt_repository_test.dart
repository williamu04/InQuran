import 'package:drift/drift.dart' hide isNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:inquran/common/voice_actions.dart';
import 'package:inquran/config/global.dart';
import 'package:inquran/data/local/db/app_database.dart';
import 'package:inquran/repositories/stt.dart';

AppDatabase _testDb() {
  return AppDatabase.withExecutor(NativeDatabase.memory());
}

Future<void> _seed(AppDatabase db) async {
  await db.batch((batch) {
    batch.insertAll(db.surah, [
      SurahCompanion.insert(
        id: Value(1),
        name: 'الفاتحة',
        nameLatin: 'Al-Fatihah',
        nameIndo: 'Pembuka',
        description: '',
        totalAyah: 7,
        place: 'MEKAH',
      ),
      SurahCompanion.insert(
        id: Value(2),
        name: 'البقرة',
        nameLatin: 'Al-Baqarah',
        nameIndo: 'Sapi',
        description: '',
        totalAyah: 286,
        place: 'MADINAH',
      ),
      SurahCompanion.insert(
        id: Value(36),
        name: 'يس',
        nameLatin: 'Yasin',
        nameIndo: 'Yasin',
        description: '',
        totalAyah: 83,
        place: 'MEKAH',
      ),
      SurahCompanion.insert(
        id: Value(106),
        name: 'قريش',
        nameLatin: 'Quraysh',
        nameIndo: 'Quraisy',
        description: '',
        totalAyah: 4,
        place: 'MEKAH',
      ),
      SurahCompanion.insert(
        id: Value(114),
        name: 'الناس',
        nameLatin: 'An-Nas',
        nameIndo: 'Manusia',
        description: '',
        totalAyah: 6,
        place: 'MEKAH',
      ),
    ]);

    // Juz 30 covers An-Nas (id ordering drives the juz boundary queries).
    batch.insertAll(db.ayah, [
      AyahCompanion.insert(
        id: Value(1),
        surahId: 114,
        ayahText: 'قُلْ أَعُوذُ بِرَبِّ النَّاسِ',
        indoText: 'Katakanlah: Aku berlindung kepada Tuhan manusia.',
        readText: '',
        juz: 30,
        ayahNumber: 1,
        audioLink: '',
        page: 604,
      ),
      AyahCompanion.insert(
        id: Value(2),
        surahId: 114,
        ayahText: 'مَلِكِ النَّاسِ',
        indoText: 'Raja manusia.',
        readText: '',
        juz: 30,
        ayahNumber: 2,
        audioLink: '',
        page: 604,
      ),
      AyahCompanion.insert(
        id: Value(3),
        surahId: 1,
        ayahText: 'بِسْمِ اللَّهِ',
        indoText: 'Dengan nama Allah.',
        readText: '',
        juz: 1,
        ayahNumber: 1,
        audioLink: '',
        page: 1,
      ),
    ]);

    batch.insertAll(db.doaCategory, [
      DoaCategoryCompanion.insert(id: Value(1), nama: 'Doa Sebelum Tidur'),
      DoaCategoryCompanion.insert(id: Value(2), nama: 'Doa Setelah Makan'),
    ]);
  });
}

void main() {
  late AppDatabase db;
  late SttRepository repo;

  setUp(() async {
    db = _testDb();
    await _seed(db);
    repo = SttRepository(db.surahDao, db.juzDao, db.doaDao);
  });

  tearDown(() async {
    await db.close();
  });

  group('SttRepository.resolveIntent — surah', () {
    test('plain fuzzy surah name', () async {
      final intent = await repo.resolveIntent('buka al fatihah');
      expect(intent, isA<OpenSurahIntent>());
      final open = intent! as OpenSurahIntent;
      expect(open.surah.nameLatin, 'Al-Fatihah');
      expect(open.ayahNumber, isNull);
    });

    test('surah at a specific ayah with digits', () async {
      final intent = await repo.resolveIntent('al baqarah ayat 255');
      final open = intent! as OpenSurahIntent;
      expect(open.surah.nameLatin, 'Al-Baqarah');
      expect(open.ayahNumber, 255);
    });

    test('surah at a specific ayah with spoken number', () async {
      final intent = await repo.resolveIntent('yasin ayat sembilan');
      final open = intent! as OpenSurahIntent;
      expect(open.surah.nameLatin, 'Yasin');
      expect(open.ayahNumber, 9);
    });
  });

  group('SttRepository.resolveIntent — collision rules', () {
    test('"baca al quran" opens the surah list, NOT surah Quraysh', () async {
      final intent = await repo.resolveIntent('baca al quran');
      expect(intent, isA<NavigateIntent>());
      expect((intent! as NavigateIntent).destination, VoiceDestination.surahList);
    });

    test('"mode normal" is reading mode, not voice mode', () async {
      final intent = await repo.resolveIntent('mode normal');
      expect(intent, isA<QuranModeIntent>());
      expect((intent! as QuranModeIntent).mode, QuranMode.normal);
    });

    test('"matikan mode suara" exits voice mode', () async {
      final intent = await repo.resolveIntent('matikan mode suara');
      expect(intent, isA<VoiceModeOffIntent>());
    });
  });

  group('SttRepository.resolveIntent — juz & page', () {
    test('juz with spoken number', () async {
      final intent = await repo.resolveIntent('buka juz tiga puluh');
      final open = intent! as OpenJuzIntent;
      expect(open.juz.juzNumber, 30);
      expect(open.juz.startSurahNumber, 114);
      expect(open.juz.endAyahNumber, 2);
    });

    test('juz with digits', () async {
      final intent = await repo.resolveIntent('juz 30');
      final open = intent! as OpenJuzIntent;
      expect(open.juz.juzNumber, 30);
    });

    test('page with spoken number', () async {
      final intent = await repo.resolveIntent('buka halaman dua ratus');
      expect(intent, isA<PageIntent>());
      expect((intent! as PageIntent).page, 200);
    });

    test('page out of range is not matched', () async {
      final intent = await repo.resolveIntent('halaman tujuh ratus');
      expect(intent, isNot(isA<PageIntent>()));
    });
  });

  group('SttRepository.resolveIntent — app navigation', () {
    test('beranda', () async {
      final intent = await repo.resolveIntent('kembali ke beranda');
      final nav = intent! as NavigateIntent;
      expect(nav.destination, VoiceDestination.home);
    });

    test('favorit', () async {
      final intent = await repo.resolveIntent('ayat favorit');
      final nav = intent! as NavigateIntent;
      expect(nav.destination, VoiceDestination.favorites);
    });

    test('cari ayat resolves to search', () async {
      final intent = await repo.resolveIntent('cari ayat tentang sabar');
      final nav = intent! as NavigateIntent;
      expect(nav.destination, VoiceDestination.search);
    });

    test('koleksi doa', () async {
      final intent = await repo.resolveIntent('koleksi doa');
      final nav = intent! as NavigateIntent;
      expect(nav.destination, VoiceDestination.doaList);
    });

    test('daftar surah', () async {
      final intent = await repo.resolveIntent('daftar surah');
      final nav = intent! as NavigateIntent;
      expect(nav.destination, VoiceDestination.surahList);
    });
  });

  group('SttRepository.resolveIntent — modes & playback', () {
    test('mode mushaf', () async {
      final intent = await repo.resolveIntent('ganti mode mushaf');
      expect((intent! as QuranModeIntent).mode, QuranMode.mushaf);
    });

    test('mode hafalan', () async {
      final intent = await repo.resolveIntent('mode hafalan');
      expect((intent! as QuranModeIntent).mode, QuranMode.memorize);
    });

    test('playback play/pause', () async {
      final intent = await repo.resolveIntent('putar ayat');
      expect((intent! as PlaybackIntent).command, PlaybackCommand.playPause);
    });

    test('playback pause', () async {
      final intent = await repo.resolveIntent('jeda');
      expect((intent! as PlaybackIntent).command, PlaybackCommand.pause);
    });

    test('playback resume', () async {
      final intent = await repo.resolveIntent('lanjutkan');
      expect((intent! as PlaybackIntent).command, PlaybackCommand.resume);
    });

    test('relative page/juz/surah', () async {
      expect(
        (await repo.resolveIntent('halaman berikutnya'))!,
        isA<RelativeIntent>()
            .having((i) => i.target, 'target', RelativeVoiceTarget.nextPage),
      );
      expect(
        (await repo.resolveIntent('juz sebelumnya'))!,
        isA<RelativeIntent>()
            .having((i) => i.target, 'target', RelativeVoiceTarget.previousJuz),
      );
      expect(
        (await repo.resolveIntent('surah berikutnya'))!,
        isA<RelativeIntent>()
            .having((i) => i.target, 'target', RelativeVoiceTarget.nextSurah),
      );
    });
  });

  group('SttRepository.resolveIntent — help, doa, qibla, unknown', () {
    test('help', () async {
      final intent = await repo.resolveIntent('bantuan');
      expect(intent, isA<HelpIntent>());
    });

    test('doa category fuzzy match', () async {
      final intent = await repo.resolveIntent('doa sebelum tidur');
      final open = intent! as OpenDoaCategoryIntent;
      expect(open.category.nama, 'Doa Sebelum Tidur');
    });

    test('qibla keywords', () async {
      final intent = await repo.resolveIntent('arah kiblat');
      final nav = intent! as NavigateIntent;
      expect(nav.destination, VoiceDestination.qibla);
    });

    test('unknown command returns null', () async {
      final intent = await repo.resolveIntent('xyzzy tidak ada sama sekali');
      expect(intent, isNull);
    });

    test('empty input returns null', () async {
      final intent = await repo.resolveIntent('   ');
      expect(intent, isNull);
    });
  });
}
