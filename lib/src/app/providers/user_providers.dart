import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../core/di/injection.dart';
import '../../domain/models/user.dart';
import '../../domain/repositories/user_repository.dart';

final userRepositoryProvider = Provider<UserRepository>((ref) {
  return getIt<UserRepository>();
});

final userProvider = FutureProvider.family<User, String>((ref, username) async {
  final repository = ref.watch(userRepositoryProvider);
  return repository.getUser(username);
});
