import 'package:injectable/injectable.dart';
import '../../domain/models/user.dart';
import '../../domain/repositories/user_repository.dart';
import '../remote/github_api_client.dart';

@LazySingleton(as: UserRepository)
class UserRepositoryImpl implements UserRepository {
  final GitHubApiClient _apiClient;

  UserRepositoryImpl(this._apiClient);

  @override
  Future<User> getUser(String username) async {
    try {
      final json = await _apiClient.getUser(username);
      return User.fromJson(json);
    } catch (e) {
      rethrow;
    }
  }
}
