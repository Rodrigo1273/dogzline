import 'package:flutter/material.dart';
import 'dialogue.dart';
import 'create_dog.dart';

// Página de detalles del perro
class DogDetailsPage extends StatelessWidget {
  final String name;
  final String imageAsset;
  final Map<String, dynamic> dogInfo;

  const DogDetailsPage({
    Key? key,
    required this.name,
    required this.imageAsset,
    required this.dogInfo,
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
            Container(
              height: 250,
              child: PageView(
                children: [
                  Image.asset(
                    imageAsset,
                    fit: BoxFit.cover,
                  ),
                ],
              ),
            ),
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
                    (dogInfo['vaccines'] as List<String>).map((vaccine) => 
                      {vaccine: '✓'}).toList()
                  ),
                  SizedBox(height: 20),
                  _buildInfoSection('Certificados',
                    (dogInfo['certificates'] as List<String>).map((cert) =>
                      {cert: '✓'}).toList()
                  ),
                  SizedBox(height: 40),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        _showDeleteConfirmationDialog(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        'Eliminar Perro',
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
                Navigator.pop(context);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('$name ha sido eliminado'),
                    backgroundColor: Colors.red,
                  ),
                );
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
}

// Pantalla de perfil modificada
class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.filter_list, color: Colors.brown[700]),
          onPressed: () {
            // Acción para abrir filtros
          },
        ),
        title: Text(
          'Dogzline',
          style: TextStyle(
            fontSize: 24,
            color: Colors.brown[700],
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.settings, color: Colors.brown[700]),
            onPressed: () {
              // Acción para ir a ajustes
            },
          ),
          IconButton(
            icon: Icon(Icons.notifications, color: Colors.brown[700]),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NotificationsPage()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Perfil
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: AssetImage('assets/user_profile.jpg'),
                      ),
                      Icon(
                        Icons.verified,
                        color: Colors.blue,
                        size: 24,
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Maria Jose',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.brown[700],
                    ),
                  ),
                ],
              ),
            ),
            // Nivel de suscripción
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const DialogueScreen()),
                );
              },
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Dogzline',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.brown[700],
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const DialogueScreen()),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.brown[700],
                          ),
                          child: Text('Subir de nivel'),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Text(
                      '¿Qué incluye?',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.brown[700],
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Icon(Icons.check, color: Colors.green),
                        SizedBox(width: 8),
                        Text('Recomendaciones Personalizadas'),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.check, color: Colors.green),
                        SizedBox(width: 8),
                        Text('Coincidencias Prioritarias'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            // Perros registrados
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      'Perros registrados',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.brown[700],
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DogDetailsPage(
                                    name: 'Chucho',
                                    imageAsset: 'assets/dog_chucho.jpg',
                                    dogInfo: {
                                      'age': '2 años',
                                      'breed': 'Labrador',
                                      'color': 'Dorado',
                                      'vaccines': ['Rabia', 'Parvovirus', 'Moquillo'],
                                      'certificates': ['Pedigrí', 'Adiestramiento'],
                                    },
                                  ),
                                ),
                              );
                            },
                            child: CircleAvatar(
                              radius: 30,
                              backgroundImage: AssetImage('assets/dog_chucho.jpg'),
                            ),
                          ),
                          SizedBox(height: 8),
                          Text('Chucho'),
                        ],
                      ),
                      Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DogDetailsPage(
                                    name: 'Rocky',
                                    imageAsset: 'assets/dog_rocky.jpg',
                                    dogInfo: {
                                      'age': '3 años',
                                      'breed': 'Pastor Alemán',
                                      'color': 'Negro y Marrón',
                                      'vaccines': ['Rabia', 'Parvovirus'],
                                      'certificates': ['Adiestramiento'],
                                    },
                                  ),
                                ),
                              );
                            },
                            child: CircleAvatar(
                              radius: 30,
                              backgroundImage: AssetImage('assets/dog_rocky.jpg'),
                            ),
                          ),
                          SizedBox(height: 8),
                          Text('Rocky'),
                        ],
                      ),
                      Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const CreateDogPage()),
                              );
                            },
                            child: CircleAvatar(
                              radius: 30,
                              backgroundColor: Colors.brown[100],
                              child: Icon(Icons.add, color: Colors.brown[700]),
                            ),
                          ),
                          SizedBox(height: 8),
                          Text('Registrar'),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Apartado',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
        selectedItemColor: Colors.brown[700],
        unselectedItemColor: Colors.grey,
      ),
      backgroundColor: Color(0xFFF9F6E8),
    );
  }
}

class NotificationsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.brown[700]),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Notificaciones',
          style: TextStyle(
            fontSize: 20,
            color: Colors.brown[700],
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          _buildNotificationItem(
            icon: Icons.notifications,
            title: 'Nueva coincidencia',
            subtitle: 'Tienes una nueva coincidencia con Rocky',
            time: 'Hace 2 horas',
          ),
          _buildNotificationItem(
            icon: Icons.event,
            title: 'Recordatorio de cita',
            subtitle: 'No olvides la cita con el veterinario mañana',
            time: 'Hace 1 día',
          ),
          _buildNotificationItem(
            icon: Icons.thumb_up,
            title: 'Nuevo like',
            subtitle: 'A Chucho le gustó tu perfil',
            time: 'Hace 3 días',
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required String time,
  }) {
    return Card(
      margin: EdgeInsets.only(bottom: 16.0),
      child: ListTile(
        leading: Icon(icon, color: Colors.brown[700]),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.brown[700],
          ),
        ),
        subtitle: Text(subtitle),
        trailing: Text(
          time,
          style: TextStyle(
            color: Colors.grey,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}