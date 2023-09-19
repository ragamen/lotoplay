import 'package:lotoplay/helper/common.dart';
import 'package:flutter/material.dart';
import 'package:lotoplay/helper/recuperar_clave.dart';
import 'package:lotoplay/helper/registrar_usuario.dart';

class StartPage extends StatefulWidget {
  const StartPage({super.key});

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  // bool _signInLoading = false;
  // bool _signUpLoading = false;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
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
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                //email
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Por favor completar Correo";
                      }
                      return null;
                    },
                    controller: _emailController,
                    decoration: const InputDecoration(
                      label: Text("Correo"),
                    ),
                  ),
                ),
                // password
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
                      label: Text("Clave"),
                    ),
                  ),
                ),
                //Sign in Bottom
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.amberAccent,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0xAA6EB1E6),
                          offset: Offset(9, 9),
                          blurRadius: 6,
                        ),
                      ],
                    ),
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
                          await cliente.auth.signInWithPassword(
                              email: _emailController.text,
                              password: _passwordController.text);
                        } catch (e) {
                          avisar();
                        }
                      },
                      child: const Text("Ingresar"),
                    ),
                  ),
                ),
                //Sign Up Botton
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 5),
                      child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const RegistrarUsuario()),
                            );
                          },
                          child: const Text(
                            "Registrate ?",
                            style: TextStyle(color: Colors.white),
                          )),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 5),
                      child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const RecuperarClave()),
                            );
                          },
                          child: const Text(
                            "Olvidaste Clave?",
                            style: TextStyle(color: Colors.white),
                          )),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  avisar() {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text("Fallo ingreso"),
      backgroundColor: Colors.redAccent,
    ));
  }
}
