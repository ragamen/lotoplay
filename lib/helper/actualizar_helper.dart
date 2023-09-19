import 'package:lotoplay/helper/common.dart';
import 'package:lotoplay/models_sp/apuesta_agencia.dart';
import 'package:lotoplay/models_sp/apuesta_general.dart';

class ActualizarHelper {
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
    if (data.isEmpty) {
      var apuestaGeneral = ApuestaGeneral(
        fecha: ticket.fecha,
        loteria: ticket.loteria,
        sorteo: ticket.sorteo,
        numero: ticket.numero,
        jugada: ticket.monto.toString(),
        maximo: '0',
        premio: '0',
        activo: true,
      );

      await cliente.from('apuestageneral').insert([
        {
          'fecha': apuestaGeneral.fecha,
          'loteria': apuestaGeneral.loteria,
          'sorteo': apuestaGeneral.sorteo,
          'numero': apuestaGeneral.numero,
          'jugada': apuestaGeneral.jugada,
          'maximo': apuestaGeneral.maximo,
          'premio': apuestaGeneral.premio,
          'activo': apuestaGeneral.activo,
        }
      ]);
    } else {
      var njugada = double.parse(data[0].maximo) - double.parse(data[0].jugada);
      if (njugada >= ticket.monto) {
        ticket.monto = ticket.monto;
      }
      if (njugada < ticket.monto) {
        ticket.monto = njugada;
      }
      if (njugada <= 0) {
        ticket.monto = 0;
      }
      var resultado = ticket.monto + double.parse(data[0].jugada);
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
            'maximo': apuestaGeneral.maximo,
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
    if (data1.isEmpty) {
      var apuestaAgencia = ApuestaAgencia(
        codigoagencia: ticket.codigoagencia,
        fecha: ticket.fecha,
        loteria: ticket.loteria,
        sorteo: ticket.sorteo,
        numero: ticket.numero,
        jugada: ticket.monto.toString(),
        maximo: '0',
        premio: '0',
        activo: true,
      );

      await cliente.from('apuestaagencia').insert([
        {
          'codigoagencia': apuestaAgencia.codigoagencia,
          'fecha': apuestaAgencia.fecha,
          'loteria': apuestaAgencia.loteria,
          'sorteo': apuestaAgencia.sorteo,
          'numero': apuestaAgencia.numero,
          'jugada': apuestaAgencia.jugada,
          'maximo': apuestaAgencia.maximo,
          'premio': apuestaAgencia.premio,
          'activo': apuestaAgencia.activo,
        }
      ]);
    } else {
      var njugada =
          double.parse(data1[0].maximo) - double.parse(data1[0].jugada);
      if (njugada >= ticket.monto) {
        ticket.monto = ticket.monto;
      }
      if (njugada < ticket.monto) {
        ticket.monto = njugada;
      }
      if (njugada <= 0) {
        ticket.monto = 0;
      }
      var resultado = ticket.monto + double.parse(data1[0].jugada);
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
            'maximo': apuestaAgencia.maximo,
          })
          .eq('codigoagencia', apuestaAgencia.codigoagencia)
          .eq('fecha', apuestaAgencia.fecha)
          .eq('loteria', apuestaAgencia.loteria)
          .eq('sorteo', apuestaAgencia.sorteo)
          .eq('numero', apuestaAgencia.numero);
    }
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
