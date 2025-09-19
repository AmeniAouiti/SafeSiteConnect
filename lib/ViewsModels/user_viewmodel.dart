import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../models/create_user_request.dart';
import '../services/user_service.dart';

class UserViewModel extends ChangeNotifier {
  final UserService _userService = UserService();

  // État de l'interface
  bool _isLoading = false;
  String? _errorMessage;
  List<UserModel> _users = [];

  // Getters
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<UserModel> get users => _users;

  // Méthodes utilitaires pour l'état
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String? error) {
    _errorMessage = error;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // Créer un utilisateur
  Future<bool> createUser({
    required String nom,
    required String email,
    required String motdepasse,
    required String confirmMotdepasse,
    required String role,
    required String poste,
    required String departement,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      final request = CreateUserRequest(
        nom: nom,
        email: email,
        motdepasse: motdepasse,
        confirmMotdepasse: confirmMotdepasse,
        role: role,
        poste: poste,
        departement: departement,
      );

      final response = await _userService.createUser(request);

      if (response.success) {
        // Actualiser la liste des utilisateurs après création
        await loadUsers();
        _setLoading(false);
        return true;
      } else {
        _setError(response.error ?? 'Erreur lors de la création');
        _setLoading(false);
        return false;
      }
    } catch (e) {
      _setError('Erreur inattendue: ${e.toString()}');
      _setLoading(false);
      return false;
    }
  }

  // Charger tous les utilisateurs
  Future<void> loadUsers({
    int page = 1,
    int limit = 50, // Augmenté pour avoir plus d'utilisateurs
    String? searchQuery,
    String? roleFilter,
    String? posteFilter,
    String? departementFilter,
    bool? statusFilter,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      final response = await _userService.getAllUsers(
        page: page,
        limit: limit,
        nom: searchQuery,
        role: roleFilter,
        poste: posteFilter,
        departement: departementFilter,
        isActive: statusFilter,
      );

      if (response.success && response.data != null) {
        _users = response.data!;
      } else {
        _setError(response.error ?? 'Erreur lors du chargement');
      }
    } catch (e) {
      _setError('Erreur inattendue: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  // Mettre à jour un utilisateur
  Future<bool> updateUser({
    required String userId,
    required String nom,
    required String email,
    required String role,
    required String poste,
    required String departement,
    String? motdepasse,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      final data = {
        'nom': nom,
        'email': email,
        'role': role,
        'poste': poste,
        'departement': departement,
      };

      if (motdepasse != null && motdepasse.isNotEmpty) {
        data['motdepasse'] = motdepasse;
      }

      final response = await _userService.updateUser(userId, data);

      if (response.success) {
        // Mettre à jour l'utilisateur dans la liste locale
        final index = _users.indexWhere((u) => u.id == userId);
        if (index != -1 && response.data != null) {
          _users[index] = response.data!;
          notifyListeners();
        }
        _setLoading(false);
        return true;
      } else {
        _setError(response.error ?? 'Erreur lors de la mise à jour');
        _setLoading(false);
        return false;
      }
    } catch (e) {
      _setError('Erreur inattendue: ${e.toString()}');
      _setLoading(false);
      return false;
    }
  }

  // Supprimer un utilisateur
  Future<bool> deleteUser(String userId) async {
    _setLoading(true);
    _clearError();

    try {
      final response = await _userService.deleteUser(userId);

      if (response.success) {
        // Supprimer l'utilisateur de la liste locale
        _users.removeWhere((u) => u.id == userId);
        notifyListeners();
        _setLoading(false);
        return true;
      } else {
        _setError(response.error ?? 'Erreur lors de la suppression');
        _setLoading(false);
        return false;
      }
    } catch (e) {
      _setError('Erreur inattendue: ${e.toString()}');
      _setLoading(false);
      return false;
    }
  }

  // Basculer le statut d'un utilisateur
  Future<bool> toggleUserStatus(String userId) async {
    _setLoading(true);
    _clearError();

    try {
      final response = await _userService.toggleUserStatus(userId);

      if (response.success && response.data != null) {
        // Mettre à jour l'utilisateur dans la liste locale
        final index = _users.indexWhere((u) => u.id == userId);
        if (index != -1) {
          _users[index] = response.data!;
          notifyListeners();
        }
        _setLoading(false);
        return true;
      } else {
        _setError(response.error ?? 'Erreur lors du changement de statut');
        _setLoading(false);
        return false;
      }
    } catch (e) {
      _setError('Erreur inattendue: ${e.toString()}');
      _setLoading(false);
      return false;
    }
  }

  // Filtrer les utilisateurs localement
  List<UserModel> getFilteredUsers(String query) {
    if (query.isEmpty) return _users;
    return _users.where((user) =>
    user.nom.toLowerCase().contains(query.toLowerCase()) ||
        user.email.toLowerCase().contains(query.toLowerCase())
    ).toList();
  }

  // Obtenir un utilisateur par ID
  UserModel? getUserById(String id) {
    try {
      return _users.firstWhere((user) => user.id == id);
    } catch (e) {
      return null;
    }
  }

  // Nettoyer les erreurs
  void clearError() {
    _clearError();
  }
}