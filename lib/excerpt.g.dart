// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'excerpt.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetExcerptCollection on Isar {
  IsarCollection<Excerpt> get excerpts => this.collection();
}

const ExcerptSchema = CollectionSchema(
  name: r'Excerpt',
  id: 6578111500826845482,
  properties: {
    r'mallets': PropertySchema(
      id: 0,
      name: r'mallets',
      type: IsarType.stringList,
    ),
    r'selected': PropertySchema(
      id: 1,
      name: r'selected',
      type: IsarType.bool,
    ),
    r'title': PropertySchema(
      id: 2,
      name: r'title',
      type: IsarType.string,
    )
  },
  estimateSize: _excerptEstimateSize,
  serialize: _excerptSerialize,
  deserialize: _excerptDeserialize,
  deserializeProp: _excerptDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _excerptGetId,
  getLinks: _excerptGetLinks,
  attach: _excerptAttach,
  version: '3.1.0+1',
);

int _excerptEstimateSize(
  Excerpt object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.mallets.length * 3;
  {
    for (var i = 0; i < object.mallets.length; i++) {
      final value = object.mallets[i];
      bytesCount += value.length * 3;
    }
  }
  bytesCount += 3 + object.title.length * 3;
  return bytesCount;
}

void _excerptSerialize(
  Excerpt object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeStringList(offsets[0], object.mallets);
  writer.writeBool(offsets[1], object.selected);
  writer.writeString(offsets[2], object.title);
}

Excerpt _excerptDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Excerpt();
  object.id = id;
  object.mallets = reader.readStringList(offsets[0]) ?? [];
  object.selected = reader.readBool(offsets[1]);
  object.title = reader.readString(offsets[2]);
  return object;
}

P _excerptDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringList(offset) ?? []) as P;
    case 1:
      return (reader.readBool(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _excerptGetId(Excerpt object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _excerptGetLinks(Excerpt object) {
  return [];
}

void _excerptAttach(IsarCollection<dynamic> col, Id id, Excerpt object) {
  object.id = id;
}

extension ExcerptQueryWhereSort on QueryBuilder<Excerpt, Excerpt, QWhere> {
  QueryBuilder<Excerpt, Excerpt, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension ExcerptQueryWhere on QueryBuilder<Excerpt, Excerpt, QWhereClause> {
  QueryBuilder<Excerpt, Excerpt, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<Excerpt, Excerpt, QAfterWhereClause> idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<Excerpt, Excerpt, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<Excerpt, Excerpt, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<Excerpt, Excerpt, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension ExcerptQueryFilter
    on QueryBuilder<Excerpt, Excerpt, QFilterCondition> {
  QueryBuilder<Excerpt, Excerpt, QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Excerpt, Excerpt, QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Excerpt, Excerpt, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Excerpt, Excerpt, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Excerpt, Excerpt, QAfterFilterCondition> malletsElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'mallets',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Excerpt, Excerpt, QAfterFilterCondition>
      malletsElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'mallets',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Excerpt, Excerpt, QAfterFilterCondition> malletsElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'mallets',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Excerpt, Excerpt, QAfterFilterCondition> malletsElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'mallets',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Excerpt, Excerpt, QAfterFilterCondition>
      malletsElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'mallets',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Excerpt, Excerpt, QAfterFilterCondition> malletsElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'mallets',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Excerpt, Excerpt, QAfterFilterCondition> malletsElementContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'mallets',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Excerpt, Excerpt, QAfterFilterCondition> malletsElementMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'mallets',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Excerpt, Excerpt, QAfterFilterCondition>
      malletsElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'mallets',
        value: '',
      ));
    });
  }

  QueryBuilder<Excerpt, Excerpt, QAfterFilterCondition>
      malletsElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'mallets',
        value: '',
      ));
    });
  }

  QueryBuilder<Excerpt, Excerpt, QAfterFilterCondition> malletsLengthEqualTo(
      int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'mallets',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<Excerpt, Excerpt, QAfterFilterCondition> malletsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'mallets',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<Excerpt, Excerpt, QAfterFilterCondition> malletsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'mallets',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Excerpt, Excerpt, QAfterFilterCondition> malletsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'mallets',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<Excerpt, Excerpt, QAfterFilterCondition>
      malletsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'mallets',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Excerpt, Excerpt, QAfterFilterCondition> malletsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'mallets',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<Excerpt, Excerpt, QAfterFilterCondition> selectedEqualTo(
      bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'selected',
        value: value,
      ));
    });
  }

  QueryBuilder<Excerpt, Excerpt, QAfterFilterCondition> titleEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Excerpt, Excerpt, QAfterFilterCondition> titleGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Excerpt, Excerpt, QAfterFilterCondition> titleLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Excerpt, Excerpt, QAfterFilterCondition> titleBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'title',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Excerpt, Excerpt, QAfterFilterCondition> titleStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Excerpt, Excerpt, QAfterFilterCondition> titleEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Excerpt, Excerpt, QAfterFilterCondition> titleContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Excerpt, Excerpt, QAfterFilterCondition> titleMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'title',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Excerpt, Excerpt, QAfterFilterCondition> titleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'title',
        value: '',
      ));
    });
  }

  QueryBuilder<Excerpt, Excerpt, QAfterFilterCondition> titleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'title',
        value: '',
      ));
    });
  }
}

extension ExcerptQueryObject
    on QueryBuilder<Excerpt, Excerpt, QFilterCondition> {}

extension ExcerptQueryLinks
    on QueryBuilder<Excerpt, Excerpt, QFilterCondition> {}

extension ExcerptQuerySortBy on QueryBuilder<Excerpt, Excerpt, QSortBy> {
  QueryBuilder<Excerpt, Excerpt, QAfterSortBy> sortBySelected() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'selected', Sort.asc);
    });
  }

  QueryBuilder<Excerpt, Excerpt, QAfterSortBy> sortBySelectedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'selected', Sort.desc);
    });
  }

  QueryBuilder<Excerpt, Excerpt, QAfterSortBy> sortByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<Excerpt, Excerpt, QAfterSortBy> sortByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }
}

extension ExcerptQuerySortThenBy
    on QueryBuilder<Excerpt, Excerpt, QSortThenBy> {
  QueryBuilder<Excerpt, Excerpt, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<Excerpt, Excerpt, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<Excerpt, Excerpt, QAfterSortBy> thenBySelected() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'selected', Sort.asc);
    });
  }

  QueryBuilder<Excerpt, Excerpt, QAfterSortBy> thenBySelectedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'selected', Sort.desc);
    });
  }

  QueryBuilder<Excerpt, Excerpt, QAfterSortBy> thenByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<Excerpt, Excerpt, QAfterSortBy> thenByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }
}

extension ExcerptQueryWhereDistinct
    on QueryBuilder<Excerpt, Excerpt, QDistinct> {
  QueryBuilder<Excerpt, Excerpt, QDistinct> distinctByMallets() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'mallets');
    });
  }

  QueryBuilder<Excerpt, Excerpt, QDistinct> distinctBySelected() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'selected');
    });
  }

  QueryBuilder<Excerpt, Excerpt, QDistinct> distinctByTitle(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'title', caseSensitive: caseSensitive);
    });
  }
}

extension ExcerptQueryProperty
    on QueryBuilder<Excerpt, Excerpt, QQueryProperty> {
  QueryBuilder<Excerpt, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<Excerpt, List<String>, QQueryOperations> malletsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'mallets');
    });
  }

  QueryBuilder<Excerpt, bool, QQueryOperations> selectedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'selected');
    });
  }

  QueryBuilder<Excerpt, String, QQueryOperations> titleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'title');
    });
  }
}
