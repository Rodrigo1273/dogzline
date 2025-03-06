class Data {
  final String id;
  final String idUsuario;
  final String nombre;
  final int edad;
  final String raza;
  final String sexo;
  final String color;
  final String vacunas;
  final String certificado;
  final String fotos;
  final String comportamiento;
  final double distancia;
  final String caracteristicas; // Añade este campo

  Data({
    required this.id,
    required this.idUsuario,
    required this.nombre,
    required this.edad,
    required this.raza,
    required this.sexo,
    required this.color,
    required this.vacunas,
    required this.certificado,
    required this.fotos,
    required this.comportamiento,
    required this.distancia,
    required this.caracteristicas, // Añade este parámetro
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      id: json['id'],
      idUsuario: json['idUsuario'],
      nombre: json['nombre'],
      edad: json['edad'],
      raza: json['raza'],
      sexo: json['sexo'],
      color: json['color'],
      vacunas: json['vacunas'],
      certificado: json['certificado'],
      fotos: json['fotos'],
      comportamiento: json['comportamiento'],
      distancia: json['distancia'],
      caracteristicas: json['caracteristicas'], // Añade este campo
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'idUsuario': idUsuario,
      'nombre': nombre,
      'edad': edad,
      'raza': raza,
      'sexo': sexo,
      'color': color,
      'vacunas': vacunas,
      'certificado': certificado,
      'fotos': fotos,
      'comportamiento': comportamiento,
      'distancia': distancia,
      'caracteristicas': caracteristicas, // Añade este campo
    };
  }
}