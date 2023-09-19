class Banquero {
  String nombre;
  double maximoanimal;
  double maxterminal;
  double maxtriple;
  double maxtripleta;
  int serial;

  Banquero({
    required this.nombre,
    required this.maximoanimal,
    required this.maxterminal,
    required this.maxtriple,
    required this.maxtripleta,
    required this.serial,
  });
  Map<String, dynamic> toMap() {
    return {
      'nombre': nombre,
      'maximoanimal': maximoanimal,
      'maxterminal': maxterminal,
      'maxtriple': maxtriple,
      'maxtripleta': maxtripleta,
      'serial': serial
    };
  }

  Banquero.fromMap(Map<String, dynamic> map)
      : nombre = map["nombre"],
        maximoanimal = map["maximoanimal"],
        maxterminal = map["maxterminal"],
        maxtriple = map["maxtriple"],
        maxtripleta = map["maxtripleta"],
        serial = map["serial"];
}
