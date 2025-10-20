import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class GitHubApiClient {
  final Dio _dio;

  GitHubApiClient(this._dio);

  Future<Map<String, dynamic>> getUser(String username) async {
    final response = await _dio.get('/users/$username');
    return response.data;
  }

  Future<List<dynamic>> getUserRepos(String username) async {
    final response = await _dio.get('/users/$username/repos');
    return response.data;
  }
}
