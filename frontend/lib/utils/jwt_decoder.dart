import 'dart:convert';

/// Decodifica el payload de un JWT sin verificar la firma.
/// Solo para uso en UI para mostrar datos del usuario autenticado.
Map<String, dynamic> decodeJwtPayload(String token) {
  try {
    final parts = token.split('.');
    if (parts.length != 3) throw Exception('JWT malformado');

    // El payload es la segunda parte, codificado en base64url
    String payload = parts[1];

    // Agregar padding si es necesario
    switch (payload.length % 4) {
      case 2:
        payload += '==';
        break;
      case 3:
        payload += '=';
        break;
    }

    final decoded = utf8.decode(base64Url.decode(payload));
    return jsonDecode(decoded) as Map<String, dynamic>;
  } catch (_) {
    return {};
  }
}
