import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DioClient {
  late Dio _dio;
  static DioClient? _instance;

  static DioClient get instance {
    _instance ??= DioClient._();
    return _instance!;
  }

  DioClient._() {
    _dio = Dio();
    _setupDio();
  }

  void _setupDio() {
    _dio.options = BaseOptions(
      baseUrl: '${ApiConstants.baseUrl}${ApiConstants.apiVersion}',
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: ApiConstants.headers,
    );

    // Ajout des interceptors pour le debug
    if (kDebugMode) {
      _dio.interceptors.add(LogInterceptor(
        requestBody: true,
        responseBody: true,
        requestHeader: true,
        responseHeader: true,
        logPrint: (object) => debugPrint(object.toString()),
      ));
    }

    // Interceptor pour l'authentification
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        // Ajoutez le token d'authentification ici si nécessaire
        final token = await _getAuthToken();
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        handler.next(options);
      },
      onResponse: (response, handler) {
        if (kDebugMode) {
          debugPrint('Response [${response.statusCode}] ${response.requestOptions.uri}');
        }
        handler.next(response);
      },
      onError: (error, handler) {
        if (kDebugMode) {
          debugPrint('API Error: ${error.message}');
          debugPrint('Status Code: ${error.response?.statusCode}');
          debugPrint('Response Data: ${error.response?.data}');
        }
        handler.next(error);
      },
    ));
  }

  Future<String?> _getAuthToken() async {
    // Implémentez la récupération du token depuis le stockage local
    // Par exemple avec SharedPreferences ou secure_storage
    return null; // Remplacez par votre logique
  }

  Dio get dio => _dio;

  // Méthode pour nettoyer l'instance (utile pour logout)
  void dispose() {
    _dio.close();
    _instance = null;
  }


// Ajoutez une méthode pour sauvegarder le token (appelée après login/signup)
  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('access_token', token);
  }

// Ajoutez pour logout (optionnel)
  Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('access_token');
  }
}