// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'surah_dao.dart';

// ignore_for_file: type=lint
mixin _$SurahDaoMixin on DatabaseAccessor<AppDatabase> {
  $SurahTable get surah => attachedDatabase.surah;
  $AyahTable get ayah => attachedDatabase.ayah;
  SurahDaoManager get managers => SurahDaoManager(this);
}

class SurahDaoManager {
  final _$SurahDaoMixin _db;
  SurahDaoManager(this._db);
  $$SurahTableTableManager get surah =>
      $$SurahTableTableManager(_db.attachedDatabase, _db.surah);
  $$AyahTableTableManager get ayah =>
      $$AyahTableTableManager(_db.attachedDatabase, _db.ayah);
}
