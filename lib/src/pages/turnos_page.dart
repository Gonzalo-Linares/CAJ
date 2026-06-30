import 'package:flutter/material.dart';
import '../widgets/main_layout.dart';
import '../provider/turnos_provider.dart'; 

class TurnosPage extends StatefulWidget {
  const TurnosPage({super.key});

  @override
  State<TurnosPage> createState() => _TurnosPageState();
}

class _TurnosPageState extends State<TurnosPage> {

  final _nombreController = TextEditingController();
  final _apellidoController = TextEditingController();
  final _fechaController = TextEditingController();
  final _horaController = TextEditingController();
  
  String? _duracionSeleccionada = '30 minutos';

  final List<String> _opcionesDuracion = [
    '30 minutos',
    '1 hora',
    '1 hora y 30 minutos',
    '2 horas',
    '2 horas y 30 minutos',
    '3 horas'
  ];
  
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _nombreController.dispose();
    _apellidoController.dispose();
    _fechaController.dispose();
    _horaController.dispose();
    super.dispose();
  }

  Future<void> _seleccionarFecha(BuildContext context) async {
    final DateTime? seleccionado = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(), 
      lastDate: DateTime(2030),
    );

    if (seleccionado != null) {
      setState(() {
        _fechaController.text = 
            "${seleccionado.year}-${seleccionado.month.toString().padLeft(2, '0')}-${seleccionado.day.toString().padLeft(2, '0')}";
      });
    }
  }

  Future<void> _seleccionarHora(BuildContext context) async {
    final TimeOfDay? seleccionado = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (seleccionado != null) {
      setState(() {
        _horaController.text = 
            "${seleccionado.hour.toString().padLeft(2, '0')}:${seleccionado.minute.toString().padLeft(2, '0')}";
      });
    }
  }

  
  Future<void> _pedirTurno() async {
    if (_formKey.currentState!.validate()) {
      
      final nuevoTurno = {
        'fecha': _fechaController.text,
        'hora': _horaController.text,
        'nombre': _nombreController.text,
        'apellido': _apellidoController.text,
        'duracion': _duracionSeleccionada,
      };

      try {
        // Guardamos en Firebase 
        await firebaseProvider.guardarTurno(nuevoTurno);

        
        // Preguntamos si la pantalla sigue abierta antes de continuar
        if (!mounted) return;

        // Limpiamos los campos
        _nombreController.clear();
        _apellidoController.clear();
        _fechaController.clear();
        _horaController.clear();
        
        // Reseteamos el formulario entero 
        _formKey.currentState!.reset();

        setState(() {
          _duracionSeleccionada = '30 minutos';
        });
        
        FocusScope.of(context).unfocus();

        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('¡Turno pedido con éxito!'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      } catch (e) {
        // Por si falla Firebase, verificamos antes de mostrar el error
        if (!mounted) return; 
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al guardar: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      title: 'Turnos',
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            //  FORMULARIO
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView( 
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text(
                          'Solicitar Nuevo Turno',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _nombreController,
                                decoration: const InputDecoration(labelText: 'Nombre', border: OutlineInputBorder()),
                                validator: (v) => v!.isEmpty ? 'Requerido' : null,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: TextFormField(
                                controller: _apellidoController,
                                decoration: const InputDecoration(labelText: 'Apellido', border: OutlineInputBorder()),
                                validator: (v) => v!.isEmpty ? 'Requerido' : null,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _fechaController,
                                readOnly: true, 
                                decoration: const InputDecoration(
                                  labelText: 'Fecha', 
                                  border: OutlineInputBorder(),
                                  suffixIcon: Icon(Icons.calendar_today),
                                ),
                                onTap: () => _seleccionarFecha(context), 
                                validator: (v) => v!.isEmpty ? 'Falta fecha' : null,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: TextFormField(
                                controller: _horaController,
                                readOnly: true, 
                                decoration: const InputDecoration(
                                  labelText: 'Hora', 
                                  border: OutlineInputBorder(),
                                  suffixIcon: Icon(Icons.access_time),
                                ),
                                onTap: () => _seleccionarHora(context), 
                                validator: (v) => v!.isEmpty ? 'Falta hora' : null,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        
                        DropdownButtonFormField<String>(
                          initialValue: _duracionSeleccionada, 
                          decoration: const InputDecoration(
                            labelText: 'Duración del turno',
                            border: OutlineInputBorder(),
                          ),
                          items: _opcionesDuracion.map((String valor) {
                            return DropdownMenuItem<String>(
                              value: valor,
                              child: Text(valor),
                            );
                          }).toList(),
                          onChanged: (nuevoValor) {
                            setState(() {
                              _duracionSeleccionada = nuevoValor;
                            });
                          },
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _pedirTurno, // Ahora llama a la función correcta
                          child: const Text('Confirmar Turno'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 10),
            const Text('Tus Turnos Activos', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            
            //LISTA DE TURNOS 
            Expanded(
              child: StreamBuilder<List<dynamic>>(
                stream: firebaseProvider.obtenerTurnosStream(), 
                builder: (context, snapshot) {
                  
                  if (snapshot.hasError) {
                    return Center(child: Text('Error al cargar turnos: ${snapshot.error}'));
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final turnos = snapshot.data ?? [];
                  if (turnos.isEmpty) {
                    return const Center(child: Text('No hay turnos registrados aún.'));
                  }

                  return ListView.builder(
                    itemCount: turnos.length,
                    itemBuilder: (context, index) {
                      final turno = turnos[index];
                      
                      return Card(
                        child: ListTile(
                          leading: const Icon(Icons.person, color: Colors.blue),
                          title: Text('${turno['nombre']} ${turno['apellido']}'),
                          subtitle: Text(
                            'Fecha: ${turno['fecha']} - Hora: ${turno['hora']} \nDuración: ${turno['duracion']}'
                          ),
                          isThreeLine: true,
                          trailing: IconButton(
                            icon: const Icon(Icons.cancel, color: Colors.red),
                            onPressed: () {
                              
                              firebaseProvider.eliminarTurno(turno['id']); 
                            },
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}