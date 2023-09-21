class Banquero {
  String email;
  String nombre;
  double maximoanimal;
  double maxterminal;
  double maxtriple;
  double maxtripleta;
  int serial;

  Banquero({
    required this.email,
    required this.nombre,
    required this.maximoanimal,
    required this.maxterminal,
    required this.maxtriple,
    required this.maxtripleta,
    required this.serial,
  });
  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'nombre': nombre,
      'maximoanimal': maximoanimal,
      'maxterminal': maxterminal,
      'maxtriple': maxtriple,
      'maxtripleta': maxtripleta,
      'serial': serial
    };
  }

  Banquero.fromMap(Map<String, dynamic> map)
      : email = map["email"],
        nombre = map["nombre"],
        maximoanimal = map["maximoanimal"],
        maxterminal = map["maxterminal"],
        maxtriple = map["maxtriple"],
        maxtripleta = map["maxtripleta"],
        serial = map["serial"];
}
