class FavoriteDto {
  final int surahNumber;
  final int ayahNumber;

  FavoriteDto(this.surahNumber, this.ayahNumber);

  factory FavoriteDto.fromJson(Map<String, dynamic> json) {
    final surah = json['surah_number'];
    final ayah = json['ayah_number'];

    return FavoriteDto(surah as int, ayah as int);
  }

  Map<String, dynamic> toJson() {
    return {
      'surah_number': surahNumber,
      'ayah_number': ayahNumber,
    };
  }
}
