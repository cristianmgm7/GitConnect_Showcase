import 'package:flutter/material.dart';
import '../../domain/models/user.dart';

class UserProfileCard extends StatelessWidget {
  final User user;

  const UserProfileCard({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(user.avatarUrl),
            ),
            const SizedBox(height: 16),
            Text(
              user.name ?? user.login,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            Text('@${user.login}'),
            if (user.bio != null) ...[
              const SizedBox(height: 8),
              Text(user.bio!),
            ],
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _StatItem('Repos', user.publicRepos ?? 0),
                _StatItem('Followers', user.followers ?? 0),
                _StatItem('Following', user.following ?? 0),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final int count;

  const _StatItem(this.label, this.count);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          count.toString(),
          style: Theme.of(context).textTheme.titleLarge,
        ),
        Text(label),
      ],
    );
  }
}
