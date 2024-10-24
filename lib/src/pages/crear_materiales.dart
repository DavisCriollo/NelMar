import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:neitorcont/src/controllers/caja_controller.dart';
import 'package:neitorcont/src/controllers/comprobantes_controller.dart';
import 'package:neitorcont/src/controllers/cuentas_por_cobrar_controller.dart';
import 'package:neitorcont/src/pages/buscar_productos_varios.dart';
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

import '../models/sesison_model.dart';
import 'package:image/image.dart' as img;


class CrearMateriales extends StatefulWidget {
     final String? tipo;
 
   final Session? user;

  const CrearMateriales({Key? key, this.tipo, this.user}) : super(key: key);


  @override
  State<CrearMateriales> createState() => _CrearMaterialesState();
}

class _CrearMaterialesState extends State<CrearMateriales> {


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
  Widget build(BuildContext context) {
     final Responsive size = Responsive.of(context);
    final ctrl = context.read<CuentasXCobrarController>();
    final ctrlTheme = context.read<ThemeProvider>();
    return GestureDetector(
       onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
         appBar: AppBar(
            title: widget.tipo == 'CREATE' 
                ? Text('Agregar Materiales')
                : Text('Editar Materiales'),
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
            physics: const BouncingScrollPhysics(),
            child: Form(
               key: ctrl.materialesFormKey,
              child: Column(
                children: [

                      //**********************SE MUESTRA LA OPCION DE IMPRIMIR *************************//
                        Consumer<SocketService>(
        builder: (_,value, __) {

     return 
         value.latestResponseVentas!.isNotEmpty 
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

                      

                    _printTicket(value.latestResponseVentas,widget.user!.logo);

                      //========================================//
                        ctrl.setFormaDePago('EFECTIVO');
                                ctrl.setTipoDeTransaccion('D');



             

              ctrl.createMaterial(context,ctrl.getRespuestaCalculoItem);

                           ctrl.resetValorTotal();
                           ctrl.buscaAllMaterialesPaginacion('',false,0);
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
                        // width: size.wScreen(100.0),
            
                        // color: Colors.blue,
                        child: Text('Placa :  ',
                            style: GoogleFonts.lexendDeca(
                                fontSize: size.iScreen(2.0),
                                fontWeight: FontWeight.normal,
                                color: Colors.grey)),
                      ),
                   Row(
                     children: [
                       SizedBox(
                          width: size.iScreen(20.0),
                          child: 
                             TextFormField(
                          inputFormatters: [
                            UpperCaseText(),
                          ],
                          decoration: InputDecoration(
                          
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
                      ctrl.setPlaca(text);
                    },
                    validator: (text) {
                      if (text!.trim().isNotEmpty) {
                        return null;
                      } else {
                        return 'Ingrese nombre de Conductor';
                      }
                    },



                        ),
                       
                        ),
                    
                     ],
                   ),
                 
                  
                  
                    ],
                  ),
 //***********************************************/
                  SizedBox(
                    height: size.iScreen(1.0),
                  ),
                  //*****************************************/


                  Container(
                    width: size.iScreen(100),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // TextField(
                        //   decoration: InputDecoration(
                        //     hintText: 'RUC/CI CONDUCTOR', // Texto de sugerencia dentro del campo
                        //     // border: OutlineInputBorder(), // Opcional: Añade un borde al campo
                        //   ),
                        //    textAlign: TextAlign.center,
                        // ),
                    //     TextFormField(
                    //       inputFormatters: [
                    //         UpperCaseText(),
                    //       ],
                    //       decoration: InputDecoration(
                    //         label:  const Text( 'Nombre Conductor'),
                    //         // Texto de sugerencia dentro del campo
                    //         // border: OutlineInputBorder(), // Opcional: Añade un borde al campo
                    //         helperStyle: TextStyle(color: Colors.grey.shade50),
                    //       ),
                    //       style: TextStyle(
                    //         fontSize:
                    //             size.iScreen(2.3), // Ajusta el tamaño de la letra
                    //         // fontWeight: FontWeight.bold, // Opcional: Aplica un peso de fuente más grueso
                    //       ),
                    //       textAlign: TextAlign.left,
                    //     onChanged: (text) {
                    //   ctrl.setNombreConductor(text);
                    // },
                    // validator: (text) {
                    //   if (text!.trim().isNotEmpty) {
                    //     return null;
                    //   } else {
                    //     return 'Ingrese nombre de Conductor';
                    //   }
                    // },
                    Consumer<CuentasXCobrarController>(
  builder: (context, provider, child) {
    return TextFormField(
      initialValue: provider.getClienteComprobante['perNombre'], // Carga inicial desde el Provider
      inputFormatters: [
        UpperCaseText(),
      ],
      decoration: InputDecoration(
        label: const Text('Nombre Conductor'),
        helperStyle: TextStyle(color: Colors.grey.shade50),
      ),
      style: TextStyle(
        fontSize: size.iScreen(2.3), // Ajusta el tamaño de la letra
      ),
      textAlign: TextAlign.left,
      onChanged: (text) {
        provider.setNombreConductor(text); // Actualiza el valor en el Provider
      },
      validator: (text) {
        if (text!.trim().isNotEmpty) {
          return null;
        } else {
          return 'Ingrese nombre de Conductor';
        }
      },
    );
  },





                        ),
                      ],
                    ),
                  ),
                  //***********************************************/
                  SizedBox(
                    height: size.iScreen(1.0),
                  ),
                  //*****************************************/
                
                  Container(
                    width: size.iScreen(100),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // TextField(
                        //   decoration: InputDecoration(
                        //     hintText: 'RUC/CI CONDUCTOR', // Texto de sugerencia dentro del campo
                        //     // border: OutlineInputBorder(), // Opcional: Añade un borde al campo
                        //   ),
                        //    textAlign: TextAlign.center,
                        // ),
                        TextFormField(
                          minLines: 1,
                          maxLines: 3,
                          inputFormatters: [
                            UpperCaseText(),
                          ],
                          decoration: InputDecoration(
                            label:  const Text( 'Destino'),
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
                      ctrl.setDestino(text);
                    },
                    validator: (text) {
                      if (text!.trim().isNotEmpty) {
                        return null;
                      } else {
                        return 'Ingrese Destino';
                      }
                    },



                        ),
                      ],
                    ),
                  ),
                  //***********************************************/
                  SizedBox(
                    height: size.iScreen(1.0),
                  ),
                  //*****************************************/

                     //***********************************************/
                  SizedBox(
                    height: size.iScreen(1.5),
                  ),
                  //*****************************************/
                  Row(
                    children: [
                      SizedBox(
                        // width: size.wScreen(100.0),
            
                        // color: Colors.blue,
                        child: Text('TARIFAS POR PASADA ',
                            style: GoogleFonts.lexendDeca(
                                fontSize: size.iScreen(2.0),
                                fontWeight: FontWeight.normal,
                                color: Colors.grey)),
                      ),
                      
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: GestureDetector(
                          onTap: () {
                                  //******************************************//
                                   final _ctrl= context.read<ComprobantesController>();
                                  
  // __ctrl.setExistCliente(true);
   _ctrl.setTotal();
   _ctrl.setTarifa({});
  //  _ctrl.setTipoDocumento('');
    _ctrl.setPrecio(0);
                         
   _ctrl.setTypeAction('MATERIALES');


 //******************************************//
                                 _ctrl.setCantidad(1);
                            _ctrl.buscaAllProductos( _ctrl.getTypeAction.toString());
            
                            // // _buscarMascota(context, size);
            
             Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      const BuscarProductosVarios()));
            
                            // modalTarifas(context, size, ctrl);
            
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
            
                      //  Spacer(),
                    ],
                  ),
                  // //***********************************************/
                  // SizedBox(
                  //   height: size.iScreen(1.0),
                  // ),
                  // //*****************************************/
            
                  // Consumer<ComprobantesController>(
                  //   builder: (_, valueTipo, __) {
                  //     return Container(
                  //       // color: Colors.red,
                  //       width: size.wScreen(100.0),
            
                  //       // color: Colors.blue,
                  //       child: Text(
                  //           valueTipo.tipoTarifa.isEmpty
                  //               ? ''
                  //               : ' ${valueTipo.tipoTarifa['tipo']} - \$${valueTipo.tipoTarifa['valor']}',
                  //           style: GoogleFonts.lexendDeca(
                  //               fontSize: size.iScreen(2.5),
                  //               fontWeight: FontWeight.normal,
                  //               color: valueTipo.tipoTarifa.isEmpty
                  //                   ? Colors.grey
                  //                   : Colors.black)),
                  //     );
                  //   },
                  // ),
            
                          Consumer<ComprobantesController>(builder: (_, value, __) { 
                  return  
                  value.getRespuestaCalculoItem.isNotEmpty
                 ? Wrap(
                  children: value.getRespuestaCalculoItem['venProductos']
                      .map<Widget>(
                        (e) => 
                       e['descripcion'].isEmpty?Container(): Card(
                               child: ListTile(
                                 visualDensity: VisualDensity.compact,
                                 title: Text(
                                   '${e['descripcion']}',
                                   style: GoogleFonts.lexendDeca(
                                       fontSize: size.iScreen(1.8),
                                       // color: Colors.black54,
                                       fontWeight: FontWeight.normal),
                                 ),
                                 subtitle: 
                                 Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                   children: [
                                       Row(
                                   children: [
                                     Text(
                                      'Cantidad ',
                                       style: GoogleFonts.lexendDeca(
                                           fontSize: size.iScreen(1.5),
                                           // color: Colors.black54,
                                           fontWeight: FontWeight.normal),
                                     ),
                                     Text(
                                      ' ${e['cantidad']}',
                                       style: GoogleFonts.lexendDeca(
                                           fontSize: size.iScreen(2.3),
                                           
                                           fontWeight: FontWeight.bold),
                                     ),
                                   ],
                                 ),
                                     Row(
                                       children: [
                                         Text(
                                          'Valor Unitario: ',
                                           style: GoogleFonts.lexendDeca(
                                               fontSize: size.iScreen(1.5),
                                               // color: Colors.black54,
                                               fontWeight: FontWeight.normal),
                                         ),
                                          Text(
                                          ' \$ ${e['valorUnitario']}',
                                           style: GoogleFonts.lexendDeca(
                                               fontSize: size.iScreen(2.3),
                                               color: Colors.black,
                                               fontWeight: FontWeight.bold),
                                         ),
                                       ],
                                     ),
                                     
                                   ],
                                 ),
                                //  trailing: 
                                //  Column(
                                //    children: [
                                //      Text(
                                //       'Cantidad',
                                //        style: GoogleFonts.lexendDeca(
                                //            fontSize: size.iScreen(1.5),
                                //            // color: Colors.black54,
                                //            fontWeight: FontWeight.normal),
                                //      ),
                                //      Text(
                                //       '${e['cantidad']}',
                                //        style: GoogleFonts.lexendDeca(
                                //            fontSize: size.iScreen(2.3),
                                //            color:ctrlTheme.appTheme.primaryColor,
                                //            fontWeight: FontWeight.normal),
                                //      ),
                                //    ],
                                //  ),
                                 // provider.getListaDeProductos.isNotEmpty
                                 // ?Wrap(children: producto['invprecios'].map<Widget>((e) =>  Text(
                                 //   '${e}',
                                 //   style: GoogleFonts.lexendDeca(
                                 //       fontSize: size.iScreen(1.7),
                                 //       // color: Colors.black54,
                                 //       fontWeight: FontWeight.normal),
                                 // )).toList(),
                                 // ):Text(
                                 //   '--- --- ---',
                                 //   style: GoogleFonts.lexendDeca(
                                 //       fontSize: size.iScreen(1.8),
                                 //       // color: Colors.black54,
                                 //       fontWeight: FontWeight.normal),
                                 // ),
                                 onTap: () {
                                   value.deleteItem(e);
            
            
                                  
                                  
                                  
                                  
                                 },
                               ),
                             ),
                      )
                      .toList(),
                ):Container();
                
                 },),
                 
                 //***********************************************/
                  SizedBox(
                    height: size.iScreen(1.0),
                  ),
                  //*****************************************/
            
                     
            
                  Container(
                    width: size.wScreen(100),
                    margin: EdgeInsets.only(right: size.iScreen(1.0)),
                  
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                         
         
           
                        Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                         
                          children: [
                            Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Container(
                                      width: size.iScreen(10.0),
            
                                      // color: Colors.blue,
                                      child: Text('SubTotal: ',
                                          style: GoogleFonts.lexendDeca(
                                              fontSize: size.iScreen(2.0),
                                              fontWeight: FontWeight.normal,
                                              color: Colors.grey), textAlign: TextAlign.right,),
                                    ),
                                    Consumer<ComprobantesController>(
                                  builder: (_, valueSubTotal, __) {
                                    return Text(valueSubTotal.getRespuestaCalculoItem['venSubTotal']==null?' 0.00':' \$ ${valueSubTotal.getRespuestaCalculoItem['venSubTotal']}',
                                        style: GoogleFonts.lexendDeca(
                                            fontSize: size.iScreen(2.0),
                                            fontWeight: FontWeight.bold,
                                            
                                            ));
                                  },
                                ),
                                  ],
                                ),
                                 Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                   Container(
                                      width: size.iScreen(9.0),
            
                                      // color: Colors.blue,
                                      child: Text('Iva: ',
                                          style: GoogleFonts.lexendDeca(
                                              fontSize: size.iScreen(2.0),
                                              fontWeight: FontWeight.normal,
                                              color: Colors.grey), textAlign: TextAlign.right,),
                                    ),
                                    Consumer<ComprobantesController>(
                                  builder: (_, valueIvaTotal, __) {
                                    return Text(valueIvaTotal.getRespuestaCalculoItem['venTotalIva']==null?'  0.00':' \$ ${valueIvaTotal.getRespuestaCalculoItem['venTotalIva']}',
                                        style: GoogleFonts.lexendDeca(
                                            fontSize: size.iScreen(2.0),
                                            fontWeight: FontWeight.bold,
                                            ));
                                  },
                                ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Container(
                                  width: size.iScreen(11.0),
            
                                      // color: Colors.blue,
                                      child: Text('Total: ',
                                          style: GoogleFonts.lexendDeca(
                                              fontSize: size.iScreen(2.5),
                                              fontWeight: FontWeight.normal,
                                              color: Colors.grey),
                                              textAlign: TextAlign.right,),
                                    ),
                                    Consumer<ComprobantesController>(
                                  builder: (_, valueTotal, __) {
                                    return Text(valueTotal.getRespuestaCalculoItem['venTotal']==null?' 0.00':' \$ ${valueTotal.getRespuestaCalculoItem['venTotal']}',
                                        style: GoogleFonts.lexendDeca(
                                            fontSize: size.iScreen(2.5),
                                            fontWeight: FontWeight.bold,
                                           ));
                                  },
                                ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                
                  //***********************************************/
                  SizedBox(
                    height: size.iScreen(3.0),
                  ),
                  //*****************************************/






                  //*****************************************/

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
    CuentasXCobrarController controller,
  ) async {
    final isValid = controller.validateForm();
    if (!isValid) return;
    if (isValid) {

        
  final _ctrl=context.read<ComprobantesController>();

 

      if (controller.getPlaca.isEmpty) {
        NotificatiosnService.showSnackBarDanger('Debe agregar Placa');
      }else if (controller.getNombreConductor.isEmpty) {
        NotificatiosnService.showSnackBarDanger('Debe agregar Conductor');
      }else if (controller.getDestino.isEmpty) {
        NotificatiosnService.showSnackBarDanger('Debe agregar Destino');
      }else if (_ctrl.getRespuestaCalculoItem.isEmpty) {
        NotificatiosnService.showSnackBarDanger('Debe agregar Material');
      }
      else{
          
        

               controller.setFormaDePago('EFECTIVO');
                                controller.setTipoDeTransaccion('D');



             

              controller.createMaterial(context,_ctrl.getRespuestaCalculoItem);

                           controller.resetValorTotal();
                           controller.buscaAllMaterialesPaginacion('',false,0);
                            
                            // Navigator.pop(context);
                               


      }

    }
  }


// void _printTickets(Map<String, dynamic>? _info,String? user) async {
//   if (_info == null) return;
//      NotificatiosnService.showSnackBarDanger('LA INFO :$_info');
//  print('LA INFO :$_info');
//   //==============================================//
//   String fechaLocal = convertirFechaLocal(_info['venFecReg']);
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
// await SunmiPrinter.printText('Fecha: $fechaLocal'); // O utiliza formattedDate si corresponde
// await SunmiPrinter.line();
// await SunmiPrinter.printText('Ingreso: ${validarCampo(_info['cajaIngreso'])}');
// await SunmiPrinter.printText('Egreso: ${validarCampo(_info['cajaEgreso'])}');
// await SunmiPrinter.printText('Crédito: ${validarCampo(_info['cajaCredito'])}');
// await SunmiPrinter.printText('Monto: ${validarCampo(_info['cajaMonto'])}');
// await SunmiPrinter.line();
// await SunmiPrinter.printText('Autorización: ${validarCampo(_info['cajaAutorizacion'])}');
// await SunmiPrinter.printText('Detalle: ${validarCampo(_info['cajaDetalle'])}');
// await SunmiPrinter.line();
//   await SunmiPrinter.lineWrap(2);
//   await SunmiPrinter.exitTransactionPrint(true);
// }






void _printTicket(Map<String, dynamic>? _info,String? user) async {
  if (_info == null) return;


  //==============================================//
  String fechaLocal = convertirFechaLocal(_info['venFecReg']);
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

  // Imprime el resto de la información del encabezado
  await SunmiPrinter.setAlignment(SunmiPrintAlign.LEFT);
  await SunmiPrinter.printText('Ruc: ${_info['venEmpRuc']}');
  await SunmiPrinter.printText('Dir: ${_info['venEmpDireccion']}');
  await SunmiPrinter.printText('Tel: ${_info['venEmpTelefono']}');
  await SunmiPrinter.printText('Email: ${_info['venEmpEmail']}');

  await SunmiPrinter.line();
  await SunmiPrinter.printText('Cliente: ${_info['venNomCliente']}');
  await SunmiPrinter.printText('Ruc: ${_info['venRucCliente']}');
 await SunmiPrinter.line();
  await SunmiPrinter.printText('Fecha: $fechaLocal'); // O utiliza formattedDate si corresponde
 await SunmiPrinter.line();
  await SunmiPrinter.printText('Conductor: ${_info['venConductor']}');
  await SunmiPrinter.printText('Placa: ${_info['venOtrosDetalles'][0]}');
  // Imprime el encabezado de la tabla
  await SunmiPrinter.setAlignment(SunmiPrintAlign.LEFT);
  await SunmiPrinter.line();
  await SunmiPrinter.printRow(cols: [
    ColumnMaker(
      text: 'Descripción',
      width: 12,
      align: SunmiPrintAlign.LEFT,
    ),
    ColumnMaker(
      text: 'Cant',
      width: 6,
      align: SunmiPrintAlign.CENTER,
    ),
    ColumnMaker(
      text: 'vU',
      width: 6,
      align: SunmiPrintAlign.RIGHT,
    ),
    ColumnMaker(
      text: 'TOT',
      width: 6,
      align: SunmiPrintAlign.RIGHT,
    ),
  ]);

  // Imprime cada ítem en la lista
  final productos = _info['venProductos'] as List<dynamic>?;

  if (productos != null) {
    // for (var item in productos) {
    //   // Cambiar el tamaño de la fuente solo para la columna de descripción
    //   // await SunmiPrinter.setFontSize(SunmiFontSize.SM); // Ajustar a un tamaño más pequeño
      
    //   await SunmiPrinter.printRow(cols: [
    //     ColumnMaker(
    //       text: item['descripcion']?.toString() ?? 'N/A',
    //       width: 12,
    //       align: SunmiPrintAlign.LEFT,
    //     ),
    //   ]);

    

    //   // Imprimir las otras columnas con el tamaño de fuente normal
    //   await SunmiPrinter.printRow(cols: [
    //     ColumnMaker(
    //       text: item['cantidad']?.toString() ?? '0',
    //       width: 6,
    //       align: SunmiPrintAlign.CENTER,
    //     ),
    //     ColumnMaker(
    //       text: item['valorUnitario']?.toString() ?? '0',
    //       width: 6,
    //       align: SunmiPrintAlign.RIGHT,
    //     ),
    //     ColumnMaker(
    //       text: item['precioSubTotalProducto']?.toString() ?? '0',
    //       width: 6,
    //       align: SunmiPrintAlign.RIGHT,
    //     ),
    //   ]);
    // }
  for  (var item in productos) {
      await SunmiPrinter.printRow(cols: [
        ColumnMaker(
          text: item['descripcion']?.toString() ?? 'N/A',
          width: 12,
          align: SunmiPrintAlign.LEFT,
          
        ),
        ColumnMaker(
          text: item['cantidad']?.toString() ?? '0',
          width: 6,
          align: SunmiPrintAlign.CENTER,
        ),
        ColumnMaker(
          text: item['valorUnitario']?.toString() ?? '0',
          width: 6,
          align: SunmiPrintAlign.RIGHT,
        ),
        ColumnMaker(
          text: item['precioSubTotalProducto']?.toString() ?? '0',
          width: 6,
          align: SunmiPrintAlign.RIGHT,
        ),
      ]);
    }
  } else {
    // Manejo de caso en el que 'venProductos' es nulo o no es una lista
    await SunmiPrinter.printText('No hay productos para mostrar.');
  }
  // Restaurar el tamaño de la fuente por defecto para las otras columnas
      // await SunmiPrinter.resetFontSize();
  // Imprime el subtotal
  await SunmiPrinter.line();
  await SunmiPrinter.printRow(cols: [
    ColumnMaker(
      text: 'SubTotal',
      width: 20, // Ajuste el ancho si es necesario
      align: SunmiPrintAlign.LEFT,
    ),
    ColumnMaker(
      text: _info['venSubTotal']?.toString() ?? '0',
      width: 10, // Aumenta el ancho para números más grandes
      align: SunmiPrintAlign.RIGHT,
    ),
  ]);

  // Imprime el IVA
  await SunmiPrinter.printRow(cols: [
    ColumnMaker(
      text: 'Iva',
      width: 20, // Ajuste el ancho si es necesario
      align: SunmiPrintAlign.LEFT,
    ),
    ColumnMaker(
      text: _info['venTotalIva']?.toString() ?? '0',
      width: 10, // Aumenta el ancho para números más grandes
      align: SunmiPrintAlign.RIGHT,
    ),
  ]);

  // Imprime el total
  await SunmiPrinter.printRow(cols: [
    ColumnMaker(
      text: 'TOTAL',
      width: 20, // Ajuste el ancho si es necesario
      align: SunmiPrintAlign.LEFT,
    ),
    ColumnMaker(
      text: _info['venTotal']?.toString() ?? '0',
      width: 10, // Aumenta el ancho para números más grandes
      align: SunmiPrintAlign.RIGHT,
    ),
  ]);

  await SunmiPrinter.line();
  await SunmiPrinter.lineWrap(2);
  await SunmiPrinter.exitTransactionPrint(true);
}



// Función para validar si una propiedad es null
String validarCampo(dynamic valor) {
  return valor == null || valor.toString().isEmpty ? '--- --- ---' : valor.toString();
}



}