class ApuestaAgencia {
  String codigoagencia;
  String fecha;
  String loteria;
  String sorteo;
  String numero;
  String jugada;
  String maximo;
  String premio;
  bool activo;
  ApuestaAgencia({
    required this.codigoagencia,
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
      'agencia': codigoagencia,
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

  ApuestaAgencia.fromMap(Map<String, dynamic> map)
      : codigoagencia = map['codigoagencia'],
        fecha = map['fecha'],
        loteria = map["loteria"],
        sorteo = map['sorteo'],
        numero = map['sorteo'],
        jugada = map['jugada'],
        maximo = map['maximo'],
        premio = map['premio'],
        activo = map['activo'];
}
