// import 'package:flutter/material.dart';
// import 'package:flutter_blue_plus/flutter_blue_plus.dart';
// import 'package:pdf/pdf.dart';
// import 'package:printing/printing.dart';
// import 'package:pdf/widgets.dart' as pw;




// class BluetoothProvider extends ChangeNotifier {
// List<Printer>? _printers;

//   List<Printer>? get printers => _printers;

//   Future<void> scanPrinters() async {
//     _printers = await Printing.listPrinters();
//     notifyListeners();
//   }

//   Future<void> printDocument() async {
//     // Crear un documento PDF
//     final pdf = pw.Document();
//     pdf.addPage(
//       pw.Page(
//         build: (pw.Context context) => pw.Center(
//           child: pw.Text('Hola, este es un documento de prueba para la impresora térmica PT250.'),
//         ),
//       ),
//     );

//     // Imprimir el documento
//     await Printing.layoutPdf(
//       onLayout: (PdfPageFormat format) async => pdf.save(),
//     );
//   }
// }
