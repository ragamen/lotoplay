import 'package:esc_pos_printer/esc_pos_printer.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lotoplay/helper/actualizar_helper.dart';
import 'package:lotoplay/helper/common.dart';
import 'package:lotoplay/helper/rliminar_helper.dart';
import 'package:lotoplay/models/agencialista.dart';
import 'package:lotoplay/models/banquero.dart';
import 'package:lotoplay/models/draw.dart';
import 'package:lotoplay/models/lottery.dart';
import 'package:lotoplay/models/number.dart';
import 'package:lotoplay/models/purchase.dart';
import 'package:lotoplay/models/serialfactura.dart';
import 'package:lotoplay/models_sp/agencia.dart';
import 'package:lotoplay/models_sp/ticket.dart';
import 'package:lotoplay/utils/lotteries.dart';
import 'package:intl/intl.dart';
import 'package:usb_thermal_printer_web/usb_thermal_printer_web.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  @override
  // ignore: library_private_types_in_public_api
  _HomeScreenState createState() => _HomeScreenState();
}

TextEditingController purchaseAmountController = TextEditingController();

class _HomeScreenState extends State<HomeScreen> {
//  var a = Loterias.lotteries;
//  final printer = WebThermalPrinter();
  List<Purchase> purchases = [];
//  List<Agencia> agenciaActual = AgenciaActual.agenciaActual;
  Lottery? selectedLottery;
  Draw? selectedDraw;
  Number? selectedNumber;
  double purchaseAmount = 0.0;
  //List<Number> selectedNumbers = [];
  List<Lottery> selectedLotteries = [];
  List<Draw> selectedDraws = [];
  List<Number> selectedNumbers = [];
  late Ticket ticket;

// 9.00
  List<String> grupo1 = [
    'Lotto Activo',
    'Ruleta Activa',
    'Chance con Animalitos',
    'Selva Plus',
    'Jungla Millonaria',
  ];
//8.00
  List<String> grupo2 = [
    'La Granjita',
  ]; //9.10
  List<String> grupo3 = ['La Ricachona'];
  // 9.30
  List<String> grupo4 = ['Lotto Rey', 'Lotto Activo RD']; //75 numerosa
  List<String> grupo5 = [
    'Guacharo Activo',
  ];
  List<Draw> availableDraws = [];

  List<Draw> getAvailableDraws() {
    if (availableDraws.isEmpty) {
      // Realizar alguna acción o devolver un valor predeterminado si la lista está vacía
      return [];
    }

    final now = DateTime.now();
    DateTime fiveMinutesFromNow = now.subtract(const Duration(minutes: 5));
    final filteredDraws = availableDraws.where((draw) {
      final drawTime = DateTime(
        now.year,
        now.month,
        now.day,
        int.parse(draw.name.split(':')[0]),
        int.parse(draw.name.split(':')[1].split(' ')[0]),
      );
      return drawTime.isAfter(fiveMinutesFromNow);
    }).toList();

    return filteredDraws;
  }

  List<Lottery> getAvailableLotteries() {
    if (selectedLottery == null) {
      // Si no se ha seleccionado ninguna lotería, se muestran todas las opciones
      return Loterias.lotteries;
    } else {
      // Filtrar las loterías disponibles según el grupo de la lotería seleccionada
      if (grupo1.contains(selectedLottery?.name)) {
        return Loterias.lotteries
            .where((lottery) => grupo1.contains(lottery.name))
            .toList();
      } else if (grupo2.contains(selectedLottery?.name)) {
        return Loterias.lotteries
            .where((lottery) => grupo2.contains(lottery.name))
            .toList();
      } else if (grupo3.contains(selectedLottery?.name)) {
        return Loterias.lotteries
            .where((lottery) => grupo3.contains(lottery.name))
            .toList();
      } else if (grupo4.contains(selectedLottery?.name)) {
        return Loterias.lotteries
            .where((lottery) => grupo4.contains(lottery.name))
            .toList();
      } else if (grupo5.contains(selectedLottery?.name)) {
        return Loterias.lotteries
            .where((lottery) => grupo5.contains(lottery.name))
            .toList();
      } else {
        // Si la lotería seleccionada no pertenece a ningún grupo, no se muestran opciones adicionales
        return [selectedLottery!];
      }
    }
  }

  List<Lottery> availableLotteries = [];
  int serial = 0;
  int nroTicket = 0;
  String xfecha = '';
  String hora = '';
  String agencia = '';
  bool serialkeys = true;
  @override
  void initState() {
    super.initState();
    availableLotteries = getAvailableLotteries();
  }

  @override
  Widget build(BuildContext context) {
    if (serialkeys) {
      obtenerSerial(AgenciaActual.agenciaActual[0].codigoagencia);
      serial = SerialFactura.sfLista[0].sfserial;
      nroTicket = SerialFactura.sfLista[0].sfticket;
      if (kDebugMode) {
        print("TICKET  $nroTicket serial $serial");
      }
      serialkeys = false;
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ventas de Loterías'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Row(
              children: [
                Text(
                  'Lotería',
                  style: TextStyle(fontSize: 16.0),
                ),
                SizedBox(width: 205.0),
                Text(
                  'Sorteo',
                  style: TextStyle(fontSize: 16.0),
                ),
                SizedBox(width: 200.0),
                Text(
                  'Número',
                  style: TextStyle(fontSize: 16.0),
                ),
                SizedBox(width: 216.0),
                Text(
                  'Monto',
                  style: TextStyle(fontSize: 16.0),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: 200,
                      child: DropdownButton<Lottery>(
                        borderRadius:
                            const BorderRadius.all(Radius.elliptical(25, 25)),
                        value: selectedLottery,
                        onChanged: (Lottery? newValue) {
                          setState(() {
                            selectedDraw = null;
                            selectedNumber = null;
                            if (selectedLotteries.contains(newValue)) {
                              selectedLotteries.remove(newValue);
                            } else {
                              selectedLotteries.add(newValue!);
                            }
                            selectedLottery = newValue;
                            newValue?.isSelected = !newValue.isSelected;
                            // Actualizar availableLotteries después de seleccionar la primera lotería
                            availableDraws = selectedLottery!.draws;
//   OOOOJOOOOO                            availableDraws = getAvailableDraws();

                            availableLotteries = getAvailableLotteries();
//                            availableLotteries = availableLotteries
//                                .where((lottery) => lottery != newValue)
//                                .toList();
                          });
                        },
                        items: availableLotteries.map((Lottery lottery) {
                          return DropdownMenuItem<Lottery>(
                            value: lottery,
                            child: SizedBox(
                              width: 160,
                              child: ListTile(
                                title: Text(lottery.name),
                                trailing: lottery.isSelected
                                    ? const Icon(Icons.check)
                                    : null,
                                tileColor: lottery.isSelected
                                    ? Colors.grey[200]
                                    : null,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: 200,
                      // sorteos
                      child: DropdownButton<Draw>(
                        value: selectedDraw,
                        onChanged: (Draw? newValue) {
                          setState(() {
                            if (selectedDraws.contains(newValue)) {
                              selectedDraws.remove(newValue);
                            } else {
                              selectedDraws.add(newValue!);
                            }
                            selectedDraw = newValue;
                            newValue?.isSelected = !newValue.isSelected;
                          });
                        },
                        items: selectedLottery != null
                            ? availableDraws.map((Draw draw) {
                                return DropdownMenuItem<Draw>(
                                  value: draw,
                                  child: SizedBox(
                                    width: 200,
                                    child: ListTile(
                                      title: Text(draw.name),
                                      trailing: draw.isSelected
                                          ? const Icon(Icons.check)
                                          : null,
                                      tileColor: draw.isSelected
                                          ? const Color.fromARGB(
                                              255, 208, 206, 206)
                                          : null,
                                    ),
                                  ),
                                );
                              }).toList()
                            : [],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
// Numeros
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: 200,
                      child: DropdownButton<Number>(
                        value: selectedNumber,
                        onChanged: (Number? newValue) {
                          setState(() {
                            if (selectedNumbers.contains(newValue)) {
                              selectedNumbers.remove(newValue);
                            } else {
                              selectedNumbers.add(newValue!);
                            }
                            selectedNumber = newValue;
                            newValue?.isSelected = !newValue.isSelected;
                          });
                        },
                        items: selectedDraw != null
                            ? selectedDraw?.numbers.map((Number number) {
                                return DropdownMenuItem<Number>(
                                  value: number,
                                  child: SizedBox(
                                    width: 200,
                                    child: ListTile(
                                      title: Text(number.value.toString()),
                                      trailing: number.isSelected
                                          ? const Icon(Icons.check)
                                          : null,
                                      tileColor: number.isSelected
                                          ? Colors.grey[200]
                                          : null,
                                    ),
                                  ),
                                );
                              }).toList()
                            : [],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: 200,
                      child: TextFormField(
                        controller: purchaseAmountController,
                        onChanged: (value) {
                          setState(() {
                            purchaseAmount = double.parse(value);
                          });
                        },
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                for (Lottery lottery in selectedLotteries) {
                  for (Draw draw in selectedDraws) {
                    for (Number number in selectedNumbers) {
                      Purchase purchase = Purchase(
                        lottery: lottery,
                        draw: draw,
                        number: number,
                        amount: purchaseAmount,
                      );
/*                      if (kDebugMode) {
                        print(
                            'Ticket1 : ${SerialFactura.sfLista[0].sfticket}Serial1 :${SerialFactura.sfLista[0].sfserial}');
                      }
                      if (kDebugMode) {
                        print('Ticket2 : ${nroTicket}Serial2 :$serial');
                      }
*/
                      final xxfecha = DateTime.now();
                      final formato = DateFormat('dd/MM/yyyy');
                      final fechaFormateada = formato.format(xxfecha);
                      xfecha = fechaFormateada;
                      String formattedTime = DateFormat.Hms().format(xxfecha);
                      hora = formattedTime;
                      agencia = AgenciaActual.agenciaActual[0].nombreagencia;
                      ticket = Ticket(
                          codigoagencia:
                              AgenciaActual.agenciaActual[0].codigoagencia,
                          nombreagencia:
                              AgenciaActual.agenciaActual[0].nombreagencia,
                          correousuario: AgenciaActual.agenciaActual[0].correo,
                          nroticket:
                              SerialFactura.sfLista[0].sfticket.toString(),
                          serial: SerialFactura.sfLista[0].sfserial.toString(),
                          fecha: xfecha,
                          hora: formattedTime,
                          loteria: lottery.name,
                          sorteo: draw.name,
                          numero: number.value,
                          monto: purchaseAmount);

                      ActualizarHelper.actualizar(ticket);
                      setState(() {
                        purchases.add(purchase);
                      });
                    }
                  }
                }
                for (Lottery lottery in selectedLotteries) {
                  lottery.isSelected = false;
                }

                for (Draw draw in selectedDraws) {
                  draw.isSelected = false;
                }

                for (Number number in selectedNumbers) {
                  number.isSelected = false;
                }
                setState(() {
                  selectedLotteries = [];
                  selectedDraws = [];
                  selectedNumbers = [];
                  selectedLottery = null;
                  selectedDraw = null;
                  selectedNumber = null;
                  availableLotteries = getAvailableLotteries();
                  purchaseAmount = 0.0;
                  purchaseAmountController.text = '0.0';
                  purchaseAmountController.clear();
                });
              },
              child: const Text('Agregar a la lista de compras'),
            ),
            const SizedBox(height: 16.0),
            Expanded(
              child: PurchaseList(
                purchases: purchases,
                nroticket: nroTicket.toString(),
                serial: serial.toString(),
                fecha: xfecha,
                onDelete: (int index) {
                  setState(() {
                    purchases.removeAt(index);

                    // DISMINUIR los valores vendidos en ApuestaAgencia y apuestaGeneral
                  });
                },
              ),
            ),
            const SizedBox(height: 16.0),
            Text(
              'Monto total: ${calculateTotalAmount().toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 16.0),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                imprimirLista(
                    purchases, nroTicket, serial, agencia, xfecha, hora);
                setState(() {
                  purchases.clear();
                  serialkeys = true;
                });
                // Lógica para enviar a impresión
              },
              child: const Text('Enviar a impresión'),
            ),
          ],
        ),
      ),
    );
  }

  double calculateTotalAmount() {
    double totalAmount = 0.0;
    for (Purchase purchase in purchases) {
      totalAmount += purchase.amount;
    }
    return totalAmount; // * selectedNumbers.length;
  }
}

void obtenerSerial(codagencia) async {
  final response = await cliente
      .from('agencias')
      .select(
          'codigoagencia,nombreagencia,direccion,correo,banco,telefono,cedulaadmin,cupo,comision,nroticket')
      .eq('codigoagencia', codagencia);
  var data1 = response.map((item) {
    return Agencia(
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
  int numeroTicket = data1[0].nroticket + 1;
  await cliente.from('agencias').update({
    'nroticket': numeroTicket,
  }).eq('codigoagencia', codagencia);
  SerialFactura.sfLista[0].sfticket = numeroTicket;

  final response1 = await cliente.from('banquero').select(
      'email,nombre,maximoanimal,maxterminal,maxtriple,maxtripleta,serial');
  int count = response1.length;

  List<Banquero> data = [];
  for (int i = 0; i < count; i++) {
    data.add(Banquero.fromMap(response1[i]));
  }
  int nroSerial = data[0].serial + 1;
  await cliente
      .from('banquero')
      .update({'serial': nroSerial}).eq('email', data[0].email);
  SerialFactura.sfLista[0].sfserial = nroSerial;
}

class PurchaseList extends StatelessWidget {
  final List<Purchase> purchases;
  final String nroticket;
  final String serial;
  final String fecha;

  final void Function(int) onDelete;
  const PurchaseList({
    Key? key,
    required this.purchases,
    required this.nroticket,
    required this.serial,
    required this.fecha,
    required this.onDelete,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: purchases.length,
      itemBuilder: (context, index) {
        final purchase = purchases[index];
        return SizedBox(
          width: 200,
          child: ListTile(
            title: Text('${purchase.lottery.name}  ${purchase.number.value}'),
            subtitle: Text('${purchase.draw.name} Monto  ${purchase.amount}'),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                final ticket = Ticket(
                  codigoagencia: AgenciaActual.agenciaActual[0].codigoagencia,
                  nombreagencia: AgenciaActual.agenciaActual[0].nombreagencia,
                  correousuario: AgenciaActual.agenciaActual[0].correo,
                  nroticket: nroticket,
                  serial: serial,
                  fecha: fecha,
                  hora: '', //purchase.hora,
                  loteria: purchase.lottery.name,
                  sorteo: purchase.draw.name,
                  numero: purchase.number.value,
                  monto: purchase.amount,
                );
                EliminarHelper.actualizar(ticket);
                onDelete(index);
              },
            ),
          ),
        );
      },
    );
  }
}

void imprimirLista(purchases, nroticket, serial, agencia, fecha, hora) async {
  final printer = WebThermalPrinter();

  // Conectar a la impresora
  await printer.pairDevice(vendorId: 6868, productId: 0200);

  // Configurar estilos de impresión
  await printer.printText("", bold: true, centerAlign: true);
  // printer.;

  // Imprimir encabezado
  await printer.printText('Agencia : $agencia');
  await printer.printText('Ticket $nroticket Serial $serial');
  await printer.printText('fecha $fecha Hora $hora');

  // Iterar sobre tu lista de nombres y direcciones
  int maxLineLength = 20; // Ancho máximo del ticket
  double total = 0.0;
  for (var purchase in purchases) {
    String line = "Loteria ${purchase.lottery} ";
    if (line.length > maxLineLength) {
      line = line.substring(0, maxLineLength); // Ajustar la longitud máxima
    }
    String line0 = "${purchase.draw} ${purchase.number} ${purchase.amount}";
    if (line0.length > maxLineLength) {
      line0 = line0.substring(0, maxLineLength); // Ajustar la longitud máxima
    }
    total = total + purchase.amount;
    await printer.printText(line);
    await printer.printText(line0);
  }
  await printer.printEmptyLine();
  await printer.printText('Total Bs. $total');

  // Cortar papel
  await printer.printText('Gracias por su compra.');
  await printer.printText('!!!!!!!!Suerte!!!!!!!!');

  await printer.printText('Vence a los tres dias');

  await printer.printEmptyLine();
//  printer.cut();

  // Desconectar de la impresora
  await printer.closePrinter();
}
/*

void imprimirLista(purchases, nroticket, serial, agencia, fecha, hora) async {
//const PaperSize paper = PaperSize.mm80;
  const PaperSize paper = PaperSize.mm80;
  final profile = await CapabilityProfile.load();
  final printer = NetworkPrinter(paper, profile);
  final PosPrintResult res = await printer.connect('192.168.0.123', port: 9100);
  if (res == PosPrintResult.success) {
    printer.text('¡Hola, mundo!');
    printer.feed(2);
    printer.cut();
    printer.disconnect();
  }
}
*/