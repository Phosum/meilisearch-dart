import 'package:dio/dio.dart';

import 'http_request.dart';
import 'http_request_impl.dart';

import 'client.dart';
import 'index.dart';
import 'index_impl.dart';

class MeiliSearchClientImpl implements MeiliSearchClient {
  MeiliSearchClientImpl(this.serverUrl, [this.apiKey])
      : dio = Dio(BaseOptions(
          baseUrl: serverUrl,
          headers: <String, dynamic>{
            if (apiKey != null) 'X-Meili-API-Key': apiKey,
          },
          responseType: ResponseType.json,
        )),
        http = HttpRequestImpl(serverUrl, apiKey);

  @override
  final String serverUrl;

  @override
  final String apiKey;

  final Dio dio;
  final HttpRequest http;

  @override
  Future<MeiliSearchIndex> createIndex(String uid, {String primaryKey}) async {
    final data = <String, dynamic>{
      'uid': uid,
      if (primaryKey != null) 'primaryKey': primaryKey,
    };
    data.removeWhere((k, v) => v == null);
    // final response = await dio.post<Map<String, dynamic>>(
    final response = await http.post_method<Map<String, dynamic>>(
      '/indexes',
      data: data,
    );

    return MeiliSearchIndexImpl.fromMap(this, response.data);
  }

  @override
  Future<MeiliSearchIndex> getIndex(String uid) async {
    // final response = await dio.get<Map<String, dynamic>>('/indexes/$uid');
    final response =
        await http.get_method<Map<String, dynamic>>('/indexes/$uid');

    return MeiliSearchIndexImpl.fromMap(this, response.data);
  }

  @override
  Future<List<MeiliSearchIndex>> getIndexes() async {
    // final response = await dio.get<List<dynamic>>('/indexes');
    final response = await http.get_method<List<dynamic>>('/indexes');

    return response.data
        .cast<Map<String, dynamic>>()
        .map((item) => MeiliSearchIndexImpl.fromMap(this, item))
        .toList();
  }

  @override
  Future<MeiliSearchIndex> getOrCreateIndex(
    String uid, {
    String primaryKey,
  }) async {
    try {
      return await getIndex(uid);
    } on DioError catch (_) {
      return await createIndex(uid, primaryKey: primaryKey);
    }
  }
}
