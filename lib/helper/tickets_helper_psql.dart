import 'package:flutter/foundation.dart';
import 'package:lotoplay/models_sp/ticket.dart';
import 'package:postgres/postgres.dart';

class TicketsHelperPsql {
  PostgreSQLConnection? _connection;
  Future<void> openConnection() async {
    _connection = PostgreSQLConnection('localhost', 5432, 'LOTERIAS',
        username: 'postgres', password: '12345678');
    await _connection!.open().then((value) {
      debugPrint("Database Connected!");
    });
    if (kDebugMode) {
      print("Luis Garcia conexion..$_connection");
    }
  }

//initDatabaseConnection() async {
//  databaseConnection.open().then((value) {
//    debugPrint("Database Connected!");
//  });
//}
  Future<List<Ticket>> getTicketsPsql() async {
    final results = await _connection!.query('SELECT * FROM tickets');
    var tickets = results.map((row) {
      return Ticket(
        codigoagencia: row[0],
        correousuario: row[1],
        nroticket: row[2],
        serial: row[3],
        fecha: row[4],
        hora: row[5],
        loteria: row[6],
        sorteo: row[7],
        numero: row[8],
        monto: row[9],
      );
    }).toList();
    return tickets;
  }

  Future<void> createTicketsPsql(Ticket ticket) async {
    await _connection!.open().then((value) {
      debugPrint("Database Connected!");
    });
    try {
      await _connection!.execute(
        'INSERT INTO tickets (agencia,nroticket,serial,fecha,hora, loteria,sorteo, numero,monto)'
        'VALUES (@agencia,@nroticket,(@serial,(@fecha,(@hora, @loteria, @sorteo, @numero, @monto)',
        substitutionValues: {
          'agencia': ticket.codigoagencia,
          'taquilla': ticket.correousuario,
          'nroTicket': ticket.nroticket,
          'serial': ticket.serial,
          'fecha': ticket.fecha,
          'hora': ticket.hora,
          'loteria': ticket.loteria,
          'sorteo': ticket.sorteo,
          'numero': ticket.numero,
          'monto': ticket.monto,
        },
      );
    } catch (e) {
      if (kDebugMode) {
        print('Luis Garcia Error $e');
      }
    }
  }

  Future<void> updateTicketsPsql(Ticket ticket) async {
    await _connection!.execute(
      'UPDATE tickets SET jugada = @jugada, maximo = @maximo WHERE fecha = @fecha AND loteria = @loteria AND sorteo = @sorteo AND numero = @numero',
      substitutionValues: {
        'agencia': ticket.codigoagencia,
        'taquilla': ticket.correousuario,
        'nroTicket': ticket.nroticket,
        'serial': ticket.serial,
        'fecha': ticket.fecha,
        'hora': ticket.hora,
        'loteria': ticket.loteria,
        'sorteo': ticket.sorteo,
        'numero': ticket.numero,
        'monto': ticket.monto,
      },
    );
  }

  Future<void> deleteTicketsPsql(Ticket ticket) async {
    await _connection!.execute(
      'DELETE FROM tickets WHERE fecha = @ticket.fecha AND loteria = @ticket.loteria AND sorteo = @ticket.sorteo AND numero = @ticket.numero',
      substitutionValues: {
        'agencia': ticket.codigoagencia,
        'taquilla': ticket.correousuario,
        'nroTicket': ticket.nroticket,
        'serial': ticket.serial,
        'fecha': ticket.fecha,
        'hora': ticket.hora,
        'loteria': ticket.loteria,
        'sorteo': ticket.sorteo,
        'numero': ticket.numero,
        'monto': ticket.monto,
      },
    );
  }

  Future<void> closeConnection() async {
    await _connection!.close();
  }
}
