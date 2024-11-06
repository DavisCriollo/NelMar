import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:neitorcont/src/pages/view_pdf_facturas.dart';
import 'package:neitorcont/src/utils/responsive.dart';
// import 'package:open_file/open_file.dart';
import 'package:open_file_safe/open_file_safe.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';






class ViewsPDFs extends StatelessWidget {
  final String infoPdf;
  final String labelPdf;

  const ViewsPDFs({Key? key, required this.infoPdf, required this.labelPdf}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Vista PDF'),
          actions: [
            IconButton(
              onPressed: () async {
                await _checkPermissions();
                // await _downloadPDF(context, infoPdf, labelPdf);
                 // Mostramos el menú cuando se presiona el botón
            showMenu(
              context: context,
              position: RelativeRect.fromLTRB(10, 80, 0, 0), // Posición del menú
              items: [
                PopupMenuItem<String>(
                  value: '1',
                  child: Text('Compartir'),
                ),
                PopupMenuItem<String>(
                  value: '2',
                  child: Text('Descragar'),
                ),
                PopupMenuItem<String>(
                  value: '3',
                  child: Text('Imprimir'),
                ),
              ],
              elevation: 8.0,
            ).then((value) {
              if (value != null) {
                // Acción al seleccionar una opción
                print("Seleccionaste: $value");
              }
            });
    
    
    
              },
              icon: const Icon(Icons.more_vert_outlined),
            ),
          ],
        ),
        body: SfPdfViewer.network(infoPdf),
      ),
    );
  }

  Future<void> _checkPermissions() async {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }
  }

  Future<void> _downloadPDF(BuildContext context, String url, String fileName) async {
    try {
      // Obtiene la ruta del directorio de descargas
      final Directory? downloadsDirectory = Directory('/storage/emulated/0/Download');
      
      // Verifica que el directorio de descargas no sea nulo
      if (await downloadsDirectory!.exists()) {
        // Define la ruta para guardar el archivo en la carpeta de descargas
        String filePath = path.join(downloadsDirectory.path, "$fileName.pdf");

        // Descargar el archivo
        Dio dio = Dio();
        await dio.download(url, filePath);

        // Notifica al sistema que hay un nuevo archivo
        _notifyGallery(filePath);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('PDF descargado en la carpeta Descargas: $filePath')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('La carpeta de descargas no existe.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al descargar el PDF: $e')),
      );
    }
  }

  void _notifyGallery(String filePath) {
    // Notifica al sistema sobre el nuevo archivo
    Process.run('am', ['broadcast', '-a', 'android.intent.action.MEDIA_SCANNER_SCAN_FILE', '-d', 'file://$filePath']);
  }






}
