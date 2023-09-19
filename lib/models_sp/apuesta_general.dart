class ApuestaGeneral {
  String fecha;
  String loteria;
  String sorteo;
  String numero;
  String jugada;
  String maximo;
  String premio;
  bool activo;

  ApuestaGeneral({
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
      'fecha': fecha,
      'loteria': loteria,
      'sorteo': sorteo,
      'numero': numero,
      'jugada': jugada,
      'maximo': maximo,
      'premio': premio,
      'activo': activo
    };
  }

  ApuestaGeneral.fromMap(Map<String, dynamic> map)
      : fecha = map['fecha'],
        loteria = map["loteria"],
        sorteo = map['sorteo'],
        numero = map['sorteo'],
        jugada = map['jugada'],
        maximo = map['maximo'],
        premio = map['premio'],
        activo = map['activo'];
}
