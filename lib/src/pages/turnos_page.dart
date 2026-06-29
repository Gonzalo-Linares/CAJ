import 'package:flutter/material.dart';
import '../widgets/main_layout.dart';
import '../provider/turnos_provider.dart';

class TurnosPage extends StatefulWidget {
  const TurnosPage({super.key});

  @override
  State<TurnosPage> createState() => _TurnosPageState();
}



class _TurnosPageState extends State<TurnosPage> {
  List<dynamic> _misTurnos = [];


  final _nombreController = TextEditingController();
  final _apellidoController = TextEditingController();
  final _fechaController = TextEditingController();
  final _horaController = TextEditingController();
  
  // VARIABLE PARA GUARDAR LA DURACIÓN SELECCIONADA (Por defecto 30 min)
  String? _duracionSeleccionada = '30 minutos';

  // Lista de opciones para la solapa de duración (de a 30 minutos)
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
  void initState() {
    super.initState();
    
  }

 

  @override
  void dispose() {
    _nombreController.dispose();
    _apellidoController.dispose();
    _fechaController.dispose();
    _horaController.dispose();
    super.dispose();
  }

  // FUNCIÓN PARA ABRIR EL CALENDARIO NATIVO
  Future<void> _seleccionarFecha(BuildContext context) async {
    final DateTime? seleccionado = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(), // No permite elegir fechas pasadas
      lastDate: DateTime(2030),
    );

    if (seleccionado != null) {
      setState(() {
        // Formateo de la fecha a YYYY-MM-DD para que coincida el JSON
        _fechaController.text = 
            "${seleccionado.year}-${seleccionado.month.toString().padLeft(2, '0')}-${seleccionado.day.toString().padLeft(2, '0')}";
      });
    }
  }
  Future<void>pedirTurno() async {
    if (_formKey.currentState!.validate()) {
      
      final nuevoTurno = {
        'fecha': _fechaController.text,
        'hora': _horaController.text,
        'nombre': _nombreController.text,
        'apellido': _apellidoController.text,
        'duracion': _duracionSeleccionada,
      };

      // Guardamos en la base de datos de verdad
      await firebaseProvider.guardarTurno(nuevoTurno);

      
    }
  }

  // FUNCIÓN PARA ABRIR EL RELOJ NATIVO
  Future<void> _seleccionarHora(BuildContext context) async {
    final TimeOfDay? seleccionado = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (seleccionado != null) {
      setState(() {
        // Formateo de la hora a HH:MM
        _horaController.text = 
            "${seleccionado.hour.toString().padLeft(2, '0')}:${seleccionado.minute.toString().padLeft(2, '0')}";
      });
    }
  }

  void _pedirTurno() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _misTurnos.add({
          'fecha': _fechaController.text,
          'hora': _horaController.text,
          'nombre': _nombreController.text,
          'apellido': _apellidoController.text,
          'duracion': _duracionSeleccionada, // Guardamos lo elegido en la solapa
        });
      });

      _nombreController.clear();
      _apellidoController.clear();
      _fechaController.clear();
      _horaController.clear();
      
      // Reiniciamos la solapa al valor por defecto
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
                        
                        // Nombre y Apellido
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
                        
                        // CAMPOS DE FECHA Y HORA COMO BOTONES
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _fechaController,
                                readOnly: true, // Evita que se abra el teclado numérico
                                decoration: const InputDecoration(
                                  labelText: 'Fecha', 
                                  border: OutlineInputBorder(),
                                  suffixIcon: Icon(Icons.calendar_today),
                                ),
                                onTap: () => _seleccionarFecha(context), // Abre el calendario al tocar
                                validator: (v) => v!.isEmpty ? 'Falta fecha' : null,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: TextFormField(
                                controller: _horaController,
                                readOnly: true, // Evita que se abra el teclado numérico
                                decoration: const InputDecoration(
                                  labelText: 'Hora', 
                                  border: OutlineInputBorder(),
                                  suffixIcon: Icon(Icons.access_time),
                                ),
                                onTap: () => _seleccionarHora(context), // Abre el reloj al tocar
                                validator: (v) => v!.isEmpty ? 'Falta hora' : null,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        
                        // SOLAPA (DROPDOWN) PARA LA DURACIÓN
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
                          onPressed: _pedirTurno,
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
            
            // LISTA DE TURNOS 
            // ... (Todo el formulario de arriba queda igual) ...

// --- SECCIÓN 2: LISTA DE TURNOS EN TIEMPO REAL ---
Expanded(
  child: StreamBuilder<List<dynamic>>(
    // Acá ponés la función que te pasó tu compañero
    stream: firebaseProvider.obtenerTurnosStream(), 
    builder: (context, snapshot) {
      
      // ESTADO 1: ¿Hay un error en la conexión?
      if (snapshot.hasError) {
        return Center(child: Text('Error al cargar turnos: ${snapshot.error}'));
      }

      // ESTADO 2: ¿Todavía está esperando la primera respuesta?
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(child: CircularProgressIndicator());
      }

      // ESTADO 3: ¿Llegaron los datos pero la lista está vacía?
      final turnos = snapshot.data ?? [];
      if (turnos.isEmpty) {
        return const Center(child: Text('No hay turnos registrados aún.'));
      }

      // ESTADO 4: ¡Tenemos datos! Dibujamos la lista
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
              // Fíjate que el botón de eliminar ahora debería llamar a 
              // una función de Firebase en lugar de un simple setState
              trailing: IconButton(
                icon: const Icon(Icons.cancel, color: Colors.red),
                onPressed: () {
                  // firebaseProvider.eliminarTurno(turno['id']);
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