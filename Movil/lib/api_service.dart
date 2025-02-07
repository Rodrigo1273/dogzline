import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = "http://tu-servidor.com/api";

  Future<bool> registrarLike(String emisorId, String receptorId) async {
    final response = await http.post(
      Uri.parse("$baseUrl/likes"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"emisor": emisorId, "receptor": receptorId}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data["match"] ?? false; // Retorna `true` si hay un match
    } else {
      throw Exception("Error al registrar el like");
    }
  }
}