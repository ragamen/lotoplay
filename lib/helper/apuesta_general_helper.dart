import 'package:lotoplay/helper/common.dart';
import 'package:lotoplay/models_sp/apuesta_general.dart';

class ApuestaGeneralHelper {
  static Future<List<ApuestaGeneral>> getApuestasGeneral() async {
    final response = await cliente.from('apuestageneral').select();
    final data = response.data as List<dynamic>;
    return data.map((item) {
      return ApuestaGeneral(
        fecha: item['fecha'] as String,
        loteria: item['loteria'] as String,
        sorteo: item['sorteo'] as String,
        numero: item['numero'] as String,
        jugada: item['jugada'] as String,
        maximo: item['maximo'] as String,
        premio: item['premio'] as String,
        activo: item['activo'] as bool,
      );
    }).toList();
  }

  static Future<void> createApuestaGeneral(
      ApuestaGeneral apuestaGeneral) async {
    // ignore: unused_local_variable
    final response = await cliente.from('apuestageneral').insert([
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
  }

  static Future<List<ApuestaGeneral>> getApuestasGenerales(ticket) async {
    final response = await cliente
        .from('apuestageneral')
        .select()
        .eq('fecha', ticket.fecha)
        .eq('loteria', ticket.loteria)
        .eq('sorteo', ticket.sorteo)
        .eq('numero', ticket.numero);

    final data = response.data as List<dynamic>;
    return data.map((item) {
      return ApuestaGeneral(
        fecha: item['fecha'] as String,
        loteria: item['loteria'] as String,
        sorteo: item['sorteo'] as String,
        numero: item['numero'] as String,
        jugada: item['jugada'] as String,
        maximo: item['maximo'] as String,
        premio: item['premio'] as String,
        activo: item['activo'] as bool,
      );
    }).toList();
    // ignore: dead_code
    if (data.isEmpty) {
      var apuestageneral = ApuestaGeneral(
        fecha: ticket.fecha,
        loteria: ticket.loteria,
        sorteo: ticket.sorteo,
        numero: ticket.numero,
        jugada: ticket.jugada,
        maximo: ticket.maximo,
        premio: ticket.premio,
        activo: ticket.activo,
      );
      createApuestaGeneral(apuestageneral);
    } else {
      //
      // incrementa valor de la jugada en apuestageneral si
      //maximo - jugada es mayor o igual a jugada
      // si es menor coloca actualiza jugada en ticket e
      //incrementa la jugada
      //
      var njugada = data[0].maximo - data[0].jugada;
      if (njugada >= ticket.jugada) {
        ticket.jugada = ticket.jugada;
      }
      if (njugada < ticket.jugada) {
        ticket.jugada = njugada;
      }
      if (njugada <= 0) {
        ticket.jugada = 0;
      }
      var apuestageneral = ApuestaGeneral(
        fecha: ticket.fecha,
        loteria: ticket.loteria,
        sorteo: ticket.sorteo,
        numero: ticket.numero,
        jugada: ticket.jugada + data[0].jugada.jugada,
        maximo: data[0].maximo,
        premio: data[0].premio,
        activo: data[0].activo,
      );
      updateApuestaGeneral(apuestageneral);
    }
  }

  static Future<void> deleteApuestaGeneral(
      String fecha, String loteria, String sorteo, String numero) async {
    // ignore: unused_local_variable
    final response = await cliente
        .from('apuestageneral')
        .delete()
        .eq('fecha', fecha)
        .eq('loteria', loteria)
        .eq('sorteo', sorteo)
        .eq('numero', numero);
  }

  static Future<void> updateApuestaGeneral(
      ApuestaGeneral apuestaGeneral) async {
    // ignore: unused_local_variable
    final response = await cliente
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
}
