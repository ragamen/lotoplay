import 'package:flutter/material.dart';
import 'package:lotoplay/helper/actualizar_helper.dart';
import 'package:lotoplay/helper/common.dart';
import 'package:lotoplay/models/agencialista.dart';
import 'package:lotoplay/models/banquero.dart';
import 'package:lotoplay/models/draw.dart';
import 'package:lotoplay/models/lottery.dart';
import 'package:lotoplay/models/number.dart';
import 'package:lotoplay/models/purchase.dart';
import 'package:lotoplay/models_sp/agencia.dart';
import 'package:lotoplay/models_sp/ticket.dart';
import 'package:lotoplay/utils/lotteries.dart';
import 'package:usb_thermal_printer_web/usb_thermal_printer_web.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  @override
  // ignore: library_private_types_in_public_api
  _HomeScreenState createState() => _HomeScreenState();
}

TextEditingController purchaseAmountController = TextEditingController();

class _HomeScreenState extends State<HomeScreen> {
//  var a = Loterias.lotteries;
  final printer = WebThermalPrinter();
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
  @override
  void initState() {
    super.initState();
    availableLotteries = getAvailableLotteries();
  }

  @override
  Widget build(BuildContext context) {
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
                      /*
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
                          });
                        },
                        items: Loterias.lotteries.map((Lottery lottery) {
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

                      */
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
                            ? selectedLottery?.draws.map((Draw draw) {
                                // Verificar si la hora del sorteo está dentro del rango
                                // bool isActive = // Lógica para verificar si la hora del sorteo está dentro del rango
                                var xhora = draw.name.substring(0, 2).trim();
                                var xminu = draw.name.substring(3, 5).trim();
//                                var xhora = draw.name.substring(0, 2).trim();
//var xminu = draw.name.substring(3, 5).trim();
                                String formattedTime =
                                    DateFormat.Hms().format(DateTime.now());
                                var xhora1 =
                                    formattedTime.substring(0, 1).trim();
                                var xminu1 =
                                    formattedTime.substring(3, 5).trim();
                                int tiempo1 = 0;
                                if (int.parse(xhora) > 1 &&
                                    int.parse(xhora) < 7) {
                                  tiempo1 = (int.parse(xhora) + 12) * 60 +
                                      int.parse(xminu);
                                } else {
                                  tiempo1 =
                                      int.parse(xhora) * 60 + int.parse(xminu);
                                }
                                var tiempo2 =
                                    int.parse(xhora1) * 60 + int.parse(xminu1);
                                if ((tiempo1 - tiempo2) < 5) {
                                  draw.isActive = true;
                                }
                                print(
                                    'hora1 $xhora $draw.name.toString()  $tiempo1');
                                print('hora2  $formattedTime  $tiempo2');

                                return DropdownMenuItem<Draw>(
                                  value: draw,
                                  child: SizedBox(
                                    width: 200,
                                    child: ListTile(
                                      title: Text(draw.name),
                                      trailing: draw.isSelected
                                          ? const Icon(Icons.check)
                                          : null,
                                      tileColor: draw.isActive
                                          ? Color.fromARGB(255, 218, 10, 10)
                                          : null,
//                                      tileColor: draw.isSelected
//                                          ? Colors.grey[200]
//                                          : null,
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
                      final xxfecha = DateTime.now();
                      final formato = DateFormat('dd/MM/yyyy');
                      final fechaFormateada = formato.format(xxfecha);
                      var xfecha = fechaFormateada;
                      int nroSerial = 0;
                      int numeroTicket = 0;

                      obtenerSerial(
                          AgenciaActual.agenciaActual[0].codigoagencia,
                          nroSerial,
                          numeroTicket);
                      //   var correo = _user?.email;
                      String formattedTime = DateFormat.Hms().format(xxfecha);
                      ticket = Ticket(
                          codigoagencia:
                              AgenciaActual.agenciaActual[0].codigoagencia,
                          correousuario:
                              AgenciaActual.agenciaActual[0].correo, //correo!,
                          nroticket: numeroTicket.toString(),
                          serial: nroSerial.toString(),
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
                  //  selectedLottery = selectedLottery;
                  //  selectedDraw = selectedDraw;
                  selectedLottery = null;
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
                onDelete: (int index) {
                  setState(() {
                    purchases.removeAt(index);
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
                imprimirLista(purchases);
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

void obtenerSerial(codagencia, nroSerial, numeroTicket) async {
  final response = await cliente
      .from('agencias')
      .select(
          'codigoagencia,nombreagencia,direccion,banco,telefono,cedulaadmin,cupo,comision,nroticket,correo')
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

  final response1 = await cliente.from('banquero').select(
      'email,nombre,maximoanimal,maxterminal,maxtriple,maxtripleta,serial');
  int count = response1.length;

  List<Banquero> data = [];
  for (int i = 0; i < count; i++) {
    data.add(Banquero.fromMap(response1[i]));
  }
  int nroSerial = data[0].serial + 1;
  await cliente.from('banquero').update({'serial': nroSerial}).eq('id', 0);
}

class PurchaseList extends StatelessWidget {
  final List<Purchase> purchases;
  final void Function(int) onDelete;
  const PurchaseList({
    Key? key,
    required this.purchases,
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
              onPressed: () => onDelete(index),
            ),
          ),
        );
      },
    );
  }
}

void imprimirLista(purchases) async {
  final printer = WebThermalPrinter();

  // Conectar a la impresora
  await printer.pairDevice(vendorId: 0x6868, productId: 0x0200);

  // Configurar estilos de impresión
  await printer.printText("", bold: true, centerAlign: true);
  // printer.;

  // Imprimir encabezado
  await printer.printText('Lista de Usuarios');
  await printer.printText('Nombre');
  await printer.printText('Dirección');

  // Iterar sobre tu lista de nombres y direcciones
  for (var usuario in purchases) {
    await printer.printText(usuario.loteria);
    await printer.printText(usuario.sorteo);
  }

  // Cortar papel
  await printer.printEmptyLine();
//  printer.cut();

  // Desconectar de la impresora
  await printer.closePrinter();
}

/*
class PurchaseAmountFormField extends StatefulWidget {
  final void Function(double) onChanged;

  const PurchaseAmountFormField({Key? key, required this.onChanged})
      : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _PurchaseAmountFormFieldState createState() =>
      _PurchaseAmountFormFieldState();
}

class _PurchaseAmountFormFieldState extends State<PurchaseAmountFormField> {
  TextEditingController controller = TextEditingController();
  @override
  void initState() {
    super.initState();
    controller.clear();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 20,
      child: TextFormField(
        controller: controller,
        onChanged: (value) {
          widget.onChanged(double.parse(value));
        },
        keyboardType: TextInputType.number,
      ),
    );
  }
}
*/
