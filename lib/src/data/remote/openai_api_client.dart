import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

@lazySingleton
class OpenAIApiClient {
  final Dio _dio;

  OpenAIApiClient(@Named('openai') this._dio) {
    // Add authorization header with API key from environment
    final apiKey = dotenv.env['OPENAI_API_KEY'];
    if (apiKey != null) {
      _dio.options.headers['Authorization'] = 'Bearer $apiKey';
    }
  }

  Future<String> generateCompletion({
    required String prompt,
    String model = 'gpt-3.5-turbo',
    int maxTokens = 500,
  }) async {
    final response = await _dio.post(
      '/chat/completions',
      data: {
        'model': model,
        'messages': [
          {
            'role': 'system',
            'content': 'You are a helpful assistant that summarizes GitHub repositories.',
          },
          {
            'role': 'user',
            'content': prompt,
          },
        ],
        'max_tokens': maxTokens,
        'temperature': 0.7,
      },
    );

    return response.data['choices'][0]['message']['content'];
  }
}
