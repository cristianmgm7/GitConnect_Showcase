import 'package:flutter_test/flutter_test.dart';
import 'package:gitconnect/src/domain/models/user.dart';

void main() {
  group('User Model', () {
    test('should correctly parse GitHub API JSON response', () {
      // Sample JSON response from GitHub API (simplified)
      final json = {
        'id': 1024025,
        'login': 'torvalds',
        'avatar_url': 'https://avatars.githubusercontent.com/u/1024025?v=4',
        'name': 'Linus Torvalds',
        'bio': 'Creator of Linux and Git',
        'public_repos': 6,
        'followers': 200000,
        'following': 0,
      };

      // Parse JSON to User model
      final user = User.fromJson(json);

      // Verify all fields are correctly mapped
      expect(user.id, 1024025);
      expect(user.login, 'torvalds');
      expect(user.avatarUrl, 'https://avatars.githubusercontent.com/u/1024025?v=4');
      expect(user.name, 'Linus Torvalds');
      expect(user.bio, 'Creator of Linux and Git');
      expect(user.publicRepos, 6);
      expect(user.followers, 200000);
      expect(user.following, 0);
    });

    test('should handle optional fields when null', () {
      final json = {
        'id': 123,
        'login': 'testuser',
        'avatar_url': 'https://example.com/avatar.jpg',
      };

      final user = User.fromJson(json);

      expect(user.id, 123);
      expect(user.login, 'testuser');
      expect(user.avatarUrl, 'https://example.com/avatar.jpg');
      expect(user.name, null);
      expect(user.bio, null);
      expect(user.publicRepos, null);
      expect(user.followers, null);
      expect(user.following, null);
    });

    test('should serialize back to JSON correctly', () {
      final user = User(
        id: 999,
        login: 'developer',
        avatarUrl: 'https://example.com/dev.jpg',
        name: 'Test Developer',
        bio: 'Building cool stuff',
        publicRepos: 42,
        followers: 100,
        following: 50,
      );

      final json = user.toJson();

      expect(json['id'], 999);
      expect(json['login'], 'developer');
      expect(json['avatar_url'], 'https://example.com/dev.jpg');
      expect(json['name'], 'Test Developer');
      expect(json['bio'], 'Building cool stuff');
      expect(json['public_repos'], 42);
      expect(json['followers'], 100);
      expect(json['following'], 50);
    });
  });
}
