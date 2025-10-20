import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../app/providers/user_providers.dart';
import '../../app/providers/search_providers.dart';
import '../widgets/user_profile_card.dart';
import '../widgets/user_search_bar.dart';
import '../widgets/repository_list.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedUsername = ref.watch(selectedUsernameProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('GitConnect - Explore & Summarize'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const UserSearchBar(),
            if (selectedUsername != null) ...[
              Consumer(
                builder: (context, ref, child) {
                  final userAsync = ref.watch(userProvider(selectedUsername));
                  return userAsync.when(
                    data: (user) => Column(
                      children: [
                        UserProfileCard(user: user),
                        const Divider(height: 32),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            'Repositories',
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                        ),
                        const SizedBox(height: 8),
                        RepositoryList(username: selectedUsername),
                      ],
                    ),
                    loading: () => const Padding(
                      padding: EdgeInsets.all(32.0),
                      child: CircularProgressIndicator(),
                    ),
                    error: (error, stack) => Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text('Error loading user: $error'),
                    ),
                  );
                },
              ),
            ] else
              Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  children: [
                    Icon(
                      Icons.search,
                      size: 64,
                      color: Colors.grey.shade400,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Search for a GitHub user to get started',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Colors.grey.shade600,
                          ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
