import 'package:flutter/material.dart';
import 'api_service.dart'; // Importa el servicio para interactuar con el backend

class DogDetailsPage extends StatelessWidget {
  final String name;
  final String imageAsset;
  final Map<String, dynamic> dogInfo;
  final String dogId; // ID del perro actual
  final ApiService apiService = ApiService();

  const DogDetailsPage({
    Key? key,
    required this.name,
    required this.imageAsset,
    required this.dogInfo,
    required this.dogId, // Agrega el ID del perro
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F6E8),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.brown[700]),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          name,
          style: TextStyle(
            fontSize: 20,
            color: Colors.brown[700],
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Galería de fotos
            Container(
              height: 250,
              child: PageView(
                children: [
                  Image.asset(
                    imageAsset,
                    fit: BoxFit.cover,
                  ),
                  // Aquí puedes agregar más fotos si las tienes
                ],
              ),
            ),

            // Información del perro
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoSection('Información General', [
                    {'Edad': dogInfo['age']},
                    {'Raza': dogInfo['breed']},
                    {'Color': dogInfo['color']},
                  ]),

                  SizedBox(height: 20),

                  _buildInfoSection('Vacunas',
                      (dogInfo['vaccines'] as List<String>)
                          .map((vaccine) => {vaccine: '✓'})
                          .toList()),

                  SizedBox(height: 20),

                  _buildInfoSection('Certificados',
                      (dogInfo['certificates'] as List<String>)
                          .map((cert) => {cert: '✓'})
                          .toList()),

                  SizedBox(height: 40),

                  // Botón de Like
                  Center(
                    child: ElevatedButton(
                      onPressed: () async {
                        await _darLike(dogId);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding:
                            EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        'Dar Like',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoSection(String title, List<Map<String, dynamic>> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.brown[700],
          ),
        ),
        SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 1,
                blurRadius: 5,
              ),
            ],
          ),
          child: ListView.separated(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: items.length,
            separatorBuilder: (context, index) => Divider(height: 1),
            itemBuilder: (context, index) {
              String key = items[index].keys.first;
              String value = items[index].values.first.toString();
              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 12,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      key,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.brown[700],
                      ),
                    ),
                    Text(
                      value,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmar eliminación'),
          content: Text('¿Estás seguro de que deseas eliminar a $name?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                // Aquí iría la lógica para eliminar el perro
                Navigator.pop(context); // Cierra el diálogo
                Navigator.pop(context); // Regresa a la pantalla anterior
                // Aquí podrías mostrar un SnackBar confirmando la eliminación
              },
              child: Text(
                'Eliminar',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _darLike(String receptorId) async {
    try {
      final emisorId = "usuario_actual"; // Obtén el ID del usuario actual

      // Llama al servicio para registrar el like
      final match = await apiService.registrarLike(emisorId, receptorId);

      if (match) {
        // Si hay un match, muestra una notificación
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("¡Tienes un nuevo match con $name!"),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        // Si no hay match, muestra un mensaje de confirmación
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Like enviado a $name"),
            backgroundColor: Colors.blue,
          ),
        );
      }
    } catch (e) {
      // Maneja errores
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error al dar like: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}