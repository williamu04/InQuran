// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $SurahTable extends Surah with TableInfo<$SurahTable, SurahData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SurahTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameLatinMeta = const VerificationMeta(
    'nameLatin',
  );
  @override
  late final GeneratedColumn<String> nameLatin = GeneratedColumn<String>(
    'nameLatin',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameIndoMeta = const VerificationMeta(
    'nameIndo',
  );
  @override
  late final GeneratedColumn<String> nameIndo = GeneratedColumn<String>(
    'nameIndo',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _totalAyahMeta = const VerificationMeta(
    'totalAyah',
  );
  @override
  late final GeneratedColumn<int> totalAyah = GeneratedColumn<int>(
    'totalAyah',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _placeMeta = const VerificationMeta('place');
  @override
  late final GeneratedColumn<String> place = GeneratedColumn<String>(
    'place',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    nameLatin,
    nameIndo,
    description,
    totalAyah,
    place,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'surah';
  @override
  VerificationContext validateIntegrity(
    Insertable<SurahData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('nameLatin')) {
      context.handle(
        _nameLatinMeta,
        nameLatin.isAcceptableOrUnknown(data['nameLatin']!, _nameLatinMeta),
      );
    } else if (isInserting) {
      context.missing(_nameLatinMeta);
    }
    if (data.containsKey('nameIndo')) {
      context.handle(
        _nameIndoMeta,
        nameIndo.isAcceptableOrUnknown(data['nameIndo']!, _nameIndoMeta),
      );
    } else if (isInserting) {
      context.missing(_nameIndoMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('totalAyah')) {
      context.handle(
        _totalAyahMeta,
        totalAyah.isAcceptableOrUnknown(data['totalAyah']!, _totalAyahMeta),
      );
    } else if (isInserting) {
      context.missing(_totalAyahMeta);
    }
    if (data.containsKey('place')) {
      context.handle(
        _placeMeta,
        place.isAcceptableOrUnknown(data['place']!, _placeMeta),
      );
    } else if (isInserting) {
      context.missing(_placeMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SurahData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SurahData(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}id'],
          )!,
      name:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}name'],
          )!,
      nameLatin:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}nameLatin'],
          )!,
      nameIndo:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}nameIndo'],
          )!,
      description:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}description'],
          )!,
      totalAyah:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}totalAyah'],
          )!,
      place:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}place'],
          )!,
    );
  }

  @override
  $SurahTable createAlias(String alias) {
    return $SurahTable(attachedDatabase, alias);
  }
}

class SurahData extends DataClass implements Insertable<SurahData> {
  final int id;
  final String name;
  final String nameLatin;
  final String nameIndo;
  final String description;
  final int totalAyah;
  final String place;
  const SurahData({
    required this.id,
    required this.name,
    required this.nameLatin,
    required this.nameIndo,
    required this.description,
    required this.totalAyah,
    required this.place,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['nameLatin'] = Variable<String>(nameLatin);
    map['nameIndo'] = Variable<String>(nameIndo);
    map['description'] = Variable<String>(description);
    map['totalAyah'] = Variable<int>(totalAyah);
    map['place'] = Variable<String>(place);
    return map;
  }

  SurahCompanion toCompanion(bool nullToAbsent) {
    return SurahCompanion(
      id: Value(id),
      name: Value(name),
      nameLatin: Value(nameLatin),
      nameIndo: Value(nameIndo),
      description: Value(description),
      totalAyah: Value(totalAyah),
      place: Value(place),
    );
  }

  factory SurahData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SurahData(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      nameLatin: serializer.fromJson<String>(json['nameLatin']),
      nameIndo: serializer.fromJson<String>(json['nameIndo']),
      description: serializer.fromJson<String>(json['description']),
      totalAyah: serializer.fromJson<int>(json['totalAyah']),
      place: serializer.fromJson<String>(json['place']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'nameLatin': serializer.toJson<String>(nameLatin),
      'nameIndo': serializer.toJson<String>(nameIndo),
      'description': serializer.toJson<String>(description),
      'totalAyah': serializer.toJson<int>(totalAyah),
      'place': serializer.toJson<String>(place),
    };
  }

  SurahData copyWith({
    int? id,
    String? name,
    String? nameLatin,
    String? nameIndo,
    String? description,
    int? totalAyah,
    String? place,
  }) => SurahData(
    id: id ?? this.id,
    name: name ?? this.name,
    nameLatin: nameLatin ?? this.nameLatin,
    nameIndo: nameIndo ?? this.nameIndo,
    description: description ?? this.description,
    totalAyah: totalAyah ?? this.totalAyah,
    place: place ?? this.place,
  );
  SurahData copyWithCompanion(SurahCompanion data) {
    return SurahData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      nameLatin: data.nameLatin.present ? data.nameLatin.value : this.nameLatin,
      nameIndo: data.nameIndo.present ? data.nameIndo.value : this.nameIndo,
      description:
          data.description.present ? data.description.value : this.description,
      totalAyah: data.totalAyah.present ? data.totalAyah.value : this.totalAyah,
      place: data.place.present ? data.place.value : this.place,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SurahData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('nameLatin: $nameLatin, ')
          ..write('nameIndo: $nameIndo, ')
          ..write('description: $description, ')
          ..write('totalAyah: $totalAyah, ')
          ..write('place: $place')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, nameLatin, nameIndo, description, totalAyah, place);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SurahData &&
          other.id == this.id &&
          other.name == this.name &&
          other.nameLatin == this.nameLatin &&
          other.nameIndo == this.nameIndo &&
          other.description == this.description &&
          other.totalAyah == this.totalAyah &&
          other.place == this.place);
}

class SurahCompanion extends UpdateCompanion<SurahData> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> nameLatin;
  final Value<String> nameIndo;
  final Value<String> description;
  final Value<int> totalAyah;
  final Value<String> place;
  const SurahCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.nameLatin = const Value.absent(),
    this.nameIndo = const Value.absent(),
    this.description = const Value.absent(),
    this.totalAyah = const Value.absent(),
    this.place = const Value.absent(),
  });
  SurahCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String nameLatin,
    required String nameIndo,
    required String description,
    required int totalAyah,
    required String place,
  }) : name = Value(name),
       nameLatin = Value(nameLatin),
       nameIndo = Value(nameIndo),
       description = Value(description),
       totalAyah = Value(totalAyah),
       place = Value(place);
  static Insertable<SurahData> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? nameLatin,
    Expression<String>? nameIndo,
    Expression<String>? description,
    Expression<int>? totalAyah,
    Expression<String>? place,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (nameLatin != null) 'nameLatin': nameLatin,
      if (nameIndo != null) 'nameIndo': nameIndo,
      if (description != null) 'description': description,
      if (totalAyah != null) 'totalAyah': totalAyah,
      if (place != null) 'place': place,
    });
  }

  SurahCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String>? nameLatin,
    Value<String>? nameIndo,
    Value<String>? description,
    Value<int>? totalAyah,
    Value<String>? place,
  }) {
    return SurahCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      nameLatin: nameLatin ?? this.nameLatin,
      nameIndo: nameIndo ?? this.nameIndo,
      description: description ?? this.description,
      totalAyah: totalAyah ?? this.totalAyah,
      place: place ?? this.place,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (nameLatin.present) {
      map['nameLatin'] = Variable<String>(nameLatin.value);
    }
    if (nameIndo.present) {
      map['nameIndo'] = Variable<String>(nameIndo.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (totalAyah.present) {
      map['totalAyah'] = Variable<int>(totalAyah.value);
    }
    if (place.present) {
      map['place'] = Variable<String>(place.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SurahCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('nameLatin: $nameLatin, ')
          ..write('nameIndo: $nameIndo, ')
          ..write('description: $description, ')
          ..write('totalAyah: $totalAyah, ')
          ..write('place: $place')
          ..write(')'))
        .toString();
  }
}

class $AyahTable extends Ayah with TableInfo<$AyahTable, AyahData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AyahTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _surahIdMeta = const VerificationMeta(
    'surahId',
  );
  @override
  late final GeneratedColumn<int> surahId = GeneratedColumn<int>(
    'surahId',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES surah (id)',
    ),
  );
  static const VerificationMeta _ayahTextMeta = const VerificationMeta(
    'ayahText',
  );
  @override
  late final GeneratedColumn<String> ayahText = GeneratedColumn<String>(
    'ayahText',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _indoTextMeta = const VerificationMeta(
    'indoText',
  );
  @override
  late final GeneratedColumn<String> indoText = GeneratedColumn<String>(
    'indoText',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _readTextMeta = const VerificationMeta(
    'readText',
  );
  @override
  late final GeneratedColumn<String> readText = GeneratedColumn<String>(
    'readText',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _juzMeta = const VerificationMeta('juz');
  @override
  late final GeneratedColumn<int> juz = GeneratedColumn<int>(
    'juz',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _ayahNumberMeta = const VerificationMeta(
    'ayahNumber',
  );
  @override
  late final GeneratedColumn<int> ayahNumber = GeneratedColumn<int>(
    'ayahNumber',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    surahId,
    ayahText,
    indoText,
    readText,
    juz,
    ayahNumber,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'ayah';
  @override
  VerificationContext validateIntegrity(
    Insertable<AyahData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('surahId')) {
      context.handle(
        _surahIdMeta,
        surahId.isAcceptableOrUnknown(data['surahId']!, _surahIdMeta),
      );
    } else if (isInserting) {
      context.missing(_surahIdMeta);
    }
    if (data.containsKey('ayahText')) {
      context.handle(
        _ayahTextMeta,
        ayahText.isAcceptableOrUnknown(data['ayahText']!, _ayahTextMeta),
      );
    } else if (isInserting) {
      context.missing(_ayahTextMeta);
    }
    if (data.containsKey('indoText')) {
      context.handle(
        _indoTextMeta,
        indoText.isAcceptableOrUnknown(data['indoText']!, _indoTextMeta),
      );
    } else if (isInserting) {
      context.missing(_indoTextMeta);
    }
    if (data.containsKey('readText')) {
      context.handle(
        _readTextMeta,
        readText.isAcceptableOrUnknown(data['readText']!, _readTextMeta),
      );
    } else if (isInserting) {
      context.missing(_readTextMeta);
    }
    if (data.containsKey('juz')) {
      context.handle(
        _juzMeta,
        juz.isAcceptableOrUnknown(data['juz']!, _juzMeta),
      );
    } else if (isInserting) {
      context.missing(_juzMeta);
    }
    if (data.containsKey('ayahNumber')) {
      context.handle(
        _ayahNumberMeta,
        ayahNumber.isAcceptableOrUnknown(data['ayahNumber']!, _ayahNumberMeta),
      );
    } else if (isInserting) {
      context.missing(_ayahNumberMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AyahData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AyahData(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}id'],
          )!,
      surahId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}surahId'],
          )!,
      ayahText:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}ayahText'],
          )!,
      indoText:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}indoText'],
          )!,
      readText:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}readText'],
          )!,
      juz:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}juz'],
          )!,
      ayahNumber:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}ayahNumber'],
          )!,
    );
  }

  @override
  $AyahTable createAlias(String alias) {
    return $AyahTable(attachedDatabase, alias);
  }
}

class AyahData extends DataClass implements Insertable<AyahData> {
  final int id;
  final int surahId;
  final String ayahText;
  final String indoText;
  final String readText;
  final int juz;
  final int ayahNumber;
  const AyahData({
    required this.id,
    required this.surahId,
    required this.ayahText,
    required this.indoText,
    required this.readText,
    required this.juz,
    required this.ayahNumber,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['surahId'] = Variable<int>(surahId);
    map['ayahText'] = Variable<String>(ayahText);
    map['indoText'] = Variable<String>(indoText);
    map['readText'] = Variable<String>(readText);
    map['juz'] = Variable<int>(juz);
    map['ayahNumber'] = Variable<int>(ayahNumber);
    return map;
  }

  AyahCompanion toCompanion(bool nullToAbsent) {
    return AyahCompanion(
      id: Value(id),
      surahId: Value(surahId),
      ayahText: Value(ayahText),
      indoText: Value(indoText),
      readText: Value(readText),
      juz: Value(juz),
      ayahNumber: Value(ayahNumber),
    );
  }

  factory AyahData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AyahData(
      id: serializer.fromJson<int>(json['id']),
      surahId: serializer.fromJson<int>(json['surahId']),
      ayahText: serializer.fromJson<String>(json['ayahText']),
      indoText: serializer.fromJson<String>(json['indoText']),
      readText: serializer.fromJson<String>(json['readText']),
      juz: serializer.fromJson<int>(json['juz']),
      ayahNumber: serializer.fromJson<int>(json['ayahNumber']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'surahId': serializer.toJson<int>(surahId),
      'ayahText': serializer.toJson<String>(ayahText),
      'indoText': serializer.toJson<String>(indoText),
      'readText': serializer.toJson<String>(readText),
      'juz': serializer.toJson<int>(juz),
      'ayahNumber': serializer.toJson<int>(ayahNumber),
    };
  }

  AyahData copyWith({
    int? id,
    int? surahId,
    String? ayahText,
    String? indoText,
    String? readText,
    int? juz,
    int? ayahNumber,
  }) => AyahData(
    id: id ?? this.id,
    surahId: surahId ?? this.surahId,
    ayahText: ayahText ?? this.ayahText,
    indoText: indoText ?? this.indoText,
    readText: readText ?? this.readText,
    juz: juz ?? this.juz,
    ayahNumber: ayahNumber ?? this.ayahNumber,
  );
  AyahData copyWithCompanion(AyahCompanion data) {
    return AyahData(
      id: data.id.present ? data.id.value : this.id,
      surahId: data.surahId.present ? data.surahId.value : this.surahId,
      ayahText: data.ayahText.present ? data.ayahText.value : this.ayahText,
      indoText: data.indoText.present ? data.indoText.value : this.indoText,
      readText: data.readText.present ? data.readText.value : this.readText,
      juz: data.juz.present ? data.juz.value : this.juz,
      ayahNumber:
          data.ayahNumber.present ? data.ayahNumber.value : this.ayahNumber,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AyahData(')
          ..write('id: $id, ')
          ..write('surahId: $surahId, ')
          ..write('ayahText: $ayahText, ')
          ..write('indoText: $indoText, ')
          ..write('readText: $readText, ')
          ..write('juz: $juz, ')
          ..write('ayahNumber: $ayahNumber')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, surahId, ayahText, indoText, readText, juz, ayahNumber);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AyahData &&
          other.id == this.id &&
          other.surahId == this.surahId &&
          other.ayahText == this.ayahText &&
          other.indoText == this.indoText &&
          other.readText == this.readText &&
          other.juz == this.juz &&
          other.ayahNumber == this.ayahNumber);
}

class AyahCompanion extends UpdateCompanion<AyahData> {
  final Value<int> id;
  final Value<int> surahId;
  final Value<String> ayahText;
  final Value<String> indoText;
  final Value<String> readText;
  final Value<int> juz;
  final Value<int> ayahNumber;
  const AyahCompanion({
    this.id = const Value.absent(),
    this.surahId = const Value.absent(),
    this.ayahText = const Value.absent(),
    this.indoText = const Value.absent(),
    this.readText = const Value.absent(),
    this.juz = const Value.absent(),
    this.ayahNumber = const Value.absent(),
  });
  AyahCompanion.insert({
    this.id = const Value.absent(),
    required int surahId,
    required String ayahText,
    required String indoText,
    required String readText,
    required int juz,
    required int ayahNumber,
  }) : surahId = Value(surahId),
       ayahText = Value(ayahText),
       indoText = Value(indoText),
       readText = Value(readText),
       juz = Value(juz),
       ayahNumber = Value(ayahNumber);
  static Insertable<AyahData> custom({
    Expression<int>? id,
    Expression<int>? surahId,
    Expression<String>? ayahText,
    Expression<String>? indoText,
    Expression<String>? readText,
    Expression<int>? juz,
    Expression<int>? ayahNumber,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (surahId != null) 'surahId': surahId,
      if (ayahText != null) 'ayahText': ayahText,
      if (indoText != null) 'indoText': indoText,
      if (readText != null) 'readText': readText,
      if (juz != null) 'juz': juz,
      if (ayahNumber != null) 'ayahNumber': ayahNumber,
    });
  }

  AyahCompanion copyWith({
    Value<int>? id,
    Value<int>? surahId,
    Value<String>? ayahText,
    Value<String>? indoText,
    Value<String>? readText,
    Value<int>? juz,
    Value<int>? ayahNumber,
  }) {
    return AyahCompanion(
      id: id ?? this.id,
      surahId: surahId ?? this.surahId,
      ayahText: ayahText ?? this.ayahText,
      indoText: indoText ?? this.indoText,
      readText: readText ?? this.readText,
      juz: juz ?? this.juz,
      ayahNumber: ayahNumber ?? this.ayahNumber,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (surahId.present) {
      map['surahId'] = Variable<int>(surahId.value);
    }
    if (ayahText.present) {
      map['ayahText'] = Variable<String>(ayahText.value);
    }
    if (indoText.present) {
      map['indoText'] = Variable<String>(indoText.value);
    }
    if (readText.present) {
      map['readText'] = Variable<String>(readText.value);
    }
    if (juz.present) {
      map['juz'] = Variable<int>(juz.value);
    }
    if (ayahNumber.present) {
      map['ayahNumber'] = Variable<int>(ayahNumber.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AyahCompanion(')
          ..write('id: $id, ')
          ..write('surahId: $surahId, ')
          ..write('ayahText: $ayahText, ')
          ..write('indoText: $indoText, ')
          ..write('readText: $readText, ')
          ..write('juz: $juz, ')
          ..write('ayahNumber: $ayahNumber')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $SurahTable surah = $SurahTable(this);
  late final $AyahTable ayah = $AyahTable(this);
  late final SurahDao surahDao = SurahDao(this as AppDatabase);
  late final AyahDao ayahDao = AyahDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [surah, ayah];
}

typedef $$SurahTableCreateCompanionBuilder =
    SurahCompanion Function({
      Value<int> id,
      required String name,
      required String nameLatin,
      required String nameIndo,
      required String description,
      required int totalAyah,
      required String place,
    });
typedef $$SurahTableUpdateCompanionBuilder =
    SurahCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String> nameLatin,
      Value<String> nameIndo,
      Value<String> description,
      Value<int> totalAyah,
      Value<String> place,
    });

final class $$SurahTableReferences
    extends BaseReferences<_$AppDatabase, $SurahTable, SurahData> {
  $$SurahTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$AyahTable, List<AyahData>> _ayahRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.ayah,
    aliasName: $_aliasNameGenerator(db.surah.id, db.ayah.surahId),
  );

  $$AyahTableProcessedTableManager get ayahRefs {
    final manager = $$AyahTableTableManager(
      $_db,
      $_db.ayah,
    ).filter((f) => f.surahId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_ayahRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$SurahTableFilterComposer extends Composer<_$AppDatabase, $SurahTable> {
  $$SurahTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nameLatin => $composableBuilder(
    column: $table.nameLatin,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nameIndo => $composableBuilder(
    column: $table.nameIndo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalAyah => $composableBuilder(
    column: $table.totalAyah,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get place => $composableBuilder(
    column: $table.place,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> ayahRefs(
    Expression<bool> Function($$AyahTableFilterComposer f) f,
  ) {
    final $$AyahTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.ayah,
      getReferencedColumn: (t) => t.surahId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AyahTableFilterComposer(
            $db: $db,
            $table: $db.ayah,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SurahTableOrderingComposer
    extends Composer<_$AppDatabase, $SurahTable> {
  $$SurahTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nameLatin => $composableBuilder(
    column: $table.nameLatin,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nameIndo => $composableBuilder(
    column: $table.nameIndo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalAyah => $composableBuilder(
    column: $table.totalAyah,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get place => $composableBuilder(
    column: $table.place,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SurahTableAnnotationComposer
    extends Composer<_$AppDatabase, $SurahTable> {
  $$SurahTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get nameLatin =>
      $composableBuilder(column: $table.nameLatin, builder: (column) => column);

  GeneratedColumn<String> get nameIndo =>
      $composableBuilder(column: $table.nameIndo, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<int> get totalAyah =>
      $composableBuilder(column: $table.totalAyah, builder: (column) => column);

  GeneratedColumn<String> get place =>
      $composableBuilder(column: $table.place, builder: (column) => column);

  Expression<T> ayahRefs<T extends Object>(
    Expression<T> Function($$AyahTableAnnotationComposer a) f,
  ) {
    final $$AyahTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.ayah,
      getReferencedColumn: (t) => t.surahId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AyahTableAnnotationComposer(
            $db: $db,
            $table: $db.ayah,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SurahTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SurahTable,
          SurahData,
          $$SurahTableFilterComposer,
          $$SurahTableOrderingComposer,
          $$SurahTableAnnotationComposer,
          $$SurahTableCreateCompanionBuilder,
          $$SurahTableUpdateCompanionBuilder,
          (SurahData, $$SurahTableReferences),
          SurahData,
          PrefetchHooks Function({bool ayahRefs})
        > {
  $$SurahTableTableManager(_$AppDatabase db, $SurahTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$SurahTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$SurahTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () => $$SurahTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> nameLatin = const Value.absent(),
                Value<String> nameIndo = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<int> totalAyah = const Value.absent(),
                Value<String> place = const Value.absent(),
              }) => SurahCompanion(
                id: id,
                name: name,
                nameLatin: nameLatin,
                nameIndo: nameIndo,
                description: description,
                totalAyah: totalAyah,
                place: place,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required String nameLatin,
                required String nameIndo,
                required String description,
                required int totalAyah,
                required String place,
              }) => SurahCompanion.insert(
                id: id,
                name: name,
                nameLatin: nameLatin,
                nameIndo: nameIndo,
                description: description,
                totalAyah: totalAyah,
                place: place,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          $$SurahTableReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: ({ayahRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (ayahRefs) db.ayah],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (ayahRefs)
                    await $_getPrefetchedData<SurahData, $SurahTable, AyahData>(
                      currentTable: table,
                      referencedTable: $$SurahTableReferences._ayahRefsTable(
                        db,
                      ),
                      managerFromTypedResult:
                          (p0) =>
                              $$SurahTableReferences(db, table, p0).ayahRefs,
                      referencedItemsForCurrentItem:
                          (item, referencedItems) => referencedItems.where(
                            (e) => e.surahId == item.id,
                          ),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$SurahTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SurahTable,
      SurahData,
      $$SurahTableFilterComposer,
      $$SurahTableOrderingComposer,
      $$SurahTableAnnotationComposer,
      $$SurahTableCreateCompanionBuilder,
      $$SurahTableUpdateCompanionBuilder,
      (SurahData, $$SurahTableReferences),
      SurahData,
      PrefetchHooks Function({bool ayahRefs})
    >;
typedef $$AyahTableCreateCompanionBuilder =
    AyahCompanion Function({
      Value<int> id,
      required int surahId,
      required String ayahText,
      required String indoText,
      required String readText,
      required int juz,
      required int ayahNumber,
    });
typedef $$AyahTableUpdateCompanionBuilder =
    AyahCompanion Function({
      Value<int> id,
      Value<int> surahId,
      Value<String> ayahText,
      Value<String> indoText,
      Value<String> readText,
      Value<int> juz,
      Value<int> ayahNumber,
    });

final class $$AyahTableReferences
    extends BaseReferences<_$AppDatabase, $AyahTable, AyahData> {
  $$AyahTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $SurahTable _surahIdTable(_$AppDatabase db) =>
      db.surah.createAlias($_aliasNameGenerator(db.ayah.surahId, db.surah.id));

  $$SurahTableProcessedTableManager get surahId {
    final $_column = $_itemColumn<int>('surahId')!;

    final manager = $$SurahTableTableManager(
      $_db,
      $_db.surah,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_surahIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$AyahTableFilterComposer extends Composer<_$AppDatabase, $AyahTable> {
  $$AyahTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get ayahText => $composableBuilder(
    column: $table.ayahText,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get indoText => $composableBuilder(
    column: $table.indoText,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get readText => $composableBuilder(
    column: $table.readText,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get juz => $composableBuilder(
    column: $table.juz,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get ayahNumber => $composableBuilder(
    column: $table.ayahNumber,
    builder: (column) => ColumnFilters(column),
  );

  $$SurahTableFilterComposer get surahId {
    final $$SurahTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.surahId,
      referencedTable: $db.surah,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SurahTableFilterComposer(
            $db: $db,
            $table: $db.surah,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AyahTableOrderingComposer extends Composer<_$AppDatabase, $AyahTable> {
  $$AyahTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ayahText => $composableBuilder(
    column: $table.ayahText,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get indoText => $composableBuilder(
    column: $table.indoText,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get readText => $composableBuilder(
    column: $table.readText,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get juz => $composableBuilder(
    column: $table.juz,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get ayahNumber => $composableBuilder(
    column: $table.ayahNumber,
    builder: (column) => ColumnOrderings(column),
  );

  $$SurahTableOrderingComposer get surahId {
    final $$SurahTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.surahId,
      referencedTable: $db.surah,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SurahTableOrderingComposer(
            $db: $db,
            $table: $db.surah,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AyahTableAnnotationComposer
    extends Composer<_$AppDatabase, $AyahTable> {
  $$AyahTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get ayahText =>
      $composableBuilder(column: $table.ayahText, builder: (column) => column);

  GeneratedColumn<String> get indoText =>
      $composableBuilder(column: $table.indoText, builder: (column) => column);

  GeneratedColumn<String> get readText =>
      $composableBuilder(column: $table.readText, builder: (column) => column);

  GeneratedColumn<int> get juz =>
      $composableBuilder(column: $table.juz, builder: (column) => column);

  GeneratedColumn<int> get ayahNumber => $composableBuilder(
    column: $table.ayahNumber,
    builder: (column) => column,
  );

  $$SurahTableAnnotationComposer get surahId {
    final $$SurahTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.surahId,
      referencedTable: $db.surah,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SurahTableAnnotationComposer(
            $db: $db,
            $table: $db.surah,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AyahTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AyahTable,
          AyahData,
          $$AyahTableFilterComposer,
          $$AyahTableOrderingComposer,
          $$AyahTableAnnotationComposer,
          $$AyahTableCreateCompanionBuilder,
          $$AyahTableUpdateCompanionBuilder,
          (AyahData, $$AyahTableReferences),
          AyahData,
          PrefetchHooks Function({bool surahId})
        > {
  $$AyahTableTableManager(_$AppDatabase db, $AyahTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$AyahTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$AyahTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () => $$AyahTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> surahId = const Value.absent(),
                Value<String> ayahText = const Value.absent(),
                Value<String> indoText = const Value.absent(),
                Value<String> readText = const Value.absent(),
                Value<int> juz = const Value.absent(),
                Value<int> ayahNumber = const Value.absent(),
              }) => AyahCompanion(
                id: id,
                surahId: surahId,
                ayahText: ayahText,
                indoText: indoText,
                readText: readText,
                juz: juz,
                ayahNumber: ayahNumber,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int surahId,
                required String ayahText,
                required String indoText,
                required String readText,
                required int juz,
                required int ayahNumber,
              }) => AyahCompanion.insert(
                id: id,
                surahId: surahId,
                ayahText: ayahText,
                indoText: indoText,
                readText: readText,
                juz: juz,
                ayahNumber: ayahNumber,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          $$AyahTableReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: ({surahId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                T extends TableManagerState<
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic
                >
              >(state) {
                if (surahId) {
                  state =
                      state.withJoin(
                            currentTable: table,
                            currentColumn: table.surahId,
                            referencedTable: $$AyahTableReferences
                                ._surahIdTable(db),
                            referencedColumn:
                                $$AyahTableReferences._surahIdTable(db).id,
                          )
                          as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$AyahTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AyahTable,
      AyahData,
      $$AyahTableFilterComposer,
      $$AyahTableOrderingComposer,
      $$AyahTableAnnotationComposer,
      $$AyahTableCreateCompanionBuilder,
      $$AyahTableUpdateCompanionBuilder,
      (AyahData, $$AyahTableReferences),
      AyahData,
      PrefetchHooks Function({bool surahId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$SurahTableTableManager get surah =>
      $$SurahTableTableManager(_db, _db.surah);
  $$AyahTableTableManager get ayah => $$AyahTableTableManager(_db, _db.ayah);
}
