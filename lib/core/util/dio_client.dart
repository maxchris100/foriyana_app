import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:foriyana_app/data/data_sources/local/user_local_data_source.dart';

typedef OnSendProgressCallBack = Function(int sent, int total);

class DioClient {
  static final instance = DioClient();
  late Dio dio;
  final InterceptorsWrapper defaultInterceptor = InterceptorsWrapper(
    onError: (e, handler) {
      log("connection error ${e.message}");
      return handler.reject(e);
    },
    onRequest: (options, handler) {
      log(
        "${options.method}: ${options.baseUrl}${options.path}, @param: ${options.queryParameters}, @body: ${options.data}",
      );
      return handler.next(options);
    },
    onResponse: (e, handler) {
      log(
        "onResponse: ${e.requestOptions.baseUrl}${e.requestOptions.path}: ${e.statusCode}",
      );
      // try {
      //   if (e.data["message"] == "User Log Not Found") {
      //     goToLogin();
      //     return;
      //   }
      // } catch (ex) {}
      return handler.next(e);
    },
  );
  DioClient() {
    dio = initiateDio();
  }

  Map<String, dynamic> getBaseHeader() {
    return {
      "Authorization": "Bearer ${UserLocalDataSource.token ?? ""}",
      HttpHeaders.contentTypeHeader: "application/json",
    };
  }

  Dio initiateDio() {
    var _dio = Dio();
    _dio.options.baseUrl =
        "https://stg-affiliate-service-nlkoa.ondigitalocean.app";
    _dio.options.connectTimeout = 30000;
    _dio.options.receiveTimeout = 30000;
    _dio.options.followRedirects = false;
    _dio.options.validateStatus = (status) {
      return status! < 500;
    };
    _dio.options.headers = {
      // "authorization": UserMemory.instance.tokenData?.token ?? "",
      HttpHeaders.contentTypeHeader: "application/json",
    };
    _dio.interceptors.add(defaultInterceptor);
    // if (Constant.alice != null) {
    //   _dio.interceptors.add(Constant.alice!.getDioInterceptor());
    // }
    return _dio;
  }

  void reInitiateDio() {
    dio = initiateDio();
  }

  Future<Response> get(
    String path, {
    CancelToken? cancelToken,
    Map<String, dynamic>? queryParameters,
    Options? options,
    Function(int, int)? onReceiveProgress,
  }) async {
    Response? response;
    try {
      Options opt = Options(headers: getBaseHeader());
      response = await dio.get(
        path,
        cancelToken: cancelToken,
        queryParameters: queryParameters,
        options: options ?? opt,
        onReceiveProgress: onReceiveProgress,
      );

      // if (response.statusCode == 401) {
      //   var value = await LoginRepository.onRefreshToken();
      //   if (value.statusCode == 200) {
      //     if (value.data["status"] == 1) {
      //       LoginData loginData = UserMemory.instance.loginData!;
      //       TokenData tokenData = TokenData.fromMap(value.data["data"]);
      //       UserMemory.instance.setLoginData(loginData, tokenData);
      //       response = await dio.get(path,
      //           cancelToken: cancelToken,
      //           queryParameters: queryParameters,
      //           options: options ?? opt,
      //           onReceiveProgress: onReceiveProgress);
      //     } else {
      //       goToLogin();
      //     }
      //   } else {
      //     goToLogin();
      //   }
      // }
      if (response.statusCode == 404) {
        log('@res: 404 Not found');
      }
    } catch (e) {
      if (e is DioError) {
        return Response(
          requestOptions: RequestOptions(path: ''),
          data: {"status": 999},
          statusCode: 999,
          statusMessage: e.message,
        );
      } else {
        return Response(
          requestOptions: RequestOptions(path: ''),
          data: {"status": 999},
          statusCode: 999,
          statusMessage: e.toString(),
        );
      }
    }
    return response;
  }

  Future<Response> post(
    String path, {
    CancelToken? cancelToken,
    Map<String, dynamic>? queryParameters,
    Options? options,
    OnSendProgressCallBack? onProgress,
    dynamic data,
  }) async {
    Response? response;
    try {
      Options opt = Options(headers: getBaseHeader());
      response = await dio.post(
        path,
        onSendProgress: onProgress,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
        options: options ?? opt,
        data: data,
      );

      // if (response.statusCode == 401 && path != "/v1/user/refresh_token") {
      //   var value = await LoginRepository.onRefreshToken();
      //   if (value.statusCode == 200) {
      //     if (value.data["status"] == 1) {
      //       LoginData loginData = UserMemory.instance.loginData!;
      //       TokenData tokenData = TokenData.fromMap(value.data["data"]);
      //       UserMemory.instance.setLoginData(loginData, tokenData);
      //       response = await dio.post(
      //         path,
      //         onSendProgress: onProgress,
      //         queryParameters: queryParameters,
      //         cancelToken: cancelToken,
      //         options: options ?? opt,
      //         data: data,
      //       );
      //     } else {
      //       goToLogin();
      //     }
      //   } else {
      //     goToLogin();
      //   }
      // }
      if (response.statusCode == 404) {
        log('@res: 404 Not found');
      } else {
        log('@res: ' + response.data.toString());
      }
    } catch (e) {
      log("Dio: $e");
      var message = 'Koneksi terputus';
      if (e is DioError) {
        if (e.error is HttpException) {
          var ed = e.error as HttpException;
          message = ed.message;
        }
        return Response(
          requestOptions: RequestOptions(path: ''),
          data: {"status": 999, "message": message},
          statusCode: 999,
          statusMessage: e.message,
        );
      } else {
        return Response(
          requestOptions: RequestOptions(path: ''),
          data: {"status": 999, "message": message},
          statusCode: 999,
          statusMessage: e.toString(),
        );
      }
    }
    return response;
  }

  Future<Response> put(
    String path, {
    CancelToken? cancelToken,
    Map<String, dynamic>? queryParameters,
    Options? options,
    OnSendProgressCallBack? onProgress,
    dynamic data,
  }) async {
    Response? response;
    try {
      Options opt = Options(headers: getBaseHeader());
      response = await dio.put(
        path,
        onSendProgress: onProgress,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
        options: options ?? opt,
        data: data,
      );

      // if (response.statusCode == 401) {
      //   var value = await LoginRepository.onRefreshToken();
      //   if (value.statusCode == 200) {
      //     if (value.data["status"] == 1) {
      //       LoginData loginData = UserMemory.instance.loginData!;
      //       TokenData tokenData = TokenData.fromMap(value.data["data"]);
      //       UserMemory.instance.setLoginData(loginData, tokenData);
      //       response = await dio.post(
      //         path,
      //         onSendProgress: onProgress,
      //         queryParameters: queryParameters,
      //         cancelToken: cancelToken,
      //         options: options ?? opt,
      //         data: data,
      //       );
      //     } else {
      //       goToLogin();
      //     }
      //   } else {
      //     goToLogin();
      //   }
      // }
      if (response.statusCode == 404) {
        log('@res: 404 Not found');
      } else {
        log('@res: ' + response.data.toString());
      }
    } catch (e) {
      log("Dio: $e");
      var message = 'Koneksi terputus';
      if (e is DioError) {
        if (e.error is HttpException) {
          var ed = e.error as HttpException;
          message = ed.message;
        }
        return Response(
          requestOptions: RequestOptions(path: ''),
          data: {"status": 999, "message": message},
          statusCode: 999,
          statusMessage: e.message,
        );
      } else {
        return Response(
          requestOptions: RequestOptions(path: ''),
          data: {"status": 999, "message": message},
          statusCode: 999,
          statusMessage: e.toString(),
        );
      }
    }
    return response;
  }

  Future<Response> delete(
    String path, {
    CancelToken? cancelToken,
    Map<String, dynamic>? queryParameters,
    Options? options,
    OnSendProgressCallBack? onProgress,
    dynamic data,
  }) async {
    Response? response;
    try {
      Options opt = Options(headers: getBaseHeader());
      response = await dio.delete(
        path,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
        options: options ?? opt,
        data: data,
      );

      // if (response.statusCode == 401) {
      //   var value = await LoginRepository.onRefreshToken();
      //   if (value.statusCode == 200) {
      //     if (value.data["status"] == 1) {
      //       LoginData loginData = UserMemory.instance.loginData!;
      //       TokenData tokenData = TokenData.fromMap(value.data["data"]);
      //       UserMemory.instance.setLoginData(loginData, tokenData);
      //       response = await dio.delete(
      //         path,
      //         queryParameters: queryParameters,
      //         cancelToken: cancelToken,
      //         options: options ?? opt,
      //         data: data,
      //       );
      //     } else {
      //       goToLogin();
      //     }
      //   } else {
      //     goToLogin();
      //   }
      // }
      if (response.statusCode == 404) {
        log('@res: 404 Not found');
      } else {
        log('@res: ' + response.data.toString());
      }
    } catch (e) {
      log("Dio: $e");
      var message = 'Koneksi terputus';
      if (e is DioError) {
        if (e.error is HttpException) {
          var ed = e.error as HttpException;
          message = ed.message;
        }
        return Response(
          requestOptions: RequestOptions(path: ''),
          data: {"status": 999, "message": message},
          statusCode: 999,
          statusMessage: e.message,
        );
      } else {
        return Response(
          requestOptions: RequestOptions(path: ''),
          data: {"status": 999, "message": message},
          statusCode: 999,
          statusMessage: e.toString(),
        );
      }
    }
    return response;
  }

  Future<Response> download(
    String path,
    String savepath, {
    CancelToken? cancelToken,
    Map<String, dynamic>? queryParameters,
    Options? options,
    OnSendProgressCallBack? onProgress,
    FormData? data,
  }) async {
    Response? response;
    try {
      Options opt = Options(headers: getBaseHeader());
      response = await Dio().download(
        path,
        savepath,
        onReceiveProgress: onProgress,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
        options: options ?? opt,
        data: data,
      );

      // if (response.statusCode == 401) {
      //   var value = await LoginRepository.onRefreshToken();
      //   if (value.statusCode == 200) {
      //     if (value.data["status"] == 1) {
      //       LoginData loginData = UserMemory.instance.loginData!;
      //       TokenData tokenData = TokenData.fromMap(value.data["data"]);
      //       UserMemory.instance.setLoginData(loginData, tokenData);
      //       response = await Dio().download(
      //         path,
      //         savepath,
      //         onReceiveProgress: onProgress,
      //         queryParameters: queryParameters,
      //         cancelToken: cancelToken,
      //         options: options ?? opt,
      //         data: data,
      //       );
      //     } else {
      //       // goToLogin();
      //     }
      //   } else {
      //     // goToLogin();
      //   }
      // }
      if (response.statusCode == 404) {
        log('@res: 404 Not found');
      } else {
        log('@res: ' + response.data.toString());
      }
    } catch (e) {
      log("Dio: $e");
      var message = 'Koneksi terputus';
      if (e is DioError) {
        if (e.error is HttpException) {
          var ed = e.error as HttpException;
          message = ed.message;
        }
        return Response(
          requestOptions: RequestOptions(path: ''),
          data: {"status": 999, "message": message},
          statusCode: 999,
          statusMessage: e.message,
        );
      } else {
        return Response(
          requestOptions: RequestOptions(path: ''),
          data: {"status": 999, "message": message},
          statusCode: 999,
          statusMessage: e.toString(),
        );
      }
    }
    return response;
  }
}
