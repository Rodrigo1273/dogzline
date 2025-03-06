class Notificacion {
  final String id; // Añade este campo
  final String idUsuario;
  final String idMascota;
  final DateTime mensajeLlegada;
  final String contenido;
  final bool leido;
  final String foto;

  Notificacion({
    required this.id, // Añade este parámetro
    required this.idUsuario,
    required this.idMascota,
    required this.mensajeLlegada,
    required this.contenido,
    required this.leido,
    required this.foto,
  });

  factory Notificacion.fromJson(Map<String, dynamic> json) {
    return Notificacion(
      id: json['id'], // Añade este campo
      idUsuario: json['idUsuario'],
      idMascota: json['idMascota'],
      mensajeLlegada: DateTime.parse(json['mensajeLlegada']),
      contenido: json['contenido'],
      leido: json['leido'],
      foto: json['foto'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id, // Añade este campo
      'idUsuario': idUsuario,
      'idMascota': idMascota,
      'mensajeLlegada': mensajeLlegada.toIso8601String(),
      'contenido': contenido,
      'leido': leido,
      'foto': foto,
    };
  }
}