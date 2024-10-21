import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:neitorcont/src/controllers/caja_controller.dart';
import 'package:neitorcont/src/models/sesison_model.dart';
import 'package:neitorcont/src/services/notifications_service.dart';
import 'package:neitorcont/src/services/socket_service.dart';
import 'package:neitorcont/src/theme/theme_provider.dart';
import 'package:neitorcont/src/utils/fechaLocal.dart';
import 'package:neitorcont/src/utils/letras_mayusculas_minusculas.dart';
import 'package:neitorcont/src/utils/responsive.dart';
import 'package:provider/provider.dart';
import 'package:sunmi_printer_plus/column_maker.dart';
import 'package:sunmi_printer_plus/enums.dart';
import 'package:sunmi_printer_plus/sunmi_printer_plus.dart';

import 'package:image/image.dart' as img;



class CreaCaja extends StatefulWidget {
   final String? tipo;
 
   final Session? user;

  const CreaCaja({Key? key, this.tipo, this.user}) : super(key: key);

  @override
  State<CreaCaja> createState() => _CreaCajaState();
}

class _CreaCajaState extends State<CreaCaja> {
    TextEditingController _textMonto = TextEditingController();
      TextEditingController _textAutorizacion = TextEditingController();


//************  PARTE PARA CONFIGURAR LA IMPRESORA*******************//

bool printBinded = false;
  int paperSize = 0;
  String serialNumber = "";
  String printerVersion = "";
  @override
  void initState() {
    super.initState();

    _bindingPrinter().then((bool? isBind) async {
      SunmiPrinter.paperSize().then((int size) {
        setState(() {
          paperSize = size;
        });
      });

      SunmiPrinter.printerVersion().then((String version) {
        setState(() {
          printerVersion = version;
        });
      });

      SunmiPrinter.serialNumber().then((String serial) {
        setState(() {
          serialNumber = serial;
        });
      });

      setState(() {
        printBinded = isBind!;
      });
    });
  }

  /// must binding ur printer at first init in app
  Future<bool?> _bindingPrinter() async {
    final bool? result = await SunmiPrinter.bindingPrinter();
    return result;
  }

//***********************************************/





      
    @override
  void dispose() {
    _textMonto.dispose();
    _textAutorizacion.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {

 final Responsive size = Responsive.of(context);
    final ctrl = context.read<CajaController>();
    final ctrlTheme = context.read<ThemeProvider>();

    return GestureDetector(
       onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
         appBar: AppBar(
            title: widget.tipo == 'CREATE' 
                ? Text('Agregar Caja General')
                : Text('Editar Caja General'),
            actions: [
               Container(
                margin: EdgeInsets.only(right: size.iScreen(1.5)),
                child: IconButton(
                    splashRadius: 28,
                    onPressed: () {
                      _onSubmit(
                        context,
                        ctrl,
                      );
                    },
                    icon: Icon(
                      Icons.save_outlined,
                      size: size.iScreen(4.0),
                    )),
              )
            ],
          ),
        body: Container(
          color: Colors.white,
          margin: EdgeInsets.only(
              left: size.iScreen(1.0),
              right: size.iScreen(1.0),
              bottom: size.iScreen(1.0)),
          width: size.wScreen(100),
          height: size.hScreen(100),
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Form(
                key: ctrl.cajaFormKey,
              child: Column(
                children: [

                      //**********************SE MUESTRA LA OPCION DE IMPRIMIR *************************//
                        Consumer<SocketService>(
        builder: (_,value, __) {

     return 
         value.latestResponseCaja!.isNotEmpty 
         //&&  value.latestResponse!['tabla']=='caja'
        ? 
        Container(
            width: size.wScreen(100.0),
          
            decoration: BoxDecoration(
                color: Colors.grey,
              borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20.0),
          bottomRight: Radius.circular(20.0),
        ),
            ),
            child: Column(
        mainAxisSize: MainAxisSize.min, // Ajusta el tamaño del contenedor según su contenido
        children: [

          SizedBox(height:size.iScreen(1.5)), 
          Text(
        '¿Desea imprimir factura?',
        style: GoogleFonts.lexendDeca(
                              fontWeight: FontWeight.bold,
                              fontSize: size.iScreen(2.0),
                        
                            ),
        textAlign: TextAlign.center,
          ),

          SizedBox(width:size.iScreen(1.5)), // Espacio entre el texto y los botones
          Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
            // SizedBox(width: 20),
            
           
            ElevatedButton(
              style: ButtonStyle(
             // Color negro
                
              ),
              onPressed: () {

                      

                    _printTicket(value.latestResponseCaja,widget.user!.logo);

                      //========================================//
                        final _ctrl =context.read<CajaController>();
                            _ctrl.setInfoBusquedaCajasPaginacion([]);
                           _ctrl.resetValorTotal();
                             _ctrl.buscaAllCajaPaginacion(
                                '',false,0);
                        Navigator.pop(context);
        
                      //****************************************//

    },
              child: Text('Imprimir', style: GoogleFonts.lexendDeca(
                              fontWeight: FontWeight.bold,
                              fontSize: size.iScreen(1.8)
                            ),),
            ), // Espacio entre los botones
            SizedBox(width: 20),
             OutlinedButton(
               style: ButtonStyle( backgroundColor: MaterialStateProperty.all(Colors.black), ),
               onPressed: (){
                 Navigator.pop(context);
                    final _ctrl =context.read<CajaController>();
                        _ctrl.setInfoBusquedaCajasPaginacion([]);
                           _ctrl.resetValorTotal();
                             _ctrl.buscaAllCajaPaginacion(
                                '',false,0);
                   
               },
               child: Text('No', style: GoogleFonts.lexendDeca(
                 color: Colors.white,
                               fontWeight: FontWeight.bold,
                               fontSize: size.iScreen(1.8)
                             ),),
             ),
           
        ],
          ),
        ],
      ),
          ):Container();
          
         
        },),


                  //***********************************************/
                  SizedBox(
                    height: size.iScreen(0.5),
                  ),
                  //*****************************************/
                  Row(
                    children: [
                      SizedBox(
                        // width: size.wScreen(20.0),
            
                        // color: Colors.blue,
                        child: Text('Tipo   ',
                            style: GoogleFonts.lexendDeca(
                                fontSize: size.iScreen(2.0),
                                fontWeight: FontWeight.normal,
                                color: Colors.grey)),
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: GestureDetector(
                          onTap: () {
                            // context
                            //     .read<MascotasController>()
                            //     .buscaAllMascotas('');
            
                            // // _buscarMascota(context, size);
                            
                            modalTipos(context, size);
            
                            // //*******************************************/
                          },
                          child: Consumer<ThemeProvider>(
                            builder: (_, valueTheme, __) {
                              return Container(
                                
                                alignment: Alignment.center,
                                color: valueTheme.appTheme.primaryColor,
                                width: size.iScreen(5.0),
                                 height: size.iScreen(4.0),
                                padding: EdgeInsets.only(
                                  top: size.iScreen(0.5),
                                  bottom: size.iScreen(0.5),
                                  left: size.iScreen(0.5),
                                  right: size.iScreen(0.5),
                                ),
                                child: Icon(
                                  Icons.keyboard_arrow_down_outlined,
                                  color: Colors.white,
                                  size: size.iScreen(2.0),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    
                      // Consumer<ComprobantesController>(
                      //   builder: (_, valueForma, __) {
                      //     return Container(
                      //       // color: Colors.red,
                      //       width: size.wScreen(50.0),
            
                      //       // color: Colors.blue,
                      //       child: Text(
                      //           valueForma.getFormaDePago.isEmpty
                      //               ? ' --- --- --- --- --- --- --- ---'
                      //               : ' ${valueForma.getFormaDePago}',
                      //           style: GoogleFonts.lexendDeca(
                      //               fontSize: size.iScreen(2.0),
                      //               fontWeight: FontWeight.normal,
                      //               color: valueForma.getFormaDePago.isEmpty
                      //                   ? Colors.grey
                      //                   : Colors.black)),
                      //     );
                      //   },
                      // ),
                      // Spacer(),
                      
                    ],
                  ),
                   // //***********************************************/
                  SizedBox(
                    height: size.iScreen(1.0),
                  ),
                  // //*****************************************/
                    Consumer<CajaController>(builder: (_, value, __) { 
                         return Container(
                            // color: Colors.red,
                            width: size.wScreen(100.0),
            
                            // color: Colors.blue,
                            child: Text(
                                value.getTipo.isEmpty
                                    ? ' --- --- --- --- --- --- --- ---'
                                    : ' ${value.getTipo}',
                                style: GoogleFonts.lexendDeca(
                                    fontSize: size.iScreen(2.3),
                                    fontWeight: FontWeight.normal,
                                    color: value.getTipo.isEmpty
                                        ? Colors.grey
                                        : Colors.black)),
                          );
                       },),
                       //***********************************************/
                  SizedBox(
                    height: size.iScreen(1.0),
                  ),
                  //*****************************************/
                  Row(
                    children: [
                      SizedBox(
                        // width: size.wScreen(20.0),
            
                        // color: Colors.blue,
                        child: Text('Tipo Documento  ',
                            style: GoogleFonts.lexendDeca(
                                fontSize: size.iScreen(2.0),
                                fontWeight: FontWeight.normal,
                                color: Colors.grey)),
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: GestureDetector(
                          onTap: () {
                            // context
                            //     .read<MascotasController>()
                            //     .buscaAllMascotas('');
            
                            // // _buscarMascota(context, size);
                            
                            modalTipoDocumentos(context, size);
            
                            // //*******************************************/
                          },
                          child: Consumer<ThemeProvider>(
                            builder: (_, valueTheme, __) {
                              return Container(
                                
                                alignment: Alignment.center,
                                color: valueTheme.appTheme.primaryColor,
                                width: size.iScreen(5.0),
                                 height: size.iScreen(4.0),
                                padding: EdgeInsets.only(
                                  top: size.iScreen(0.5),
                                  bottom: size.iScreen(0.5),
                                  left: size.iScreen(0.5),
                                  right: size.iScreen(0.5),
                                ),
                                child: Icon(
                                  Icons.keyboard_arrow_down_outlined,
                                  color: Colors.white,
                                  size: size.iScreen(2.0),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    
                      // Consumer<ComprobantesController>(
                      //   builder: (_, valueForma, __) {
                      //     return Container(
                      //       // color: Colors.red,
                      //       width: size.wScreen(50.0),
            
                      //       // color: Colors.blue,
                      //       child: Text(
                      //           valueForma.getFormaDePago.isEmpty
                      //               ? ' --- --- --- --- --- --- --- ---'
                      //               : ' ${valueForma.getFormaDePago}',
                      //           style: GoogleFonts.lexendDeca(
                      //               fontSize: size.iScreen(2.0),
                      //               fontWeight: FontWeight.normal,
                      //               color: valueForma.getFormaDePago.isEmpty
                      //                   ? Colors.grey
                      //                   : Colors.black)),
                      //     );
                      //   },
                      // ),
                      // Spacer(),
                      
                    ],
                  ),
                   // //***********************************************/
                  SizedBox(
                    height: size.iScreen(0.5),
                  ),
                  // //*****************************************/
                    Consumer<CajaController>(builder: (_, value, __) { 
                         return Container(
                            // color: Colors.red,
                            width: size.wScreen(100.0),
            
                            // color: Colors.blue,
                            child: Text(
                                value.getTipoDocumento.isEmpty
                                    ? ' --- --- --- --- --- --- --- ---'
                                    : ' ${value.getTipoDocumento}',
                                style: GoogleFonts.lexendDeca(
                                    fontSize: size.iScreen(2.3),
                                    fontWeight: FontWeight.normal,
                                    color: value.getTipo.isEmpty
                                        ? Colors.grey
                                        : Colors.black)),
                          );
                       },),


                        Row(
                    children: [
                      SizedBox(
                        // width: size.wScreen(100.0),
            
                        // color: Colors.blue,
                        child: Text('Monto :  ',
                            style: GoogleFonts.lexendDeca(
                                fontSize: size.iScreen(2.0),
                                fontWeight: FontWeight.normal,
                                color: Colors.grey)),
                      ),
                   Row(
                     children: [
                       SizedBox(
                          width: size.iScreen(20.0),
                          child: TextFormField(
           
            textAlign: TextAlign.center,
            autofocus: false,
            decoration: InputDecoration(
          
              labelStyle: TextStyle(fontSize: size.iScreen(1.9)),
              // Aquí puedes agregar más personalización si es necesario
            ),
            style: TextStyle(
              fontSize: size.iScreen(3.0),
              color: Colors.black,
            ),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$')),
            ],
            onChanged: (text) {
              double value = 0.0;
              if (text.isNotEmpty) {
                try {
                  value = double.parse(text);
                } catch (e) {
                  // Manejo del error si el parse falla
                  value = 0.0;
                }
              }
              ctrl.setMonto(value);
            },
            validator: (text) {
              if (text == null || text.isEmpty) {
                return 'Por favor, ingrese monto';
              }
              final value = double.tryParse(text);
              if (value == null) {
                return 'Ingrese un número válido';
              }
              return null; // Devuelve null si la validación es exitosa
            },
          ),
                        ),
                    
                     ],
                   ),
                 
                  
                  
                    ],
                  ),
                 //***********************************************/
                  SizedBox(
                    height: size.iScreen(0.5),
                  ),
                  // //*****************************************/
                  TextFormField(
                          inputFormatters: [
                            UpperCaseText(),
                          ],
                          decoration: InputDecoration(
                            label:  const Text( 'Autorización'),
                            // Texto de sugerencia dentro del campo
                            // border: OutlineInputBorder(), // Opcional: Añade un borde al campo
                            helperStyle: TextStyle(color: Colors.grey.shade50),
                          ),
                          style: TextStyle(
                            fontSize:
                                size.iScreen(2.3), // Ajusta el tamaño de la letra
                            // fontWeight: FontWeight.bold, // Opcional: Aplica un peso de fuente más grueso
                          ),
                          textAlign: TextAlign.left,
                        onChanged: (text) {
                      ctrl.setAutorizacion(text);
                    },
                    validator: (text) {
                      if (text!.trim().isNotEmpty) {
                        return null;
                      } else {
                        return 'Ingrese Autorización';
                      }
                    },
                     ),

                      //***********************************************/
                  SizedBox(
                    height: size.iScreen(0.5),
                  ),
                  // //*****************************************/
                  TextFormField(
                     minLines: 1,
                          maxLines: 3,
                          inputFormatters: [
                            UpperCaseText(),
                          ],
                          decoration: InputDecoration(
                            label:  const Text( 'Detalle'),
                            // Texto de sugerencia dentro del campo
                            // border: OutlineInputBorder(), // Opcional: Añade un borde al campo
                            helperStyle: TextStyle(color: Colors.grey.shade50),
                          ),
                          style: TextStyle(
                            fontSize:
                                size.iScreen(2.3), // Ajusta el tamaño de la letra
                            // fontWeight: FontWeight.bold, // Opcional: Aplica un peso de fuente más grueso
                          ),
                          textAlign: TextAlign.left,
                        onChanged: (text) {
                      ctrl.setDetalle(text);
                    },
                    validator: (text) {
                      if (text!.trim().isNotEmpty) {
                        return null;
                      } else {
                        return 'Ingrese Detalle';
                      }
                    },



                        ),
                ],
              ),
            ),
          ),
        ),
       ),
    );
  }

  //********************************************************************************************************************//
  void _onSubmit(
    BuildContext context,
    CajaController controller,
  ) async {
    final isValid = controller.validateForm();
    if (!isValid) return;
    if (isValid) {

 

      if (controller.getTipo.isEmpty) {
        NotificatiosnService.showSnackBarDanger('Debe seleccionar Tipo');
      } else if (controller.getTipo.isEmpty) {
        NotificatiosnService.showSnackBarDanger(
            'Debe seleccionar Tipo documento');
      }
      //  else if (controller.getNombreConductor == "") {
      //   NotificatiosnService.showSnackBarDanger(
      //       'Debe ingresar nombre de Conductor');
      // }
      else if (controller.getAutorizacion.isEmpty) {
        NotificatiosnService.showSnackBarDanger(
            'Debe agregar Autorización');
      } else if (controller.getDetalle.isEmpty) {
        NotificatiosnService.showSnackBarDanger(
            'Debe agregar Detalle');
      }
      else{
          
          controller.createCaja(context);
           controller.setInfoBusquedaCajasPaginacion([]);
                           controller.resetValorTotal();
                             controller.buscaAllCajaPaginacion(
                                '',false,0);
                               


      }

    }
  }



  //**********************************************MODAL TIPO  **********************************************************************//
  Future<bool?> modalTipos(
      BuildContext context, Responsive size) {
    return showDialog<bool>(
      barrierColor: Colors.black54,
      context: context,
      builder: (context) {

       return AlertDialog(
          title: const Text("SELECCIONE TIPO"),
          content: SizedBox(
            width: size.wScreen(100),
            height: size.hScreen(20.0), // Ajusta la altura según sea necesario
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),

           

              child: 
              Consumer<CajaController>(builder: (_, value, __) {  

                    if (value.getListTipos.isEmpty) {
                            return Center(
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              
                                              CircularProgressIndicator(),
                                              Text('Por favor espere ....')
                                            ],
                                          ));
                            // Text("sin datos");
                          }

                          return 
                          
                           Wrap(
                  children: value.getListTipos.map((e) => 
                  
                  
                  GestureDetector(
                          onTap: () {
                            value.setTipo( e);
                            Navigator.pop(context);
                          },
                          child: Container(
                            margin: EdgeInsets.symmetric(
                                vertical: size.iScreen(0.5)),
                            padding: EdgeInsets.symmetric(
                                horizontal: size.iScreen(2.0),
                                vertical: size.iScreen(1.0)),
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(
                              child: Text(
                               e,
                                style: GoogleFonts.lexendDeca(
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ),
                          ),
                        )
                  
                  
                  ).toList(),
                );
      

              },)
              
             
            
            ),
          ),
        );
      },
    );
  }


  //**********************************************MODAL TIPO  **********************************************************************//
  Future<bool?> modalTipoDocumentos(
      BuildContext context, Responsive size) {
    return showDialog<bool>(
      barrierColor: Colors.black54,
      context: context,
      builder: (context) {

       return AlertDialog(
          title: const Text("SELECCIONE TIPO DOCUMENTO"),
          content: SizedBox(
            width: size.wScreen(100),
            height: size.hScreen(20.0), // Ajusta la altura según sea necesario
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),

           

              child: 
              Consumer<CajaController>(builder: (_, value, __) {  

                    if (value.getListTiposDocumentos.isEmpty) {
                            return Center(
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              
                                              CircularProgressIndicator(),
                                              Text('Por favor espere ....')
                                            ],
                                          ));
                            // Text("sin datos");
                          }

                          return 
                          
                           Wrap(
                  children: value.getListTiposDocumentos.map((e) => 
                  
                  
                  GestureDetector(
                          onTap: () {
                            value.setTipoDocumento( e);
                            Navigator.pop(context);
                          },
                          child: Container(
                            margin: EdgeInsets.symmetric(
                                vertical: size.iScreen(0.5)),
                            padding: EdgeInsets.symmetric(
                                horizontal: size.iScreen(2.0),
                                vertical: size.iScreen(1.0)),
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(
                              child: Text(
                               e,
                                style: GoogleFonts.lexendDeca(
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ),
                          ),
                        )
                  
                  
                  ).toList(),
                );
      

              },)
              
             
            
            ),
          ),
        );
      },
    );
  }

//**************************************//


// void _printTicket(Map<String, dynamic>? _info,String? user) async {
//   if (_info == null) return;

//   //==============================================//
//   String utcDate = _info['venFecReg'];

//   // Parsear la fecha en UTC
//   DateTime dateTimeUtc = DateTime.parse(utcDate);

//   // Convertirla a hora local
//   DateTime dateTimeLocal = dateTimeUtc.toLocal();

//   // Formatear la fecha y hora local como 'YYYY-MM-DD HH:MM'
//   String formattedDate = DateFormat('yyyy-MM-dd HH:mm').format(dateTimeLocal);

//   // print(formattedDate);  // Resultado: 2024-09-18 19:27

//  //==============================================//
 


// // Función principal de impresión

//   // Imprime el logo (si existe)
//   if (user!.isNotEmpty) {
//     String url = user;
    
//     // Convertir la imagen a formato Uint8List
//     Uint8List byte = (await NetworkAssetBundle(Uri.parse(url)).load(url))
//         .buffer
//         .asUint8List();

//     // Decodificar la imagen
//     img.Image? originalImage = img.decodeImage(byte);

//     if (originalImage != null) {
//       // Redimensionar la imagen (ajusta width y height según tus necesidades)
//       img.Image resizedImage = img.copyResize(originalImage, width: 150, height: 150);

//       // Convertir la imagen redimensionada de vuelta a Uint8List
//       Uint8List resizedByte = Uint8List.fromList(img.encodePng(resizedImage));

//       // Alinear la imagen y comenzar la transacción de impresión
//       await SunmiPrinter.setAlignment(SunmiPrintAlign.CENTER);
//       await SunmiPrinter.printImage(resizedByte);

//       // Agregar un salto de línea para asegurar que el texto se imprima debajo
//       await SunmiPrinter.lineWrap(2); // Esto asegura que haya espacio debajo del logo
//     }
//   } else {
//     // Si no hay logo, imprimir el texto "NO LOGO"
//     await SunmiPrinter.printText('NO LOGO');
//     await SunmiPrinter.lineWrap(1); // Saltar una línea para separación
//   }

//   // Imprime el resto de la información del encabezado
//   await SunmiPrinter.setAlignment(SunmiPrintAlign.LEFT);
//   await SunmiPrinter.printText('Ruc: ${_info['venEmpRuc']}');
//   await SunmiPrinter.printText('Dir: ${_info['venEmpDireccion']}');
//   await SunmiPrinter.printText('Tel: ${_info['venEmpTelefono']}');
//   await SunmiPrinter.printText('Email: ${_info['venEmpEmail']}');

//   await SunmiPrinter.line();
//   await SunmiPrinter.printText('Cliente: ${_info['venNomCliente']}');
//   await SunmiPrinter.printText('Ruc: ${_info['venRucCliente']}');
//  await SunmiPrinter.line();
//   await SunmiPrinter.printText('Fecha: ${_info['venFechaFactura']}'); // O utiliza formattedDate si corresponde
//  await SunmiPrinter.line();
//   await SunmiPrinter.printText('Conductor: ${_info['venConductor']}');
//   await SunmiPrinter.printText('Placa: ${_info['venOtrosDetalles'][0]}');
//   // Imprime el encabezado de la tabla
//   await SunmiPrinter.setAlignment(SunmiPrintAlign.LEFT);
//   await SunmiPrinter.line();
//   await SunmiPrinter.printRow(cols: [
//     ColumnMaker(
//       text: 'Descripción',
//       width: 12,
//       align: SunmiPrintAlign.LEFT,
//     ),
//     ColumnMaker(
//       text: 'Cant',
//       width: 6,
//       align: SunmiPrintAlign.CENTER,
//     ),
//     ColumnMaker(
//       text: 'vU',
//       width: 6,
//       align: SunmiPrintAlign.RIGHT,
//     ),
//     ColumnMaker(
//       text: 'TOT',
//       width: 6,
//       align: SunmiPrintAlign.RIGHT,
//     ),
//   ]);

//   // Imprime cada ítem en la lista
//   final productos = _info['venProductos'] as List<dynamic>?;

//   if (productos != null) {
//     // for (var item in productos) {
//     //   // Cambiar el tamaño de la fuente solo para la columna de descripción
//     //   // await SunmiPrinter.setFontSize(SunmiFontSize.SM); // Ajustar a un tamaño más pequeño
      
//     //   await SunmiPrinter.printRow(cols: [
//     //     ColumnMaker(
//     //       text: item['descripcion']?.toString() ?? 'N/A',
//     //       width: 12,
//     //       align: SunmiPrintAlign.LEFT,
//     //     ),
//     //   ]);

    

//     //   // Imprimir las otras columnas con el tamaño de fuente normal
//     //   await SunmiPrinter.printRow(cols: [
//     //     ColumnMaker(
//     //       text: item['cantidad']?.toString() ?? '0',
//     //       width: 6,
//     //       align: SunmiPrintAlign.CENTER,
//     //     ),
//     //     ColumnMaker(
//     //       text: item['valorUnitario']?.toString() ?? '0',
//     //       width: 6,
//     //       align: SunmiPrintAlign.RIGHT,
//     //     ),
//     //     ColumnMaker(
//     //       text: item['precioSubTotalProducto']?.toString() ?? '0',
//     //       width: 6,
//     //       align: SunmiPrintAlign.RIGHT,
//     //     ),
//     //   ]);
//     // }
//   for  (var item in productos) {
//       await SunmiPrinter.printRow(cols: [
//         ColumnMaker(
//           text: item['descripcion']?.toString() ?? 'N/A',
//           width: 12,
//           align: SunmiPrintAlign.LEFT,
          
//         ),
//         ColumnMaker(
//           text: item['cantidad']?.toString() ?? '0',
//           width: 6,
//           align: SunmiPrintAlign.CENTER,
//         ),
//         ColumnMaker(
//           text: item['valorUnitario']?.toString() ?? '0',
//           width: 6,
//           align: SunmiPrintAlign.RIGHT,
//         ),
//         ColumnMaker(
//           text: item['precioSubTotalProducto']?.toString() ?? '0',
//           width: 6,
//           align: SunmiPrintAlign.RIGHT,
//         ),
//       ]);
//     }
//   } else {
//     // Manejo de caso en el que 'venProductos' es nulo o no es una lista
//     await SunmiPrinter.printText('No hay productos para mostrar.');
//   }
//   // Restaurar el tamaño de la fuente por defecto para las otras columnas
//       // await SunmiPrinter.resetFontSize();
//   // Imprime el subtotal
//   await SunmiPrinter.line();
//   await SunmiPrinter.printRow(cols: [
//     ColumnMaker(
//       text: 'SubTotal',
//       width: 20, // Ajuste el ancho si es necesario
//       align: SunmiPrintAlign.LEFT,
//     ),
//     ColumnMaker(
//       text: _info['venSubTotal']?.toString() ?? '0',
//       width: 10, // Aumenta el ancho para números más grandes
//       align: SunmiPrintAlign.RIGHT,
//     ),
//   ]);

//   // Imprime el IVA
//   await SunmiPrinter.printRow(cols: [
//     ColumnMaker(
//       text: 'Iva',
//       width: 20, // Ajuste el ancho si es necesario
//       align: SunmiPrintAlign.LEFT,
//     ),
//     ColumnMaker(
//       text: _info['venTotalIva']?.toString() ?? '0',
//       width: 10, // Aumenta el ancho para números más grandes
//       align: SunmiPrintAlign.RIGHT,
//     ),
//   ]);

//   // Imprime el total
//   await SunmiPrinter.printRow(cols: [
//     ColumnMaker(
//       text: 'TOTAL',
//       width: 20, // Ajuste el ancho si es necesario
//       align: SunmiPrintAlign.LEFT,
//     ),
//     ColumnMaker(
//       text: _info['venTotal']?.toString() ?? '0',
//       width: 10, // Aumenta el ancho para números más grandes
//       align: SunmiPrintAlign.RIGHT,
//     ),
//   ]);

//   await SunmiPrinter.line();
//   await SunmiPrinter.lineWrap(2);
//   await SunmiPrinter.exitTransactionPrint(true);
// }




// void _printTicket(Map<String, dynamic>? _info,String? user) async {
//   if (_info == null) return;

//   //==============================================//
//   String utcDate = _info['cajaFecReg'];

//   // Parsear la fecha en UTC
//   DateTime dateTimeUtc = DateTime.parse(utcDate);

//   // Convertirla a hora local
//   DateTime dateTimeLocal = dateTimeUtc.toLocal();

//   // Formatear la fecha y hora local como 'YYYY-MM-DD HH:MM'
//   String formattedDate = DateFormat('yyyy-MM-dd HH:mm').format(dateTimeLocal);

//   // print(formattedDate);  // Resultado: 2024-09-18 19:27

//  //==============================================//
 


// // Función principal de impresión

//   // Imprime el logo (si existe)
//   if (user!.isNotEmpty) {
//     String url = user;
    
//     // Convertir la imagen a formato Uint8List
//     Uint8List byte = (await NetworkAssetBundle(Uri.parse(url)).load(url))
//         .buffer
//         .asUint8List();

//     // Decodificar la imagen
//     img.Image? originalImage = img.decodeImage(byte);

//     if (originalImage != null) {
//       // Redimensionar la imagen (ajusta width y height según tus necesidades)
//       img.Image resizedImage = img.copyResize(originalImage, width: 150, height: 150);

//       // Convertir la imagen redimensionada de vuelta a Uint8List
//       Uint8List resizedByte = Uint8List.fromList(img.encodePng(resizedImage));

//       // Alinear la imagen y comenzar la transacción de impresión
//       await SunmiPrinter.setAlignment(SunmiPrintAlign.CENTER);
//       await SunmiPrinter.printImage(resizedByte);

//       // Agregar un salto de línea para asegurar que el texto se imprima debajo
//       await SunmiPrinter.lineWrap(2); // Esto asegura que haya espacio debajo del logo
//     }
//   } else {
//     // Si no hay logo, imprimir el texto "NO LOGO"
//     await SunmiPrinter.printText('NO LOGO');
//     await SunmiPrinter.lineWrap(1); // Saltar una línea para separación
//   }




// //   // Imprime el resto de la información 
// //   await SunmiPrinter.setAlignment(SunmiPrintAlign.LEFT);
// //    await SunmiPrinter.printText('Id: ${_info['cajaId']}');
// //   await SunmiPrinter.printText('Número: ${_info['cajaNumero']}');
// //    await SunmiPrinter.printText('Tipo: ${_info['cajaTipoCaja']}');
// //     await SunmiPrinter.printText('Documeto: ${_info['cajaTipoDocumento']}');
// //   await SunmiPrinter.line();
// //   await SunmiPrinter.printText('Fecha: ${_info['venFechaFactura']}'); // O utiliza formattedDate si corresponde
// //  await SunmiPrinter.line();
// //   await SunmiPrinter.printText('Ingreso: ${_info['cajaIngreso']}');
// //   await SunmiPrinter.printText('Egreso: ${_info['cajaEgreso']}');
// //    await SunmiPrinter.printText('Crédito: ${_info['cajaCredito']}');
// //   await SunmiPrinter.printText('Monto: ${_info['cajaMonto']}');
// //    await SunmiPrinter.line();
// //   await SunmiPrinter.printText('Autorización: ${_info['cajaAutorizacion']}');
// //  await SunmiPrinter.printText('Detalle: ${_info['cajaDetalle']}');


// // Imprime el resto de la información 
// await SunmiPrinter.setAlignment(SunmiPrintAlign.LEFT);
// await SunmiPrinter.printText('Id: ${validarCampo(_info['cajaId'])}');
// await SunmiPrinter.printText('Número: ${validarCampo(_info['cajaNumero'])}');
// await SunmiPrinter.printText('Tipo: ${validarCampo(_info['cajaTipoCaja'])}');
// await SunmiPrinter.printText('Documento: ${validarCampo(_info['cajaTipoDocumento'])}');
// await SunmiPrinter.line();
// await SunmiPrinter.printText('Fecha: ${_info['venFechaFactura']}');
// await SunmiPrinter.line();
// await SunmiPrinter.printText('Ingreso: ${validarCampo(_info['cajaIngreso'])}');
// await SunmiPrinter.printText('Egreso: ${validarCampo(_info['cajaEgreso'])}');
// await SunmiPrinter.printText('Crédito: ${validarCampo(_info['cajaCredito'])}');
// await SunmiPrinter.printText('Monto: ${validarCampo(_info['cajaMonto'])}');
// await SunmiPrinter.line();
// await SunmiPrinter.printText('Autorización: ${validarCampo(_info['cajaAutorizacion'])}');
// await SunmiPrinter.printText('Detalle: ${validarCampo(_info['cajaDetalle'])}');

//   await SunmiPrinter.lineWrap(2);
//   await SunmiPrinter.exitTransactionPrint(true);
// }

// // Función para validar si una propiedad es null
// String validarCampo(dynamic valor) {
//   return valor == null || valor.toString().isEmpty ? '--- --- ---' : valor.toString();
// }


void _printTicket(Map<String, dynamic>? _info,String? user) async {
  if (_info == null) return;


  //==============================================//
  String fechaLocal = convertirFechaLocal(_info['cajaFecReg']);
 //==============================================//
 


// Función principal de impresión

  // Imprime el logo (si existe)
  if (user!.isNotEmpty) {
    String url = user;
    
    // Convertir la imagen a formato Uint8List
    Uint8List byte = (await NetworkAssetBundle(Uri.parse(url)).load(url))
        .buffer
        .asUint8List();

    // Decodificar la imagen
    img.Image? originalImage = img.decodeImage(byte);

    if (originalImage != null) {
      // Redimensionar la imagen (ajusta width y height según tus necesidades)
      img.Image resizedImage = img.copyResize(originalImage, width: 150, height: 150);

      // Convertir la imagen redimensionada de vuelta a Uint8List
      Uint8List resizedByte = Uint8List.fromList(img.encodePng(resizedImage));

      // Alinear la imagen y comenzar la transacción de impresión
      await SunmiPrinter.setAlignment(SunmiPrintAlign.CENTER);
      await SunmiPrinter.printImage(resizedByte);

      // Agregar un salto de línea para asegurar que el texto se imprima debajo
      await SunmiPrinter.lineWrap(2); // Esto asegura que haya espacio debajo del logo
    }
  } else {
    // Si no hay logo, imprimir el texto "NO LOGO"
    await SunmiPrinter.printText('NO LOGO');
    await SunmiPrinter.lineWrap(1); // Saltar una línea para separación
  }




//   // Imprime el resto de la información 
//   await SunmiPrinter.setAlignment(SunmiPrintAlign.LEFT);
//    await SunmiPrinter.printText('Id: ${_info['cajaId']}');
//   await SunmiPrinter.printText('Número: ${_info['cajaNumero']}');
//    await SunmiPrinter.printText('Tipo: ${_info['cajaTipoCaja']}');
//     await SunmiPrinter.printText('Documeto: ${_info['cajaTipoDocumento']}');
//   await SunmiPrinter.line();
//   await SunmiPrinter.printText('Fecha: ${_info['venFechaFactura']}'); // O utiliza formattedDate si corresponde
//  await SunmiPrinter.line();
//   await SunmiPrinter.printText('Ingreso: ${_info['cajaIngreso']}');
//   await SunmiPrinter.printText('Egreso: ${_info['cajaEgreso']}');
//    await SunmiPrinter.printText('Crédito: ${_info['cajaCredito']}');
//   await SunmiPrinter.printText('Monto: ${_info['cajaMonto']}');
//    await SunmiPrinter.line();
//   await SunmiPrinter.printText('Autorización: ${_info['cajaAutorizacion']}');
//  await SunmiPrinter.printText('Detalle: ${_info['cajaDetalle']}');


// Imprime el resto de la información 
await SunmiPrinter.setAlignment(SunmiPrintAlign.LEFT);
await SunmiPrinter.printText('Id: ${validarCampo(_info['cajaId'])}');
await SunmiPrinter.printText('Número: ${validarCampo(_info['cajaNumero'])}');
await SunmiPrinter.printText('Tipo: ${validarCampo(_info['cajaTipoCaja'])}');
await SunmiPrinter.printText('Documento: ${validarCampo(_info['cajaTipoDocumento'])}');
await SunmiPrinter.line();
await SunmiPrinter.printText('Fecha: $fechaLocal'); // O utiliza formattedDate si corresponde
await SunmiPrinter.line();
await SunmiPrinter.printText('Ingreso: ${validarCampo(_info['cajaIngreso'])}');
await SunmiPrinter.printText('Egreso: ${validarCampo(_info['cajaEgreso'])}');
await SunmiPrinter.printText('Crédito: ${validarCampo(_info['cajaCredito'])}');
await SunmiPrinter.printText('Monto: ${validarCampo(_info['cajaMonto'])}');
await SunmiPrinter.line();
await SunmiPrinter.printText('Autorización: ${validarCampo(_info['cajaAutorizacion'])}');
await SunmiPrinter.printText('Detalle: ${validarCampo(_info['cajaDetalle'])}');
await SunmiPrinter.line();
  await SunmiPrinter.lineWrap(2);
  await SunmiPrinter.exitTransactionPrint(true);
}

// Función para validar si una propiedad es null
String validarCampo(dynamic valor) {
  return valor == null || valor.toString().isEmpty ? '--- --- ---' : valor.toString();
}





}