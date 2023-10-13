class ApuestaFranquicia {
  String codigofranquicia;
  String fecha;
  String loteria;
  String sorteo;
  String numero;
  String jugada;
  String maximo;
  String premio;
  bool activo;
  ApuestaFranquicia({
    required this.codigofranquicia,
    required this.fecha,
    required this.loteria,
    required this.sorteo,
    required this.numero,
    required this.jugada,
    required this.maximo,
    required this.premio,
    required this.activo,
  });
  Map<String, dynamic> toMap() {
    return {
      'agencia': codigofranquicia,
      'fecha': fecha,
      'loteria': loteria,
      'sorteo': sorteo,
      'numero': numero,
      'jugada': jugada,
      'maximo': maximo,
      'premio': premio,
      'activo': activo,
    };
  }

  ApuestaFranquicia.fromMap(Map<String, dynamic> map)
      : codigofranquicia = map['codigofranquicia'],
        fecha = map['fecha'],
        loteria = map["loteria"],
        sorteo = map['sorteo'],
        numero = map['sorteo'],
        jugada = map['jugada'],
        maximo = map['maximo'],
        premio = map['premio'],
        activo = map['activo'];
}
