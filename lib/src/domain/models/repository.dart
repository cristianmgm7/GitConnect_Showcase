import 'package:freezed_annotation/freezed_annotation.dart';

part 'repository.freezed.dart';
part 'repository.g.dart';

@freezed
class Repository with _$Repository {
  const factory Repository({
    required int id,
    required String name,
    @JsonKey(name: 'full_name') required String fullName,
    required String description,
    @JsonKey(name: 'html_url') required String htmlUrl,
    required String language,
    @JsonKey(name: 'stargazers_count') required int stargazersCount,
    @JsonKey(name: 'forks_count') required int forksCount,
    @JsonKey(name: 'updated_at') required String updatedAt,
    @JsonKey(name: 'default_branch') String? defaultBranch,
  }) = _Repository;

  factory Repository.fromJson(Map<String, dynamic> json) =>
      _$RepositoryFromJson(json);
}
