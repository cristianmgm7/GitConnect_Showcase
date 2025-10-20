import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../app/providers/user_providers.dart';
import '../widgets/user_profile_card.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userProvider('cristianmgm7')); // Example: Linus Torvalds

    return Scaffold(
      appBar: AppBar(
        title: const Text('GitConnect Showcase'),
      ),
      body: Center(
        child: userAsync.when(
          data: (user) => UserProfileCard(user: user),
          loading: () => const CircularProgressIndicator(),
          error: (error, stack) => Text('Error: $error'),
        ),
      ),
    );
  }
}
