import 'package:mtqmnuns/repositories/ayah.dart';
import 'package:mtqmnuns/state/mushaf.dart';
import 'package:mtqmnuns/viewmodel/stateful_generic_helper.dart';

class MushafViewModel extends StatefulViewModel<MushafState> {
  final AyahRepository _ayahRepo;

  int pageNumber = 1;
  int? initSurah;
  int? initAyah;

  MushafViewModel(this._ayahRepo) : super(MushafInit());

  void init(int surahId, int ayahNumber) {
    initSurah = surahId;
    initAyah = ayahNumber;
  }

}
