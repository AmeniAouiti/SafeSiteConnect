import 'package:dio/dio.dart';
import '../models/user_model.dart';  // Votre UserModel

import '../utils/constants.dart';
import '../utils/dio_client.dart';

class AuthRepository {
  final Dio _dio = DioClient.instance.dio;

  // Pour Signup (créer utilisateur)
  Future<Map<String, dynamic>> signup({
    required String nom,
    required String email,
    required String motdepasse,
    required String confirmMotdepasse,
    required String role,
    required String poste,
    required String departement,
  }) async {
    try {
      final response = await _dio.post(
        ApiConstants.signup,
        data: {
          'nom': nom,
          'email': email,
          'motdepasse': motdepasse,
          'confirmMotdepasse': confirmMotdepasse,
          'role': role,
          'poste': poste,
          'departement': departement,
        },
      );
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Pour Login
  Future<UserModel> login(String email, String motdepasse) async {
    try {
      final response = await _dio.post(
        ApiConstants.login,
        data: {'email': email, 'motdepasse': motdepasse},
      );
      final data = response.data;
      await DioClient.instance.saveToken(data['accessToken']);  // Sauvegarde token
      return UserModel.fromJson(data['user']);  // Retourne l'utilisateur avec role
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Gestion des erreurs (personnalisée)
  Exception _handleError(DioException e) {
    if (e.response != null) {
      return Exception(e.response?.data['message'] ?? 'Erreur inconnue');
    }
    return Exception('Erreur réseau : ${e.message}');
  }

  // Nouvelle méthode pour Forgot Password
  Future<String> forgotPassword(String email) async {
    try {
      final response = await _dio.post(
        '/auth/forgot-password',  // Endpoint direct, ou ajoutez à ApiConstants si besoin
        data: {'email': email},
      );
      return response.data['userId'];  // Retourne userId pour navigation
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Erreur lors de la demande de réinitialisation');
    }
  }

  // Nouvelle méthode pour Verify OTP
  Future<void> verifyOtp(String userId, String otp) async {
    try {
      await _dio.post(
        '/auth/verify-otp/$userId',
        data: {'otp': otp},
      );
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Code OTP invalide ou expiré');
    }
  }

  // Nouvelle méthode pour Reset Password
  Future<void> resetPassword(String userId, String password) async {
    try {
      await _dio.post(
        '/auth/reset-password/$userId',
        data: {'password': password},
      );
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Erreur lors du changement de mot de passe');
    }
  }

  Future<void> logout() async {
    await DioClient.instance.clearToken();
  }
}