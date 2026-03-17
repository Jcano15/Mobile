import 'package:shared_preferences/shared_preferences.dart';

/// Servicio para persistir el JWT en almacenamiento local.
class AuthService {
  static const String _tokenKey = 'jwt_token';

  /// Guarda el token JWT.
  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  /// Obtiene el token JWT almacenado. Retorna null si no existe.
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  /// Borra el token JWT (logout).
  static Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
  }

  /// Retorna true si hay un token guardado.
  static Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }
}
