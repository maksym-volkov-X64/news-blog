import 'package:dio/dio.dart';
import 'package:news_blog/env/env.dart';
import 'package:news_blog/models/payload.dart';

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

  Future<List<PageModel>> getPages() async {
    try {
      Response response = await Dio().get('$_apiUrl/pages', options: _options);

      return (response.data['docs'] as List)
          .map<PageModel>((page) => PageModel.fromJson(page))
          .toList();
    } catch (e) {
      print('Error fetching pages: $e');

      return [];
    }
  }

  Future<PageModel?> getPage(String? id) async {
    if (id == null) return null;

    try {
      Response response = await Dio().get(
        '$_apiUrl/pages/$id',
        options: _options,
      );

      return PageModel.fromJson(response.data);
    } catch (e) {
      print('Error fetching page: $e');

      return null;
    }
  }
}
