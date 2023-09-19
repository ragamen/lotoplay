import 'package:lotoplay/helper/common.dart';
import 'package:lotoplay/models_sp/apuesta_agencia.dart';

class ApuestaAgenciaHelper {
  static Future<List<ApuestaAgencia>> getApuestasGenerales() async {
    final response = await cliente.from('apuestaagencia').select();

    if (response.error != null) {
      throw response.error!;
    }

    final data = response.data as List<dynamic>;

    return data.map((item) {
      return ApuestaAgencia(
        codigoagencia: item['codigoagencia'] as String,
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

  static Future<void> createApuestaAgencia(
      ApuestaAgencia apuestaAgencia) async {
    final response = await cliente.from('apuestaAgencia').insert([
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

    if (response.error != null) {
      throw response.error!;
    }
  }

  static Future<List<ApuestaAgencia>> getApuestasAgencias(ticket) async {
    final response = await cliente
        .from('apuestageneral')
        .select()
        .eq('fecha', ticket.fecha)
        .eq('loteria', ticket.loteria)
        .eq('sorteo', ticket.sorteo)
        .eq('numero', ticket.numero);

    final data = response.data as List<dynamic>;
    return data.map((item) {
      return ApuestaAgencia(
        codigoagencia: item['codigoagencia'] as String,
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
      var apuestaagencia = ApuestaAgencia(
        codigoagencia: ticket.codigoagencia,
        fecha: ticket.fecha,
        loteria: ticket.loteria,
        sorteo: ticket.sorteo,
        numero: ticket.numero,
        jugada: ticket.jugada,
        maximo: ticket.maximo,
        premio: ticket.premio,
        activo: ticket.activo,
      );
      createApuestaAgencia(apuestaagencia);
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
      var apuestaagencia = ApuestaAgencia(
        codigoagencia: ticket.codigoagencia,
        fecha: ticket.fecha,
        loteria: ticket.loteria,
        sorteo: ticket.sorteo,
        numero: ticket.numero,
        jugada: ticket.jugada + data[0].jugada.jugada,
        maximo: data[0].maximo,
        premio: data[0].premio,
        activo: data[0].activo,
      );
      updateApuestaAgencia(apuestaagencia);
    }
  }

  static Future<void> deleteApuestaAgencia(String codigoagencia, String fecha,
      String loteria, String sorteo, String numero) async {
    // ignore: unused_local_variable
    final response = await cliente
        .from('apuestaAgencia')
        .delete()
        .eq('codigoagencia', codigoagencia)
        .eq('fecha', fecha)
        .eq('loteria', loteria)
        .eq('sorteo', sorteo)
        .eq('numero', numero);
  }

  static Future<void> updateApuestaAgencia(
      ApuestaAgencia apuestaAgencia) async {
    // ignore: unused_local_variable
    final response = await cliente
        .from('apuestaAgencia')
        .update({
          'jugada': apuestaAgencia.jugada,
          'maximo': apuestaAgencia.maximo,
        })
        .eq('fecha', apuestaAgencia.fecha)
        .eq('loteria', apuestaAgencia.loteria)
        .eq('sorteo', apuestaAgencia.sorteo)
        .eq('numero', apuestaAgencia.numero);
  }
}
