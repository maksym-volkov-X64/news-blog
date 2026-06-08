import 'package:dio/dio.dart';
import 'package:news_blog/env/env.dart';
import 'package:news_blog/models/payload.dart';
import 'package:flutter_localization/flutter_localization.dart';

class PayloadClient {
  final Options _options = _getOptions();
  final String _apiUrl = _getApiUrl();

  static Options _getOptions() {
    String apiKey = Env.payloadApiKey;
    String authHeader = 'users API-Key $apiKey';

    return Options(headers: {'Authorization': authHeader});
  }

  static String _getApiUrl() {
    return Env.payloadApiUrl;
  }

  String _getLanguageCode() {
    return FlutterLocalization.instance.currentLocale?.languageCode ?? 'en';
  }

  Future<List<PostModel>> getPosts() async {
    final String languageCode = _getLanguageCode();

    try {
      Response response = await Dio().get(
        '$_apiUrl/posts?locale=$languageCode',
        options: _options,
      );

      return (response.data['docs'] as List)
          .map<PostModel>((page) => PostModel.fromJson(page))
          .toList();
    } catch (e) {
      print('Error fetching posts: $e');

      return [];
    }
  }

  Future<PostModel?> getPost(String? id) async {
    if (id == null) return null;

    final String languageCode = _getLanguageCode();

    try {
      Response response = await Dio().get(
        '$_apiUrl/posts/$id?locale=$languageCode',
        options: _options,
      );

      return PostModel.fromJson(response.data);
    } catch (e) {
      print('Error fetching post: $e');

      return null;
    }
  }
}
