import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../app/providers/repository_providers.dart';
import 'repository_card.dart';

class RepositoryList extends ConsumerWidget {
  final String username;

  const RepositoryList({super.key, required this.username});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repositoriesAsync = ref.watch(repositoryListProvider(username));
    final notifier = ref.read(repositoryListProvider(username).notifier);

    return repositoriesAsync.when(
      data: (repositories) => Column(
        children: [
          if (repositories.isEmpty)
            const Padding(
              padding: EdgeInsets.all(32.0),
              child: Text('No repositories found'),
            )
          else
            ...repositories.map((repo) => RepositoryCard(repository: repo)),

          if (notifier.hasMore)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton.icon(
                onPressed: () => notifier.loadMore(),
                icon: const Icon(Icons.refresh),
                label: const Text('Load More'),
              ),
            ),
        ],
      ),
      loading: () => const Center(
        child: Padding(
          padding: EdgeInsets.all(32.0),
          child: CircularProgressIndicator(),
        ),
      ),
      error: (error, stack) => Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text('Error: $error'),
        ),
      ),
    );
  }
}
