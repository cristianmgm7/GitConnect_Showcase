import 'package:freezed_annotation/freezed_annotation.dart';

part 'repository_content.freezed.dart';
part 'repository_content.g.dart';

@freezed
class RepositoryContent with _$RepositoryContent {
  const factory RepositoryContent({
    required String name,
    required String path,
    required String type, // "file" or "dir"
    String? content, // base64 encoded
    @JsonKey(name: 'download_url') String? downloadUrl,
    int? size,
  }) = _RepositoryContent;

  factory RepositoryContent.fromJson(Map<String, dynamic> json) =>
      _$RepositoryContentFromJson(json);
}
