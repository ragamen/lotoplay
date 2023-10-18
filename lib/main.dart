import 'package:flutter/material.dart';
import 'package:lotoplay/helper/common.dart';
import 'package:lotoplay/home_screen.dart';
import 'package:lotoplay/models/agencialista.dart';
import 'package:lotoplay/models_sp/agencia.dart';
import 'package:lotoplay/stars_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  await Supabase.initialize(
      url: "https://qpewttmefqniyqflyjmu.supabase.co",
      anonKey:
          "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InFwZXd0dG1lZnFuaXlxZmx5am11Iiwicm9sZSI6ImFub24iLCJpYXQiOjE2NzM2NjI1NDYsImV4cCI6MTk4OTIzODU0Nn0.OnRuoILFCh1WhCTjNx8JGRPaf_OzrBthdhL-H3dXhQk");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //title: 'Ventas de Loterías',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyWidget(),
    );
  }
}

class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  User? _user;
  bool vinculado = false;
  @override
  void initState() {
    _getAuth();
    super.initState();
  }

  Future<void> _getAuth() async {
    if (mounted) {
      setState(() {
        _user = cliente.auth.currentUser;
      });
    }
    cliente.auth.onAuthStateChange.listen((event) {
      if (mounted) {
        setState(() {
          _user = event.session?.user;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!(_user == null)) {
      leerAgencia(_user?.email);
    }
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.black, // Cambia el color del icono aquí
        ),
        backgroundColor: Colors.yellow,
        title: const Text(
          "Ventas de Loterías",
          style: TextStyle(color: Colors.black),
        ),
      ),

      drawer: _user == null
          ? null
          : Drawer(
              child: ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[
                  Container(
                    constraints: const BoxConstraints(
                      maxHeight: 80,
                    ),
                    child: const DrawerHeader(
                      decoration: BoxDecoration(color: Colors.yellow),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "Modulos Alternos",
                            style: TextStyle(color: Colors.black),
                          ),
                          //               SizedBox(height: 100,child: Image.file(File("C:/Users/Luis/Desktop/cuaderno/cuaderno/.dart_tool/sqflite_common_ffi/imagenes/tiendas/tienda02.png"))),
                        ],
                      ),
                    ),
                  ),
                  ListTile(
                    title: const Text(
                      'Venta de animalitos',
                      style: TextStyle(color: Colors.black),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const HomeScreen()),
                      );
                    },
                  ),
                  ListTile(
                    title: const Text(
                      'Resultados y premiacion',
                      style: TextStyle(color: Colors.black),
                    ),
                    onTap: () {
                      //      const EndSession();
                      // Navega a la página 2
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const HomeScreen()),
                      );
                    },
                  ),
                  ListTile(
                    title: const Text('Cerrar Sesion'),
                    onTap: () {
                      //      const EndSession();
                      // Navega a la página 2
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const EndSession()),
                      );
                    },
                  ),
                ],
              ),
            ),

      body: _user == null ? const StartPage() : null,
//      const HomeMenu(),
    );
  }

  Future<void> leerAgencia(correo) async {
    try {
      final response = await cliente
          .from('agencias')
          .select(
              'codigofranquicia,codigoagencia,nombreagencia,direccion,correo,banco,telefono,cedulaadmin,cupo,comision,nroticket,serial')
          .eq('correo', correo);
      if (response.length == 1) {
        int count = response.length;
        List<Agencia> agencia = [];
        for (int i = 0; i < count; i++) {
          agencia.add(Agencia.fromMap(response[i]));
        }
        AgenciaActual.agenciaActual = agencia;
//        setState(() {
        vinculado = true;
        //       });
      } else {
        //       setState(() {
        vinculado = false;
        AgenciaActual.agenciaActual = List.empty();
        _user = null;
        cliente.auth.signOut();
        //     });
      }
    } catch (e) {
      //
    }
  }
}

class EndSession extends StatelessWidget {
  const EndSession({super.key});

  @override
  Widget build(BuildContext context) {
    cliente.auth.signOut();
    return const MyWidget();
  }
}
