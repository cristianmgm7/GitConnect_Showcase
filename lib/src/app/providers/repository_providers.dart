import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../core/di/injection.dart';
import '../../domain/models/repository.dart';
import '../../domain/repositories/repository_repository.dart';

final repositoryRepositoryProvider = Provider<RepositoryRepository>((ref) {
  return getIt<RepositoryRepository>();
});

// Provider for repository list with pagination state
class RepositoryListNotifier extends StateNotifier<AsyncValue<List<Repository>>> {
  RepositoryListNotifier(this._repository, this._username)
      : super(const AsyncValue.loading()) {
    _loadRepositories();
  }

  final RepositoryRepository _repository;
  final String _username;
  int _currentPage = 1;
  bool _hasMore = true;

  Future<void> _loadRepositories() async {
    try {
      final repos = await _repository.getUserRepositories(
        _username,
        page: _currentPage,
        perPage: 10,
      );

      state = AsyncValue.data(repos);
      _hasMore = repos.length == 10;
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> loadMore() async {
    if (!_hasMore || state.isLoading) return;

    _currentPage++;

    final previousRepos = state.value ?? [];

    try {
      final newRepos = await _repository.getUserRepositories(
        _username,
        page: _currentPage,
        perPage: 10,
      );

      _hasMore = newRepos.length == 10;
      state = AsyncValue.data([...previousRepos, ...newRepos]);
    } catch (e, stack) {
      _currentPage--;
      state = AsyncValue.error(e, stack);
    }
  }

  bool get hasMore => _hasMore;
}

final repositoryListProvider = StateNotifierProvider.family<
    RepositoryListNotifier,
    AsyncValue<List<Repository>>,
    String>(
  (ref, username) {
    final repository = ref.watch(repositoryRepositoryProvider);
    return RepositoryListNotifier(repository, username);
  },
);
