import 'package:injectable/injectable.dart';
import '../../domain/repositories/ai_repository.dart';
import '../remote/openai_api_client.dart';

@LazySingleton(as: AIRepository)
class AIRepositoryImpl implements AIRepository {
  final OpenAIApiClient _apiClient;

  AIRepositoryImpl(this._apiClient);

  @override
  Future<String> summarizeRepository(String repositoryContent) async {
    try {
      final prompt = '''
Summarize this repository's purpose, main technologies, and functionality based on the provided files.

Repository Content:
$repositoryContent

Please provide a concise summary covering:
1. Purpose and main functionality
2. Key technologies and frameworks used
3. Project structure and architecture
''';

      return await _apiClient.generateCompletion(prompt: prompt);
    } catch (e) {
      rethrow;
    }
  }
}
