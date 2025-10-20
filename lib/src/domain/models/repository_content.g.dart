// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'repository_content.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RepositoryContentImpl _$$RepositoryContentImplFromJson(
  Map<String, dynamic> json,
) => _$RepositoryContentImpl(
  name: json['name'] as String,
  path: json['path'] as String,
  type: json['type'] as String,
  content: json['content'] as String?,
  downloadUrl: json['download_url'] as String?,
  size: (json['size'] as num?)?.toInt(),
);

Map<String, dynamic> _$$RepositoryContentImplToJson(
  _$RepositoryContentImpl instance,
) => <String, dynamic>{
  'name': instance.name,
  'path': instance.path,
  'type': instance.type,
  'content': instance.content,
  'download_url': instance.downloadUrl,
  'size': instance.size,
};
