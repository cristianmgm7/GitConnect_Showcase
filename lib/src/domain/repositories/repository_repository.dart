import '../models/repository.dart';
import '../models/repository_content.dart';

abstract class RepositoryRepository {
  Future<List<Repository>> getUserRepositories(
    String username, {
    int page = 1,
    int perPage = 10,
  });

  Future<List<RepositoryContent>> getRepositoryContents(
    String owner,
    String repo, {
    String path = '',
  });
}
