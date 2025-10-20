import 'package:flutter/material.dart';
import '../../domain/models/repository.dart';

class RepositoryCard extends StatelessWidget {
  final Repository repository;
  final VoidCallback? onSummarize;

  const RepositoryCard({
    super.key,
    required this.repository,
    this.onSummarize,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    repository.name,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
                if (repository.language.isNotEmpty)
                  Chip(
                    label: Text(repository.language),
                    backgroundColor: Colors.blue.shade100,
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              repository.description,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.star, size: 16, color: Colors.amber.shade700),
                const SizedBox(width: 4),
                Text('${repository.stargazersCount}'),
                const SizedBox(width: 16),
                const Icon(Icons.fork_right, size: 16),
                const SizedBox(width: 4),
                Text('${repository.forksCount}'),
                const Spacer(),
                if (onSummarize != null)
                  ElevatedButton.icon(
                    onPressed: onSummarize,
                    icon: const Icon(Icons.auto_awesome),
                    label: const Text('Summarize'),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
