import 'package:dio/dio.dart';
import 'package:foriyana_app/core/util/date_format.dart';
import 'package:foriyana_app/core/util/dio_client.dart';

class ProfileRepository {
  ProfileRepository._();

  static Future<Response> getProfile(
    String channel, {
    CancelToken? cancelToken,
  }) async {
    return await DioClient.instance.get(
      "/v1/profile",
      queryParameters: {"channel": channel},
    );
  }
}
