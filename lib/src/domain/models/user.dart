import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';
part 'user.g.dart';

@freezed
class User with _$User {
  const factory User({
    required int id,
    required String login,
    @JsonKey(name: 'avatar_url') required String avatarUrl,
    String? name,
    String? bio,
    @JsonKey(name: 'public_repos') int? publicRepos,
    int? followers,
    int? following,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) =>
      _$UserFromJson(json);
}
