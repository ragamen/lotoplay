import 'package:lotoplay/helper/common.dart';
import 'package:lotoplay/models_sp/apuesta_franquicia.dart';

class ApuestaFranquiciaHelper {
  static Future<List<ApuestaFranquicia>> getApuestasGenerales() async {
    final response = await cliente.from('apuestafranquicia').select();

    if (response.error != null) {
      throw response.error!;
    }

    final data = response.data as List<dynamic>;

    return data.map((item) {
      return ApuestaFranquicia(
        codigofranquicia: item['codigofranquicia'] as String,
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

  static Future<void> createApuestaFranquicia(
      ApuestaFranquicia apuestaFranquicia) async {
    final response = await cliente.from('apuestaFranquicia').insert([
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

    if (response.error != null) {
      throw response.error!;
    }
  }

  static Future<List<ApuestaFranquicia>> getApuestasFranquicias(ticket) async {
    final response = await cliente
        .from('apuestageneral')
        .select()
        .eq('fecha', ticket.fecha)
        .eq('loteria', ticket.loteria)
        .eq('sorteo', ticket.sorteo)
        .eq('numero', ticket.numero);

    final data = response.data as List<dynamic>;
    return data.map((item) {
      return ApuestaFranquicia(
        codigofranquicia: item['codigofranquicia'] as String,
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
      var apuestafranquicia = ApuestaFranquicia(
        codigofranquicia: ticket.codigofranquicia,
        fecha: ticket.fecha,
        loteria: ticket.loteria,
        sorteo: ticket.sorteo,
        numero: ticket.numero,
        jugada: ticket.jugada,
        maximo: ticket.maximo,
        premio: ticket.premio,
        activo: ticket.activo,
      );
      createApuestaFranquicia(apuestafranquicia);
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
      var apuestafranquicia = ApuestaFranquicia(
        codigofranquicia: ticket.codigofranquicia,
        fecha: ticket.fecha,
        loteria: ticket.loteria,
        sorteo: ticket.sorteo,
        numero: ticket.numero,
        jugada: ticket.jugada + data[0].jugada.jugada,
        maximo: data[0].maximo,
        premio: data[0].premio,
        activo: data[0].activo,
      );
      updateApuestaFranquicia(apuestafranquicia);
    }
  }

  static Future<void> deleteApuestaFranquicia(String codigofranquicia,
      String fecha, String loteria, String sorteo, String numero) async {
    // ignore: unused_local_variable
    final response = await cliente
        .from('apuestaFranquicia')
        .delete()
        .eq('codigofranquicia', codigofranquicia)
        .eq('fecha', fecha)
        .eq('loteria', loteria)
        .eq('sorteo', sorteo)
        .eq('numero', numero);
  }

  static Future<void> updateApuestaFranquicia(
      ApuestaFranquicia apuestaFranquicia) async {
    // ignore: unused_local_variable
    final response = await cliente
        .from('apuestaFranquicia')
        .update({
          'jugada': apuestaFranquicia.jugada,
          'maximo': apuestaFranquicia.maximo,
        })
        .eq('fecha', apuestaFranquicia.fecha)
        .eq('loteria', apuestaFranquicia.loteria)
        .eq('sorteo', apuestaFranquicia.sorteo)
        .eq('numero', apuestaFranquicia.numero);
  }
}
