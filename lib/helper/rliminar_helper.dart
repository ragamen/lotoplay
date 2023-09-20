import 'package:lotoplay/helper/common.dart';
import 'package:lotoplay/models_sp/apuesta_agencia.dart';
import 'package:lotoplay/models_sp/apuesta_general.dart';

class EliminarHelper {
  static Future<void> actualizar(ticket) async {
    final response = await cliente
        .from('apuestageneral')
        .select()
        .eq('fecha', ticket.fecha)
        .eq('loteria', ticket.loteria)
        .eq('sorteo', ticket.sorteo)
        .eq('numero', ticket.numero);
    int count = response.length;
    List<ApuestaGeneral> data = [];
    for (int i = 0; i < count; i++) {
      data.add(ApuestaGeneral.fromMap(response[i]));
    }
    // ignore: dead_code
    if (data.isNotEmpty) {
      var resultado = double.parse(data[0].jugada) - ticket.monto;
      var apuestaGeneral = ApuestaGeneral(
        fecha: ticket.fecha,
        loteria: ticket.loteria,
        sorteo: ticket.sorteo,
        numero: ticket.numero,
        jugada: resultado.toString(),
        maximo: data[0].maximo,
        premio: data[0].premio,
        activo: data[0].activo,
      );
      await cliente
          .from('apuestageneral')
          .update({
            'jugada': apuestaGeneral.jugada,
          })
          .eq('fecha', apuestaGeneral.fecha)
          .eq('loteria', apuestaGeneral.loteria)
          .eq('sorteo', apuestaGeneral.sorteo)
          .eq('numero', apuestaGeneral.numero);
    }
//
// Actualizar Apuesta Agencia
//
    final response1 = await cliente
        .from('apuestaagencia')
        .select()
        .eq('codigoagencia', ticket.codigoagencia)
        .eq('fecha', ticket.fecha)
        .eq('loteria', ticket.loteria)
        .eq('sorteo', ticket.sorteo)
        .eq('numero', ticket.numero);
    count = response1.length;
    List<ApuestaGeneral> data1 = [];
    for (int i = 0; i < count; i++) {
      data1.add(ApuestaGeneral.fromMap(response1[i]));
    }
    // ignore: dead_code
    if (data1.isNotEmpty) {
      var resultado = double.parse(data1[0].jugada) - ticket.monto;
      var apuestaAgencia = ApuestaAgencia(
        codigoagencia: ticket.codigoagencia,
        fecha: ticket.fecha,
        loteria: ticket.loteria,
        sorteo: ticket.sorteo,
        numero: ticket.numero,
        jugada: resultado.toString(),
        maximo: data1[0].maximo.toString(),
        premio: data1[0].premio.toString(),
        activo: data1[0].activo,
      );
      await cliente
          .from('apuestaagencia')
          .update({
            'jugada': apuestaAgencia.jugada,
          })
          .eq('codigoagencia', apuestaAgencia.codigoagencia)
          .eq('fecha', apuestaAgencia.fecha)
          .eq('loteria', apuestaAgencia.loteria)
          .eq('sorteo', apuestaAgencia.sorteo)
          .eq('numero', apuestaAgencia.numero);
    }
//
//  Registra el ticket
//.eq('codigoagencia', codigoagencia)
    await cliente
        .from('tickets')
        .delete()
        .eq('nroticket', ticket.nroticket)
        .eq('serial', ticket.serial)
        .eq('fecha', ticket.fecha)
        .eq('loteria', ticket.loteria)
        .eq('sorteo', ticket.sorteo)
        .eq('numero', ticket.numero);
  }
}
