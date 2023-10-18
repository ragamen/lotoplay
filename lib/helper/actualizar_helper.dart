import 'package:lotoplay/helper/common.dart';
import 'package:lotoplay/models_sp/apuesta_agencia.dart';
import 'package:lotoplay/models_sp/apuesta_franquicia.dart';
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
// Actualizar ApuestaFraquicia
//

    final response1 = await cliente
        .from('apuestafranquicia')
        .select()
        .eq('codigofranquicia', ticket.codigofranquicia)
        .eq('fecha', ticket.fecha)
        .eq('loteria', ticket.loteria)
        .eq('sorteo', ticket.sorteo)
        .eq('numero', ticket.numero);
    count = response1.length;
    List<ApuestaFranquicia> data1 = [];
    for (int i = 0; i < count; i++) {
      data1.add(ApuestaFranquicia.fromMap(response1[i]));
    }
    // ignore: dead_code
    if (data1.isEmpty) {
      var apuestaFranquicia = ApuestaFranquicia(
        codigofranquicia: ticket.codigofranquicia,
        fecha: ticket.fecha,
        loteria: ticket.loteria,
        sorteo: ticket.sorteo,
        numero: ticket.numero,
        jugada: ticket.monto.toString(),
        maximo: '0',
        premio: '0',
        activo: true,
      );

      await cliente.from('apuestafranquicia').insert([
        {
          'codigofranquicia': apuestaFranquicia.codigofranquicia,
          'fecha': apuestaFranquicia.fecha,
          'loteria': apuestaFranquicia.loteria,
          'sorteo': apuestaFranquicia.sorteo,
          'numero': apuestaFranquicia.numero,
          'jugada': apuestaFranquicia.jugada,
          'maximo': apuestaFranquicia.maximo,
          'premio': apuestaFranquicia.premio,
          'activo': apuestaFranquicia.activo,
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
      var apuestaFranquicia = ApuestaFranquicia(
        codigofranquicia: ticket.codigofranquicia,
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
          .from('apuestafranquicia')
          .update({
            'jugada': apuestaFranquicia.jugada,
            'maximo': apuestaFranquicia.maximo,
          })
          .eq('codigofranquicia', apuestaFranquicia.codigofranquicia)
          .eq('fecha', apuestaFranquicia.fecha)
          .eq('loteria', apuestaFranquicia.loteria)
          .eq('sorteo', apuestaFranquicia.sorteo)
          .eq('numero', apuestaFranquicia.numero);
    }

//
// Actualizar Apuesta Agencia
//
    final response2 = await cliente
        .from('apuestaagencia')
        .select()
        .eq('codigoagencia', ticket.codigoagencia)
        .eq('fecha', ticket.fecha)
        .eq('loteria', ticket.loteria)
        .eq('sorteo', ticket.sorteo)
        .eq('numero', ticket.numero);
    count = response2.length;
    List<ApuestaAgencia> data2 = [];
    for (int i = 0; i < count; i++) {
      data2.add(ApuestaAgencia.fromMap(response2[i]));
    }
    // ignore: dead_code
    if (data2.isEmpty) {
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
          double.parse(data2[0].maximo) - double.parse(data2[0].jugada);
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
  }
}
