// // // import 'package:flutter/material.dart';

// // // // import 'package:flutter_blue_plus/flutter_blue_plus.dart';
// // // import 'package:neitorcont/src/controllers/comprobantes_controller.dart';
// // // import 'package:pdf/pdf.dart';
// // // import 'package:provider/provider.dart';
// // // // import 'package:sunmi_printer_plus/sunmi_printer_plus.dart';
// // // import 'dart:typed_data'; // Importa esta biblioteca para utilizar Uint8List


// // // // class Prueba extends StatelessWidget {
// // // //   @override
// // // //   Widget build(BuildContext context) {
// // // //     final printerService = Provider.of<ComprobantesController>(context, listen: false);

// // // //     return Scaffold(
// // // //       appBar: AppBar(title: Text('Sunmi V2 Printer')),
// // // //       body: Center(
// // // //         child: ElevatedButton(
// // // //           onPressed: () async {
// // // //             printerService.printDocument();
// // // //           },
// // // //           child: Text('Print Text'),
// // // //         ),
// // // //       ),
// // // //     );
// // // //   }
// // // // }


// // // // ignore_for_file: public_member_api_docs, avoid_redundant_argument_values

// // // import 'dart:typed_data';

// // // import 'package:flutter/material.dart';
// // // import 'package:pdf/pdf.dart';
// // // import 'package:pdf/widgets.dart' as pw;
// // // import 'package:printing/printing.dart';

// // // // class Prueba extends StatelessWidget {




// // // //   @override
// // // //   Widget build(BuildContext context) {
// // // //     return MaterialApp(
// // // //       home: Scaffold(
// // // //         appBar: AppBar(title: Text('title')),
// // // //         body: PdfPreview(
// // // //           build: (format) => _generatePdf(format, 'title'),
// // // //         ),
// // // //       ),
// // // //     );
// // // //   }

// // // //   Future<Uint8List> _generatePdf(PdfPageFormat format, String title) async {
// // // //     final pdf = pw.Document(version: PdfVersion.pdf_1_5, compress: true);
// // // //     final font = await PdfGoogleFonts.nunitoExtraLight();

// // // //     pdf.addPage(
// // // //       pw.Page(
// // // //         pageFormat: format,
// // // //         build: (context) {
// // // //           return pw.Column(
// // // //             children: [
// // // //               pw.SizedBox(
// // // //                 width: double.infinity,
// // // //                 child: pw.FittedBox(
// // // //                   child: pw.Text(title, style: pw.TextStyle(font: font)),
// // // //                 ),
// // // //               ),
// // // //               pw.SizedBox(height: 20),
// // // //               pw.Flexible(child: pw.FlutterLogo()),
// // // //             ],
// // // //           );
// // // //         },
// // // //       ),
// // // //     );

// // // //     return pdf.save();
// // // //   }
// // // // }

// // // // class Prueba extends StatelessWidget {
// // // //   @override
// // // //   Widget build(BuildContext context) {
// // // //     final bluetoothProvider = Provider.of<ComprobantesController>(context);

// // // //     return Column(
// // // //       children: [
// // // //         ElevatedButton(
// // // //           onPressed: () {
// // // //             bluetoothProvider.startScanning();
// // // //           },
// // // //           child: Text('Scan for Bluetooth Printers'),
// // // //         ),
// // // //         if (bluetoothProvider.isScanning)
// // // //           CircularProgressIndicator(),
// // // //         Expanded(
// // // //           child: ListView.builder(
// // // //             itemCount: bluetoothProvider.devicesList.length,
// // // //             itemBuilder: (context, index) {
// // // //               final device = bluetoothProvider.devicesList[index];
// // // //               return ListTile(
// // // //                 title: Text(device.name.isEmpty ? 'Unknown Device' : device.name),
// // // //                 subtitle: Text(device.id.toString()),
// // // //                 onTap: () => _connectToDevice(context, device),
// // // //               );
// // // //             },
// // // //           ),
// // // //         ),
// // // //       ],
// // // //     );
// // // //   }

// // // //   void _connectToDevice(BuildContext context, BluetoothDevice device) async {
// // // //     // Aquí puedes agregar el código para conectarte a la impresora y realizar la impresión
// // // //     print('Connecting to device: ${device.name}');
// // // //   }
// // // // }



// // // // class Prueba extends StatelessWidget {
// // // //   @override
// // // //   Widget build(BuildContext context) {
// // // //     final bluetoothProvider = Provider.of<ComprobantesController>(context);

// // // //     return Scaffold(
// // // //       appBar: AppBar(
// // // //         title: Text('Bluetooth Printers'),
// // // //         actions: [
// // // //           IconButton(
// // // //             icon: Icon(Icons.refresh),
// // // //             onPressed: () {
// // // //               bluetoothProvider.startScanning();
// // // //             },
// // // //           ),
// // // //         ],
// // // //       ),
// // // //       body: Column(
// // // //         children: [
// // // //           if (bluetoothProvider.isScanning)
// // // //             Padding(
// // // //               padding: const EdgeInsets.all(8.0),
// // // //               child: Center(child: CircularProgressIndicator()),
// // // //             ),
// // // //           Expanded(
// // // //             child: ListView.builder(
// // // //               itemCount: bluetoothProvider.devicesList.length,
// // // //               itemBuilder: (context, index) {
// // // //                 final device = bluetoothProvider.devicesList[index];
// // // //                 return ListTile(
// // // //                   title: Text(device.name.isEmpty ? 'Unknown Device' : device.name),
// // // //                   subtitle: Text(device.id.toString()),
// // // //                   onTap: () => _connectToDevice(context, device),
// // // //                 );
// // // //               },
// // // //             ),
// // // //           ),
// // // //         ],
// // // //       ),
// // // //     );
// // // //   }

// // // //   void _connectToDevice(BuildContext context, BluetoothDevice device) async {
// // // //     // Aquí puedes agregar el código para conectarte a la impresora y realizar la impresión
// // // //     print('Connecting to device: ${device.name}');
// // // //     // Ejemplo: Conectar al dispositivo
// // // //     await device.connect();
// // // //     // Realizar acciones adicionales, como enviar datos a la impresora
// // // //   }
// // // // }



// // // // class Prueba extends StatelessWidget {
// // // //   @override
// // // //   Widget build(BuildContext context) {
// // // //     final bluetoothProvider = Provider.of<ComprobantesController>(context);

// // // //     return Scaffold(
// // // //       appBar: AppBar(
// // // //         title: Text('Bluetooth Printers'),
// // // //         actions: [
// // // //           IconButton(
// // // //             icon: Icon(Icons.refresh),
// // // //             onPressed: () {
// // // //               bluetoothProvider.startScanning();
// // // //             },
// // // //           ),
// // // //         ],
// // // //       ),
// // // //       body: Column(
// // // //         children: [
// // // //           if (bluetoothProvider.isScanning)
// // // //             Padding(
// // // //               padding: const EdgeInsets.all(8.0),
// // // //               child: Center(child: CircularProgressIndicator()),
// // // //             ),
// // // //           Expanded(
// // // //             child: ListView.builder(
// // // //               itemCount: bluetoothProvider.devicesList.length,
// // // //               itemBuilder: (context, index) {
// // // //                 final device = bluetoothProvider.devicesList[index];
// // // //                 return ListTile(
// // // //                   title: Text(device.name.isEmpty ? 'Unknown Device' : device.name),
// // // //                   subtitle: Text(device.id.toString()),
// // // //                   onTap: () => _connectToDevice(context, device),
// // // //                 );
// // // //               },
// // // //             ),
// // // //           ),
// // // //         ],
// // // //       ),
// // // //     );
// // // //   }

// // // //   void _connectToDevice(BuildContext context, BluetoothDevice device) async {
// // // //     print('Connecting to device: ${device.name}');
// // // //     await device.connect();
// // // //   }
// // // // }


// // // // class Prueba extends StatelessWidget {
// // // //   @override
// // // //   Widget build(BuildContext context) {
// // // //     final bluetoothProvider = Provider.of<ComprobantesController>(context);

// // // //     return Scaffold(
// // // //       appBar: AppBar(
// // // //         title: Text('Bluetooth Printers'),
// // // //         actions: [
// // // //           IconButton(
// // // //             icon: Icon(Icons.refresh),
// // // //             onPressed: () {
// // // //               bluetoothProvider.startScanning();
// // // //             },
// // // //           ),
// // // //         ],
// // // //       ),
// // // //       body: Column(
// // // //         children: [
// // // //           if (bluetoothProvider.isScanning)
// // // //             Padding(
// // // //               padding: const EdgeInsets.all(8.0),
// // // //               child: Center(child: CircularProgressIndicator()),
// // // //             ),
// // // //           Expanded(
// // // //             child: ListView.builder(
// // // //               itemCount: bluetoothProvider.devicesList.length,
// // // //               itemBuilder: (context, index) {
// // // //                  print('Connecting to device: ${bluetoothProvider.devicesList[index]}');
// // // //                 final device = bluetoothProvider.devicesList[index];
// // // //                 return ListTile(
// // // //                   title: Text('asdasd'),//Text(device.platformName.isEmpty ? 'Unknown Device' : device.platformName),
// // // //                   subtitle: Text(device.id.toString()),
// // // //                   onTap: () => _connectToDevice(context, device),
// // // //                 );
// // // //               },
// // // //             ),
// // // //           ),
// // // //         ],
// // // //       ),
// // // //     );
// // // //   }

// // // //   void _connectToDevice(BuildContext context, BluetoothDevice device) async {
// // // //     print('Connecting to device: ${device.platformName}');
// // // //     await device.connect();
// // // //   }
// // // // }



// // // // class Prueba extends StatelessWidget {
// // // //   @override
// // // //   Widget build(BuildContext context) {
// // // //     final bluetoothProvider = Provider.of<ComprobantesController>(context);

// // // //     return Scaffold(
// // // //       appBar: AppBar(
// // // //         title: Text('Bluetooth Printers'),
// // // //         actions: [
// // // //           IconButton(
// // // //             icon: Icon(Icons.refresh),
// // // //             onPressed: () {
// // // //               bluetoothProvider.startScanning();
// // // //             },
// // // //           ),
// // // //         ],
// // // //       ),
// // // //       body: Column(
// // // //         children: [
// // // //           if (bluetoothProvider.isScanning)
// // // //             Padding(
// // // //               padding: const EdgeInsets.all(8.0),
// // // //               child: Center(child: CircularProgressIndicator()),
// // // //             ),
// // // //           Expanded(
// // // //             child: ListView.builder(
// // // //               itemCount: bluetoothProvider.devicesList.length,
// // // //               itemBuilder: (context, index) {
// // // //                 final device = bluetoothProvider.devicesList[index];
// // // //                 print('Building item for device: ${device.platformName}'); // Debug: imprime el dispositivo en construcción
// // // //                 return ListTile(
// // // //                   title: Text(device.platformName.isEmpty ? 'Unknown Device' : device.platformName),
// // // //                   subtitle: Text(device.id.toString()),
// // // //                   onTap: () => _connectToDevice(context, device),
// // // //                 );
// // // //               },
// // // //             ),
// // // //           ),
// // // //         ],
// // // //       ),
// // // //     );
// // // //   }

// // // //   void _connectToDevice(BuildContext context, BluetoothDevice device) async {
// // // //     print('Connecting to device: ${device.platformName}');
// // // //     await device.connect();
// // // //   }
// // // // }



// // // class Prueba extends StatelessWidget {
// // //   @override
// // //   Widget build(BuildContext context) {
// // //     final bluetoothProvider = Provider.of<ComprobantesController>(context);

// // //     return Scaffold(
// // //       appBar: AppBar(
// // //         title: Text('Bluetooth Devices'),
// // //         actions: [
// // //           IconButton(
// // //             icon: Icon(Icons.search),
// // //             onPressed: () {
// // //               bluetoothProvider.searchForConnectedDevices();
// // //             },
// // //           ),
// // //         ],
// // //       ),
// // //       body: ListView.builder(
// // //         itemCount: bluetoothProvider.devices.length,
// // //         itemBuilder: (context, index) {
// // //           final device = bluetoothProvider.devices[index];
// // //           return ListTile(
// // //             title: Text(device.name.isNotEmpty ? device.name : 'Unknown Device'),
// // //             subtitle: Text(device.id.toString()),
// // //             trailing: ElevatedButton(
// // //               onPressed: () {
// // //                 bluetoothProvider.connectToDevice(device);
// // //               },
// // //               child: Text('Connect'),
// // //             ),
// // //           );
// // //         },
// // //       ),
// // //     );
// // //   }






// // // }


// // import 'dart:async';
// // import 'dart:typed_data';

// // import 'package:esc_pos_utils/esc_pos_utils.dart';
// // import 'package:flutter/material.dart';
// // import 'package:flutter_blue_plus/flutter_blue_plus.dart';
// // import 'package:neitorcont/src/controllers/bluetooth_controller.dart';
// // import 'package:neitorcont/src/controllers/comprobantes_controller.dart';
// // import 'package:pdf/pdf.dart';
// // import 'package:permission_handler/permission_handler.dart';
// // import 'package:printing/printing.dart';
// // import 'package:provider/provider.dart';

// // import 'package:pdf/widgets.dart' as pw;
// // // class BluetoothPrintPage extends StatelessWidget {
// // //   @override
// // //   Widget build(BuildContext context) {
// // //     final bluetoothProvider = Provider.of<ComprobantesController>(context);

// // //     return Scaffold(
// // //       appBar: AppBar(
// // //         title: Text('Impresora Bluetooth'),
// // //       ),
// // //       body: Column(
// // //         children: [
// // //           // Botón para escanear dispositivos
// // //           ElevatedButton(
// // //             onPressed: () {
// // //               bluetoothProvider.scanDispositivos();
// // //             },
// // //             child: Text('Buscar dispositivos Bluetooth'),
// // //           ),
// // //           // Indicador de carga o lista de dispositivos encontrados
// // //           Expanded(
// // //             child: bluetoothProvider.isScanning
// // //                 ? Center(
// // //                     child: CircularProgressIndicator(),
// // //                   )
// // //                 : bluetoothProvider.dispositivos.isEmpty
// // //                     ? Center(
// // //                         child: Text(
// // //                           'No hay Dispositivos cerca',
// // //                           style: TextStyle(fontSize: 16),
// // //                         ),
// // //                       )
// // //                     : ListView.builder(
// // //                         itemCount: bluetoothProvider.dispositivos.length,
// // //                         itemBuilder: (context, index) {
// // //                           return ListTile(
// // //                             title: Text(bluetoothProvider.dispositivos[index].name),
// // //                             subtitle: Text(bluetoothProvider.dispositivos[index].id.toString()),
// // //                             onTap: () {
// // //                               bluetoothProvider.conectarDispositivo(bluetoothProvider.dispositivos[index]);
                              
// // //                               // Mostrar Snackbar al conectar
// // //                               ScaffoldMessenger.of(context).showSnackBar(
// // //                                 SnackBar(
// // //                                   content: Text(
// // //                                     'Conectado a ${bluetoothProvider.dispositivos[index].name}',
// // //                                     style: TextStyle(fontSize: 16),
// // //                                   ),
// // //                                   duration: Duration(seconds: 2),
// // //                                 ),
// // //                               );
// // //                             },
// // //                           );
// // //                         },
// // //                       ),
// // //           ),
// // //           // Botón para imprimir
// // //           ElevatedButton(
// // //             onPressed: () {
// // //               bluetoothProvider.imprimir();
// // //             },
// // //             child: Text('Imprimir'),
// // //           ),
// // //         ],
// // //       ),
// // //     );
// // //   }



// // class PrintScreen extends StatelessWidget {
// //   @override
// //   Widget build(BuildContext context) {
// //     final printProvider = Provider.of<BluetoothProvider>(context);

// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text('Seleccionar Impresora'),
// //       ),
// //       body: Column(
// //         children: [
// //           ElevatedButton(
// //             onPressed: () async {
// //               await printProvider.scanPrinters();
// //             },
// //             child: Text('Escanear Impresoras'),
// //           ),
// //           Expanded(
// //             child: ListView.builder(
// //               itemCount: printProvider.printers?.length ?? 0,
// //               itemBuilder: (context, index) {
// //                 final printer = printProvider.printers![index];
// //                 return ListTile(
// //                   title: Text(printer.name ?? 'Impresora desconocida'),
// //                   onTap: () {
// //                     // Seleccionar impresora (opcional si no se va a usar)
// //                     // printProvider.selectPrinter(printer);
// //                     ScaffoldMessenger.of(context).showSnackBar(
// //                       SnackBar(content: Text('Impresora seleccionada: ${printer.name}')),
// //                     );
// //                   },
// //                 );
// //               },
// //             ),
// //           ),
// //           ElevatedButton(
// //             onPressed: () {
// //               printProvider.printDocument();
// //             },
// //             child: Text('Imprimir'),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }





// // import 'package:blue_thermal_printing/blue_print.dart';
// import 'dart:math';

// import 'package:esc_pos_bluetooth/esc_pos_bluetooth.dart';
// import 'package:esc_pos_utils/esc_pos_utils.dart';
// import 'package:flutter/material.dart';
// // import 'package:flutter_blue/flutter_blue.dart';
// import 'package:flutter_blue_plus/flutter_blue_plus.dart';


// class PrintingWidget extends StatefulWidget {
//   const PrintingWidget({Key? key}) : super(key: key);

//   @override
//   _PrintingWidgetState createState() => _PrintingWidgetState();
// }

// class _PrintingWidgetState extends State<PrintingWidget> {
//   List<ScanResult>? scanResult;

//   @override
//   void initState() {
//     super.initState();
//   }

//   void findDevices() {
//     FlutterBluePlus.startScan(timeout: const Duration(seconds: 4));
//     FlutterBluePlus.scanResults.listen((results) {
//       setState(() {
//         scanResult = results;
//       });
//     });

//     Future.delayed(const Duration(seconds: 4), () {
//       FlutterBluePlus.stopScan();
//     });
//   }

//   void printWithDevice(ScanResult result) async {
//     final printerManager = PrinterBluetoothManager();
//     final printer = PrinterBluetooth(
//       MyBluetoothDevice(
//         name: result.device.
//         address: result.device.id.id,
//       ),
//     );
//     printerManager.selectPrinter(printer);

//     final profile = await CapabilityProfile.load();
//     final generator = Generator(PaperSize.mm80, profile);

//     List<int> bytes = [];
//     bytes += generator.text('Hola Mundo', styles: PosStyles(align: PosAlign.center));
//     bytes += generator.feed(2);
//     bytes += generator.cut();

//     printerManager.printTicket(bytes);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Bluetooth devices')),
//       body: Column(
//         children: [
//           ElevatedButton(
//             onPressed: findDevices,
//             child: const Text('Escanear Impresoras'),
//           ),
//           Expanded(
//             child: ListView.separated(
//               itemBuilder: (context, index) {
//                 return ListTile(
//                   title: Text(scanResult![index].device.platformName.isNotEmpty 
//                       ? scanResult![index].device.platformName 
//                       : 'Desconocido'),
//                   subtitle: Text(scanResult![index].device.id.id),
//                   onTap: () => printWithDevice(scanResult![index]),
//                 );
//               },
//               separatorBuilder: (context, index) => const Divider(),
//               itemCount: scanResult?.length ?? 0,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class MyBluetoothDevice {
//   final String name;
//   final String address;

//   MyBluetoothDevice({required this.name, required this.address});
// }

// class BluePrint {
//   BluePrint({this.chunkLen = 512});

//   final int chunkLen;
//   final _data = List<int>.empty(growable: true);

//   void add(List<int> data) {
//     _data.addAll(data);
//   }

//   List<List<int>> getChunks() {
//     final chunks = List<List<int>>.empty(growable: true);
//     for (var i = 0; i < _data.length; i += chunkLen) {
//       chunks.add(_data.sublist(i, (i + chunkLen).clamp(0, _data.length)));
//     }
//     return chunks;
//   }

//   Future<void> printData(BluetoothDevice device) async {
//     final data = getChunks();
//     final characs = await _getCharacteristics(device);
//     for (var i = 0; i < characs.length; i++) {
//       if (await _tryPrint(characs[i], data)) {
//         break;
//       }
//     }
//   }

//   Future<bool> _tryPrint(
//     BluetoothCharacteristic charac,
//     List<List<int>> data,
//   ) async {
//     for (var i = 0; i < data.length; i++) {
//       try {
//         await charac.write(data[i]);
//       } catch (e) {
//         return false;
//       }
//     }
//     return true;
//   }

//   Future<List<BluetoothCharacteristic>> _getCharacteristics(
//     BluetoothDevice device,
//   ) async {
//     final services = await device.discoverServices();
//     final res = List<BluetoothCharacteristic>.empty(growable: true);
//     for (var service in services) {
//       res.addAll(service.characteristics);
//     }
//     return res;
//   }
// }