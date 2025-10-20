import 'package:injectable/injectable.dart';
import '../../domain/models/repository.dart';
import '../../domain/models/repository_content.dart';
import '../../domain/repositories/repository_repository.dart';
import '../remote/github_api_client.dart';

@LazySingleton(as: RepositoryRepository)
class RepositoryRepositoryImpl implements RepositoryRepository {
  final GitHubApiClient _apiClient;

  RepositoryRepositoryImpl(this._apiClient);

  @override
  Future<List<Repository>> getUserRepositories(
    String username, {
    int page = 1,
    int perPage = 10,
  }) async {
    try {
      final jsonList = await _apiClient.getUserRepos(
        username,
        page: page,
        perPage: perPage,
      );
      return jsonList.map((json) => Repository.fromJson(json)).toList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<RepositoryContent>> getRepositoryContents(
    String owner,
    String repo, {
    String path = '',
  }) async {
    try {
      final jsonList = await _apiClient.getRepositoryContents(
        owner,
        repo,
        path: path,
      );
      return jsonList.map((json) => RepositoryContent.fromJson(json)).toList();
    } catch (e) {
      rethrow;
    }
  }
}
