// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'doa_dao.dart';

// ignore_for_file: type=lint
mixin _$DoaDaoMixin on DatabaseAccessor<AppDatabase> {
  $DoaCategoryTable get doaCategory => attachedDatabase.doaCategory;
  $SurahTable get surah => attachedDatabase.surah;
  $AyahTable get ayah => attachedDatabase.ayah;
  $DoaTable get doa => attachedDatabase.doa;
  DoaDaoManager get managers => DoaDaoManager(this);
}

class DoaDaoManager {
  final _$DoaDaoMixin _db;
  DoaDaoManager(this._db);
  $$DoaCategoryTableTableManager get doaCategory =>
      $$DoaCategoryTableTableManager(_db.attachedDatabase, _db.doaCategory);
  $$SurahTableTableManager get surah =>
      $$SurahTableTableManager(_db.attachedDatabase, _db.surah);
  $$AyahTableTableManager get ayah =>
      $$AyahTableTableManager(_db.attachedDatabase, _db.ayah);
  $$DoaTableTableManager get doa =>
      $$DoaTableTableManager(_db.attachedDatabase, _db.doa);
}
