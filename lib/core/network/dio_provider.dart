import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:super_adoption/core/log/app_logger.dart';

part 'dio_provider.g.dart';

@riverpod
Dio animalApiClient(Ref ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: 'https://data.moa.gov.tw',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      responseType: ResponseType.json,
    ),
  );

  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) {
        AppLogger.instance.i(
          'HTTP ${options.method} ${options.uri}\nquery=${options.queryParameters}',
        );
        handler.next(options);
      },
      onResponse: (response, handler) {
        final data = response.data;
        final summary = data is List
            ? 'list(${data.length})'
            : data.runtimeType;
        AppLogger.instance.i(
          'HTTP ${response.statusCode} ${response.requestOptions.uri}\nresponse=$summary',
        );
        handler.next(response);
      },
      onError: (error, handler) {
        AppLogger.instance.e(
          'HTTP ERROR ${error.requestOptions.uri}',
          error: error,
          stackTrace: error.stackTrace,
        );
        handler.next(error);
      },
    ),
  );

  return dio;
}
