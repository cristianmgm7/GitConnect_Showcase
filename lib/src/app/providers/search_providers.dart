import 'package:hooks_riverpod/hooks_riverpod.dart';

// Search query state
final searchQueryProvider = StateProvider<String>((ref) => '');

// Selected username state (after search)
final selectedUsernameProvider = StateProvider<String?>((ref) => null);
