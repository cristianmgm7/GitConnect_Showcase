import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../core/di/injection.dart';
import '../../domain/repositories/ai_repository.dart';

final aiRepositoryProvider = Provider<AIRepository>((ref) {
  return getIt<AIRepository>();
});

final repositorySummaryProvider = FutureProvider.family<String, String>(
  (ref, repositoryContent) async {
    final repository = ref.watch(aiRepositoryProvider);
    return repository.summarizeRepository(repositoryContent);
  },
);
