import 'package:lotoplay/helper/common.dart';
import 'package:lotoplay/models/agencialista.dart';
import 'package:lotoplay/models_sp/agencia.dart';

class AgenciaHelper {
  static Future<List<Agencia>> getAgencias(String codagencia) async {
    final response = await cliente
        .from('agencias')
        .select(
            'codigofranquicia,codigoagencia,nombreagencia,direccion,banco,telefono,cedulaadmin,cupo,comision,nroticket,serial')
        .eq('codigoagencia', codagencia);
    return AgenciaActual.agenciaActual = response.map((item) {
      return Agencia(
        codigofranquicia: item['codigofranquicia'] as String,
        codigoagencia: item['codigoagencia'] as String,
        nombreagencia: item['nombreagencia'] as String,
        direccion: item['direccion'] as String,
        correo: item['correo'] as String,
        banco: item['banco'] as String,
        telefono: item['telefono'] as String,
        cedulaadmin: item['cedulaadmin'] as String,
        cupo: item['cupo'] as double,
        comision: item['comision'] as double,
        nroticket: item['nroticket'] as int,
      );
    }).toList();
  }

  static Future<void> createAgencia(Agencia agencia) async {
    await cliente.from('agencia').insert([
      {
        'codigoagencia': agencia.codigoagencia,
        'codigofranquicia': agencia.codigofranquicia,
        'nombreagencia': agencia.nombreagencia,
        'direccion': agencia.direccion,
        'correo': agencia.correo,
        'banco': agencia.banco,
        'telefono': agencia.telefono,
        'cedulaadmin': agencia.cedulaadmin,
        'cupo': agencia.cupo,
        'comision': agencia.comision,
        'nroticket': agencia.nroticket,
      }
    ]);

    /* if (response.error != null) {
      throw response.error!;
    }*/
  }

  static Future<void> deleteAgencia(String codigoagencia) async {
    final response = await cliente
        .from('agencia')
        .delete()
        .eq('codigoagencia', codigoagencia);
    if (response.error != null) {
      throw response.error!;
    }
  }

  static Future<void> updateAgencia(Agencia agencia) async {
    // ignore: unused_local_variable
    final response = await cliente.from('agencia').update({
      'nombreagencia': agencia.nombreagencia,
      'direccion': agencia.direccion,
      'correo': agencia.correo,
      'banco': agencia.banco,
      'telefono': agencia.telefono,
      'cedulaadmin': agencia.cedulaadmin,
      'cupo': agencia.cupo,
      'comision': agencia.comision,
      'nroticket': agencia.nroticket,
    }).eq('codigoagencia', agencia.codigoagencia);
  }
}
