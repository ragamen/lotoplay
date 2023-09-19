class Agencia {
  String codigoagencia;
  String nombreagencia;
  String direccion;
  String correo;
  String banco;
  String telefono;
  String cedulaadmin;
  double cupo;
  double comision;
  int nroticket;

  Agencia({
    required this.codigoagencia,
    required this.nombreagencia,
    required this.direccion,
    required this.correo,
    required this.banco,
    required this.telefono,
    required this.cedulaadmin,
    required this.cupo,
    required this.comision,
    required this.nroticket,
  });
  Map<String, dynamic> toMap() {
    return {
      'codigoagencia': codigoagencia,
      'nombreagencia': nombreagencia,
      'direccion': direccion,
      'correo': correo,
      'banco': banco,
      'telefono': telefono,
      'cedulaadmin': cedulaadmin,
      'cupo': cupo,
      'comision': comision,
      'nroticket': nroticket
    };
  }

  Agencia.fromMap(Map<String, dynamic> map)
      : codigoagencia = map["codigoagencia"],
        nombreagencia = map["nombreagencia"],
        direccion = map["direccion"],
        correo = map["correo"],
        banco = map["banco"],
        telefono = map["telefono"],
        cedulaadmin = map["cedulaadmin"],
        cupo = map["cupo"],
        comision = map["comision"],
        nroticket = map["nroticket"];
}
