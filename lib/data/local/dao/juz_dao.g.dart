// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'juz_dao.dart';

// ignore_for_file: type=lint
mixin _$JuzDaoMixin on DatabaseAccessor<AppDatabase> {
  $SurahTable get surah => attachedDatabase.surah;
  $AyahTable get ayah => attachedDatabase.ayah;
  JuzDaoManager get managers => JuzDaoManager(this);
}

class JuzDaoManager {
  final _$JuzDaoMixin _db;
  JuzDaoManager(this._db);
  $$SurahTableTableManager get surah =>
      $$SurahTableTableManager(_db.attachedDatabase, _db.surah);
  $$AyahTableTableManager get ayah =>
      $$AyahTableTableManager(_db.attachedDatabase, _db.ayah);
}
