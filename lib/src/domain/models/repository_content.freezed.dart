// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'repository_content.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

RepositoryContent _$RepositoryContentFromJson(Map<String, dynamic> json) {
  return _RepositoryContent.fromJson(json);
}

/// @nodoc
mixin _$RepositoryContent {
  String get name => throw _privateConstructorUsedError;
  String get path => throw _privateConstructorUsedError;
  String get type => throw _privateConstructorUsedError; // "file" or "dir"
  String? get content => throw _privateConstructorUsedError; // base64 encoded
  @JsonKey(name: 'download_url')
  String? get downloadUrl => throw _privateConstructorUsedError;
  int? get size => throw _privateConstructorUsedError;

  /// Serializes this RepositoryContent to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RepositoryContent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RepositoryContentCopyWith<RepositoryContent> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RepositoryContentCopyWith<$Res> {
  factory $RepositoryContentCopyWith(
    RepositoryContent value,
    $Res Function(RepositoryContent) then,
  ) = _$RepositoryContentCopyWithImpl<$Res, RepositoryContent>;
  @useResult
  $Res call({
    String name,
    String path,
    String type,
    String? content,
    @JsonKey(name: 'download_url') String? downloadUrl,
    int? size,
  });
}

/// @nodoc
class _$RepositoryContentCopyWithImpl<$Res, $Val extends RepositoryContent>
    implements $RepositoryContentCopyWith<$Res> {
  _$RepositoryContentCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RepositoryContent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? path = null,
    Object? type = null,
    Object? content = freezed,
    Object? downloadUrl = freezed,
    Object? size = freezed,
  }) {
    return _then(
      _value.copyWith(
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            path: null == path
                ? _value.path
                : path // ignore: cast_nullable_to_non_nullable
                      as String,
            type: null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as String,
            content: freezed == content
                ? _value.content
                : content // ignore: cast_nullable_to_non_nullable
                      as String?,
            downloadUrl: freezed == downloadUrl
                ? _value.downloadUrl
                : downloadUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            size: freezed == size
                ? _value.size
                : size // ignore: cast_nullable_to_non_nullable
                      as int?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$RepositoryContentImplCopyWith<$Res>
    implements $RepositoryContentCopyWith<$Res> {
  factory _$$RepositoryContentImplCopyWith(
    _$RepositoryContentImpl value,
    $Res Function(_$RepositoryContentImpl) then,
  ) = __$$RepositoryContentImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String name,
    String path,
    String type,
    String? content,
    @JsonKey(name: 'download_url') String? downloadUrl,
    int? size,
  });
}

/// @nodoc
class __$$RepositoryContentImplCopyWithImpl<$Res>
    extends _$RepositoryContentCopyWithImpl<$Res, _$RepositoryContentImpl>
    implements _$$RepositoryContentImplCopyWith<$Res> {
  __$$RepositoryContentImplCopyWithImpl(
    _$RepositoryContentImpl _value,
    $Res Function(_$RepositoryContentImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of RepositoryContent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? path = null,
    Object? type = null,
    Object? content = freezed,
    Object? downloadUrl = freezed,
    Object? size = freezed,
  }) {
    return _then(
      _$RepositoryContentImpl(
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        path: null == path
            ? _value.path
            : path // ignore: cast_nullable_to_non_nullable
                  as String,
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
        content: freezed == content
            ? _value.content
            : content // ignore: cast_nullable_to_non_nullable
                  as String?,
        downloadUrl: freezed == downloadUrl
            ? _value.downloadUrl
            : downloadUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        size: freezed == size
            ? _value.size
            : size // ignore: cast_nullable_to_non_nullable
                  as int?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$RepositoryContentImpl implements _RepositoryContent {
  const _$RepositoryContentImpl({
    required this.name,
    required this.path,
    required this.type,
    this.content,
    @JsonKey(name: 'download_url') this.downloadUrl,
    this.size,
  });

  factory _$RepositoryContentImpl.fromJson(Map<String, dynamic> json) =>
      _$$RepositoryContentImplFromJson(json);

  @override
  final String name;
  @override
  final String path;
  @override
  final String type;
  // "file" or "dir"
  @override
  final String? content;
  // base64 encoded
  @override
  @JsonKey(name: 'download_url')
  final String? downloadUrl;
  @override
  final int? size;

  @override
  String toString() {
    return 'RepositoryContent(name: $name, path: $path, type: $type, content: $content, downloadUrl: $downloadUrl, size: $size)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RepositoryContentImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.path, path) || other.path == path) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.downloadUrl, downloadUrl) ||
                other.downloadUrl == downloadUrl) &&
            (identical(other.size, size) || other.size == size));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, name, path, type, content, downloadUrl, size);

  /// Create a copy of RepositoryContent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RepositoryContentImplCopyWith<_$RepositoryContentImpl> get copyWith =>
      __$$RepositoryContentImplCopyWithImpl<_$RepositoryContentImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$RepositoryContentImplToJson(this);
  }
}

abstract class _RepositoryContent implements RepositoryContent {
  const factory _RepositoryContent({
    required final String name,
    required final String path,
    required final String type,
    final String? content,
    @JsonKey(name: 'download_url') final String? downloadUrl,
    final int? size,
  }) = _$RepositoryContentImpl;

  factory _RepositoryContent.fromJson(Map<String, dynamic> json) =
      _$RepositoryContentImpl.fromJson;

  @override
  String get name;
  @override
  String get path;
  @override
  String get type; // "file" or "dir"
  @override
  String? get content; // base64 encoded
  @override
  @JsonKey(name: 'download_url')
  String? get downloadUrl;
  @override
  int? get size;

  /// Create a copy of RepositoryContent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RepositoryContentImplCopyWith<_$RepositoryContentImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
