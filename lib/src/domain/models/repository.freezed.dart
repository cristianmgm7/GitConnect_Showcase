// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'repository.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Repository _$RepositoryFromJson(Map<String, dynamic> json) {
  return _Repository.fromJson(json);
}

/// @nodoc
mixin _$Repository {
  int get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  @JsonKey(name: 'full_name')
  String get fullName => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  @JsonKey(name: 'html_url')
  String get htmlUrl => throw _privateConstructorUsedError;
  String get language => throw _privateConstructorUsedError;
  @JsonKey(name: 'stargazers_count')
  int get stargazersCount => throw _privateConstructorUsedError;
  @JsonKey(name: 'forks_count')
  int get forksCount => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  String get updatedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'default_branch')
  String? get defaultBranch => throw _privateConstructorUsedError;

  /// Serializes this Repository to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Repository
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RepositoryCopyWith<Repository> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RepositoryCopyWith<$Res> {
  factory $RepositoryCopyWith(
    Repository value,
    $Res Function(Repository) then,
  ) = _$RepositoryCopyWithImpl<$Res, Repository>;
  @useResult
  $Res call({
    int id,
    String name,
    @JsonKey(name: 'full_name') String fullName,
    String description,
    @JsonKey(name: 'html_url') String htmlUrl,
    String language,
    @JsonKey(name: 'stargazers_count') int stargazersCount,
    @JsonKey(name: 'forks_count') int forksCount,
    @JsonKey(name: 'updated_at') String updatedAt,
    @JsonKey(name: 'default_branch') String? defaultBranch,
  });
}

/// @nodoc
class _$RepositoryCopyWithImpl<$Res, $Val extends Repository>
    implements $RepositoryCopyWith<$Res> {
  _$RepositoryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Repository
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? fullName = null,
    Object? description = null,
    Object? htmlUrl = null,
    Object? language = null,
    Object? stargazersCount = null,
    Object? forksCount = null,
    Object? updatedAt = null,
    Object? defaultBranch = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            fullName: null == fullName
                ? _value.fullName
                : fullName // ignore: cast_nullable_to_non_nullable
                      as String,
            description: null == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String,
            htmlUrl: null == htmlUrl
                ? _value.htmlUrl
                : htmlUrl // ignore: cast_nullable_to_non_nullable
                      as String,
            language: null == language
                ? _value.language
                : language // ignore: cast_nullable_to_non_nullable
                      as String,
            stargazersCount: null == stargazersCount
                ? _value.stargazersCount
                : stargazersCount // ignore: cast_nullable_to_non_nullable
                      as int,
            forksCount: null == forksCount
                ? _value.forksCount
                : forksCount // ignore: cast_nullable_to_non_nullable
                      as int,
            updatedAt: null == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as String,
            defaultBranch: freezed == defaultBranch
                ? _value.defaultBranch
                : defaultBranch // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$RepositoryImplCopyWith<$Res>
    implements $RepositoryCopyWith<$Res> {
  factory _$$RepositoryImplCopyWith(
    _$RepositoryImpl value,
    $Res Function(_$RepositoryImpl) then,
  ) = __$$RepositoryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int id,
    String name,
    @JsonKey(name: 'full_name') String fullName,
    String description,
    @JsonKey(name: 'html_url') String htmlUrl,
    String language,
    @JsonKey(name: 'stargazers_count') int stargazersCount,
    @JsonKey(name: 'forks_count') int forksCount,
    @JsonKey(name: 'updated_at') String updatedAt,
    @JsonKey(name: 'default_branch') String? defaultBranch,
  });
}

/// @nodoc
class __$$RepositoryImplCopyWithImpl<$Res>
    extends _$RepositoryCopyWithImpl<$Res, _$RepositoryImpl>
    implements _$$RepositoryImplCopyWith<$Res> {
  __$$RepositoryImplCopyWithImpl(
    _$RepositoryImpl _value,
    $Res Function(_$RepositoryImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Repository
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? fullName = null,
    Object? description = null,
    Object? htmlUrl = null,
    Object? language = null,
    Object? stargazersCount = null,
    Object? forksCount = null,
    Object? updatedAt = null,
    Object? defaultBranch = freezed,
  }) {
    return _then(
      _$RepositoryImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        fullName: null == fullName
            ? _value.fullName
            : fullName // ignore: cast_nullable_to_non_nullable
                  as String,
        description: null == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String,
        htmlUrl: null == htmlUrl
            ? _value.htmlUrl
            : htmlUrl // ignore: cast_nullable_to_non_nullable
                  as String,
        language: null == language
            ? _value.language
            : language // ignore: cast_nullable_to_non_nullable
                  as String,
        stargazersCount: null == stargazersCount
            ? _value.stargazersCount
            : stargazersCount // ignore: cast_nullable_to_non_nullable
                  as int,
        forksCount: null == forksCount
            ? _value.forksCount
            : forksCount // ignore: cast_nullable_to_non_nullable
                  as int,
        updatedAt: null == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as String,
        defaultBranch: freezed == defaultBranch
            ? _value.defaultBranch
            : defaultBranch // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$RepositoryImpl implements _Repository {
  const _$RepositoryImpl({
    required this.id,
    required this.name,
    @JsonKey(name: 'full_name') required this.fullName,
    required this.description,
    @JsonKey(name: 'html_url') required this.htmlUrl,
    required this.language,
    @JsonKey(name: 'stargazers_count') required this.stargazersCount,
    @JsonKey(name: 'forks_count') required this.forksCount,
    @JsonKey(name: 'updated_at') required this.updatedAt,
    @JsonKey(name: 'default_branch') this.defaultBranch,
  });

  factory _$RepositoryImpl.fromJson(Map<String, dynamic> json) =>
      _$$RepositoryImplFromJson(json);

  @override
  final int id;
  @override
  final String name;
  @override
  @JsonKey(name: 'full_name')
  final String fullName;
  @override
  final String description;
  @override
  @JsonKey(name: 'html_url')
  final String htmlUrl;
  @override
  final String language;
  @override
  @JsonKey(name: 'stargazers_count')
  final int stargazersCount;
  @override
  @JsonKey(name: 'forks_count')
  final int forksCount;
  @override
  @JsonKey(name: 'updated_at')
  final String updatedAt;
  @override
  @JsonKey(name: 'default_branch')
  final String? defaultBranch;

  @override
  String toString() {
    return 'Repository(id: $id, name: $name, fullName: $fullName, description: $description, htmlUrl: $htmlUrl, language: $language, stargazersCount: $stargazersCount, forksCount: $forksCount, updatedAt: $updatedAt, defaultBranch: $defaultBranch)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RepositoryImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.fullName, fullName) ||
                other.fullName == fullName) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.htmlUrl, htmlUrl) || other.htmlUrl == htmlUrl) &&
            (identical(other.language, language) ||
                other.language == language) &&
            (identical(other.stargazersCount, stargazersCount) ||
                other.stargazersCount == stargazersCount) &&
            (identical(other.forksCount, forksCount) ||
                other.forksCount == forksCount) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.defaultBranch, defaultBranch) ||
                other.defaultBranch == defaultBranch));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    name,
    fullName,
    description,
    htmlUrl,
    language,
    stargazersCount,
    forksCount,
    updatedAt,
    defaultBranch,
  );

  /// Create a copy of Repository
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RepositoryImplCopyWith<_$RepositoryImpl> get copyWith =>
      __$$RepositoryImplCopyWithImpl<_$RepositoryImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RepositoryImplToJson(this);
  }
}

abstract class _Repository implements Repository {
  const factory _Repository({
    required final int id,
    required final String name,
    @JsonKey(name: 'full_name') required final String fullName,
    required final String description,
    @JsonKey(name: 'html_url') required final String htmlUrl,
    required final String language,
    @JsonKey(name: 'stargazers_count') required final int stargazersCount,
    @JsonKey(name: 'forks_count') required final int forksCount,
    @JsonKey(name: 'updated_at') required final String updatedAt,
    @JsonKey(name: 'default_branch') final String? defaultBranch,
  }) = _$RepositoryImpl;

  factory _Repository.fromJson(Map<String, dynamic> json) =
      _$RepositoryImpl.fromJson;

  @override
  int get id;
  @override
  String get name;
  @override
  @JsonKey(name: 'full_name')
  String get fullName;
  @override
  String get description;
  @override
  @JsonKey(name: 'html_url')
  String get htmlUrl;
  @override
  String get language;
  @override
  @JsonKey(name: 'stargazers_count')
  int get stargazersCount;
  @override
  @JsonKey(name: 'forks_count')
  int get forksCount;
  @override
  @JsonKey(name: 'updated_at')
  String get updatedAt;
  @override
  @JsonKey(name: 'default_branch')
  String? get defaultBranch;

  /// Create a copy of Repository
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RepositoryImplCopyWith<_$RepositoryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
