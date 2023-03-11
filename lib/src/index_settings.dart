import 'pagination_settings.dart';
import 'typo_tolerance.dart';

class IndexSettings {
  IndexSettings({
    this.synonyms,
    this.stopWords,
    this.rankingRules,
    this.filterableAttributes,
    this.distinctAttribute,
    this.sortableAttributes,
    this.searchableAttributes = allAttributes,
    this.displayedAttributes = allAttributes,
    this.typoTolerance,
    this.pagination,
  });

  static const allAttributes = <String>['*'];

  /// List of associated words treated similarly
  Map<String, List<String>>? synonyms;

  /// List of words ignored by Meilisearch when present in search queries
  List<String>? stopWords;

  /// List of ranking rules sorted by order of importance
  List<String>? rankingRules;

  /// Attributes to use in [filters](https://docs.meilisearch.com/reference/features/filtering_and_faceted_search.html)
  List<String>? filterableAttributes;

  /// Search returns documents with distinct (different) values of the given field
  String? distinctAttribute;

  /// Fields in which to search for matching query words sorted by order of importance
  List<String>? searchableAttributes;

  /// Fields displayed in the returned documents
  List<String>? displayedAttributes;

  /// List of attributes by which to sort results
  List<String>? sortableAttributes;

  /// Customize typo tolerance feature.
  TypoToleranceSettings? typoTolerance;

  ///Customize pagination feature.
  PaginationSettings? pagination;

  Map<String, Object?> toMap() => <String, Object?>{
        'synonyms': synonyms,
        'stopWords': stopWords,
        'rankingRules': rankingRules,
        'filterableAttributes': filterableAttributes,
        'distinctAttribute': distinctAttribute,
        'searchableAttributes': searchableAttributes,
        'displayedAttributes': displayedAttributes,
        'sortableAttributes': sortableAttributes,
        'typoTolerance': typoTolerance?.toMap(),
        'pagination': pagination?.toMap(),
      };

  factory IndexSettings.fromMap(Map<String, Object?> map) {
    final typoTolerance = map['typoTolerance'];
    final pagination = map['pagination'];
    return IndexSettings(
      synonyms: (map['synonyms'] as Map?)
          ?.cast<String, List<Object?>>()
          .map((key, value) => MapEntry(key, value.cast<String>())),
      stopWords: (map['stopWords'] as Iterable?)?.cast<String>().toList(),
      rankingRules: (map['rankingRules'] as List?)?.cast<String>(),
      filterableAttributes:
          (map['filterableAttributes'] as List?)?.cast<String>(),
      distinctAttribute: (map['distinctAttribute'] as String?),
      searchableAttributes:
          (map['searchableAttributes'] as List?)?.cast<String>(),
      displayedAttributes:
          (map['displayedAttributes'] as List?)?.cast<String>(),
      sortableAttributes: (map['sortableAttributes'] as List?)?.cast<String>(),
      typoTolerance: typoTolerance is Map<String, Object?>
          ? TypoToleranceSettings.fromMap(typoTolerance)
          : null,
      pagination: pagination is Map<String, Object?>
          ? PaginationSettings.fromMap(pagination)
          : null,
    );
  }
}
