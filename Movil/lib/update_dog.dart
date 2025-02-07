import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class UpdateDogPage extends StatefulWidget {
  final String dogId;
  final String dogName;
  final String dogBreed;
  final String dogAge;
  final String dogImage;
  final String dogDescription;

  const UpdateDogPage({
    Key? key,
    required this.dogId,
    required this.dogName,
    required this.dogBreed,
    required this.dogAge,
    required this.dogImage,
    required this.dogDescription,
  }) : super(key: key);

  @override
  _UpdateDogPageState createState() => _UpdateDogPageState();
}

class _UpdateDogPageState extends State<UpdateDogPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _breedController;
  late TextEditingController _ageController;
  late TextEditingController _descriptionController;
  File? _imageFile;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.dogName);
    _breedController = TextEditingController(text: widget.dogBreed);
    _ageController = TextEditingController(text: widget.dogAge);
    _descriptionController = TextEditingController(text: widget.dogDescription);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _breedController.dispose();
    _ageController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    
    if (image != null) {
      setState(() {
        _imageFile = File(image.path);
      });
    }
  }

  Future<void> _updateDog() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        // Aquí iría la lógica para actualizar el perro en la base de datos
        // Por ejemplo:
        // await FirebaseFirestore.instance.collection('dogs').doc(widget.dogId).update({
        //   'name': _nameController.text,
        //   'breed': _breedController.text,
        //   'age': _ageController.text,
        //   'description': _descriptionController.text,
        //   'updatedAt': DateTime.now(),
        // });

        // Si hay una nueva imagen, subirla y actualizar la URL
        if (_imageFile != null) {
          // Aquí iría el código para subir la imagen
          // Por ejemplo:
          // final imageUrl = await uploadImageToStorage(_imageFile!);
          // await FirebaseFirestore.instance.collection('dogs').doc(widget.dogId)
          //     .update({'imageUrl': imageUrl});
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Perro actualizado correctamente')),
        );
        Navigator.pop(context, true);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al actualizar el perro')),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _confirmDelete() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmar eliminación'),
          content: Text('¿Estás seguro que deseas eliminar a ${widget.dogName}? Esta acción no se puede deshacer.'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancelar'),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            TextButton(
              child: Text(
                'Eliminar',
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () => Navigator.of(context).pop(true),
            ),
          ],
        );
      },
    );

    if (result == true) {
      setState(() {
        _isLoading = true;
      });

      try {
        // Aquí iría la lógica para eliminar el perro de la base de datos
        // Por ejemplo:
        // await FirebaseFirestore.instance.collection('dogs').doc(widget.dogId).delete();
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Perro eliminado correctamente')),
        );
        Navigator.pop(context, true);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al eliminar el perro')),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar ${widget.dogName}'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.brown[700],
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    GestureDetector(
                      onTap: _pickImage,
                      child: Container(
                        height: 200,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: _imageFile != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.file(
                                  _imageFile!,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : Image.network(
                                widget.dogImage,
                                fit: BoxFit.cover,
                              ),
                      ),
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: 'Nombre del perro',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingresa el nombre del perro';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: _breedController,
                      decoration: InputDecoration(
                        labelText: 'Raza',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingresa la raza del perro';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: _ageController,
                      decoration: InputDecoration(
                        labelText: 'Edad',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingresa la edad del perro';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: _descriptionController,
                      decoration: InputDecoration(
                        labelText: 'Descripción',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 3,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingresa una descripción';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: _updateDog,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.brown[700],
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'Guardar cambios',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    SizedBox(height: 16),
                    TextButton(
                      onPressed: _confirmDelete,
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.red,
                        padding: EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: Text(
                        'Eliminar perro',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
            ),
      backgroundColor: Color(0xFFF9F6E8),
    );
  }
}