import 'package:flutter/material.dart';
import 'package:lotoplay/helper/common.dart';
//import 'package:supabase_flutter/supabase_flutter.dart';

class RegistrarUsuario extends StatefulWidget {
  const RegistrarUsuario({super.key});

  @override
  State<RegistrarUsuario> createState() => _RegistrarUsuarioState();
}
// bool _signInLoading = false;

class _RegistrarUsuarioState extends State<RegistrarUsuario> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nombreController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
//  final cliente = Supabase.instance.client;
//  final String? _user = cliente.auth.currentUser!.email;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Franquicia"),
      ),
      body: Center(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 35),
            child: Container(
              height: 400,
              width: 400,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 9, 209, 244),
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0xAA6EB1E6),
                    offset: Offset(9, 9),
                    blurRadius: 6,
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  //email
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Por favor completar su Nombre";
                        }
                        return null;
                      },
                      controller: _nombreController,
                      decoration: const InputDecoration(
                        label: Text("Nombre"),
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Por favor completar Correo";
                        }
                        return null;
                      },
                      controller: _emailController,
                      decoration: const InputDecoration(
                        label: Text("Email"),
                      ),
                    ),
                  ),
                  // password
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Por favor llenar clave de acceso";
                        }
                        return null;
                      },
                      obscureText: true,
                      controller: _passwordController,
                      decoration: const InputDecoration(
                        label: Text("Password"),
                      ),
                    ),
                  ),
                  //Sign in Bottom
                  //Sign Up Botton
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.white,
                        elevation: 10, //<-- SEE HERE
                        shadowColor: const Color.fromARGB(255, 93, 90, 81),
                        side: const BorderSide(
                            color: Color.fromARGB(255, 66, 63, 63),
                            width: 2), //<-- SEE HERE
                      ),
                      onPressed: () async {
                        final isValid = _formKey.currentState?.validate();
                        if (isValid != true) {
                          return;
                        }
                        try {
                          await cliente.auth.signUp(
                              email: _emailController.text,
                              password: _passwordController.text);
                          avisar();
                          await insertarUsuario();
                        } catch (e) {
                          avisar1();
                        }
                      },
                      child: const Text("Enviar Datos"),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  avisar() {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text("Verificar Correo"),
      backgroundColor: Colors.redAccent,
    ));
  }

  avisar1() {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text("Fallo registro"),
      backgroundColor: Colors.redAccent,
    ));
  }

  insertarUsuario() async {
    //final String? _user = cliente.auth.currentUser!.email;
    try {
      await cliente.from('usuarios').insert({
        'email': _emailController.text,
        'password': _passwordController.text,
        'activo': false,
        'nombre': _nombreController.text,
        'apellidos': '',
        'superuser': false
      });
      //'fechanac':"",'fechainicio':"",
      // 'fechafinal':""
    } catch (e) {
      avisar2();
    }
    // como cerrar la base de datos
  }

  avisar2() {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text("Fallo registro en Tabla Usuarios"),
      backgroundColor: Colors.redAccent,
    ));
  }
}
