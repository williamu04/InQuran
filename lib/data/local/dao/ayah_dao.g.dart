// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ayah_dao.dart';

// ignore_for_file: type=lint
mixin _$AyahDaoMixin on DatabaseAccessor<AppDatabase> {
  $SurahTable get surah => attachedDatabase.surah;
  $AyahTable get ayah => attachedDatabase.ayah;
  AyahDaoManager get managers => AyahDaoManager(this);
}

class AyahDaoManager {
  final _$AyahDaoMixin _db;
  AyahDaoManager(this._db);
  $$SurahTableTableManager get surah =>
      $$SurahTableTableManager(_db.attachedDatabase, _db.surah);
  $$AyahTableTableManager get ayah =>
      $$AyahTableTableManager(_db.attachedDatabase, _db.ayah);
}
