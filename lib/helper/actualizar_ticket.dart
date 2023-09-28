import 'package:lotoplay/helper/common.dart';

class ActualizarTicketHelper {
  static Future<void> actualizar(ticket) async {
//
//  Registra el ticket
//
    await cliente.from('tickets').insert([
      {
        'codigoagencia': ticket.codigoagencia,
        'correousuario': ticket.correousuario,
        'nroticket': ticket.nroticket,
        'serial': ticket.serial,
        'fecha': ticket.fecha,
        'hora': ticket.hora,
        'loteria': ticket.loteria,
        'sorteo': ticket.sorteo,
        'numero': ticket.numero,
        'monto': ticket.monto,
      }
    ]);
  }
}
