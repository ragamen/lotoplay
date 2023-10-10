import 'package:flutter/material.dart';
import 'package:lotoplay/home_screen.dart';

class HomeMenu extends StatelessWidget {
  const HomeMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Modulos Alternos"),
                  //               SizedBox(height: 100,child: Image.file(File("C:/Users/Luis/Desktop/cuaderno/cuaderno/.dart_tool/sqflite_common_ffi/imagenes/tiendas/tienda02.png"))),
                ],
              ),
            ),
            ListTile(
              title: const Text('Usuario'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HomeScreen()),
                );
              },
            ),
            ListTile(
              title: const Text('Cambiar Clave'),
              onTap: () {
                //      const EndSession();
                // Navega a la página 2
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HomeScreen()),
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
                  MaterialPageRoute(builder: (context) => const HomeScreen()),
                );
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: const Text("Hola"),
      ),
    );
/*
    ListView(
      children: [
        DrawerHeader(
          decoration: const BoxDecoration(
            color: Colors.blue,
          ),
          child: Container(
            constraints: const BoxConstraints(
              maxHeight: 30, // Ajusta este valor según tus necesidades
            ),
            child: const Text(
              'Opciones',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
        ),
        ListTile(
          title: const Text('Ventas Animalitos'),
          onTap: () {
            Navigator.push(
              Scaffold.of(context).context,
              MaterialPageRoute(builder: (context) => const HomeScreen()),
            );
          },
        ),
        ListTile(
          title: const Text('Ventas Triples'),
          onTap: () {},
        ),
        // Otras opciones del Drawer
      ],
    );*/
  }
}
