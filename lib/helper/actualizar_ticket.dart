import 'package:lotoplay/helper/common.dart';
import 'package:lotoplay/home_screen.dart';
import 'package:lotoplay/models/agencialista.dart';
import 'package:lotoplay/models/serialfactura.dart';

class ActualizarTicketHelper {
  static Future<void> actualizar(ticket) async {
//
//  Registra el ticket
//

    if (int.parse(ticket.nroticket) == 0) {
      await obtenerSerial(AgenciaActual.agenciaActual[0].codigoagencia);
      ticket.nroticket = SerialFactura.sfLista[0].sfticket.toString();
      ticket.serial = SerialFactura.sfLista[0].sfserial.toString();
    }
    if (int.parse(ticket.nroticket) != 0) {
      await cliente.from('tickets').insert([
        {
          'codigofranquicia': ticket.codigofranquicia,
          'codigoagencia': ticket.codigoagencia,
          'agencia': ticket.nombreagencia,
          'correousuario': ticket.correousuario,
          'nroticket': ticket.nroticket,
          'serial': ticket.serial,
          'fecha': ticket.fecha,
          'hora': ticket.hora,
          'loteria': ticket.loteria,
          'sorteo': ticket.sorteo,
          'numero': ticket.numero,
          'monto': ticket.monto,
          'premio': ticket.premio,
        }
      ]);
    }
  }
}
