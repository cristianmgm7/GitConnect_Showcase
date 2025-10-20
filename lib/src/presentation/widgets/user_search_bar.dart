import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:rxdart/rxdart.dart';
import '../../app/providers/search_providers.dart';

class UserSearchBar extends HookConsumerWidget {
  const UserSearchBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchController = useTextEditingController();
    final searchSubject = useMemoized(() => BehaviorSubject<String>());

    useEffect(() {
      // Set up debounced subscription
      final subscription = searchSubject
          .debounceTime(const Duration(milliseconds: 400))
          .distinct()
          .listen((query) {
        if (query.isNotEmpty) {
          ref.read(selectedUsernameProvider.notifier).state = query;
        }
      });

      return () {
        subscription.cancel();
        searchSubject.close();
      };
    }, []);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        controller: searchController,
        decoration: InputDecoration(
          labelText: 'Search GitHub User',
          hintText: 'Enter username...',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    searchController.clear();
                    ref.read(selectedUsernameProvider.notifier).state = null;
                  },
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onChanged: (value) {
          ref.read(searchQueryProvider.notifier).state = value;
          searchSubject.add(value);
        },
      ),
    );
  }
}
