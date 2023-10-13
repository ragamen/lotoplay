import 'package:lotoplay/helper/common.dart';
import 'package:lotoplay/models_sp/ticket.dart';

class TicketsHelper {
  static Future<List<Ticket>> getTickets() async {
    final response = await cliente.from('Tickets').select();

/*
    if (response.error != null) {
      throw response.error!;
    }

    final data = response.data as List<dynamic>;
*/
    return response.map((item) {
      return Ticket(
        codigofranquicia: item['codigofranquicia'] as String,
        codigoagencia: item['codigoagencia'] as String,
        nombreagencia: item['codigoagencia'] as String,
        correousuario: item['taquilla'] as String,
        nroticket: item['nroticket'] as String,
        serial: item['serial'] as String,
        fecha: item['fecha'] as String,
        hora: item['hora'] as String,
        loteria: item['loteria'] as String,
        sorteo: item['sorteo'] as String,
        numero: item['numero'] as String,
        monto: item['monto'] as double,
      );
    }).toList();
  }

  static Future<void> createTicket(Ticket ticket) async {
    // ignore: unused_local_variable
    final response = await cliente.from('tickets').insert([
      {
        'codigofranquicia': ticket.codigofranquicia,
        'codigoagencia': ticket.codigoagencia,
        'nombreagencia': ticket.nombreagencia,
        'taquilla': ticket.correousuario,
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

  static Future<void> deleteTicket(
    String codigofranquicia,
    String codigoagencia,
    String nombreagencia,
    String correousuario,
    String nroticket,
    String fecha,
    String hora,
    String loteria,
    String sorteo,
    String numero,
  ) async {
    final response = await cliente
        .from('ticket')
        .delete()
        .eq('codigofranquicia', codigofranquicia)
        .eq('codigoagencia', codigoagencia)
        .eq('nombreagencia', nombreagencia)
        .eq('taquilla', correousuario)
        .eq('nroticket', nroticket)
        .eq('fecha', fecha)
        .eq('loteria', loteria)
        .eq('sorteo', sorteo)
        .eq('numero', numero);
    if (response.error != null) {
      throw response.error!;
    }
  }

  static Future<void> updateTicket(Ticket ticket) async {
    final response = await cliente.from('ticket').update({
      'nroTicket': ticket.nroticket,
    }).eq('codigoTicket', ticket.nroticket);

    if (response.error != null) {
      throw response.error!;
    }
  }
}
