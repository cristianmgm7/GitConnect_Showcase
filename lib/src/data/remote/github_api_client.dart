import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class GitHubApiClient {
  final Dio _dio;

  GitHubApiClient(@Named('github') this._dio);

  Future<Map<String, dynamic>> getUser(String username) async {
    final response = await _dio.get('/users/$username');
    return response.data;
  }

  Future<List<dynamic>> getUserRepos(
    String username, {
    int page = 1,
    int perPage = 10,
  }) async {
    final response = await _dio.get(
      '/users/$username/repos',
      queryParameters: {
        'page': page,
        'per_page': perPage,
        'sort': 'updated',
      },
    );
    return response.data;
  }

  Future<List<dynamic>> getRepositoryContents(
    String owner,
    String repo, {
    String path = '',
  }) async {
    final response = await _dio.get(
      '/repos/$owner/$repo/contents/$path',
    );
    return response.data is List ? response.data : [response.data];
  }
}
