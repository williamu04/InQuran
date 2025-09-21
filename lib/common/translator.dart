final Map<String, String> kategoriDoaIndonesia = {
  "children": "Anak-anak",
  "devotion": "Pengabdian",
  "guidance": "Petunjuk",
  "healing": "Kesembuhan",
  "hereafter": "Akhirat",
  "marriage": "Pernikahan",
  "mercy": "Rahmat",
  "parents": "Orang Tua",
  "patience": "Kesabaran",
  "protection": "Perlindungan",
  "tawbah": "Tobat",
  "friends": "Teman",
  "sleeping": "Tidur",
  "strength": "Kekuatan",
};

String terjemahkanKategori(String namaInggris) {
  final kunci = namaInggris.trim().toLowerCase();
  return kategoriDoaIndonesia[kunci] ?? namaInggris;
}
