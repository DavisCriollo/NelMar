// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:neitorcont/src/api/api_provider.dart';
// import 'package:neitorcont/src/controllers/comprobantes_controller.dart';
// import 'package:neitorcont/src/controllers/facturas_controller.dart';
// import 'package:neitorcont/src/controllers/home_controller.dart';
// import 'package:neitorcont/src/controllers/prefacturas_controller.dart';
// import 'package:neitorcont/src/controllers/proformas_controller.dart';
// import 'package:neitorcont/src/controllers/propietarios_controller.dart';
// import 'package:neitorcont/src/models/sesison_model.dart';
// import 'package:neitorcont/src/pages/buscar_productos_varios.dart';
// import 'package:neitorcont/src/pages/crear_propietario.dart';
// import 'package:neitorcont/src/pages/print.dart';
// import 'package:neitorcont/src/services/notifications_service.dart';
// import 'package:neitorcont/src/services/socket_service.dart';
// import 'package:neitorcont/src/theme/theme_provider.dart';
// import 'package:neitorcont/src/utils/dialogs.dart';
// import 'package:neitorcont/src/utils/letras_mayusculas_minusculas.dart';
// import 'package:neitorcont/src/utils/responsive.dart';
// import 'package:neitorcont/src/utils/solo_decimales.dart';
// import 'package:neitorcont/src/utils/valida_email.dart';
// import 'package:neitorcont/src/widgets/no_data.dart';
// import 'package:provider/provider.dart';
// import 'package:sunmi_printer_plus/column_maker.dart';
// import 'package:sunmi_printer_plus/enums.dart';
// import 'package:sunmi_printer_plus/sunmi_printer_plus.dart';

// class CrearComprobante extends StatefulWidget {

//   final String? tipo;
 
//    final Session? user;
//   const CrearComprobante({Key? key, this.tipo, this.user,}) : super(key: key);

//   @override
//   State<CrearComprobante> createState() => _CrearComprobanteState();
// }

// class _CrearComprobanteState extends State<CrearComprobante> {
//   final TextEditingController _rucCliController = TextEditingController();
//   final TextEditingController _rucChofController = TextEditingController();

//   TextEditingController _controller = TextEditingController();
//    TextEditingController _textAddPlaca = TextEditingController();
//   TextEditingController _textAddCorreo = TextEditingController();


// //************  PARTE PARA CONFIGURAR LA IMPRESORA*******************//

// bool printBinded = false;
//   int paperSize = 0;
//   String serialNumber = "";
//   String printerVersion = "";
//   @override
//   void initState() {
//     super.initState();

//     _bindingPrinter().then((bool? isBind) async {
//       SunmiPrinter.paperSize().then((int size) {
//         setState(() {
//           paperSize = size;
//         });
//       });

//       SunmiPrinter.printerVersion().then((String version) {
//         setState(() {
//           printerVersion = version;
//         });
//       });

//       SunmiPrinter.serialNumber().then((String serial) {
//         setState(() {
//           serialNumber = serial;
//         });
//       });

//       setState(() {
//         printBinded = isBind!;
//       });
//     });
//   }

//   /// must binding ur printer at first init in app
//   Future<bool?> _bindingPrinter() async {
//     final bool? result = await SunmiPrinter.bindingPrinter();
//     return result;
//   }

// //***********************************************/



//    @override
//   void dispose() {

//  _rucCliController.dispose();
//    _rucChofController.dispose();

//  _controller.dispose();
//   _textAddPlaca.dispose();
//     _textAddCorreo.dispose();


//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final Responsive size = Responsive.of(context);
//     final ctrl = context.read<ComprobantesController>();
//     final ctrlTheme = context.read<ThemeProvider>();
//     return GestureDetector(
//       onTap: () {
//         FocusScope.of(context).requestFocus(FocusNode());
//       },
//       child: Scaffold(
//         appBar: AppBar(
//           title: widget.tipo == 'CREATE' || widget.tipo == 'SEARCH'
//               ? Text('Crear Comprobante')
//               : Text('Editar Comprobante'),
//           actions: [
//           Consumer<SocketService>(
//             builder: (_,value, __) {
//              return value.latestResponse!.isEmpty 
//             ?Container(
//               margin: EdgeInsets.only(right: size.iScreen(1.5)),
//               child: IconButton(
//                   splashRadius: 28,
//                   onPressed: () {
//                     _onSubmit(
//                       context,
//                       ctrl,
//                     );
//                   },
//                   icon: Icon(
//                     Icons.save_outlined,
//                     size: size.iScreen(4.0),
//                   )),
//             ):Container();

//             // : Container();
//             })
//           ],
//         ),
//         body: Container(
//           color: Colors.white,
//           margin: EdgeInsets.only(
//               left: size.iScreen(1.0),
//               right: size.iScreen(1.0),
//               bottom: size.iScreen(1.0)),
//           width: size.wScreen(100),
//           height: size.hScreen(100),
//           child: SingleChildScrollView(
//             physics: const BouncingScrollPhysics(),
//             child: Form(
//               key: ctrl.comprobantesFormKey,
//               child: Column(
//                 children: [
//                   // //***********************************************/
//                   // SizedBox(
//                   //   height: size.iScreen(1.5),
//                   // ),
//                   // //*****************************************/
//                   // Row(
//                   //   children: [
//                   //     SizedBox(
//                   //       // width: size.wScreen(100.0),
            
//                   //       // color: Colors.blue,
//                   //       child: Text('TIPO CODUMENTO :',
//                   //           style: GoogleFonts.lexendDeca(
//                   //               // fontSize: size.iScreen(2.0),
//                   //               fontWeight: FontWeight.normal,
//                   //               color: Colors.grey)),
//                   //     ),
//                   //     Consumer<ComprobantesController>(
//                   //       builder: (_, valueTipo, __) {
//                   //         return Container(
//                   //           // color: Colors.red,
//                   //           width: size.wScreen(50.0),
            
//                   //           // color: Colors.blue,
//                   //           child: Text(
//                   //               valueTipo.getTipoDocumento.isEmpty
//                   //                   ? ' --- --- --- --- ---'
//                   //                   : ' ${valueTipo.getTipoDocumento}',
//                   //               style: GoogleFonts.lexendDeca(
//                   //                   fontSize: size.iScreen(2.0),
//                   //                   fontWeight: FontWeight.normal,
//                   //                   color: valueTipo.getTipoDocumento.isEmpty
//                   //                       ? Colors.grey
//                   //                       : Colors.black)),
//                   //         );
//                   //       },
//                   //     ),
//                   //     Spacer(),
//                   //     ClipRRect(
//                   //       borderRadius: BorderRadius.circular(8),
//                   //       child: GestureDetector(
//                   //         onTap: () {
//                   //           // context
//                   //           //     .read<MascotasController>()
//                   //           //     .buscaAllMascotas('');
            
//                   //           // // _buscarMascota(context, size);
//                   //           modalTipoDocumento(context, size, ctrl);
            
//                   //           // //*******************************************/
//                   //         },
//                   //         child: Consumer<ThemeProvider>(
//                   //           builder: (_, valueTheme, __) {
//                   //             return Container(
//                   //               alignment: Alignment.center,
//                   //               color: valueTheme.appTheme.primaryColor,
//                   //               width: size.iScreen(3.5),
//                   //               padding: EdgeInsets.only(
//                   //                 top: size.iScreen(0.5),
//                   //                 bottom: size.iScreen(0.5),
//                   //                 left: size.iScreen(0.5),
//                   //                 right: size.iScreen(0.5),
//                   //               ),
//                   //               child: Icon(
//                   //                 Icons.add,
//                   //                 color: Colors.white,
//                   //                 size: size.iScreen(2.0),
//                   //               ),
//                   //             );
//                   //           },
//                   //         ),
//                   //       ),
//                   //     ),
//                   //   ],
//                   // ),


//                   //**********************SE MUESTRA LA OPCION DE IMPRIMIR *************************//
//                         Consumer<SocketService>(
//         builder: (_,value, __) {
//          return 
//          value.latestResponse!.isNotEmpty
//         ? 
//         Container(
//             width: size.wScreen(100.0),
          
//             decoration: BoxDecoration(
//                 color: Colors.grey,
//               borderRadius: BorderRadius.only(
//           bottomLeft: Radius.circular(20.0),
//           bottomRight: Radius.circular(20.0),
//         ),
//             ),
//             child: Column(
//         mainAxisSize: MainAxisSize.min, // Ajusta el tamaño del contenedor según su contenido
//         children: [

//           SizedBox(height:size.iScreen(1.5)), 
//           Text(
//         '¿Desea imprimir factura?',
//         style: GoogleFonts.lexendDeca(
//                               fontWeight: FontWeight.bold,
//                               fontSize: size.iScreen(2.0),
                        
//                             ),
//         textAlign: TextAlign.center,
//           ),
//           SizedBox(width:size.iScreen(1.5)), // Espacio entre el texto y los botones
//           Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//             // SizedBox(width: 20),
            
           
//             ElevatedButton(
//               style: ButtonStyle(
//              // Color negro
                
//               ),
//               onPressed: (){

//                     _printTicket(value.latestResponse);

//                     //========================================//
//                         final _ctrl =context.read<ComprobantesController>();
//                    if (_ctrl.getTipoDeTransaccion=='F') {
//                       //================FACTURAS F ==================//
//                  final _controllerFacturas =
//                             context.read<FacturasController>();

//                         _controllerFacturas
//                             .onSearchTextFacturaPaginacion("");

//                         _controllerFacturas
//                             .setBtnSearchFacturaPaginacion(false);
//                         _controllerFacturas
//                             .setErrorFacturasPaginacion(null);

//                         _controllerFacturas
//                             .setError401FacturasPaginacion(false);

//                         _controllerFacturas.resetFormFacturas();
//                         _controllerFacturas.setPage(0);
//                         _controllerFacturas.setIsNext(false);
//                         _controllerFacturas
//                             .setInfoBusquedaFacturasPaginacion([]);
//                         _controllerFacturas.buscaAllFacturasPaginacion(
//                             '',false,0);
//                    }
//                 if (_ctrl.getTipoDeTransaccion=='N') {
//                 //================PREFACTURAS N ==================//
//                  final _controllerPreFacturas =
//                             context.read<PreFacturasController>();

//                         _controllerPreFacturas
//                             .onSearchTextPreFacturaPaginacion("");

//                         _controllerPreFacturas
//                             .setBtnSearchPreFacturaPaginacion(false);
//                         _controllerPreFacturas
//                             .setErrorPreFacturasPaginacion(null);

//                         _controllerPreFacturas
//                             .setError401PreFacturasPaginacion(false);

//                         _controllerPreFacturas.resetFormPreFacturas();
//                         _controllerPreFacturas.setPage(0);
//                         _controllerPreFacturas.setIsNext(false);
//                         _controllerPreFacturas
//                             .setInfoBusquedaPreFacturasPaginacion([]);
//                         _controllerPreFacturas
//                             .buscaAllPreFacturasPaginacion('', true,0);
//                 }
//                   if (_ctrl.getTipoDeTransaccion=='P') {
//                     //================PROFORMAS P ==================//
//             final _controllerProformas =
//                             context.read<ProformasController>();

//                         _controllerProformas
//                             .onSearchTextProformasPaginacion("");

//                         _controllerProformas
//                             .setBtnSearchProformasPaginacion(false);
//                         _controllerProformas
//                             .setErrorProformasPaginacion(null);

//                         _controllerProformas
//                             .setError401ProformasPaginacion(false);

//                         _controllerProformas.resetFormProformas();
//                         _controllerProformas.setPage(0);
//                         _controllerProformas.setIsNext(false);
//                         _controllerProformas
//                             .setInfoBusquedaProformasPaginacion([]);
//                         _controllerProformas.buscaAllProformasPaginacion(
//                             '', true,0);

//                      //==================================//
//                   }



//                     //****************************************//







//               },
//               child: Text('Imprimir', style: GoogleFonts.lexendDeca(
//                               fontWeight: FontWeight.bold,
//                               fontSize: size.iScreen(1.8)
//                             ),),
//             ), // Espacio entre los botones
//             SizedBox(width: 20),
//              OutlinedButton(
//                style: ButtonStyle( backgroundColor: MaterialStateProperty.all(Colors.black), ),
//                onPressed: (){
//                  Navigator.pop(context);
//                     final _ctrl =context.read<ComprobantesController>();
//                     if (_ctrl.getTipoDeTransaccion=='F') {
//                        //================FACTURAS F ==================//
//                   final _controllerFacturas =
//                              context.read<FacturasController>();

//                          _controllerFacturas
//                              .onSearchTextFacturaPaginacion("");

//                          _controllerFacturas
//                              .setBtnSearchFacturaPaginacion(false);
//                          _controllerFacturas
//                              .setErrorFacturasPaginacion(null);

//                          _controllerFacturas
//                              .setError401FacturasPaginacion(false);

//                          _controllerFacturas.resetFormFacturas();
//                          _controllerFacturas.setPage(0);
//                          _controllerFacturas.setIsNext(false);
//                          _controllerFacturas
//                              .setInfoBusquedaFacturasPaginacion([]);
//                          _controllerFacturas.buscaAllFacturasPaginacion(
//                              '',false,0);
//                     }
//                  if (_ctrl.getTipoDeTransaccion=='N') {
//                  //================PREFACTURAS N ==================//
//                   final _controllerPreFacturas =
//                              context.read<PreFacturasController>();

//                          _controllerPreFacturas
//                              .onSearchTextPreFacturaPaginacion("");

//                          _controllerPreFacturas
//                              .setBtnSearchPreFacturaPaginacion(false);
//                          _controllerPreFacturas
//                              .setErrorPreFacturasPaginacion(null);

//                          _controllerPreFacturas
//                              .setError401PreFacturasPaginacion(false);

//                          _controllerPreFacturas.resetFormPreFacturas();
//                          _controllerPreFacturas.setPage(0);
//                          _controllerPreFacturas.setIsNext(false);
//                          _controllerPreFacturas
//                              .setInfoBusquedaPreFacturasPaginacion([]);
//                          _controllerPreFacturas
//                              .buscaAllPreFacturasPaginacion('', true,0);
//                  }
//                    if (_ctrl.getTipoDeTransaccion=='P') {
//                      //================PROFORMAS P ==================//
//              final _controllerProformas =
//                              context.read<ProformasController>();

//                          _controllerProformas
//                              .onSearchTextProformasPaginacion("");

//                          _controllerProformas
//                              .setBtnSearchProformasPaginacion(false);
//                          _controllerProformas
//                              .setErrorProformasPaginacion(null);

//                          _controllerProformas
//                              .setError401ProformasPaginacion(false);

//                          _controllerProformas.resetFormProformas();
//                          _controllerProformas.setPage(0);
//                          _controllerProformas.setIsNext(false);
//                          _controllerProformas
//                              .setInfoBusquedaProformasPaginacion([]);
//                          _controllerProformas.buscaAllProformasPaginacion(
//                              '', true,0);

//                       //==================================//
//                    }
//                },
//                child: Text('No', style: GoogleFonts.lexendDeca(
//                  color: Colors.white,
//                                fontWeight: FontWeight.bold,
//                                fontSize: size.iScreen(1.8)
//                              ),),
//              ),
           
//         ],
//           ),
//         ],
//       ),
//           ):Container();
          
         
//         },),
      
          



//                   //***********************************************/
//                   SizedBox(
//                     height: size.iScreen(1.0),
//                   ),
//                   //*****************SI ES MOTO O CARRRO************************/

//                    ctrl.getTypeAction=='VEHICULOS'

//                   ?Column(
//                     children: [

//                                    Container(
                 
//                     padding: EdgeInsets.only(bottom: size.iScreen(1.0)),
                    
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceAround,
//                       children: [
//                           Consumer<ComprobantesController>(builder: (_, value, __) { 
//                             return  
//                             value.getExistCliente==false
//                             ?ClipRRect(
//                           borderRadius: BorderRadius.circular(8),
//                           child: GestureDetector(
//                             onTap:() {
                           
//                                      final ctrlPropi=  context.read<PropietariosController>();
//                      ctrlPropi.resetFormPropietario();

// ctrlPropi.setDocumento('');
//  ctrlPropi.setGeneros('');
//   ctrlPropi.setNombres('');
//                  ctrlPropi.setDireccion('');
//                    ctrlPropi.setLabelTelefono('');
//                   ctrlPropi.seItemAddPlaca('');
//                    ctrlPropi.resetPlacas();
//                      ctrlPropi.resetCelulares();
//                     ctrlPropi.resetCorreos();
//                 ctrlPropi.setObservacion('');

//                  ctrlPropi.setPais('');
//                   ctrlPropi.setListaTodosLosPaises([]);
//                   ctrlPropi.setProvincia('');
//                   ctrlPropi.setListaTodasLasProvincias([]);
//                    ctrlPropi.setCanton('');
//                     ctrlPropi.setListaTodosLosCantones([]);


//                   Navigator.of(context)
//                       .push(MaterialPageRoute(
//                           builder: (context) =>
//                                CrearPropietario(action: 'CREATE',
//                               user: widget.user,)));
//                                   },
//                             child:
                               
//                                 Consumer<ThemeProvider>(
//                               builder: (_, valueTheme, __) {
//                                 return Container(
//                                   alignment: Alignment.center,
//                                   color: valueTheme.appTheme.accentColor,
//                                   width: size.iScreen(4.5),
//                                   height: size.iScreen(4.5),
//                                   padding: EdgeInsets.only(
//                                     top: size.iScreen(0.5),
//                                     bottom: size.iScreen(0.5),
//                                     left: size.iScreen(0.5),
//                                     right: size.iScreen(0.5),
//                                   ),
//                                   child: Icon(
//                                     Icons.person_add_alt,
//                                     color: Colors.white,
//                                     size: size.iScreen(2.0),
//                                   ),
//                                 );
//                               },
//                             ),
//                           ),
//                         ):Container();
                            
//                            },),
//                            SizedBox(width: size.iScreen(1.0),),

                           
//                         Consumer<ComprobantesController>(
//                           builder: (_, tipo, __) {
//                             return Container(
//                               width: size.iScreen(28),
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   TextField(
//                                     decoration: InputDecoration(
//                                       label: Text( 'Ingrese Documento'),
//                                       labelStyle:TextStyle(color: Colors.grey,fontSize: size.iScreen(1.9)),
//                                       // hintText: 'Ingrese Documento', // Texto de sugerencia dentro del campo
//                                       // border: OutlineInputBorder(), // Opcional: Añade un borde al campo
//                                       helperStyle:
//                                           TextStyle(color: Colors.grey,fontSize: size.iScreen(1.5)),
//                                     ),
//                                     inputFormatters: [
//                                       UpperCaseText(), // Limita a 13 dígitos
//                                     ],
//                                     style: TextStyle(
//                                       fontSize: size.iScreen( 3.0), // Ajusta el tamaño de la letra
//                                       // fontWeight: FontWeight.bold, // Opcional: Aplica un peso de fuente más grueso
//                                     ),
//                                     textAlign: TextAlign.center,
//                                     onChanged: (text) {
//                                       ctrl.setDocumento(text);
//                                     },
//                                   ),
//                                 ],
//                               ),
//                             );
//                           },
//                         ),
//                          Consumer<ComprobantesController>(builder: (_, value, __) { 
//                             return  ClipRRect(
//                           borderRadius: BorderRadius.circular(8),
//                           child: GestureDetector(
//                             onTap: value.getDocumento!.isNotEmpty
//                                 ? () async {
//                                     ProgressDialog.show(context);
//                                     final response = await value.buscaClienteComprobante();
//                                     ProgressDialog.dissmiss(context);
//                                     if (response != null) {
//                                        if(value.getClienteComprobante.isNotEmpty){
                                       
//                                       //  NotificatiosnService.showSnackBarDanger( '${value.getClienteComprobante}');
//                                      }else{
//                                        value.setExistCliente(false);

//                                        final _ctrl =context.read<ComprobantesController>();
//                        _ctrl.resetListasProdutos();
//                      _ctrl.resetPlacas();
//                             _ctrl.setDocumento('');
//                             _ctrl.setFormaDePago('EFECTIVO');
//                             _ctrl.setFacturaOk(false);
                           
//                              _ctrl.setClienteComprbante({});
//                              _ctrl.resetCorreos();



//                                       NotificatiosnService.showSnackBarDanger( 'No se encuentra información,ingrese datos manualmente');
                                   
//                                      }
                                     
//                                     } else {
            
//                                     }
                                    
            
//                                     //     .searchAllPersinas('');
//                                     // Navigator.of(context).push(
//                                     //     MaterialPageRoute(
//                                     //         builder: (context) =>
//                                     //             BuscarPropietario()));
//                                   }
//                                 : () {
//                                     NotificatiosnService.showSnackBarDanger(
//                                         'Debe ingresar Documento para buscar');
//                                   },
//                             child:
//                                 // Container(
//                                 //   alignment: Alignment.center,
//                                 //   color: primaryColor,
//                                 //   width: size.iScreen(3.5),
//                                 //   padding: EdgeInsets.only(
//                                 //     top: size.iScreen(0.5),
//                                 //     bottom: size.iScreen(0.5),
//                                 //     left: size.iScreen(0.5),
//                                 //     right: size.iScreen(0.5),
//                                 //   ),
//                                 //   child: Icon(
//                                 //     Icons.search_outlined,
//                                 //     color: Colors.white,
//                                 //     size: size.iScreen(2.0),
//                                 //   ),
//                                 // ),
//                                 Consumer<ThemeProvider>(
//                               builder: (_, valueTheme, __) {
//                                 return Container(
//                                   alignment: Alignment.center,
//                                   color: valueTheme.appTheme.primaryColor,
//                                   width: size.iScreen(4.5),
//                                   height: size.iScreen(4.5),
//                                   padding: EdgeInsets.only(
//                                     top: size.iScreen(0.5),
//                                     bottom: size.iScreen(0.5),
//                                     left: size.iScreen(0.5),
//                                     right: size.iScreen(0.5),
//                                   ),
//                                   child: Icon(
//                                     Icons.search_outlined,
//                                     color: Colors.white,
//                                     size: size.iScreen(2.0),
//                                   ),
//                                 );
//                               },
//                             ),
//                           ),
//                         );
                      
//                            },)
            
//                       ],
//                     ),
//                   ),
//                   //***********************************************/
                  
//                   SizedBox(
//                     height: size.iScreen(1.0),
//                   ),
//                   //*****************************************/
            
//             Consumer<ComprobantesController>(builder: (_, value, __) {  
            
//             return 
//             value.getClienteComprobante.isNotEmpty?
//              Column(
//                     children: [
//                       Container(
//                         width: size.wScreen(100.0),
            
//                         // color: Colors.blue,
//                         child:  Text(value.getClienteComprobante.isEmpty?'--- --- --- --- ---':'${value.getClienteComprobante['perNombre']}',
//                             style: GoogleFonts.lexendDeca(
//                               fontSize: size.iScreen(2.3),
//                               fontWeight: FontWeight.normal,
//                               color: value.getClienteComprobante.isEmpty?Colors.grey:Colors.black
//                             )),
//                       ),
//                   //***********************************************/
//                   SizedBox(
//                     height: size.iScreen(1.0),
//                   ),
//                   //*****************************************/
//                   // Container(
//                   //   width: size.wScreen(100.0),
            
//                   //   // color: Colors.blue,
//                   //   child:  Text(value.getClienteComprobante.isEmpty?'--- --- --- --- ---':value.getClienteComprobante['perEmail'].isEmpty?'--- --- --- --- ---':'${value.getClienteComprobante['perEmail'][0]}',
//                   //       style: GoogleFonts.lexendDeca(
//                   //         fontSize: size.iScreen(2.0),
//                   //         fontWeight: FontWeight.normal,
//                   //          color: value.getClienteComprobante.isEmpty?Colors.grey:Colors.black
//                   //       )),
//                   // ),
//                     ],
//                   ):Container();
            
            
//             },),
            
                
//                   //***********************************************/
//                         SizedBox(
//                           height: size.iScreen(0.0),
//                         ),
//                         //*****************************************/

//                         Row(
//                           children: [
//                             SizedBox(
//                                 width: size.wScreen(20.0),

//                                 // color: Colors.blue,
//                                 child: Consumer<ComprobantesController>(
//                                   builder: (_, valueCantCorreos, __) {
//                                     return Row(
//                                       children: [
//                                         Text('Correo: ',
//                                             style: GoogleFonts.lexendDeca(
//                                                 fontSize: size.iScreen(2.0),
//                                                 fontWeight:
//                                                     FontWeight.normal,
//                                                 color: Colors.grey)),
//                                         valueCantCorreos.getlistaAddCorreos!
//                                                 .isNotEmpty
//                                             ? Text(
//                                                 '${valueCantCorreos.getlistaAddCorreos!.length} ',
//                                                 style:
//                                                     GoogleFonts.lexendDeca(
//                                                         fontSize: size.iScreen(2.0),
//                                                         fontWeight:
//                                                             FontWeight
//                                                                 .normal,
//                                                         color: Colors.grey))
//                                             : Container(),
//                                       ],
//                                     );
//                                   },
//                                 )),
//                             ClipRRect(
//                               borderRadius: BorderRadius.circular(8),
//                               child: GestureDetector(
//                                 onTap: () {
//                                   _agregaCorreo(context, ctrl, size);

// //*******************************************/
//                                 },
//                                 child: 
//                                 // Consumer<AppTheme>(builder: (_, valueTheme, __) {  
//                                 //   return Container(
//                                 //     alignment: Alignment.center,
//                                 //     color: valueTheme.getPrimaryTextColor,
//                                 //     width: size.iScreen(3.5),
//                                 //     padding: EdgeInsets.only(
//                                 //       top: size.iScreen(0.5),
//                                 //       bottom: size.iScreen(0.5),
//                                 //       left: size.iScreen(0.5),
//                                 //       right: size.iScreen(0.5),
//                                 //     ),
//                                 //     child: Icon(
//                                 //       Icons.add,
//                                 //       color: valueTheme.getSecondryTextColor,
//                                 //       size: size.iScreen(2.0),
//                                 //     ),
//                                 //   );
//                                 // },
                       
//                                 // ),
//                                  Consumer<ThemeProvider>(builder: (_, valueTheme, __) {  
//                                     return Container(
//                                       alignment: Alignment.center,
//                                       color: valueTheme.appTheme.primaryColor,
//                                       width: size.iScreen(5.0),
//                                       height: size.iScreen(4.0),
//                                       padding: EdgeInsets.only(
//                                         top: size.iScreen(0.5),
//                                         bottom: size.iScreen(0.5),
//                                         left: size.iScreen(0.5),
//                                         right: size.iScreen(0.5),
//                                       ),
//                                       child: Icon(
//                                         Icons.add,
//                                         color: Colors.white,
//                                         size: size.iScreen(2.0),
//                                       ),
//                                     );
//                                   },
//                                   ),
//                               ),
//                             ),
//                           ],
//                         ),
//                           //***********************************************/
//                         SizedBox(
//                           height: size.iScreen(0.0),
//                         ),
//                         //*****************************************/

//                         Consumer<ComprobantesController>(
//                           builder: (_, valueCorreos, __) {
//                             return SizedBox(
//                               // color: Colors.red,
//                               width: size.wScreen(100.0),
//                               child: Wrap(
//                                 children: valueCorreos.getlistaAddCorreos!
//                                     .map(
//                                       (e) => Row(
//                                         children: [
//                                           Expanded(
//                                             child: GestureDetector(
//                                               onDoubleTap: () {
//                                                 // print(e);
//                                                 valueCorreos
//                                                     .eliminaCorreo(e);
//                                               },
//                                               child: Container(
//                                                 decoration: BoxDecoration(
//                                                     color: Colors
//                                                         .grey.shade200,
//                                                     borderRadius:
//                                                         BorderRadius
//                                                             .circular(5.0)),
//                                                 margin:
//                                                     EdgeInsets.symmetric(
//                                                         vertical: size
//                                                             .iScreen(0.5)),
//                                                 padding:
//                                                     EdgeInsets.symmetric(
//                                                         horizontal: size
//                                                             .iScreen(1.0),
//                                                         vertical: size
//                                                             .iScreen(0.5)),
//                                                 child: Text('$e',
//                                                     style: GoogleFonts
//                                                         .lexendDeca(
//                                                             fontSize: size
//                                                                 .iScreen(
//                                                                     2.0),
//                                                             fontWeight:
//                                                                 FontWeight
//                                                                     .normal,
//                                                             color: Colors
//                                                                 .black)),
//                                               ),
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     )
//                                     .toList(),
//                               ),

//                               // Column(
//                               //   children: [
//                               //     Row(
//                               //       children: [
//                               //         Expanded(
//                               //           child: Container(
//                               //             decoration: BoxDecoration(
//                               //                 color: Colors.grey.shade300,
//                               //                 borderRadius:
//                               //                     BorderRadius.circular(5.0)),
//                               //             margin: EdgeInsets.symmetric(
//                               //                 vertical: size.iScreen(0.5)),
//                               //             padding: EdgeInsets.symmetric(
//                               //                 horizontal: size.iScreen(1.0),
//                               //                 vertical: size.iScreen(0.5)),
//                               //             child: Text('correo@corresdf.com',
//                               //                 style: GoogleFonts.lexendDeca(
//                               //                     fontSize: size.iScreen(1.7),
//                               //                     fontWeight: FontWeight.normal,
//                               //                     color: Colors.black)),
//                               //           ),
//                               //         ),
//                               //       ],
//                               //     ),
//                               //   ],
//                               // ),
//                             );
//                           },
//                         ),
                       
                       
//             //*****************************************/
//                   SizedBox(
//                     height: size.iScreen(0.0),
//                   ),
//                   //*****************************************/
                      


//                     ],
//                   ):Container(),



//                   Row(
//                     children: [
//                       SizedBox(
//                         // width: size.wScreen(100.0),
            
//                         // color: Colors.blue,
//                         child: Text('Placa: ',
//                             style: GoogleFonts.lexendDeca(
//                                 fontSize: size.iScreen(2.0),
//                                 fontWeight: FontWeight.normal,
//                                 color: Colors.grey)),
//                       ),
//                    Row(
//                      children: [
//                        SizedBox(
//                           width: size.iScreen(20.0),
//                           child: Form(
//                              key: ctrl.placaFormKey,
//                             child: TextFormField(
//                               textAlign: TextAlign.center,
//                               autofocus: false,
//                               controller: _textAddPlaca,
//                               decoration: const InputDecoration(
//                                 // Aquí puedes agregar más personalización si es necesario
//                               ),
//                               style: TextStyle(
//                                 fontSize: size.iScreen(3.5),
//                                 color: Colors.black,
//                               ),
//                               inputFormatters: <TextInputFormatter>[
//                                 UpperCaseText(),
//                               ],
//                               onChanged: (text) {
//                                 ctrl.seItemAddPlaca(text);
//                               },
//                               validator: (text) {
//                                 if (text!.trim().isNotEmpty) {
//                                   return null;
//                                 } else {
//                                   return 'Ingrese Placa';
//                                 }
//                               },
//                             ),
//                           ),
//                         ),
//                         TextButton(
//                       onPressed: () {
//                         final isValidS = ctrl.validateFormPlaca();
//                         if (!isValidS) return;
//                         if (isValidS) {
//                           _textAddPlaca.text = '';
//                           ctrl.agregaListaPlacas();
//                           // Navigator.pop(context);
//                         }
//                       },
//                       child: Consumer<ThemeProvider>(
//                         builder: (_, valueTheme, __) {
//                           return Container(
//                             width: size.iScreen(5.0),
//                             height:  size.iScreen(4.0),
//                             decoration: BoxDecoration(
//                               color: valueTheme.appTheme.primaryColor,
//                               borderRadius: BorderRadius.circular(5.0),
//                             ),
//                             padding: EdgeInsets.symmetric(
//                               vertical: size.iScreen(0.5),
//                               horizontal: size.iScreen(0.5),
//                             ),
//                             child: Icon(
//                                   Icons.add,
//                                   color: Colors.white,
//                                   size: size.iScreen(2.0),
//                                 ),
//                           );
//                         },
//                       ),
//                     ),
//                      ],
//                    ),
//                      //****************************************//
//                       // ClipRRect(
//                       //   borderRadius: BorderRadius.circular(8),
//                       //   child: GestureDetector(
//                       //     onTap: () {
//                       //       // context
//                       //       //     .read<MascotasController>()
//                       //       //     .buscaAllMascotas('');
            
//                       //       // // _buscarMascota(context, size);
//                       //       _agregaPlaca(context,ctrl,size);
            
//                       //       // //*******************************************/
//                       //     },
//                       //     child: Consumer<ThemeProvider>(
//                       //       builder: (_, valueTheme, __) {
//                       //         return Container(
//                       //           alignment: Alignment.center,
//                       //           color: valueTheme.appTheme.primaryColor,
//                       //           width: size.iScreen(4.5),
//                       //           padding: EdgeInsets.only(
//                       //             top: size.iScreen(0.5),
//                       //             bottom: size.iScreen(0.5),
//                       //             left: size.iScreen(0.5),
//                       //             right: size.iScreen(0.5),
//                       //           ),
//                       //           child: Icon(
//                       //             Icons.add,
//                       //             color: Colors.white,
//                       //             size: size.iScreen(2.0),
//                       //           ),
//                       //         );
//                       //       },
//                       //     ),
//                       //   ),
//                       // ),
                  
                  
                  
                  
//                     ],
//                   ),
//   //*****************************************/
//                    SizedBox(
//                     height: size.iScreen(1.0),
//                   ),
//                     //*****************************************/
                   
//                     //*****************************************/
//                    SizedBox(
//                     height: size.iScreen(1.0),
//                   ),
//                     //*****************************************/
//                   SizedBox(
//                      width: size.wScreen(100.0),
//                     child: 
//                     Consumer<ComprobantesController>(builder: (_, value, __) {  
//                       return 
//                       value.getlistaAddPlacas!.isNotEmpty?
//                       Wrap( children: (value.getlistaAddPlacas as List).map((e) =>
//                       GestureDetector(
//                         onDoubleTap: () {
//                           value.eliminaPlaca(e);
//                         },
//                         child: Container(
//                           margin: EdgeInsets.symmetric(horizontal: size.iScreen(1.0),vertical: size.iScreen(0.5)),
//                            padding: EdgeInsets.symmetric(horizontal: size.iScreen(0.5)),
//                           decoration: BoxDecoration(
//                               color: Colors.grey.shade200,
//                               borderRadius: BorderRadius.circular(8)
//                           ),
                        
//                           child: Text('$e',
//                             style: GoogleFonts.lexendDeca(
//                                 fontSize: size.iScreen(2.3),
//                                 fontWeight: FontWeight.normal,
//                                 color: Colors.black)),
//                         ),
//                       )
//                       ).toList(),)
//                       :Text('--- --- --- --- ---',
//                             style: GoogleFonts.lexendDeca(
//                               fontSize: size.iScreen(2.3),
//                               fontWeight: FontWeight.normal,
//                               color: Colors.grey
//                             ));
                      
//                     },),
                    
//                   ),
            

//             //***************************/
                
//                   Container(
//                     width: size.iScreen(100),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         // TextField(
//                         //   decoration: InputDecoration(
//                         //     hintText: 'RUC/CI CONDUCTOR', // Texto de sugerencia dentro del campo
//                         //     // border: OutlineInputBorder(), // Opcional: Añade un borde al campo
//                         //   ),
//                         //    textAlign: TextAlign.center,
//                         // ),
//                         TextFormField(
//                           inputFormatters: [
//                             UpperCaseText(),
//                           ],
//                           decoration: InputDecoration(
//                             label:  const Text( 'Nombre Conductor'),
//                             // Texto de sugerencia dentro del campo
//                             // border: OutlineInputBorder(), // Opcional: Añade un borde al campo
//                             helperStyle: TextStyle(color: Colors.grey.shade50),
//                           ),
//                           style: TextStyle(
//                             fontSize:
//                                 size.iScreen(2.3), // Ajusta el tamaño de la letra
//                             // fontWeight: FontWeight.bold, // Opcional: Aplica un peso de fuente más grueso
//                           ),
//                           textAlign: TextAlign.left,
//                         onChanged: (text) {
//                       ctrl.setNombreConductor(text);
//                     },
//                     validator: (text) {
//                       if (text!.trim().isNotEmpty) {
//                         return null;
//                       } else {
//                         return 'Ingrese nombre de Conductor';
//                       }
//                     },



//                         ),
//                       ],
//                     ),
//                   ),
//                   //***********************************************/
//                   SizedBox(
//                     height: size.iScreen(1.0),
//                   ),
//                   //*****************************************/
            
//                   //       Container(
//                   //         width: size.wScreen(100),
//                   //         child:
//                   //        Row(
//                   //   mainAxisAlignment: MainAxisAlignment.spaceAround,
//                   //   children: <Widget>[
//                   //     RadioButtonWithLabel(value: 1, label: 'Pasaporte'),
//                   //     RadioButtonWithLabel(value: 2, label: 'Calibración'),
//                   //     RadioButtonWithLabel(value: 3, label: 'Venta Cupo'),
//                   //     RadioButtonWithLabel(value: 4, label: 'Prepago'),
//                   //   ],
//                   // ),
            
//                   //       ),
            
//                   // ContainerRow(),
            
//             //***********************************************/
//                   // SizedBox(
//                   //   height: size.iScreen(1.0),
//                   // ),
//                   // //*****************************************/
//                   // Row(
//                   //   children: [
//                   //     SizedBox(
//                   //       // width: size.wScreen(100.0),
            
//                   //       // color: Colors.blue,
//                   //       child: Text('FORMA DE PAGO: ',
//                   //           style: GoogleFonts.lexendDeca(
//                   //               fontSize: size.iScreen(2.0),
//                   //               fontWeight: FontWeight.normal,
//                   //               color: Colors.grey)),
//                   //     ),
//                   //     Text('EFECTIVO',
//                   //         style: GoogleFonts.lexendDeca(
//                   //             fontSize: size.iScreen(2.3),
//                   //             fontWeight: FontWeight.bold,
//                   //             color: Colors.green)),
//                   //   ],
//                   // ),
//                    //***********************************************/
//                   SizedBox(
//                     height: size.iScreen(1.5),
//                   ),
//                   //*****************************************/
//                   Row(
//                     children: [
//                       SizedBox(
//                         // width: size.wScreen(20.0),
            
//                         // color: Colors.blue,
//                         child: Text('FORMA DE PAGO   ',
//                             style: GoogleFonts.lexendDeca(
//                                 fontSize: size.iScreen(2.0),
//                                 fontWeight: FontWeight.normal,
//                                 color: Colors.grey)),
//                       ),
//                       ClipRRect(
//                         borderRadius: BorderRadius.circular(8),
//                         child: GestureDetector(
//                           onTap: () {
//                             // context
//                             //     .read<MascotasController>()
//                             //     .buscaAllMascotas('');
            
//                             // // _buscarMascota(context, size);
//                             ctrl.getAllFormaPago() ;
//                             modalFormaPago(context, size, ctrl);
            
//                             // //*******************************************/
//                           },
//                           child: Consumer<ThemeProvider>(
//                             builder: (_, valueTheme, __) {
//                               return Container(
                                
//                                 alignment: Alignment.center,
//                                 color: valueTheme.appTheme.primaryColor,
//                                 width: size.iScreen(5.0),
//                                  height: size.iScreen(4.0),
//                                 padding: EdgeInsets.only(
//                                   top: size.iScreen(0.5),
//                                   bottom: size.iScreen(0.5),
//                                   left: size.iScreen(0.5),
//                                   right: size.iScreen(0.5),
//                                 ),
//                                 child: Icon(
//                                   Icons.keyboard_arrow_down_outlined,
//                                   color: Colors.white,
//                                   size: size.iScreen(2.0),
//                                 ),
//                               );
//                             },
//                           ),
//                         ),
//                       ),
                    
//                       // Consumer<ComprobantesController>(
//                       //   builder: (_, valueForma, __) {
//                       //     return Container(
//                       //       // color: Colors.red,
//                       //       width: size.wScreen(50.0),
            
//                       //       // color: Colors.blue,
//                       //       child: Text(
//                       //           valueForma.getFormaDePago.isEmpty
//                       //               ? ' --- --- --- --- --- --- --- ---'
//                       //               : ' ${valueForma.getFormaDePago}',
//                       //           style: GoogleFonts.lexendDeca(
//                       //               fontSize: size.iScreen(2.0),
//                       //               fontWeight: FontWeight.normal,
//                       //               color: valueForma.getFormaDePago.isEmpty
//                       //                   ? Colors.grey
//                       //                   : Colors.black)),
//                       //     );
//                       //   },
//                       // ),
//                       // Spacer(),
                      
//                     ],
//                   ),
//                    // //***********************************************/
//                   SizedBox(
//                     height: size.iScreen(1.0),
//                   ),
//                   // //*****************************************/
//                     Consumer<ComprobantesController>(builder: (_, value, __) { 
//                          return Container(
//                             // color: Colors.red,
//                             width: size.wScreen(100.0),
            
//                             // color: Colors.blue,
//                             child: Text(
//                                 value.getFormaDePago.isEmpty
//                                     ? ' --- --- --- --- --- --- --- ---'
//                                     : ' ${value.getFormaDePago}',
//                                 style: GoogleFonts.lexendDeca(
//                                     fontSize: size.iScreen(2.3),
//                                     fontWeight: FontWeight.normal,
//                                     color: value.getFormaDePago.isEmpty
//                                         ? Colors.grey
//                                         : Colors.black)),
//                           );
//                        },),
//                   // //***********************************************/
//                   // SizedBox(
//                   //   height: size.iScreen(1.0),
//                   // ),
//                   // //*****************************************/
//                   //***********************************************/
//                   // SizedBox(
//                   //   height: size.iScreen(1.0),
//                   // ),
//                   //*****************************************/
//                   // Container(
//                   //   width: size.wScreen(100.0),
//                   //   child: ContainerCombustible()),
//                   //***********************************************/
//                   // SizedBox(
//                   //   height: size.iScreen(1.0),
//                   // ),
//                   // //*****************************************/
            
//                   //***********************************************/
//                   SizedBox(
//                     height: size.iScreen(1.5),
//                   ),
//                   //*****************************************/
//                   Row(
//                     children: [
//                       SizedBox(
//                         // width: size.wScreen(100.0),
            
//                         // color: Colors.blue,
//                         child: Text('TARIFAS POR PASADA ',
//                             style: GoogleFonts.lexendDeca(
//                                 fontSize: size.iScreen(2.0),
//                                 fontWeight: FontWeight.normal,
//                                 color: Colors.grey)),
//                       ),
                      
//                       ClipRRect(
//                         borderRadius: BorderRadius.circular(8),
//                         child: GestureDetector(
//                           onTap: () {
//                             ctrl.buscaAllProductos( ctrl.getTypeAction.toString());
            
//                             // // _buscarMascota(context, size);
            
//              Navigator.of(context).push(MaterialPageRoute(
//                                   builder: (context) =>
//                                       const BuscarProductosVarios()));
            
//                             // modalTarifas(context, size, ctrl);
            
//                             // //*******************************************/
//                           },
//                           child: Consumer<ThemeProvider>(
//                             builder: (_, valueTheme, __) {
//                               return Container(
//                                 alignment: Alignment.center,
//                                 color: valueTheme.appTheme.primaryColor,
//                                 width: size.iScreen(5.0),
//                                  height: size.iScreen(4.0),
//                                 padding: EdgeInsets.only(
//                                   top: size.iScreen(0.5),
//                                   bottom: size.iScreen(0.5),
//                                   left: size.iScreen(0.5),
//                                   right: size.iScreen(0.5),
//                                 ),
//                                 child: Icon(
//                                   Icons.keyboard_arrow_down_outlined,
//                                   color: Colors.white,
//                                   size: size.iScreen(2.0),
//                                 ),
//                               );
//                             },
//                           ),
//                         ),
//                       ),
            
//                       //  Spacer(),
//                     ],
//                   ),
//                   // //***********************************************/
//                   // SizedBox(
//                   //   height: size.iScreen(1.0),
//                   // ),
//                   // //*****************************************/
            
//                   // Consumer<ComprobantesController>(
//                   //   builder: (_, valueTipo, __) {
//                   //     return Container(
//                   //       // color: Colors.red,
//                   //       width: size.wScreen(100.0),
            
//                   //       // color: Colors.blue,
//                   //       child: Text(
//                   //           valueTipo.tipoTarifa.isEmpty
//                   //               ? ''
//                   //               : ' ${valueTipo.tipoTarifa['tipo']} - \$${valueTipo.tipoTarifa['valor']}',
//                   //           style: GoogleFonts.lexendDeca(
//                   //               fontSize: size.iScreen(2.5),
//                   //               fontWeight: FontWeight.normal,
//                   //               color: valueTipo.tipoTarifa.isEmpty
//                   //                   ? Colors.grey
//                   //                   : Colors.black)),
//                   //     );
//                   //   },
//                   // ),
            
//                           Consumer<ComprobantesController>(builder: (_, value, __) { 
//                   return  
//                   value.getRespuestaCalculoItem.isNotEmpty
//                  ? Wrap(
//                   children: value.getRespuestaCalculoItem['venProductos']
//                       .map<Widget>(
//                         (e) => 
//                        e['descripcion'].isEmpty?Container(): Card(
//                                child: ListTile(
//                                  visualDensity: VisualDensity.compact,
//                                  title: Text(
//                                    '${e['descripcion']}',
//                                    style: GoogleFonts.lexendDeca(
//                                        fontSize: size.iScreen(1.8),
//                                        // color: Colors.black54,
//                                        fontWeight: FontWeight.normal),
//                                  ),
//                                  subtitle: 
//                                  Row(
//                                    children: [
//                                      Text(
//                                       'Valor Unitario: ',
//                                        style: GoogleFonts.lexendDeca(
//                                            fontSize: size.iScreen(1.5),
//                                            // color: Colors.black54,
//                                            fontWeight: FontWeight.normal),
//                                      ),
//                                       Text(
//                                       ' \$ ${e['valorUnitario']}',
//                                        style: GoogleFonts.lexendDeca(
//                                            fontSize: size.iScreen(2.3),
//                                            color: Colors.black,
//                                            fontWeight: FontWeight.bold),
//                                      ),
//                                    ],
//                                  ),
//                                  trailing: Column(
//                                    children: [
//                                      Text(
//                                       'Cantidad',
//                                        style: GoogleFonts.lexendDeca(
//                                            fontSize: size.iScreen(1.5),
//                                            // color: Colors.black54,
//                                            fontWeight: FontWeight.normal),
//                                      ),
//                                      Text(
//                                       '${e['cantidad']}',
//                                        style: GoogleFonts.lexendDeca(
//                                            fontSize: size.iScreen(2.3),
//                                            color:ctrlTheme.appTheme.primaryColor,
//                                            fontWeight: FontWeight.normal),
//                                      ),
//                                    ],
//                                  ),
//                                  // provider.getListaDeProductos.isNotEmpty
//                                  // ?Wrap(children: producto['invprecios'].map<Widget>((e) =>  Text(
//                                  //   '${e}',
//                                  //   style: GoogleFonts.lexendDeca(
//                                  //       fontSize: size.iScreen(1.7),
//                                  //       // color: Colors.black54,
//                                  //       fontWeight: FontWeight.normal),
//                                  // )).toList(),
//                                  // ):Text(
//                                  //   '--- --- ---',
//                                  //   style: GoogleFonts.lexendDeca(
//                                  //       fontSize: size.iScreen(1.8),
//                                  //       // color: Colors.black54,
//                                  //       fontWeight: FontWeight.normal),
//                                  // ),
//                                  onTap: () {
//                                    value.deleteItem(e);
            
            
                                  
                                  
                                  
                                  
//                                  },
//                                ),
//                              ),
//                       )
//                       .toList(),
//                 ):Container();
                
//                  },),
                 





//                   //*****************************************/
            
//             //                 Consumer<ComprobantesController>(builder: (_, value, __) { 
//             //                   return  
                    
//             //                   value.tipoTarifa.isEmpty? Text(
//             //                                      '--- --- --- --- --- --- --- --- --- --- ',
//             //                                       style: GoogleFonts.lexendDeca(
//             //                                           fontSize: size.iScreen(3.0),
//             //                                           fontWeight: FontWeight.normal,
//             //                                           color:  value.tipoTarifa.isEmpty? Colors.grey:Colors.black
//             //                                               )):
                    
//             //                   Container(
//             //                   // color: Colors.grey.shade200,
//             //                   padding: EdgeInsets.only(bottom: size.iScreen(1.0)),
//             //                   child: Row(
//             //                     mainAxisAlignment: MainAxisAlignment.spaceAround,
//             //                     children: [
//             //                       Container(
//             //                         width: size.iScreen(10),
//             //                         child: Column(
//             //                           crossAxisAlignment: CrossAxisAlignment.start,
//             //                           children: [
//             //                             //       TextField(
//             //                             //          inputFormatters: [
//             //                             //                             UpperCaseText(),
//             //                             //                           ],
//             //                             //         decoration: InputDecoration(
//             //                             //           hintText: 'Valor', // Texto de sugerencia dentro del campo
//             //                             //           // border: OutlineInputBorder(), // Opcional: Añade un borde al campo
//             //                             //            helperStyle:TextStyle(color: Colors.grey.shade50),
//             //                             //         ),
//             //                             //         style: TextStyle(
//             //                             //   fontSize: size.iScreen(2.0), // Ajusta el tamaño de la letra
//             //                             //   // fontWeight: FontWeight.bold, // Opcional: Aplica un peso de fuente más grueso
//             //                             // ),
//             //                             //         textAlign: TextAlign.center,
//             //                             //       ),
//             //                             //  TextField(
//             //                             //         inputFormatters: [
//             //                             //           FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$')), // Permite números y un solo punto decimal
//             //                             //         ],
//             //                             //         keyboardType: TextInputType.numberWithOptions(decimal: true), // Permite punto decimal en el teclado
//             //                             //         decoration: InputDecoration(
//             //                             //           hintText: 'Valor', // Texto de sugerencia dentro del campo
//             //                             //           helperStyle: TextStyle(color: Colors.grey.shade50),
//             //                             //         ),
//             //                             //         style: TextStyle(
//             //                             //           fontSize: size.iScreen(2.2), // Ajusta el tamaño de la letra
//             //                             //         ),
//             //                             //         textAlign: TextAlign.center,
//             //                             //       ),
//             //                             Consumer<ComprobantesController>(
//             //                               builder: (_, valueTatifa, __) {
//             //                                 return Container(
//             //                                   // color: Colors.red,
//             //                                   width: size.wScreen(20.0),
            
//             //                                   // color: Colors.blue,
//             //                                   child: Text(
//             //                                       valueTatifa.tipoTarifa.isEmpty
//             //                                           ? ' --- ---'
//             //                                           : ' \$${valueTatifa.tipoTarifa['valor']}',
//             //                                       style: GoogleFonts.lexendDeca(
//             //                                           fontSize: size.iScreen(3.0),
//             //                                           fontWeight: FontWeight.bold,
//             //                                           color: valueTatifa.tipoTarifa.isEmpty
//             //                                               ? Colors.grey
//             //                                               : Colors.red)),
//             //                                 );
//             //                               },
//             //                             ),
//             //                           ],
//             //                         ),
//             //                       ),
//             //                       Consumer<ComprobantesController>(
//             //                         builder: (_, values, __) {
//             //                           return values.tipoTarifa.isNotEmpty
//             //                               ? Container(
//             //                                   width: size.iScreen(20),
//             //                                   child: Column(
//             //                                     crossAxisAlignment:
//             //                                         CrossAxisAlignment.start,
//             //                                     children: [
//             // // TextFormField(
            
//             // //   // initialValue:values.getCantidad ,
//             // //   controller: _controller,
//             // //   inputFormatters: [
//             // //     FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$')), // Permite números y un solo punto decimal
//             // //   ],
//             // //   keyboardType: TextInputType.numberWithOptions(decimal: true), // Permite punto decimal en el teclado
//             // //   decoration: InputDecoration(
//             // //     hintStyle:TextStyle(
//             // //       fontSize: size.iScreen(2.0)
//             // //     ),
//             // //     hintText: 'Cantidad', // Texto de sugerencia dentro del campo
//             // //     helperStyle: TextStyle(color: Colors.grey.shade50),
//             // //   ),
//             // //   style: TextStyle(
//             // //     fontSize: size.iScreen(3.5), // Ajusta el tamaño de la letra
//             // //   ),
//             // //   textAlign: TextAlign.center,
//             // //    onChanged: (text) {
//             // //     if (text=='') {
//             // //       text==0.00;
//             // //     }
//             // //     values.setCantidad(double.parse(text));
//             // //                       },
//             // // ),
//             //                                       TextFormField(
//             //                                         controller: _controller,
//             //                                         inputFormatters: [
//             //                                           FilteringTextInputFormatter.allow(RegExp(
//             //                                               r'^\d*\.?\d*$')), // Permite números y un solo punto decimal
//             //                                         ],
//             //                                         keyboardType:
//             //                                             TextInputType.numberWithOptions(
//             //                                                 decimal:
//             //                                                     true), // Permite punto decimal en el teclado
//             //                                         decoration: InputDecoration(
//             //                                           hintStyle: TextStyle(
//             //                                             fontSize: size.iScreen(2.0),
//             //                                           ),
//             //                                           hintText:
//             //                                               'Cantidad', // Texto de sugerencia dentro del campo
//             //                                           helperStyle: TextStyle(
//             //                                               color: Colors.grey.shade50),
//             //                                         ),
//             //                                         style: TextStyle(
//             //                                           fontSize: size.iScreen(
//             //                                               3.5), // Ajusta el tamaño de la letra
//             //                                         ),
//             //                                         textAlign: TextAlign.center,
            
//             //                                         // Validación y conversión
//             //                                         onChanged: (text) {
//             //                                           double value = 0.0;
//             //                                           if (text.isNotEmpty) {
//             //                                             try {
//             //                                               value = double.parse(text);
//             //                                             } catch (e) {
//             //                                               // Manejo del error si el parse falla
//             //                                               value = 0.0;
//             //                                             }
//             //                                           }
//             //                                           values.setCantidad(value);
//             //                                         },
            
//             //                                         // Validación adicional al enviar el formulario (opcional)
//             //                                         validator: (text) {
//             //                                           if (text == null || text.isEmpty) {
//             //                                             return 'Por favor, ingrese una cantidad';
//             //                                           }
//             //                                           final value = double.tryParse(text);
//             //                                           if (value == null) {
//             //                                             return 'Ingrese un número válido';
//             //                                           }
//             //                                           return null; // Devuelve null si la validación es exitosa
//             //                                         },
//             //                                       ),
//             //                                     ],
//             //                                   ),
//             //                                 )
//             //                               : Container();
//             //                         },
//             //                       )
//             //                       // Container(
//             //                       //   width: size.iScreen(4.0), // Ajusta el ancho del contenedor según sea necesario
//             //                       //   height: size.iScreen(4.0), // Ajusta la altura del contenedor según sea necesario
//             //                       //   decoration: BoxDecoration(
//             //                       //     color:ctrlTheme.appTheme.primaryColor, // Color de fondo del contenedor
//             //                       //     borderRadius: BorderRadius.circular(8), // Forma circular
//             //                       //   ),
//             //                       //   child: IconButton(
//             //                       //     icon: Icon(Icons.search, color: Colors.white), // Icono de lupa
//             //                       //     onPressed: () {
//             //                       //       // Acción al presionar el icono
//             //                       //     },
//             //                       //   ),
//             //                       // ),
//             //                     ],
//             //                   ),
//             //                 );
                  
//             //                  },),
            
//                  //***********************************************/
//                   // //***********************************************/
//                   // SizedBox(
//                   //   height: size.iScreen(1.0),
//                   // ),
//                   // //*****************************************/
//                   // //***********************************************/
//                   // Container(
//                   //   color:Colors.grey.shade200,
//                   //   width: size.wScreen(100),
//                   //   height: size.iScreen(0.5),
//                   // ),
//                   // //*****************************************/
//                    //***********************************************/
//                   SizedBox(
//                     height: size.iScreen(1.0),
//                   ),
//                   //*****************************************/
            
                     
            
//                   Container(
//                     width: size.wScreen(100),
//                     margin: EdgeInsets.only(right: size.iScreen(1.0)),
                  
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.end,
//                       children: [
                         
         
           
//                         Column(
//                           mainAxisAlignment: MainAxisAlignment.end,
                         
//                           children: [
//                             Column(
//                               children: [
//                                 Row(
//                                   mainAxisAlignment: MainAxisAlignment.end,
//                                   children: [
//                                     Container(
//                                       width: size.iScreen(10.0),
            
//                                       // color: Colors.blue,
//                                       child: Text('SubTotal: ',
//                                           style: GoogleFonts.lexendDeca(
//                                               fontSize: size.iScreen(2.0),
//                                               fontWeight: FontWeight.normal,
//                                               color: Colors.grey), textAlign: TextAlign.right,),
//                                     ),
//                                     Consumer<ComprobantesController>(
//                                   builder: (_, valueSubTotal, __) {
//                                     return Text(valueSubTotal.getRespuestaCalculoItem['venSubTotal']==null?' 0.00':' \$ ${valueSubTotal.getRespuestaCalculoItem['venSubTotal']}',
//                                         style: GoogleFonts.lexendDeca(
//                                             fontSize: size.iScreen(2.0),
//                                             fontWeight: FontWeight.bold,
                                            
//                                             ));
//                                   },
//                                 ),
//                                   ],
//                                 ),
//                                  Row(
//                                   mainAxisAlignment: MainAxisAlignment.end,
//                                   children: [
//                                    Container(
//                                       width: size.iScreen(9.0),
            
//                                       // color: Colors.blue,
//                                       child: Text('Iva: ',
//                                           style: GoogleFonts.lexendDeca(
//                                               fontSize: size.iScreen(2.0),
//                                               fontWeight: FontWeight.normal,
//                                               color: Colors.grey), textAlign: TextAlign.right,),
//                                     ),
//                                     Consumer<ComprobantesController>(
//                                   builder: (_, valueIvaTotal, __) {
//                                     return Text(valueIvaTotal.getRespuestaCalculoItem['venTotalIva']==null?'  0.00':' \$ ${valueIvaTotal.getRespuestaCalculoItem['venTotalIva']}',
//                                         style: GoogleFonts.lexendDeca(
//                                             fontSize: size.iScreen(2.0),
//                                             fontWeight: FontWeight.bold,
//                                             ));
//                                   },
//                                 ),
//                                   ],
//                                 ),
//                                 Row(
//                                   mainAxisAlignment: MainAxisAlignment.end,
//                                   children: [
//                                     Container(
//                                   width: size.iScreen(11.0),
            
//                                       // color: Colors.blue,
//                                       child: Text('Total: ',
//                                           style: GoogleFonts.lexendDeca(
//                                               fontSize: size.iScreen(2.5),
//                                               fontWeight: FontWeight.normal,
//                                               color: Colors.grey),
//                                               textAlign: TextAlign.right,),
//                                     ),
//                                     Consumer<ComprobantesController>(
//                                   builder: (_, valueTotal, __) {
//                                     return Text(valueTotal.getRespuestaCalculoItem['venTotal']==null?' 0.00':' \$ ${valueTotal.getRespuestaCalculoItem['venTotal']}',
//                                         style: GoogleFonts.lexendDeca(
//                                             fontSize: size.iScreen(2.5),
//                                             fontWeight: FontWeight.bold,
//                                            ));
//                                   },
//                                 ),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
                
//                   //***********************************************/
//                   SizedBox(
//                     height: size.iScreen(3.0),
//                   ),
//                   //*****************************************/


//                    //***********************************************/
//                   SizedBox(
//                     height: size.iScreen(1.0),
//                   ),
                 
//     //*****************************************/
            
//                   //***********************************************/
//                   SizedBox(
//                     height: size.iScreen(1.0),
//                   ),
//                   //*****************************************/
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   //**********************************************MODAL TIPO DE PLACA **********************************************************************//
//   Future<bool?> modalFormaPago(
//       BuildContext context, Responsive size, ComprobantesController ctrl) {
//     return showDialog<bool>(
//       barrierColor: Colors.black54,
//       context: context,
//       builder: (context) {


//         // List<String> _forma = 
//         // [
//         // "EFECTIVO", 
//         // "TARJETA DE CRÉDITO", 
//         // "TRANSFERENCIA", 
//         // 'DEPOSITO',
//         // "CHEQUE", 
//         // "TARJETA DE DÉBITO", 
//         // "DINERO ELECTRÓNICO", 
//         // "TARJETA PREPAGO"
//         // ];

//         return AlertDialog(
//           title: const Text("SELECCIONE FORMA DE PAGO"),
//           content: SizedBox(
//             width: size.wScreen(100),
//             height: size.hScreen(20.0), // Ajusta la altura según sea necesario
//             child: SingleChildScrollView(
//               physics: BouncingScrollPhysics(),

           

//               child: 
//               Consumer<ComprobantesController>(builder: (_, value, __) {  

//                     if (value.getListaFormasPago.isEmpty) {
//                             return Center(
//                                             child: Column(
//                                               mainAxisAlignment: MainAxisAlignment.center,
//                                             children: [
                                              
//                                               CircularProgressIndicator(),
//                                               Text('Por favor espere ....')
//                                             ],
//                                           ));
//                             // Text("sin datos");
//                           }

//                           return 
                          
//                            Wrap(
//                   children: value.getListaFormasPago.map((e) => 
                  
                  
//                   GestureDetector(
//                           onTap: () {
//                             value.setFormaDePago( e['fpagoNombre'],);
//                             Navigator.pop(context);
//                           },
//                           child: Container(
//                             margin: EdgeInsets.symmetric(
//                                 vertical: size.iScreen(0.5)),
//                             padding: EdgeInsets.symmetric(
//                                 horizontal: size.iScreen(2.0),
//                                 vertical: size.iScreen(1.0)),
//                             decoration: BoxDecoration(
//                               color: Colors.grey[200],
//                               borderRadius: BorderRadius.circular(8),
//                             ),
//                             child: Center(
//                               child: Text(
//                                e['fpagoNombre'],
//                                 style: GoogleFonts.lexendDeca(
//                                   fontWeight: FontWeight.normal,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         )
                  
                  
//                   ).toList(),
//                 );
//       //            ListView.builder(
//       //   itemCount: value.getFormaDePago.length,
//       //   itemBuilder: (context, index) {
         
//       //     return
//       //     GestureDetector(
//       //                     onTap: () {
//       //                       value.setFormaDePago(value.getFormaDePago[index]['fpagoNombre'].toString());
//       //                       Navigator.pop(context);
//       //                     },
//       //                     child: Container(
//       //                       margin: EdgeInsets.symmetric(
//       //                           vertical: size.iScreen(0.5)),
//       //                       padding: EdgeInsets.symmetric(
//       //                           horizontal: size.iScreen(2.0),
//       //                           vertical: size.iScreen(1.0)),
//       //                       decoration: BoxDecoration(
//       //                         color: Colors.grey[200],
//       //                         borderRadius: BorderRadius.circular(8),
//       //                       ),
//       //                       child: Center(
//       //                         child: Text(
//       //                           value.getFormaDePago[index].toString(),
//       //                           style: GoogleFonts.lexendDeca(
//       //                             fontWeight: FontWeight.normal,
//       //                           ),
//       //                         ),
//       //                       ),
//       //                     ),
//       //                   );
//       //   },
//       // );
//               //   Column(
//               //   mainAxisSize: MainAxisSize.min,
//               //   children: _forma
//               //       .map((e) => 
//               //       GestureDetector(
//               //             onTap: () {
//               //               value.setFormaDePago(e);
//               //               Navigator.pop(context);
//               //             },
//               //             child: Container(
//               //               margin: EdgeInsets.symmetric(
//               //                   vertical: size.iScreen(0.5)),
//               //               padding: EdgeInsets.symmetric(
//               //                   horizontal: size.iScreen(2.0),
//               //                   vertical: size.iScreen(1.0)),
//               //               decoration: BoxDecoration(
//               //                 color: Colors.grey[200],
//               //                 borderRadius: BorderRadius.circular(8),
//               //               ),
//               //               child: Center(
//               //                 child: Text(
//               //                   e,
//               //                   style: GoogleFonts.lexendDeca(
//               //                     fontWeight: FontWeight.normal,
//               //                   ),
//               //                 ),
//               //               ),
//               //             ),
//               //           ))
//               //       .toList(),
//               // );
            
            

//               },)
              
             
            
//             ),
//           ),
//         );
//       },
//     );
//   }

//   //**********************************************MODAL TIPO DE PLACA **********************************************************************//
//   Future<bool?> modalTipoDocumento(
//       BuildContext context, Responsive size, ComprobantesController ctrl) {
//     return showDialog<bool>(
//       barrierColor: Colors.black54,
//       context: context,
//       builder: (context) {
//         List<String> _tipos = ["CÉDULA/RUC", "PLACA", 'CONSUMIDOR FINAL'];

//         return AlertDialog(
//           title: const Text("SELECCIONE TIPO DE PLACA"),
//           content: SizedBox(
//             width: size.wScreen(100),
//             height: size.hScreen(20.0), // Ajusta la altura según sea necesario
//             child: SingleChildScrollView(
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: _tipos
//                     .map((e) => GestureDetector(
//                           onTap: () {
//                             ctrl.setTipoDocumento(e);
//                             Navigator.pop(context);
//                           },
//                           child: Container(
//                             margin: EdgeInsets.symmetric(
//                                 vertical: size.iScreen(0.5)),
//                             padding: EdgeInsets.symmetric(
//                                 horizontal: size.iScreen(2.0),
//                                 vertical: size.iScreen(1.0)),
//                             decoration: BoxDecoration(
//                               color: Colors.grey[200],
//                               borderRadius: BorderRadius.circular(8),
//                             ),
//                             child: Center(
//                               child: Text(
//                                 e,
//                                 style: GoogleFonts.lexendDeca(
//                                   fontWeight: FontWeight.normal,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ))
//                     .toList(),
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }



//   Future<bool?> _agregaCorreo(BuildContext context,
//       ComprobantesController controller, Responsive size) {
//     return showDialog<bool>(
//       context: context,
//       builder: (context) {
//         return CupertinoAlertDialog(
//             title: Container(child: const Text("AGREGAR CORREO")),
//             content: Card(
//               color: Colors.transparent,
//               elevation: 0.0,
//               child: Form(
//                 key: controller.correoFormKey,
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     SizedBox(
//                       width: size.iScreen(100.0),
//                       child: Container(
//                         // width: size.wScreen(45.0),
//                         child:
//                             // IntlPhoneField(
//                             //   controller: controllerTextCountry,
//                             //   decoration: const InputDecoration(

//                             //       // labelText: 'Phone Number',
//                             //       // border: OutlineInputBorder(
//                             //       //   // borderSide: BorderSide(),
//                             //       // ),
//                             //       ),
//                             //   onChanged: (phone) {
//                             //     print(phone.completeNumber);
//                             //     controller.seItemAddCelulars(phone.completeNumber);
//                             //   },
//                             //   onCountryChanged: (country) {
//                             //     controller.seItemCodeCelular(country.dialCode);
//                             //   },
//                             // ),
//                             //===============================================//
//                             SizedBox(
//                           width: size.iScreen(40.0),
//                           child: TextFormField(
//                             controller: _textAddCorreo,

//                             keyboardType: TextInputType.emailAddress,
//                             textCapitalization: TextCapitalization.none,

//                             autovalidateMode:
//                                 AutovalidateMode.onUserInteraction,
//                             validator: (value) {
//                               final validador = validateEmail(value);
//                               if (validador == null) {
//                                 controller.setIsCorreo(true);
//                               }
//                               return validateEmail(value);
//                             },
//                             decoration: const InputDecoration(
//                                 hintText: '  Ingrese un Correo'
//                                 // suffixIcon: Icon(Icons.beenhere_outlined)
//                                 ),
//                             inputFormatters: [
//                               LowerCaseText(),
//                             ],
//                             textAlign: TextAlign.center,
//                             style: const TextStyle(

//                                 // fontSize: size.iScreen(3.5),
//                                 // fontWeight: FontWeight.bold,
//                                 // letterSpacing: 2.0,
//                                 ),
//                             onChanged: (text) {
//                               controller.seItemAddCorreos(text);
//                               // final _estado=
//                               // valueCantidad.validaStock(text);
//                               // if(_estado==true){
//                               // print('@VERDADERO@ $_estado');

//                               // }else{
//                               // print('@FALSE@ $_estado');

//                               // }
//                             },
//                             // validator: (text) {
//                             //   if (text!.trim().isNotEmpty) {
//                             //     return null;
//                             //   } else {
//                             //     return 'Cantidad inválida';
//                             //   }
//                             // },
//                           ),
//                         ),
//                         //===============================================//
//                       ),
//                     ),
//                     TextButton(
//                         onPressed: () {
//                           final isValidS = controller.validateFormCorreo();
//                           if (!isValidS) return;
//                           if (isValidS) {
//                             _textAddCorreo.text = '';
//                             controller.agregaListaCorreos();
//                             Navigator.pop(context);
//                           }
//                           //  print(countries.firstWhere((element) => element['code'] == phone.countryISOCode)['max_length']);
//                         },
//                         child: 
//                     Consumer<ThemeProvider>(builder: (_, valueTheme, __) { 
//                           return    Container(
//                           decoration: BoxDecoration(
//                               color: valueTheme.appTheme.primaryColor,
//                               borderRadius: BorderRadius.circular(5.0)),
//                           // color: primaryColor,
//                           padding: EdgeInsets.symmetric(
//                               vertical: size.iScreen(0.5),
//                               horizontal: size.iScreen(0.5)),
//                           child: Text('Agregar',
//                               style: GoogleFonts.lexendDeca(
//                                   // fontSize: size.iScreen(2.0),
//                                   fontWeight: FontWeight.normal,
//                                   color: Colors.white)),
//                         );

//                        },)
                        
                        
                     
//                     )
//                   ],
//                 ),
//               ),
//             )

//             //  },)

//             );
//       },
//     );
//   }


// // void showProcessingModal(BuildContext context, Responsive size) {
// //   showDialog(
// //     context: context,
// //     barrierDismissible: false,
// //     builder: (BuildContext context) {
// //       return AlertDialog(
// //               content: Column(
// //                 mainAxisSize: MainAxisSize.min,
// //                 children: [
// //                   const Text('Datos guardados correctamente'),
// //                   SizedBox(height: size.iScreen(1.0)),
// //                   const Text('¿Desea imprimir la factura?'),
// //                   SizedBox(height: size.iScreen(1.0)),
// //                   Row(
// //                     mainAxisAlignment: MainAxisAlignment.spaceAround,
// //                     children: [
// //                       ElevatedButton(
// //                         onPressed: () {
// //                           // Lógica para imprimir la factura
// //                           final crtl = context.read<ComprobantesController>();
// //                           print('LA DATA PARA TICKET : ${crtl.getInfoFacturaResponse}');
// //                           Navigator.of(context).pop();
// //                         },
// //                         child: const Text('Imprimir'),
// //                       ),
// //                       ElevatedButton(
// //                         onPressed: () {
// //                           // Cerrar el modal sin imprimir
// //                           Navigator.of(context).pop();
// //                         },
// //                         child: const Text('No'),
// //                       ),
// //                     ],
// //                   ),
// //                 ],
// //               ),
// //             );
// //     },
// //   );
// // }


// //   Future<bool?> _agregaPlaca(BuildContext context,
// //       ComprobantesController controller, Responsive size) {
// //     return showDialog<bool>(
// //       context: context,
// //       builder: (context) {
// //         return CupertinoAlertDialog(
// //             title: Container(child: const Text("AGREGAR PLACA")),
// //             content: Card(
// //               color: Colors.transparent,
// //               elevation: 0.0,
// //               child: Form(
// //                 key: controller.placaFormKey,
// //                 child: 
// //                 Column(
// //                   mainAxisSize: MainAxisSize.min,
// //                   children: [
// //                     SizedBox(
// //                       width: size.iScreen(50.0),
// //                       child: 
// //                       Container(
// //                         // width: size.wScreen(45.0),
// //                         child: TextFormField(
// //                          textAlign: TextAlign.center,
// //                           autofocus: true,
// //                           controller: _textAddPlaca,
// //                           decoration: const InputDecoration(
                         

                             
// //                               ),
// //                               style:TextStyle(
// //                                 fontSize:size.iScreen(3.5),
// //                                 color:Colors.black
// //                               ),
                              
// // //  initialCountryCode: 'EC',

// //                           // keyboardType: TextInputType.none,
// //                           inputFormatters: <TextInputFormatter>[
// //                             UpperCaseText(),
// //                           ],
// //                           onChanged: (text) {
                           
// //                             controller.seItemAddPlaca(text);
// //                           },
// //                            validator: (text) {
// //                                           if (text!.trim().isNotEmpty) {
// //                                             return null;
// //                                           } else {
// //                                             return 'Ingrese Placa';
// //                                           }
// //                                         },
                          
// //                         ),
// //                       ),
// //                     ),
// //                    TextButton(
// //                         onPressed: () {
// //                           final isValidS = controller.validateFormPlaca();
// //                           if (!isValidS) return;
// //                           if (isValidS) {
// //                             _textAddPlaca.text = '';
// //                             controller.agregaListaPlacas();
// //                             Navigator.pop(context);
// //                           }
// //                           //  print(countries.firstWhere((element) => element['code'] == phone.countryISOCode)['max_length']);
// //                         },
// //                         child: 
// //                         // Consumer<ThemeProvider>(builder: (_, valueTheme, __) {  
// //                         //                 return Container(
// //                         //                   alignment: Alignment.center,
// //                         //                   color: valueTheme.appTheme.primaryColor,
// //                         //                   width: size.iScreen(3.5),
// //                         //                   padding: EdgeInsets.only(
// //                         //                     top: size.iScreen(0.5),
// //                         //                     bottom: size.iScreen(0.5),
// //                         //                     left: size.iScreen(0.5),
// //                         //                     right: size.iScreen(0.5),
// //                         //                   ),
// //                         //                   child: Icon(
// //                         //                     Icons.add,
// //                         //                     color: Colors.white,
// //                         //                     size: size.iScreen(2.0),
// //                         //                   ),
// //                         //                 );
// //                         //               },
// //                         //               ),
// //                      Consumer<ThemeProvider>(builder: (_, valueTheme, __) {  
// //                           return    Container(
// //                           decoration: BoxDecoration(
// //                               color: valueTheme.appTheme.primaryColor,
// //                               borderRadius: BorderRadius.circular(5.0)),
// //                           // color: primaryColor,
// //                           padding: EdgeInsets.symmetric(
// //                               vertical: size.iScreen(0.5),
// //                               horizontal: size.iScreen(0.5)),
// //                           child: Text('Agregar',
// //                               style: GoogleFonts.lexendDeca(
// //                                   // fontSize: size.iScreen(2.0),
// //                                   fontWeight: FontWeight.normal,
// //                                   color: Colors.white)),
// //                         );

// //                        },)
                        
                        
                     
// //                     )
// //                   ],
// //                 ),
// //               ),
// //             )

// //             //  },)

// //             );
// //       },
// //     );
// //   }
// Future<bool?> _agregaPlaca(BuildContext context,
//     ComprobantesController controller, Responsive size) {
//   return showDialog<bool>(
//     context: context,
//     builder: (context) {
//       return Dialog(
//         backgroundColor: Colors.white, // Cambia el color de toda la modal a blanco
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(10.0),
//         ),
//         child: Padding(
//           padding: EdgeInsets.all(size.iScreen(2.0)),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Text("AGREGAR PLACA", style: TextStyle(fontSize: size.iScreen(2.5))),
//               SizedBox(height: size.iScreen(2.0)),
//               Form(
//                 key: controller.placaFormKey,
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     SizedBox(
//                       width: size.iScreen(50.0),
//                       child: TextFormField(
//                         textAlign: TextAlign.center,
//                         autofocus: true,
//                         controller: _textAddPlaca,
//                         decoration: const InputDecoration(
//                           // Aquí puedes agregar más personalización si es necesario
//                         ),
//                         style: TextStyle(
//                           fontSize: size.iScreen(3.5),
//                           color: Colors.black,
//                         ),
//                         inputFormatters: <TextInputFormatter>[
//                           UpperCaseText(),
//                         ],
//                         onChanged: (text) {
//                           controller.seItemAddPlaca(text);
//                         },
//                         validator: (text) {
//                           if (text!.trim().isNotEmpty) {
//                             return null;
//                           } else {
//                             return 'Ingrese Placa';
//                           }
//                         },
//                       ),
//                     ),
//                     SizedBox(height: size.iScreen(2.0)),
//                     TextButton(
//                       onPressed: () {
//                         final isValidS = controller.validateFormPlaca();
//                         if (!isValidS) return;
//                         if (isValidS) {
//                           _textAddPlaca.text = '';
//                           controller.agregaListaPlacas();
//                           Navigator.pop(context);
//                         }
//                       },
//                       child: Consumer<ThemeProvider>(
//                         builder: (_, valueTheme, __) {
//                           return Container(
//                             decoration: BoxDecoration(
//                               color: valueTheme.appTheme.primaryColor,
//                               borderRadius: BorderRadius.circular(5.0),
//                             ),
//                             padding: EdgeInsets.symmetric(
//                               vertical: size.iScreen(0.5),
//                               horizontal: size.iScreen(0.5),
//                             ),
//                             child: Text('Agregar',
//                                 style: GoogleFonts.lexendDeca(
//                                   fontWeight: FontWeight.normal,
//                                   color: Colors.white,
//                                 )),
//                           );
//                         },
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       );
//     },
//   );
// }

//   //**********************************************MODAL TIPO DE PLACA **********************************************************************//
//   Future<bool?> modalTarifas(
//       BuildContext context, Responsive size, ComprobantesController ctrl) {
//     return showDialog<bool>(
//       barrierColor: Colors.black54,
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: const Text("SELECCIONE TARIFA"),
//           content: SizedBox(
//             width: size.wScreen(100),
//             height: size.hScreen(20.0), // Ajusta la altura según sea necesario
//             child: SingleChildScrollView(
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: ctrl.listTarifas
//                     .map((e) => GestureDetector(
//                           onTap: () {
//                             _controller.text = '1';
//                             ctrl.setTotal();
//                             ctrl.setCantidad(0.0);
//                             ctrl.setTarifa(e);
//                             ctrl.calculateTotal();
//                             Navigator.pop(context);
//                           },
//                           child: Container(
//                             margin: EdgeInsets.symmetric(
//                                 vertical: size.iScreen(0.5)),
//                             padding: EdgeInsets.symmetric(
//                                 horizontal: size.iScreen(2.0),
//                                 vertical: size.iScreen(1.0)),
//                             decoration: BoxDecoration(
//                               color: Colors.grey[200],
//                               borderRadius: BorderRadius.circular(8),
//                             ),
//                             child: Center(
//                               child: Text(
//                                 '${e['tipo']} - \$${e['valor']}',
//                                 style: GoogleFonts.lexendDeca(
//                                   fontWeight: FontWeight.normal,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ))
//                     .toList(),
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }

//   //********************************************************************************************************************//
//   void _onSubmit(
//     BuildContext context,
//     ComprobantesController controller,
//   ) async {
//     final isValid = controller.validateForm();
//     if (!isValid) return;
//     if (isValid) {

//     //  controller.createFactura();
//                                       // showProcessingModal( context, size);

//       if (controller.getClienteComprobante.isEmpty) {
//         NotificatiosnService.showSnackBarDanger('Debe seleccionar Cliente');
//       } else if (controller.getlistaAddPlacas!.isEmpty) {
//         NotificatiosnService.showSnackBarDanger(
//             'Debe agregar placa de vehículo');
//       }
//       //  else if (controller.getNombreConductor == "") {
//       //   NotificatiosnService.showSnackBarDanger(
//       //       'Debe ingresar nombre de Conductor');
//       // }
//       else if (controller.getFormaDePago == "") {
//         NotificatiosnService.showSnackBarDanger(
//             'Debe seleccionar forma de pago');
//       } else if (controller.getRespuestaCalculoItem.isEmpty) {
//         NotificatiosnService.showSnackBarDanger(
//             'Debe agregar producto');
//       } else if (controller.getlistaAddCorreos!.isEmpty) {
//         NotificatiosnService.showSnackBarDanger(
//             'Debe agregar correo');
//       }
//       else{
//            final ctrl = context.read<ComprobantesController>();
//           ctrl.createFactura(context);


//       }

//       // if (controller.getNombreMascota != "" &&
//       //     controller.getVetInternoNombre != "" &&
//       //     controller.getTipoConsulta != "") {
//       //   //   if (image != null) {
//       //   //     ProgressDialog.show(context);
//       //   //     controller.setNewPictureFile(image);
//       //   //     await controller.upLoadImagen();
//       //   //   }

//       //   //   ProgressDialog.dissmiss(context);
//       //   if (widget.tipo == 'CREATE') {
//       //     await controller.creaHistoriaClinica(context);
//       //     Navigator.pop(context);
//       //   }
//       //   if (widget.tipo == 'EDIT') {
//       //     await controller.editaHistoriaClinica(context);
//       //     Navigator.pop(context);
//       //   }
//       // }
//     }
//   }



// //  void _printTicket(Map<String, dynamic>? _info) async {


// //    // Inicializa la impresora
// //           await SunmiPrinter.initPrinter();
// //           await SunmiPrinter.startTransactionPrint(true);
          
// //           // Alinea al centro y imprime el nombre de la empresa
// //           await SunmiPrinter.setAlignment(SunmiPrintAlign.CENTER);
// //           await SunmiPrinter.line();
// //           await SunmiPrinter.printText('${_info!['venEmpComercial']}');
// //            await SunmiPrinter.printText('${_info['venEmpRuc']}');
// //           await SunmiPrinter.printText('${_info['venEmpDireccion']}');
// //           await SunmiPrinter.printText('${_info['venEmpTelefono']}');
// //            await SunmiPrinter.printText('${_info['venEmpEmail']}');
// //           // Imprime el número de CLIENTE
// //             await SunmiPrinter.setAlignment(SunmiPrintAlign.CENTER);
// //           await SunmiPrinter.line();
// //            await SunmiPrinter.printText('Cliente: ${_info['venNomCliente']}');
// //           await SunmiPrinter.printText('${_info['venRucCliente']}');
// //            await SunmiPrinter.setAlignment(SunmiPrintAlign.CENTER);
// //           await SunmiPrinter.line();
// //            await SunmiPrinter.printText('FECHA: ${_info['venFechaFactura']}');
// //              await SunmiPrinter.setAlignment(SunmiPrintAlign.CENTER);
// //           await SunmiPrinter.line();
// //   // Imprime el número de factura
// //           // Encabezado de la tabla
// //           await SunmiPrinter.printRow(cols: [
// //             ColumnMaker(
// //               text: 'Descripción',
// //               width: 12,
// //               align: SunmiPrintAlign.LEFT,
// //             ),
// //             ColumnMaker(
// //               text: 'Cant',
// //               width: 6,
// //               align: SunmiPrintAlign.CENTER,
// //             ),
// //             ColumnMaker(
// //               text: 'vU',
// //               width: 6,
// //               align: SunmiPrintAlign.RIGHT,
// //             ),
// //             ColumnMaker(
// //               text: 'TOT',
// //               width: 6,
// //               align: SunmiPrintAlign.RIGHT,
// //             ),
// //           ]);

// //           // Imprime cada ítem en la lista
// //           for (var item in _info['venProductos']) {
// //             await SunmiPrinter.printRow(cols: [
// //               ColumnMaker(
// //                 text: item['descripcion'],
// //                 width: 12,
// //                 align: SunmiPrintAlign.LEFT,
// //               ),
// //               ColumnMaker(
// //                 text: item['cantidad'],
// //                 width: 6,
// //                 align: SunmiPrintAlign.CENTER,
// //               ),
// //               ColumnMaker(
// //                 text: item['valorUnitario'],
// //                 width: 6,
// //                 align: SunmiPrintAlign.RIGHT,
// //               ),
// //               ColumnMaker(
// //                 text: item['precioSubTotalProducto'],
// //                 width: 6,
// //                 align: SunmiPrintAlign.RIGHT,
// //               ),
// //             ]);
// //           }

// //           await SunmiPrinter.line();
// //           // Agrega  fila

// //             await SunmiPrinter.printRow(cols: [
// //               ColumnMaker(
// //                 text: 'SubTotal', // Texto para la nueva fila
// //                 width: 25,
// //                 align: SunmiPrintAlign.LEFT,
// //               ),
// //               ColumnMaker(
// //                 text:  _info['precioSubTotalProducto'], // Valor para la nueva fila
// //                 width: 5,
// //                 align: SunmiPrintAlign.RIGHT,
// //               ),
// //             ]);

// //           // Imprime el total
// //           await SunmiPrinter.printRow(cols: [
// //             ColumnMaker(
// //               text: 'Iva',
// //               width: 25,
// //               align: SunmiPrintAlign.LEFT,
// //             ),
// //             ColumnMaker(
// //               text: _info['venTotalIva'],
// //               width: 5,
// //               align: SunmiPrintAlign.RIGHT,
// //             ),
// //           ]);

// //                // Imprime el total
// //           await SunmiPrinter.printRow(cols: [
// //             ColumnMaker(
// //               text: 'TOTAL',
// //               width: 25,
// //               align: SunmiPrintAlign.LEFT,
// //             ),
// //             ColumnMaker(
// //               text: _info['venTotal'],
// //               width: 5,
// //               align: SunmiPrintAlign.RIGHT,
// //             ),
// //           ]);

// //           await SunmiPrinter.lineWrap(2);
// //           await SunmiPrinter.exitTransactionPrint(true);





// //   }


// void _printTicket(Map<String, dynamic>? _info) async {
//   if (_info == null) return;

//   // Inicializa la impresora
//   await SunmiPrinter.initPrinter();
//   await SunmiPrinter.startTransactionPrint(true);

//   // Imprime el encabezado
//   await SunmiPrinter.setAlignment(SunmiPrintAlign.CENTER);
//   // await SunmiPrinter.line();
//   await SunmiPrinter.printText('${_info['venEmpComercial']}');
//   await SunmiPrinter.printText('${_info['venEmpRuc']}');
//   await SunmiPrinter.printText('${_info['venEmpDireccion']}');
//   await SunmiPrinter.printText('${_info['venEmpTelefono']}');
//   await SunmiPrinter.printText('${_info['venEmpEmail']}');
  
//   await SunmiPrinter.setAlignment(SunmiPrintAlign.CENTER);
//   await SunmiPrinter.line();
//   await SunmiPrinter.printText('Cliente: ${_info['venNomCliente']}');
//   await SunmiPrinter.printText('${_info['venRucCliente']}');
//   await SunmiPrinter.setAlignment(SunmiPrintAlign.CENTER);
//   await SunmiPrinter.line();
//   await SunmiPrinter.printText('FECHA: ${_info['venFechaFactura']}');

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
//     for (var item in productos) {
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

//  // Imprime el subtotal
// await SunmiPrinter.line();
// await SunmiPrinter.printRow(cols: [
//   ColumnMaker(
//     text: 'SubTotal',
//     width: 20, // Ajuste el ancho si es necesario
//     align: SunmiPrintAlign.LEFT,
//   ),
//   ColumnMaker(
//     text: _info['venSubTotal']?.toString() ?? '0',
//     width: 10, // Aumenta el ancho para números más grandes
//     align: SunmiPrintAlign.RIGHT,
//   ),
// ]);

// // Imprime el IVA
// await SunmiPrinter.printRow(cols: [
//   ColumnMaker(
//     text: 'Iva',
//     width: 20, // Ajuste el ancho si es necesario
//     align: SunmiPrintAlign.LEFT,
//   ),
//   ColumnMaker(
//     text: _info['venTotalIva']?.toString() ?? '0',
//     width: 10, // Aumenta el ancho para números más grandes
//     align: SunmiPrintAlign.RIGHT,
//   ),
// ]);

// // Imprime el total
// await SunmiPrinter.printRow(cols: [
//   ColumnMaker(
//     text: 'TOTAL',
//     width: 20, // Ajuste el ancho si es necesario
//     align: SunmiPrintAlign.LEFT,
//   ),
//   ColumnMaker(
//     text: _info['venTotal']?.toString() ?? '0',
//     width: 10, // Aumenta el ancho para números más grandes
//     align: SunmiPrintAlign.RIGHT,
//   ),
// ]);
//  await SunmiPrinter.line();
//   await SunmiPrinter.lineWrap(2);
//   await SunmiPrinter.exitTransactionPrint(true);
// }














// }

// class RadioButtonWithLabel extends StatelessWidget {
//   final int value;
//   final String label;

//   const RadioButtonWithLabel({
//     required this.value,
//     required this.label,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final radioProvider = context.watch<ComprobantesController>();

//     return Column(
//       children: <Widget>[
//         Text(label),
//         Radio<int>(
//           value: value,
//           groupValue: radioProvider.selectedValue,
//           onChanged: (newValue) {
//             radioProvider.setSelectedValue(newValue!);
//           },
//         ),
//       ],
//     );
//   }
// }

// // class ContainerRow extends StatelessWidget {

// //   @override
// //   Widget build(BuildContext context) {
// //        final Responsive size = Responsive.of(context);
// //     return SingleChildScrollView(
// //        scrollDirection: Axis.horizontal,
// //        physics: const BouncingScrollPhysics(),
// //       child: Row(
// //         mainAxisAlignment: MainAxisAlignment.center,
// //         children: <Widget>[
// //           for (int i = 1; i <= 7; i++)
// //             Container(
// //               margin: EdgeInsets.symmetric(horizontal: size.iScreen(1.0)), // Espaciado entre contenedores
// //               padding: EdgeInsets.all(10.0), // Espaciado interno del contenedor
// //               decoration: BoxDecoration(
// //                 color: Colors.white, // Color de fondo del contenedor
// //                 borderRadius: BorderRadius.circular(8.0), // Bordes redondeados
// //                 border: Border.all(color: Colors.grey, width: 1), // Borde gris
// //               ),
// //               child: Center(
// //                 child: Text(
// //                   getTextForIndex(i),
// //                    style: GoogleFonts.lexendDeca(
// //                                     fontSize: size.iScreen(2.0),
// //                                     fontWeight: FontWeight.normal,
// //                                     // color: Colors.grey
// //                                     )
// //                 ),
// //               ),
// //             ),
// //         ],
// //       ),
// //     );
// //   }

// //   String getTextForIndex(int index) {
// //     switch (index) {
// //       case 1:
// //         return '\$5';
// //       case 2:
// //         return '\$10';
// //       case 3:
// //         return '\$15';
// //       case 4:
// //         return '\$20';
// //       case 5:
// //         return '\$25';
// //       case 6:
// //         return '\$30';
// //       case 7:
// //         return 'Lleno';
// //       default:
// //         return '';
// //     }
// //   }
// // }

// class ContainerRow extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final Responsive size = Responsive.of(context);
//     return SingleChildScrollView(
//       scrollDirection: Axis.horizontal,
//       physics: const BouncingScrollPhysics(),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: <Widget>[
//           for (int i = 1; i <= 7; i++)
//             Consumer<ComprobantesController>(
//               builder: (context, selectionProvider, child) {
//                 final isSelected =
//                     selectionProvider.selectedIndex == getTextForIndex(i);
//                 return GestureDetector(
//                   onTap: () {
//                     final selectedValue = getTextForIndex(i);
//                     selectionProvider.selectIndex(i);
//                     selectionProvider.selectValue(selectedValue);
//                   },
//                   child: Container(
//                     margin: EdgeInsets.symmetric(
//                         horizontal:
//                             size.iScreen(0.6)), // Espaciado entre contenedores
//                     padding: EdgeInsets.all(
//                         size.iScreen(1.0)), // Espaciado interno del contenedor
//                     decoration: BoxDecoration(
//                       color: selectionProvider.selectedIndex == i
//                           ? Colors.blue
//                           : Colors
//                               .white, // Color de fondo basado en la selección
//                       borderRadius:
//                           BorderRadius.circular(8.0), // Bordes redondeados
//                       border: Border.all(
//                           color: Colors.grey, width: 1), // Borde gris
//                     ),
//                     child: Center(
//                       child: Text(
//                         getTextForIndex(i),
//                         style: GoogleFonts.lexendDeca(
//                           fontSize: size.iScreen(2.5),
//                           fontWeight: FontWeight.normal,
//                           color: selectionProvider.selectedIndex == i
//                               ? Colors.white
//                               : Colors
//                                   .black, // Color del texto basado en la selección
//                         ),
//                       ),
//                     ),
//                   ),
//                 );
//               },
//             ),
//         ],
//       ),
//     );
//   }

//   String getTextForIndex(int index) {
//     switch (index) {
//       case 1:
//         return '\$5';
//       case 2:
//         return '\$10';
//       case 3:
//         return '\$15';
//       case 4:
//         return '\$20';
//       case 5:
//         return '\$25';
//       case 6:
//         return '\$30';
//       case 7:
//         return 'Lleno';
//       default:
//         return '';
//     }
//   }







// }

// class ContainerCombustible extends StatelessWidget {
//   // Método para manejar la selección
//   void _onContainerSelected(String text) {
//     print('Seleccionado: $text');
//   }

//   @override
//   Widget build(BuildContext context) {
//     final Responsive size = Responsive.of(context);
//     return Container(
//       width: size.wScreen(60),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceAround,
//         children: <Widget>[
//           for (String text in ['Super', 'Extra con Ethanol', 'Diesel'])
//             GestureDetector(
//               onTap: () {
//                 Provider.of<ComprobantesController>(context, listen: false)
//                     .select(text);
//               },
//               child: Consumer<ComprobantesController>(
//                 builder: (context, selectionNotifier, child) {
//                   final isSelected =
//                       selectionNotifier.selectedTextCombustible == text;
//                   return Container(
//                     margin: EdgeInsets.symmetric(
//                         horizontal:
//                             size.iScreen(1.0)), // Espaciado entre contenedores
//                     padding: EdgeInsets.all(
//                         size.iScreen(1.0)), // Espaciado interno del contenedor
//                     decoration: BoxDecoration(
//                       color: isSelected
//                           ? Colors.blue
//                           : Colors.white, // Color de fondo según selección
//                       borderRadius:
//                           BorderRadius.circular(8.0), // Bordes redondeados
//                       border: Border.all(
//                           color: Colors.grey, width: 1), // Borde gris
//                     ),
//                     child: Center(
//                       child: Text(text,
//                           style: GoogleFonts.lexendDeca(
//                             fontSize: size.iScreen(2.0),
//                             fontWeight: FontWeight.normal,
//                             color: isSelected ? Colors.white : Colors.black,
//                           )),
//                     ),
//                   );
//                 },
//               ),
//             ),
//         ],
//       ),
//     );
//   }












// }



import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:neitorcont/src/api/api_provider.dart';
import 'package:neitorcont/src/api/authentication_client.dart';
import 'package:neitorcont/src/controllers/comprobantes_controller.dart';
import 'package:neitorcont/src/controllers/facturas_controller.dart';
import 'package:neitorcont/src/controllers/home_controller.dart';
import 'package:neitorcont/src/controllers/prefacturas_controller.dart';
import 'package:neitorcont/src/controllers/proformas_controller.dart';
import 'package:neitorcont/src/controllers/propietarios_controller.dart';
import 'package:neitorcont/src/models/sesison_model.dart';
import 'package:neitorcont/src/pages/buscar_productos_varios.dart';
import 'package:neitorcont/src/pages/crear_propietario.dart';
import 'package:neitorcont/src/pages/print.dart';
import 'package:neitorcont/src/services/notifications_service.dart';
import 'package:neitorcont/src/services/socket_service.dart';
import 'package:neitorcont/src/theme/theme_provider.dart';
import 'package:neitorcont/src/utils/dialogs.dart';
import 'package:neitorcont/src/utils/fechaLocal.dart';
import 'package:neitorcont/src/utils/letras_mayusculas_minusculas.dart';
import 'package:neitorcont/src/utils/responsive.dart';
import 'package:neitorcont/src/utils/solo_decimales.dart';
import 'package:neitorcont/src/utils/valida_email.dart';
import 'package:neitorcont/src/widgets/no_data.dart';
import 'package:provider/provider.dart';
import 'package:sunmi_printer_plus/column_maker.dart';
import 'package:sunmi_printer_plus/enums.dart';
import 'package:sunmi_printer_plus/sunmi_printer_plus.dart';
import 'package:image/image.dart' as img;

class CrearComprobante extends StatefulWidget {

  final String? tipo;
 
   final Session? user;
  const CrearComprobante({Key? key, this.tipo, this.user,}) : super(key: key);

  @override
  State<CrearComprobante> createState() => _CrearComprobanteState();
}

class _CrearComprobanteState extends State<CrearComprobante> {
  final TextEditingController _rucCliController = TextEditingController();
  final TextEditingController _rucChofController = TextEditingController();

  TextEditingController _controller = TextEditingController();
   TextEditingController _textAddPlaca = TextEditingController();
  TextEditingController _textAddCorreo = TextEditingController();


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

 _rucCliController.dispose();
   _rucChofController.dispose();

 _controller.dispose();
  _textAddPlaca.dispose();
    _textAddCorreo.dispose();


    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Responsive size = Responsive.of(context);
    final ctrl = context.read<ComprobantesController>();
    final ctrlTheme = context.read<ThemeProvider>();

         WidgetsBinding.instance!.addPostFrameCallback((_) {
            final ctrlSock = context.read<SocketService>();
              if ( ctrlSock.latestResponseVentas!.isNotEmpty &&  ctrlSock.latestResponseVentas!['tabla']=='proveedor') {
        final _ctrls=context.read<ComprobantesController>();
         _ctrls.setClienteComprbante({
			"perId": ctrlSock.latestResponseVentas!['perId'],
			"perNombre": ctrlSock.latestResponseVentas!['perNombre'],
			"perDocNumero": ctrlSock.latestResponseVentas!['perDocNumero'],
			"perDocTipo": ctrlSock.latestResponseVentas!['perDocTipo'],
			"perTelefono":ctrlSock.latestResponseVentas!['perTelefono'],
			"perDireccion": ctrlSock.latestResponseVentas!['perDireccion'],
			"perEmail": ctrlSock.latestResponseVentas!['perEmail'],
			"perCelular": ctrlSock.latestResponseVentas!['perCelular'],
			"perOtros": ctrlSock.latestResponseVentas!['perOtros'],
		});
              

// print('ESTA ES LA DATA DEL SOCKET PROPIETARIO: ${ctrlSock.latestResponse}');



            } else {

            }
   
  });




    return 
    
    
    GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: widget.tipo == 'CREATE' || widget.tipo == 'SEARCH'
              ? Text('Crear Comprobante')
              : Text('Editar Comprobante'),
          actions: [

              Consumer<SocketService>(builder: (_, values, __) {  

                  return  
                  values.getEstadoPrintVenta==false
                  ?Consumer<ComprobantesController>(builder: (BuildContext context, value, Widget? child) { 
                return Container(
              margin: EdgeInsets.only(right: size.iScreen(1.5)),
              child: IconButton(
                  splashRadius: 28,
                  onPressed: value.getRespuestaCalculoItem.isNotEmpty?() {
                    _onSubmit(
                      context,
                      ctrl,
                    );
                  }:(){
                     NotificatiosnService.showSnackBarDanger(
            'Debe agregar información necesaria');
                  },
                  icon: Icon(
                    Icons.save_outlined,
                    size: size.iScreen(4.0),
                  )),
            );
             },):Container();
            

              },),

            
          // Consumer<SocketService>(
          //   builder: (_,value, __) {
          //    return value.latestResponse!.isEmpty ||  value.latestResponse!['tabla']=='proveedor'
          //   ?
          //   Container(
          //     margin: EdgeInsets.only(right: size.iScreen(1.5)),
          //     child: IconButton(
          //         splashRadius: 28,
          //         onPressed: () {
          //           _onSubmit(
          //             context,
          //             ctrl,
          //           );
          //         },
          //         icon: Icon(
          //           Icons.save_outlined,
          //           size: size.iScreen(4.0),
          //         )),
          //   ):Container();

          //   // : Container();
          //   })
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
              key: ctrl.comprobantesFormKey,
              child: Column(
                children: [
                  // //***********************************************/
                  // SizedBox(
                  //   height: size.iScreen(1.5),
                  // ),
                  // //*****************************************/
                  // Row(
                  //   children: [
                  //     SizedBox(
                  //       // width: size.wScreen(100.0),
            
                  //       // color: Colors.blue,
                  //       child: Text('TIPO CODUMENTO :',
                  //           style: GoogleFonts.lexendDeca(
                  //               // fontSize: size.iScreen(2.0),
                  //               fontWeight: FontWeight.normal,
                  //               color: Colors.grey)),
                  //     ),
                  //     Consumer<ComprobantesController>(
                  //       builder: (_, valueTipo, __) {
                  //         return Container(
                  //           // color: Colors.red,
                  //           width: size.wScreen(50.0),
            
                  //           // color: Colors.blue,
                  //           child: Text(
                  //               valueTipo.getTipoDocumento.isEmpty
                  //                   ? ' --- --- --- --- ---'
                  //                   : ' ${valueTipo.getTipoDocumento}',
                  //               style: GoogleFonts.lexendDeca(
                  //                   fontSize: size.iScreen(2.0),
                  //                   fontWeight: FontWeight.normal,
                  //                   color: valueTipo.getTipoDocumento.isEmpty
                  //                       ? Colors.grey
                  //                       : Colors.black)),
                  //         );
                  //       },
                  //     ),
                  //     Spacer(),
                  //     ClipRRect(
                  //       borderRadius: BorderRadius.circular(8),
                  //       child: GestureDetector(
                  //         onTap: () {
                  //           // context
                  //           //     .read<MascotasController>()
                  //           //     .buscaAllMascotas('');
            
                  //           // // _buscarMascota(context, size);
                  //           modalTipoDocumento(context, size, ctrl);
            
                  //           // //*******************************************/
                  //         },
                  //         child: Consumer<ThemeProvider>(
                  //           builder: (_, valueTheme, __) {
                  //             return Container(
                  //               alignment: Alignment.center,
                  //               color: valueTheme.appTheme.primaryColor,
                  //               width: size.iScreen(3.5),
                  //               padding: EdgeInsets.only(
                  //                 top: size.iScreen(0.5),
                  //                 bottom: size.iScreen(0.5),
                  //                 left: size.iScreen(0.5),
                  //                 right: size.iScreen(0.5),
                  //               ),
                  //               child: Icon(
                  //                 Icons.add,
                  //                 color: Colors.white,
                  //                 size: size.iScreen(2.0),
                  //               ),
                  //             );
                  //           },
                  //         ),
                  //       ),
                  //     ),
                  //   ],
                  // ),


                  //**********************SE MUESTRA LA OPCION DE IMPRIMIR *************************//
                        Consumer<SocketService>(
        builder: (_,value, __) {
          
         
     return 
         value.latestResponseVentas!.isNotEmpty 
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
                     
                    //  print('LA INFORMACION PARA PRINT: ${value.latestResponseVentas!}');
                       String fechaLocal ='';

                         
                             fechaLocal= convertirFechaLocal(value.latestResponseVentas!['venFecReg']);
                          

                       

                    _printTicket( value.latestResponseVentas! ,widget.user!.logo,fechaLocal);



                    //========================================//
                        final _ctrl =context.read<ComprobantesController>();
                   if (_ctrl.getTipoDeTransaccion=='F') {
                      //================FACTURAS F ==================//
                 final _controllerFacturas =
                            context.read<FacturasController>();

                        _controllerFacturas
                            .onSearchTextFacturaPaginacion("");

                        _controllerFacturas
                            .setBtnSearchFacturaPaginacion(false);
                        _controllerFacturas
                            .setErrorFacturasPaginacion(null);

                        _controllerFacturas
                            .setError401FacturasPaginacion(false);

                        _controllerFacturas.resetFormFacturas();
                        _controllerFacturas.setPage(0);
                        _controllerFacturas.setIsNext(false);
                        _controllerFacturas
                            .setInfoBusquedaFacturasPaginacion([]);
                        _controllerFacturas.buscaAllFacturasPaginacion(
                            '',false,0);
                   }
                if (_ctrl.getTipoDeTransaccion=='N') {
                //================PREFACTURAS N ==================//
                 final _controllerPreFacturas =
                            context.read<PreFacturasController>();

                        _controllerPreFacturas
                            .onSearchTextPreFacturaPaginacion("");

                        _controllerPreFacturas
                            .setBtnSearchPreFacturaPaginacion(false);
                        _controllerPreFacturas
                            .setErrorPreFacturasPaginacion(null);

                        _controllerPreFacturas
                            .setError401PreFacturasPaginacion(false);

                        _controllerPreFacturas.resetFormPreFacturas();
                        _controllerPreFacturas.resetValorTotal();
                        _controllerPreFacturas.restetTotalGenerales();
                        _controllerPreFacturas.setPage(0);
                        _controllerPreFacturas.setIsNext(false);
                        _controllerPreFacturas
                            .setInfoBusquedaPreFacturasPaginacion([]);
                        _controllerPreFacturas
                            .buscaAllPreFacturasPaginacion('', true,0);
                }
                  if (_ctrl.getTipoDeTransaccion=='P') {
                    //================PROFORMAS P ==================//
            final _controllerProformas =
                            context.read<ProformasController>();

                        _controllerProformas
                            .onSearchTextProformasPaginacion("");

                        _controllerProformas
                            .setBtnSearchProformasPaginacion(false);
                        _controllerProformas
                            .setErrorProformasPaginacion(null);

                        _controllerProformas
                            .setError401ProformasPaginacion(false);

                        _controllerProformas.resetFormProformas();
                        _controllerProformas.setPage(0);
                        _controllerProformas.setIsNext(false);
                        _controllerProformas
                            .setInfoBusquedaProformasPaginacion([]);
                        _controllerProformas.buscaAllProformasPaginacion(
                            '', true,0);

                     //==================================//
                  }



Navigator.pop(context);

                    //*********************LA DATA PARA IMPRIMIR*******************//

              // print('LA DATA PARA IMPRIMIR =======>: ${value.latestResponse!}');





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
                    final _ctrl =context.read<ComprobantesController>();
                    if (_ctrl.getTipoDeTransaccion=='F') {
                       //================FACTURAS F ==================//
                  final _controllerFacturas =
                             context.read<FacturasController>();

                         _controllerFacturas
                             .onSearchTextFacturaPaginacion("");

                         _controllerFacturas
                             .setBtnSearchFacturaPaginacion(false);
                         _controllerFacturas
                             .setErrorFacturasPaginacion(null);

                         _controllerFacturas
                             .setError401FacturasPaginacion(false);

                         _controllerFacturas.resetFormFacturas();
                         _controllerFacturas.setPage(0);
                         _controllerFacturas.setIsNext(false);
                         _controllerFacturas
                             .setInfoBusquedaFacturasPaginacion([]);
                         _controllerFacturas.buscaAllFacturasPaginacion(
                             '',false,0);
                    }
                 if (_ctrl.getTipoDeTransaccion=='N') {
                 //================PREFACTURAS N ==================//
                  final _controllerPreFacturas =
                             context.read<PreFacturasController>();

                         _controllerPreFacturas
                             .onSearchTextPreFacturaPaginacion("");

                         _controllerPreFacturas
                             .setBtnSearchPreFacturaPaginacion(false);
                         _controllerPreFacturas
                             .setErrorPreFacturasPaginacion(null);

                         _controllerPreFacturas
                             .setError401PreFacturasPaginacion(false);

                         _controllerPreFacturas.resetFormPreFacturas();
                         _controllerPreFacturas.setPage(0);
                         _controllerPreFacturas.setIsNext(false);
                         _controllerPreFacturas
                             .setInfoBusquedaPreFacturasPaginacion([]);
                         _controllerPreFacturas
                             .buscaAllPreFacturasPaginacion('', true,0);
                 }
                   if (_ctrl.getTipoDeTransaccion=='P') {
                     //================PROFORMAS P ==================//
             final _controllerProformas =
                             context.read<ProformasController>();

                         _controllerProformas
                             .onSearchTextProformasPaginacion("");

                         _controllerProformas
                             .setBtnSearchProformasPaginacion(false);
                         _controllerProformas
                             .setErrorProformasPaginacion(null);

                         _controllerProformas
                             .setError401ProformasPaginacion(false);

                         _controllerProformas.resetFormProformas();
                         _controllerProformas.setPage(0);
                         _controllerProformas.setIsNext(false);
                         _controllerProformas
                             .setInfoBusquedaProformasPaginacion([]);
                         _controllerProformas.buscaAllProformasPaginacion(
                             '', true,0);

                      //==================================//
                   }
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
                    height: size.iScreen(1.0),
                  ),
                  //*****************SI ES MOTO O CARRRO************************/

                 
                  Column(
                    children: [

                                   Container(
                 
                    padding: EdgeInsets.only(bottom: size.iScreen(1.0)),
                    
                    child: Row(
                     
                      children: [


//*************** PLACA ****************//
Consumer<ComprobantesController>(builder: (_, value, __) {  
  return   Row(
     mainAxisAlignment: MainAxisAlignment.spaceAround,
    children: [
        value.getTypeAction=='MOTOS'?   SizedBox(
                        // width: size.wScreen(100.0),
            
                        // color: Colors.blue,
                        child: Text('Placa: ',
                            style: GoogleFonts.lexendDeca(
                                fontSize: size.iScreen(2.0),
                                fontWeight: FontWeight.normal,
                                color: Colors.grey)),
                      ):Container(),
      Container(
        // color: Colors.red,
                              width: value.getTypeAction=='VEHICULOS'?size.iScreen(15.0):size.iScreen(20.0),
                              child: TextFormField(
                                textAlign: TextAlign.center,
                                autofocus: false,
                                controller: _textAddPlaca,
                                decoration: InputDecoration(
                                          label:  value.getTypeAction=='MOTOS'? Text( ''):Text( 'Placa'),
                                          labelStyle:TextStyle(color: Colors.grey,fontSize: size.iScreen(1.9)),
                                          // hintText: 'Ingrese Documento', // Texto de sugerencia dentro del campo
                                          // border: OutlineInputBorder(), // Opcional: Añade un borde al campo
                                          helperStyle:
                                              TextStyle(color: Colors.grey,fontSize: size.iScreen(1.5)),
                                        ),
                                style: TextStyle(
                                  fontSize: size.iScreen(2.8),
                                  color: Colors.black,
                                ),
                                inputFormatters: <TextInputFormatter>[
                                  UpperCaseText(),
                                ],
                                onChanged: (text) {
                                  ctrl.seItemAddPlaca(text);
                                },
                                validator: (text) {
                                  if (text!.trim().isNotEmpty) {
                                    return null;
                                  } else {
                                    return 'Ingrese Placa';
                                  }
                                },
                              ),
                            ),
    ],
  );

},),
 

//********************************//


                          Consumer<ComprobantesController>(builder: (_, value, __) { 
                            return  
                            value.getExistCliente==false
                            ?ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: GestureDetector(
                            onTap:() {
                           
                                     final ctrlPropi=  context.read<PropietariosController>();
                     ctrlPropi.resetFormPropietario();


ctrlPropi.setDocumento(value.getDocumento);
 ctrlPropi.setGeneros('');
  ctrlPropi.setNombres('');
                 ctrlPropi.setDireccion('');
                   ctrlPropi.setLabelTelefono('');
                  ctrlPropi.seItemAddPlaca('');
                   ctrlPropi.resetPlacas();
                     ctrlPropi.resetCelulares();
                    ctrlPropi.resetCorreos();
                ctrlPropi.setObservacion('');

                 ctrlPropi.setPais('');
                  ctrlPropi.setListaTodosLosPaises([]);
                  ctrlPropi.setProvincia('');
                  ctrlPropi.setListaTodasLasProvincias([]);
                   ctrlPropi.setCanton('');
                    ctrlPropi.setListaTodosLosCantones([]);


                  Navigator.of(context)
                      .push(MaterialPageRoute(
                          builder: (context) =>
                               CrearPropietario(action: 'CREATE',tipo:'comprobantes',
                              user: widget.user,)));
                                  },
                            child:
                               
                                Consumer<ThemeProvider>(
                              builder: (_, valueTheme, __) {
                                return Container(
                                  alignment: Alignment.center,
                                  color: valueTheme.appTheme.accentColor,
                                  width: size.iScreen(4.5),
                                  height: size.iScreen(4.5),
                                  padding: EdgeInsets.only(
                                    top: size.iScreen(0.5),
                                    bottom: size.iScreen(0.5),
                                    left: size.iScreen(0.5),
                                    right: size.iScreen(0.5),
                                  ),
                                  child: Icon(
                                    Icons.person_add_alt,
                                    color: Colors.white,
                                    size: size.iScreen(2.0),
                                  ),
                                );
                              },
                            ),
                          ),
                        ):Container();
                            
                           },),

                            
                          
                              
                                Consumer<ComprobantesController>(
                          builder: (_, tipo, __) {
                            return 
                              ctrl.getTypeAction=='VEHICULOS'

                  ?
                            Row(
                              children: [
                                SizedBox(width: size.iScreen(0.5),),
                                Container(
                                  width: size.iScreen(20),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      TextField(
                                        decoration: InputDecoration(
                                          label: Text( 'Documento'),
                                          labelStyle:TextStyle(color: Colors.grey,fontSize: size.iScreen(1.9)),
                                          // hintText: 'Ingrese Documento', // Texto de sugerencia dentro del campo
                                          // border: OutlineInputBorder(), // Opcional: Añade un borde al campo
                                          helperStyle:
                                              TextStyle(color: Colors.grey,fontSize: size.iScreen(1.5)),
                                        ),
                                        inputFormatters: [
                                          UpperCaseText(), // Limita a 13 dígitos
                                        ],
                                        style: TextStyle(
                                          fontSize: size.iScreen( 2.8), // Ajusta el tamaño de la letra
                                          // fontWeight: FontWeight.bold, // Opcional: Aplica un peso de fuente más grueso
                                        ),
                                        textAlign: TextAlign.center,
                                        onChanged: (text) {
                                          ctrl.setDocumento(text);
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                Consumer<ComprobantesController>(builder: (_, value, __) { 
                            return  ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: GestureDetector(
                            onTap: value.getDocumento!.isNotEmpty
                                ? () async {
                                    ProgressDialog.show(context);
                                    final response = await value.buscaClienteComprobante();
                                    ProgressDialog.dissmiss(context);
                                    if (response != null) {
                                       if(value.getClienteComprobante.isNotEmpty){
                                       
                                      //  NotificatiosnService.showSnackBarDanger( '${value.getClienteComprobante}');
                                     }else{
                                       value.setExistCliente(false);

                                       final _ctrl =context.read<ComprobantesController>();
                       _ctrl.resetListasProdutos();
                     _ctrl.resetPlacas();
                            // _ctrl.setDocumento('');
                            _ctrl.setFormaDePago('EFECTIVO');
                            _ctrl.setFacturaOk(false);
                           
                             _ctrl.setClienteComprbante({});
                             _ctrl.resetCorreos();



                                      NotificatiosnService.showSnackBarDanger( 'No se encuentra información,ingrese datos manualmente');
                                   
                                     }
                                     
                                    } else {
            
                                    }
                                    
            
                                    //     .searchAllPersinas('');
                                    // Navigator.of(context).push(
                                    //     MaterialPageRoute(
                                    //         builder: (context) =>
                                    //             BuscarPropietario()));
                                  }
                                : () {
                                    NotificatiosnService.showSnackBarDanger(
                                        'Debe ingresar Documento para buscar');
                                  },
                            child:
                                // Container(
                                //   alignment: Alignment.center,
                                //   color: primaryColor,
                                //   width: size.iScreen(3.5),
                                //   padding: EdgeInsets.only(
                                //     top: size.iScreen(0.5),
                                //     bottom: size.iScreen(0.5),
                                //     left: size.iScreen(0.5),
                                //     right: size.iScreen(0.5),
                                //   ),
                                //   child: Icon(
                                //     Icons.search_outlined,
                                //     color: Colors.white,
                                //     size: size.iScreen(2.0),
                                //   ),
                                // ),
                                Consumer<ThemeProvider>(
                              builder: (_, valueTheme, __) {
                                return Container(
                                  alignment: Alignment.center,
                                  color: valueTheme.appTheme.primaryColor,
                                  width: size.iScreen(4.5),
                                  height: size.iScreen(4.5),
                                  padding: EdgeInsets.only(
                                    top: size.iScreen(0.5),
                                    bottom: size.iScreen(0.5),
                                    left: size.iScreen(0.5),
                                    right: size.iScreen(0.5),
                                  ),
                                  child: Icon(
                                    Icons.search_outlined,
                                    color: Colors.white,
                                    size: size.iScreen(2.0),
                                  ),
                                );
                              },
                            ),
                          ),
                        );
                      
                           },)
            
                              ],
                            ):Container();
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
            
            Consumer<ComprobantesController>(builder: (_, value, __) {  
            
            return 
            value.getClienteComprobante.isNotEmpty?
             Column(
                    children: [
                      Container(
                        width: size.wScreen(100.0),
            
                        // color: Colors.blue,
                        child:  Text(value.getClienteComprobante.isEmpty?'--- --- --- --- ---':'${value.getClienteComprobante['perNombre']}',
                            style: GoogleFonts.lexendDeca(
                              fontSize: size.iScreen(2.3),
                              fontWeight: FontWeight.normal,
                              color: value.getClienteComprobante.isEmpty?Colors.grey:Colors.black
                            )),
                      ),
                  //***********************************************/
                  SizedBox(
                    height: size.iScreen(1.0),
                  ),
                  //*****************************************/
                  // Container(
                  //   width: size.wScreen(100.0),
            
                  //   // color: Colors.blue,
                  //   child:  Text(value.getClienteComprobante.isEmpty?'--- --- --- --- ---':value.getClienteComprobante['perEmail'].isEmpty?'--- --- --- --- ---':'${value.getClienteComprobante['perEmail'][0]}',
                  //       style: GoogleFonts.lexendDeca(
                  //         fontSize: size.iScreen(2.0),
                  //         fontWeight: FontWeight.normal,
                  //          color: value.getClienteComprobante.isEmpty?Colors.grey:Colors.black
                  //       )),
                  // ),
                    ],
                  ):Container();
            
            
            },),
            
                
                  //***********************************************/
                        SizedBox(
                          height: size.iScreen(0.0),
                        ),
                        //*****************************************/

                        Row(
                          children: [
                            SizedBox(
                                width: size.wScreen(20.0),

                                // color: Colors.blue,
                                child: Consumer<ComprobantesController>(
                                  builder: (_, valueCantCorreos, __) {
                                    return Row(
                                      children: [
                                        Text('Correo: ',
                                            style: GoogleFonts.lexendDeca(
                                                fontSize: size.iScreen(2.0),
                                                fontWeight:
                                                    FontWeight.normal,
                                                color: Colors.grey)),
                                        valueCantCorreos.getlistaAddCorreos!
                                                .isNotEmpty
                                            ? Text(
                                                '${valueCantCorreos.getlistaAddCorreos!.length} ',
                                                style:
                                                    GoogleFonts.lexendDeca(
                                                        fontSize: size.iScreen(2.0),
                                                        fontWeight:
                                                            FontWeight
                                                                .normal,
                                                        color: Colors.grey))
                                            : Container(),
                                      ],
                                    );
                                  },
                                )),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: GestureDetector(
                                onTap: () {
                                  _agregaCorreo(context, ctrl, size);

//*******************************************/
                                },
                                child: 
                                // Consumer<AppTheme>(builder: (_, valueTheme, __) {  
                                //   return Container(
                                //     alignment: Alignment.center,
                                //     color: valueTheme.getPrimaryTextColor,
                                //     width: size.iScreen(3.5),
                                //     padding: EdgeInsets.only(
                                //       top: size.iScreen(0.5),
                                //       bottom: size.iScreen(0.5),
                                //       left: size.iScreen(0.5),
                                //       right: size.iScreen(0.5),
                                //     ),
                                //     child: Icon(
                                //       Icons.add,
                                //       color: valueTheme.getSecondryTextColor,
                                //       size: size.iScreen(2.0),
                                //     ),
                                //   );
                                // },
                       
                                // ),
                                 Consumer<ThemeProvider>(builder: (_, valueTheme, __) {  
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
                                        Icons.add,
                                        color: Colors.white,
                                        size: size.iScreen(2.0),
                                      ),
                                    );
                                  },
                                  ),
                              ),
                            ),
                          ],
                        ),
                          //***********************************************/
                        SizedBox(
                          height: size.iScreen(0.0),
                        ),
                        //*****************************************/

                        Consumer<ComprobantesController>(
                          builder: (_, valueCorreos, __) {
                            return SizedBox(
                              // color: Colors.red,
                              width: size.wScreen(100.0),
                              child: Wrap(
                                children: valueCorreos.getlistaAddCorreos!
                                    .map(
                                      (e) => Row(
                                        children: [
                                          Expanded(
                                            child: GestureDetector(
                                              onDoubleTap: () {
                                                // print(e);
                                                valueCorreos
                                                    .eliminaCorreo(e);
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    color: Colors
                                                        .grey.shade200,
                                                    borderRadius:
                                                        BorderRadius
                                                            .circular(5.0)),
                                                margin:
                                                    EdgeInsets.symmetric(
                                                        vertical: size
                                                            .iScreen(0.5)),
                                                padding:
                                                    EdgeInsets.symmetric(
                                                        horizontal: size
                                                            .iScreen(1.0),
                                                        vertical: size
                                                            .iScreen(0.5)),
                                                child: Text('$e',
                                                    style: GoogleFonts
                                                        .lexendDeca(
                                                            fontSize: size
                                                                .iScreen(
                                                                    2.0),
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                            color: Colors
                                                                .black)),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                    .toList(),
                              ),

                              // Column(
                              //   children: [
                              //     Row(
                              //       children: [
                              //         Expanded(
                              //           child: Container(
                              //             decoration: BoxDecoration(
                              //                 color: Colors.grey.shade300,
                              //                 borderRadius:
                              //                     BorderRadius.circular(5.0)),
                              //             margin: EdgeInsets.symmetric(
                              //                 vertical: size.iScreen(0.5)),
                              //             padding: EdgeInsets.symmetric(
                              //                 horizontal: size.iScreen(1.0),
                              //                 vertical: size.iScreen(0.5)),
                              //             child: Text('correo@corresdf.com',
                              //                 style: GoogleFonts.lexendDeca(
                              //                     fontSize: size.iScreen(1.7),
                              //                     fontWeight: FontWeight.normal,
                              //                     color: Colors.black)),
                              //           ),
                              //         ),
                              //       ],
                              //     ),
                              //   ],
                              // ),
                            );
                          },
                        ),
                       
                       
            //*****************************************/
                  SizedBox(
                    height: size.iScreen(0.0),
                  ),
                  //*****************************************/
                      


                    ],
                  ),



                  // Row(
                  //   children: [
                  //     SizedBox(
                  //       // width: size.wScreen(100.0),
            
                  //       // color: Colors.blue,
                  //       child: Text('Placa: ',
                  //           style: GoogleFonts.lexendDeca(
                  //               fontSize: size.iScreen(2.0),
                  //               fontWeight: FontWeight.normal,
                  //               color: Colors.grey)),
                  //     ),
                  //  Row(
                  //    children: [
                  //      SizedBox(
                  //         width: size.iScreen(20.0),
                  //         child: TextFormField(
                  //           textAlign: TextAlign.center,
                  //           autofocus: false,
                  //           controller: _textAddPlaca,
                  //           decoration: const InputDecoration(
                  //             // Aquí puedes agregar más personalización si es necesario
                  //           ),
                  //           style: TextStyle(
                  //             fontSize: size.iScreen(3.5),
                  //             color: Colors.black,
                  //           ),
                  //           inputFormatters: <TextInputFormatter>[
                  //             UpperCaseText(),
                  //           ],
                  //           onChanged: (text) {
                  //             ctrl.seItemAddPlaca(text);
                  //           },
                  //           validator: (text) {
                  //             if (text!.trim().isNotEmpty) {
                  //               return null;
                  //             } else {
                  //               return 'Ingrese Placa';
                  //             }
                  //           },
                  //         ),
                  //       ),
                  //   //     TextButton(
                  //   //   onPressed: () {
                  //   //     final isValidS = ctrl.validateFormPlaca();
                  //   //     if (!isValidS) return;
                  //   //     if (isValidS) {
                  //   //       _textAddPlaca.text = '';
                  //   //       ctrl.agregaListaPlacas();
                  //   //       // Navigator.pop(context);
                  //   //     }
                  //   //   },
                  //   //   child: Consumer<ThemeProvider>(
                  //   //     builder: (_, valueTheme, __) {
                  //   //       return Container(
                  //   //         width: size.iScreen(5.0),
                  //   //         height:  size.iScreen(4.0),
                  //   //         decoration: BoxDecoration(
                  //   //           color: valueTheme.appTheme.primaryColor,
                  //   //           borderRadius: BorderRadius.circular(5.0),
                  //   //         ),
                  //   //         padding: EdgeInsets.symmetric(
                  //   //           vertical: size.iScreen(0.5),
                  //   //           horizontal: size.iScreen(0.5),
                  //   //         ),
                  //   //         child: Icon(
                  //   //               Icons.add,
                  //   //               color: Colors.white,
                  //   //               size: size.iScreen(2.0),
                  //   //             ),
                  //   //       );
                  //   //     },
                  //   //   ),
                  //   // ),
                  //    ],
                  //  ),
                  //    //****************************************//
                  //     // ClipRRect(
                  //     //   borderRadius: BorderRadius.circular(8),
                  //     //   child: GestureDetector(
                  //     //     onTap: () {
                  //     //       // context
                  //     //       //     .read<MascotasController>()
                  //     //       //     .buscaAllMascotas('');
            
                  //     //       // // _buscarMascota(context, size);
                  //     //       _agregaPlaca(context,ctrl,size);
            
                  //     //       // //*******************************************/
                  //     //     },
                  //     //     child: Consumer<ThemeProvider>(
                  //     //       builder: (_, valueTheme, __) {
                  //     //         return Container(
                  //     //           alignment: Alignment.center,
                  //     //           color: valueTheme.appTheme.primaryColor,
                  //     //           width: size.iScreen(4.5),
                  //     //           padding: EdgeInsets.only(
                  //     //             top: size.iScreen(0.5),
                  //     //             bottom: size.iScreen(0.5),
                  //     //             left: size.iScreen(0.5),
                  //     //             right: size.iScreen(0.5),
                  //     //           ),
                  //     //           child: Icon(
                  //     //             Icons.add,
                  //     //             color: Colors.white,
                  //     //             size: size.iScreen(2.0),
                  //     //           ),
                  //     //         );
                  //     //       },
                  //     //     ),
                  //     //   ),
                  //     // ),
                  
                  
                  
                  
                  //   ],
                  // ),
  //*****************************************/
                  //  SizedBox(
                  //   height: size.iScreen(1.0),
                  // ),
                  //   //*****************************************/
                   
                  //   //*****************************************/
                  //  SizedBox(
                  //   height: size.iScreen(1.0),
                  // ),
                  //   //*****************************************/
                  // SizedBox(
                  //    width: size.wScreen(100.0),
                  //   child: 
                  //   Consumer<ComprobantesController>(builder: (_, value, __) {  
                  //     return 
                  //     value.getlistaAddPlacas!.isNotEmpty?
                  //     Wrap( children: (value.getlistaAddPlacas as List).map((e) =>
                  //     GestureDetector(
                  //       onDoubleTap: () {
                  //         value.eliminaPlaca(e);
                  //       },
                  //       child: Container(
                  //         margin: EdgeInsets.symmetric(horizontal: size.iScreen(1.0),vertical: size.iScreen(0.5)),
                  //          padding: EdgeInsets.symmetric(horizontal: size.iScreen(0.5)),
                  //         decoration: BoxDecoration(
                  //             color: Colors.grey.shade200,
                  //             borderRadius: BorderRadius.circular(8)
                  //         ),
                        
                  //         child: Text('$e',
                  //           style: GoogleFonts.lexendDeca(
                  //               fontSize: size.iScreen(2.3),
                  //               fontWeight: FontWeight.normal,
                  //               color: Colors.black)),
                  //       ),
                  //     )
                  //     ).toList(),)
                  //     :Text('--- --- --- --- ---',
                  //           style: GoogleFonts.lexendDeca(
                  //             fontSize: size.iScreen(2.3),
                  //             fontWeight: FontWeight.normal,
                  //             color: Colors.grey
                  //           ));
                      
                  //   },),
                    
                  // ),
            

            //***************************/
                
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
                          inputFormatters: [
                            UpperCaseText(),
                          ],
                          decoration: InputDecoration(
                            label:  const Text( 'Nombre Conductor'),
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
                      ctrl.setNombreConductor(text);
                    },
                    validator: (text) {
                      if (text!.trim().isNotEmpty) {
                        return null;
                      } else {
                        return 'Ingrese nombre de Conductor';
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
            
                  //       Container(
                  //         width: size.wScreen(100),
                  //         child:
                  //        Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceAround,
                  //   children: <Widget>[
                  //     RadioButtonWithLabel(value: 1, label: 'Pasaporte'),
                  //     RadioButtonWithLabel(value: 2, label: 'Calibración'),
                  //     RadioButtonWithLabel(value: 3, label: 'Venta Cupo'),
                  //     RadioButtonWithLabel(value: 4, label: 'Prepago'),
                  //   ],
                  // ),
            
                  //       ),
            
                  // ContainerRow(),
            
            //***********************************************/
                  // SizedBox(
                  //   height: size.iScreen(1.0),
                  // ),
                  // //*****************************************/
                  // Row(
                  //   children: [
                  //     SizedBox(
                  //       // width: size.wScreen(100.0),
            
                  //       // color: Colors.blue,
                  //       child: Text('FORMA DE PAGO: ',
                  //           style: GoogleFonts.lexendDeca(
                  //               fontSize: size.iScreen(2.0),
                  //               fontWeight: FontWeight.normal,
                  //               color: Colors.grey)),
                  //     ),
                  //     Text('EFECTIVO',
                  //         style: GoogleFonts.lexendDeca(
                  //             fontSize: size.iScreen(2.3),
                  //             fontWeight: FontWeight.bold,
                  //             color: Colors.green)),
                  //   ],
                  // ),
                   //***********************************************/
                  SizedBox(
                    height: size.iScreen(1.0),
                  ),
                  //*****************************************/
                  SizedBox(
                    width: size.wScreen(100.0),
            
                    // color: Colors.blue,
                    child: Text('FORMA DE PAGO  : ',
                        style: GoogleFonts.lexendDeca(
                            fontSize: size.iScreen(2.0),
                            fontWeight: FontWeight.normal,
                            color: Colors.grey)),
                  ),


                    Consumer<ComprobantesController>(builder: (_, value, __) {  

                    if (value.getListaFormasPago.isEmpty) {
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
                  children: value.getListaFormasPago.map((e) => 
                  
                  
                  GestureDetector(
                          onTap: () {
                            value.setFormaDePago( e['fpagoNombre'],);
                       
                          },
                          child: Container(
                            width: size.iScreen(20.0),
                            margin: EdgeInsets.symmetric(
                                vertical: size.iScreen(0.5), horizontal: size.iScreen(0.5)),
                            padding: EdgeInsets.symmetric(
                                horizontal: size.iScreen(2.0),
                                vertical: size.iScreen(1.0)),
                            decoration: BoxDecoration(
                              color:  value.getFormaDePago == e['fpagoNombre'] ? ctrlTheme.appTheme.primaryColor : Colors.grey[300], // Cambia el color si está seleccionado Colors.grey[300],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(
                              child: Text(
                               e['fpagoNombre'],
                                style: GoogleFonts.lexendDeca(
                                  color: value.getFormaDePago == e['fpagoNombre'] ?Colors.white:Colors.black ,
                                  fontWeight: FontWeight.normal,
                                  fontSize:size.iScreen(1.8)
                                ),
                              ),
                            ),
                          ),
                        )
                  
                  
                  ).toList(),
                );
      

              },),
              
             


                  //  // //***********************************************/
                  // SizedBox(
                  //   height: size.iScreen(1.0),
                  // ),
                  // // //*****************************************/
                  //   Consumer<ComprobantesController>(builder: (_, value, __) { 
                  //        return GestureDetector(
                  //         onTap: () {
                  //           value.setFormaDePago('');
                  //         },
                  //          child: Container(
                  //             // color: Colors.red,
                  //             width: size.wScreen(100.0),
                                     
                  //             // color: Colors.blue,
                  //             child: Text(
                  //                 value.getFormaDePago.isEmpty
                  //                     ? ' --- --- --- --- --- --- --- ---'
                  //                     : ' ${value.getFormaDePago}',
                  //                 style: GoogleFonts.lexendDeca(
                  //                     fontSize: size.iScreen(2.3),
                  //                     fontWeight: FontWeight.bold,
                  //                     color: value.getFormaDePago.isEmpty
                  //                         ? Colors.grey
                  //                         : Colors.black)),
                  //           ),
                  //        );
                  //      },),
                  // //***********************************************/
                  // SizedBox(
                  //   height: size.iScreen(1.0),
                  // ),
                  // //*****************************************/
                  //***********************************************/
                  // SizedBox(
                  //   height: size.iScreen(1.0),
                  // ),
                  //*****************************************/
                  // Container(
                  //   width: size.wScreen(100.0),
                  //   child: ContainerCombustible()),
                  //***********************************************/
                  // SizedBox(
                  //   height: size.iScreen(1.0),
                  // ),
                  // //*****************************************/
            
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
                                 ctrl.setCantidad(1);
                            ctrl.buscaAllProductos( ctrl.getTypeAction.toString());
            
                            // // _buscarMascota(context, size);
            
             Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                       BuscarProductosVarios()));
            
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
                 





                  //*****************************************/
            
            //                 Consumer<ComprobantesController>(builder: (_, value, __) { 
            //                   return  
                    
            //                   value.tipoTarifa.isEmpty? Text(
            //                                      '--- --- --- --- --- --- --- --- --- --- ',
            //                                       style: GoogleFonts.lexendDeca(
            //                                           fontSize: size.iScreen(3.0),
            //                                           fontWeight: FontWeight.normal,
            //                                           color:  value.tipoTarifa.isEmpty? Colors.grey:Colors.black
            //                                               )):
                    
            //                   Container(
            //                   // color: Colors.grey.shade200,
            //                   padding: EdgeInsets.only(bottom: size.iScreen(1.0)),
            //                   child: Row(
            //                     mainAxisAlignment: MainAxisAlignment.spaceAround,
            //                     children: [
            //                       Container(
            //                         width: size.iScreen(10),
            //                         child: Column(
            //                           crossAxisAlignment: CrossAxisAlignment.start,
            //                           children: [
            //                             //       TextField(
            //                             //          inputFormatters: [
            //                             //                             UpperCaseText(),
            //                             //                           ],
            //                             //         decoration: InputDecoration(
            //                             //           hintText: 'Valor', // Texto de sugerencia dentro del campo
            //                             //           // border: OutlineInputBorder(), // Opcional: Añade un borde al campo
            //                             //            helperStyle:TextStyle(color: Colors.grey.shade50),
            //                             //         ),
            //                             //         style: TextStyle(
            //                             //   fontSize: size.iScreen(2.0), // Ajusta el tamaño de la letra
            //                             //   // fontWeight: FontWeight.bold, // Opcional: Aplica un peso de fuente más grueso
            //                             // ),
            //                             //         textAlign: TextAlign.center,
            //                             //       ),
            //                             //  TextField(
            //                             //         inputFormatters: [
            //                             //           FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$')), // Permite números y un solo punto decimal
            //                             //         ],
            //                             //         keyboardType: TextInputType.numberWithOptions(decimal: true), // Permite punto decimal en el teclado
            //                             //         decoration: InputDecoration(
            //                             //           hintText: 'Valor', // Texto de sugerencia dentro del campo
            //                             //           helperStyle: TextStyle(color: Colors.grey.shade50),
            //                             //         ),
            //                             //         style: TextStyle(
            //                             //           fontSize: size.iScreen(2.2), // Ajusta el tamaño de la letra
            //                             //         ),
            //                             //         textAlign: TextAlign.center,
            //                             //       ),
            //                             Consumer<ComprobantesController>(
            //                               builder: (_, valueTatifa, __) {
            //                                 return Container(
            //                                   // color: Colors.red,
            //                                   width: size.wScreen(20.0),
            
            //                                   // color: Colors.blue,
            //                                   child: Text(
            //                                       valueTatifa.tipoTarifa.isEmpty
            //                                           ? ' --- ---'
            //                                           : ' \$${valueTatifa.tipoTarifa['valor']}',
            //                                       style: GoogleFonts.lexendDeca(
            //                                           fontSize: size.iScreen(3.0),
            //                                           fontWeight: FontWeight.bold,
            //                                           color: valueTatifa.tipoTarifa.isEmpty
            //                                               ? Colors.grey
            //                                               : Colors.red)),
            //                                 );
            //                               },
            //                             ),
            //                           ],
            //                         ),
            //                       ),
            //                       Consumer<ComprobantesController>(
            //                         builder: (_, values, __) {
            //                           return values.tipoTarifa.isNotEmpty
            //                               ? Container(
            //                                   width: size.iScreen(20),
            //                                   child: Column(
            //                                     crossAxisAlignment:
            //                                         CrossAxisAlignment.start,
            //                                     children: [
            // // TextFormField(
            
            // //   // initialValue:values.getCantidad ,
            // //   controller: _controller,
            // //   inputFormatters: [
            // //     FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$')), // Permite números y un solo punto decimal
            // //   ],
            // //   keyboardType: TextInputType.numberWithOptions(decimal: true), // Permite punto decimal en el teclado
            // //   decoration: InputDecoration(
            // //     hintStyle:TextStyle(
            // //       fontSize: size.iScreen(2.0)
            // //     ),
            // //     hintText: 'Cantidad', // Texto de sugerencia dentro del campo
            // //     helperStyle: TextStyle(color: Colors.grey.shade50),
            // //   ),
            // //   style: TextStyle(
            // //     fontSize: size.iScreen(3.5), // Ajusta el tamaño de la letra
            // //   ),
            // //   textAlign: TextAlign.center,
            // //    onChanged: (text) {
            // //     if (text=='') {
            // //       text==0.00;
            // //     }
            // //     values.setCantidad(double.parse(text));
            // //                       },
            // // ),
            //                                       TextFormField(
            //                                         controller: _controller,
            //                                         inputFormatters: [
            //                                           FilteringTextInputFormatter.allow(RegExp(
            //                                               r'^\d*\.?\d*$')), // Permite números y un solo punto decimal
            //                                         ],
            //                                         keyboardType:
            //                                             TextInputType.numberWithOptions(
            //                                                 decimal:
            //                                                     true), // Permite punto decimal en el teclado
            //                                         decoration: InputDecoration(
            //                                           hintStyle: TextStyle(
            //                                             fontSize: size.iScreen(2.0),
            //                                           ),
            //                                           hintText:
            //                                               'Cantidad', // Texto de sugerencia dentro del campo
            //                                           helperStyle: TextStyle(
            //                                               color: Colors.grey.shade50),
            //                                         ),
            //                                         style: TextStyle(
            //                                           fontSize: size.iScreen(
            //                                               3.5), // Ajusta el tamaño de la letra
            //                                         ),
            //                                         textAlign: TextAlign.center,
            
            //                                         // Validación y conversión
            //                                         onChanged: (text) {
            //                                           double value = 0.0;
            //                                           if (text.isNotEmpty) {
            //                                             try {
            //                                               value = double.parse(text);
            //                                             } catch (e) {
            //                                               // Manejo del error si el parse falla
            //                                               value = 0.0;
            //                                             }
            //                                           }
            //                                           values.setCantidad(value);
            //                                         },
            
            //                                         // Validación adicional al enviar el formulario (opcional)
            //                                         validator: (text) {
            //                                           if (text == null || text.isEmpty) {
            //                                             return 'Por favor, ingrese una cantidad';
            //                                           }
            //                                           final value = double.tryParse(text);
            //                                           if (value == null) {
            //                                             return 'Ingrese un número válido';
            //                                           }
            //                                           return null; // Devuelve null si la validación es exitosa
            //                                         },
            //                                       ),
            //                                     ],
            //                                   ),
            //                                 )
            //                               : Container();
            //                         },
            //                       )
            //                       // Container(
            //                       //   width: size.iScreen(4.0), // Ajusta el ancho del contenedor según sea necesario
            //                       //   height: size.iScreen(4.0), // Ajusta la altura del contenedor según sea necesario
            //                       //   decoration: BoxDecoration(
            //                       //     color:ctrlTheme.appTheme.primaryColor, // Color de fondo del contenedor
            //                       //     borderRadius: BorderRadius.circular(8), // Forma circular
            //                       //   ),
            //                       //   child: IconButton(
            //                       //     icon: Icon(Icons.search, color: Colors.white), // Icono de lupa
            //                       //     onPressed: () {
            //                       //       // Acción al presionar el icono
            //                       //     },
            //                       //   ),
            //                       // ),
            //                     ],
            //                   ),
            //                 );
                  
            //                  },),
            
                 //***********************************************/
                  // //***********************************************/
                  // SizedBox(
                  //   height: size.iScreen(1.0),
                  // ),
                  // //*****************************************/
                  // //***********************************************/
                  // Container(
                  //   color:Colors.grey.shade200,
                  //   width: size.wScreen(100),
                  //   height: size.iScreen(0.5),
                  // ),
                  // //*****************************************/
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


                   //***********************************************/
                  SizedBox(
                    height: size.iScreen(1.0),
                  ),
                 
    //*****************************************/
            
                  //***********************************************/
                  SizedBox(
                    height: size.iScreen(1.0),
                  ),
                  //*****************************************/
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  //**********************************************MODAL TIPO DE PLACA **********************************************************************//
  Future<bool?> modalFormaPago(
      BuildContext context, Responsive size, ComprobantesController ctrl) {
    return showDialog<bool>(
      barrierColor: Colors.black54,
      context: context,
      builder: (context) {


        // List<String> _forma = 
        // [
        // "EFECTIVO", 
        // "TARJETA DE CRÉDITO", 
        // "TRANSFERENCIA", 
        // 'DEPOSITO',
        // "CHEQUE", 
        // "TARJETA DE DÉBITO", 
        // "DINERO ELECTRÓNICO", 
        // "TARJETA PREPAGO"
        // ];

        return AlertDialog(
          title: const Text("SELECCIONE FORMA DE PAGO"),
          content: SizedBox(
            width: size.wScreen(100),
            height: size.hScreen(20.0), // Ajusta la altura según sea necesario
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),

           

              child: 
              Consumer<ComprobantesController>(builder: (_, value, __) {  

                    if (value.getListaFormasPago.isEmpty) {
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
                  children: value.getListaFormasPago.map((e) => 
                  
                  
                  GestureDetector(
                          onTap: () {
                            value.setFormaDePago( e['fpagoNombre'],);
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
                               e['fpagoNombre'],
                                style: GoogleFonts.lexendDeca(
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ),
                          ),
                        )
                  
                  
                  ).toList(),
                );
      //            ListView.builder(
      //   itemCount: value.getFormaDePago.length,
      //   itemBuilder: (context, index) {
         
      //     return
      //     GestureDetector(
      //                     onTap: () {
      //                       value.setFormaDePago(value.getFormaDePago[index]['fpagoNombre'].toString());
      //                       Navigator.pop(context);
      //                     },
      //                     child: Container(
      //                       margin: EdgeInsets.symmetric(
      //                           vertical: size.iScreen(0.5)),
      //                       padding: EdgeInsets.symmetric(
      //                           horizontal: size.iScreen(2.0),
      //                           vertical: size.iScreen(1.0)),
      //                       decoration: BoxDecoration(
      //                         color: Colors.grey[200],
      //                         borderRadius: BorderRadius.circular(8),
      //                       ),
      //                       child: Center(
      //                         child: Text(
      //                           value.getFormaDePago[index].toString(),
      //                           style: GoogleFonts.lexendDeca(
      //                             fontWeight: FontWeight.normal,
      //                           ),
      //                         ),
      //                       ),
      //                     ),
      //                   );
      //   },
      // );
              //   Column(
              //   mainAxisSize: MainAxisSize.min,
              //   children: _forma
              //       .map((e) => 
              //       GestureDetector(
              //             onTap: () {
              //               value.setFormaDePago(e);
              //               Navigator.pop(context);
              //             },
              //             child: Container(
              //               margin: EdgeInsets.symmetric(
              //                   vertical: size.iScreen(0.5)),
              //               padding: EdgeInsets.symmetric(
              //                   horizontal: size.iScreen(2.0),
              //                   vertical: size.iScreen(1.0)),
              //               decoration: BoxDecoration(
              //                 color: Colors.grey[200],
              //                 borderRadius: BorderRadius.circular(8),
              //               ),
              //               child: Center(
              //                 child: Text(
              //                   e,
              //                   style: GoogleFonts.lexendDeca(
              //                     fontWeight: FontWeight.normal,
              //                   ),
              //                 ),
              //               ),
              //             ),
              //           ))
              //       .toList(),
              // );
            
            

              },)
              
             
            
            ),
          ),
        );
      },
    );
  }

  //**********************************************MODAL TIPO DE PLACA **********************************************************************//
  Future<bool?> modalTipoDocumento(
      BuildContext context, Responsive size, ComprobantesController ctrl) {
    return showDialog<bool>(
      barrierColor: Colors.black54,
      context: context,
      builder: (context) {
        List<String> _tipos = ["CÉDULA/RUC", "PLACA", 'CONSUMIDOR FINAL'];

        return AlertDialog(
          title: const Text("SELECCIONE TIPO DE PLACA"),
          content: SizedBox(
            width: size.wScreen(100),
            height: size.hScreen(20.0), // Ajusta la altura según sea necesario
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: _tipos
                    .map((e) => GestureDetector(
                          onTap: () {
                            ctrl.setTipoDocumento(e);
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
                        ))
                    .toList(),
              ),
            ),
          ),
        );
      },
    );
  }



  Future<bool?> _agregaCorreo(BuildContext context,
      ComprobantesController controller, Responsive size) {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
            title: Container(child: const Text("AGREGAR CORREO")),
            content: Card(
              color: Colors.transparent,
              elevation: 0.0,
              child: Form(
                key: controller.correoFormKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: size.iScreen(100.0),
                      child: Container(
                        // width: size.wScreen(45.0),
                        child:
                            // IntlPhoneField(
                            //   controller: controllerTextCountry,
                            //   decoration: const InputDecoration(

                            //       // labelText: 'Phone Number',
                            //       // border: OutlineInputBorder(
                            //       //   // borderSide: BorderSide(),
                            //       // ),
                            //       ),
                            //   onChanged: (phone) {
                            //     print(phone.completeNumber);
                            //     controller.seItemAddCelulars(phone.completeNumber);
                            //   },
                            //   onCountryChanged: (country) {
                            //     controller.seItemCodeCelular(country.dialCode);
                            //   },
                            // ),
                            //===============================================//
                            SizedBox(
                          width: size.iScreen(40.0),
                          child: TextFormField(
                            controller: _textAddCorreo,

                            keyboardType: TextInputType.emailAddress,
                            textCapitalization: TextCapitalization.none,

                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (value) {
                              final validador = validateEmail(value);
                              if (validador == null) {
                                controller.setIsCorreo(true);
                              }
                              return validateEmail(value);
                            },
                            decoration: const InputDecoration(
                                hintText: '  Ingrese un Correo'
                                // suffixIcon: Icon(Icons.beenhere_outlined)
                                ),
                            inputFormatters: [
                              LowerCaseText(),
                            ],
                            textAlign: TextAlign.center,
                            style: const TextStyle(

                                // fontSize: size.iScreen(3.5),
                                // fontWeight: FontWeight.bold,
                                // letterSpacing: 2.0,
                                ),
                            onChanged: (text) {
                              controller.seItemAddCorreos(text);
                              // final _estado=
                              // valueCantidad.validaStock(text);
                              // if(_estado==true){
                              // print('@VERDADERO@ $_estado');

                              // }else{
                              // print('@FALSE@ $_estado');

                              // }
                            },
                            // validator: (text) {
                            //   if (text!.trim().isNotEmpty) {
                            //     return null;
                            //   } else {
                            //     return 'Cantidad inválida';
                            //   }
                            // },
                          ),
                        ),
                        //===============================================//
                      ),
                    ),
                    TextButton(
                        onPressed: () {
                          final isValidS = controller.validateFormCorreo();
                          if (!isValidS) return;
                          if (isValidS) {
                            _textAddCorreo.text = '';
                            controller.agregaListaCorreos();
                            Navigator.pop(context);
                          }
                          //  print(countries.firstWhere((element) => element['code'] == phone.countryISOCode)['max_length']);
                        },
                        child: 
                    Consumer<ThemeProvider>(builder: (_, valueTheme, __) { 
                          return    Container(
                          decoration: BoxDecoration(
                              color: valueTheme.appTheme.primaryColor,
                              borderRadius: BorderRadius.circular(5.0)),
                          // color: primaryColor,
                          padding: EdgeInsets.symmetric(
                              vertical: size.iScreen(0.5),
                              horizontal: size.iScreen(0.5)),
                          child: Text('Agregar',
                              style: GoogleFonts.lexendDeca(
                                  // fontSize: size.iScreen(2.0),
                                  fontWeight: FontWeight.normal,
                                  color: Colors.white)),
                        );

                       },)
                        
                        
                     
                    )
                  ],
                ),
              ),
            )

            //  },)

            );
      },
    );
  }


// void showProcessingModal(BuildContext context, Responsive size) {
//   showDialog(
//     context: context,
//     barrierDismissible: false,
//     builder: (BuildContext context) {
//       return AlertDialog(
//               content: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   const Text('Datos guardados correctamente'),
//                   SizedBox(height: size.iScreen(1.0)),
//                   const Text('¿Desea imprimir la factura?'),
//                   SizedBox(height: size.iScreen(1.0)),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceAround,
//                     children: [
//                       ElevatedButton(
//                         onPressed: () {
//                           // Lógica para imprimir la factura
//                           final crtl = context.read<ComprobantesController>();
//                           print('LA DATA PARA TICKET : ${crtl.getInfoFacturaResponse}');
//                           Navigator.of(context).pop();
//                         },
//                         child: const Text('Imprimir'),
//                       ),
//                       ElevatedButton(
//                         onPressed: () {
//                           // Cerrar el modal sin imprimir
//                           Navigator.of(context).pop();
//                         },
//                         child: const Text('No'),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             );
//     },
//   );
// }


//   Future<bool?> _agregaPlaca(BuildContext context,
//       ComprobantesController controller, Responsive size) {
//     return showDialog<bool>(
//       context: context,
//       builder: (context) {
//         return CupertinoAlertDialog(
//             title: Container(child: const Text("AGREGAR PLACA")),
//             content: Card(
//               color: Colors.transparent,
//               elevation: 0.0,
//               child: Form(
//                 key: controller.placaFormKey,
//                 child: 
//                 Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     SizedBox(
//                       width: size.iScreen(50.0),
//                       child: 
//                       Container(
//                         // width: size.wScreen(45.0),
//                         child: TextFormField(
//                          textAlign: TextAlign.center,
//                           autofocus: true,
//                           controller: _textAddPlaca,
//                           decoration: const InputDecoration(
                         

                             
//                               ),
//                               style:TextStyle(
//                                 fontSize:size.iScreen(3.5),
//                                 color:Colors.black
//                               ),
                              
// //  initialCountryCode: 'EC',

//                           // keyboardType: TextInputType.none,
//                           inputFormatters: <TextInputFormatter>[
//                             UpperCaseText(),
//                           ],
//                           onChanged: (text) {
                           
//                             controller.seItemAddPlaca(text);
//                           },
//                            validator: (text) {
//                                           if (text!.trim().isNotEmpty) {
//                                             return null;
//                                           } else {
//                                             return 'Ingrese Placa';
//                                           }
//                                         },
                          
//                         ),
//                       ),
//                     ),
//                    TextButton(
//                         onPressed: () {
//                           final isValidS = controller.validateFormPlaca();
//                           if (!isValidS) return;
//                           if (isValidS) {
//                             _textAddPlaca.text = '';
//                             controller.agregaListaPlacas();
//                             Navigator.pop(context);
//                           }
//                           //  print(countries.firstWhere((element) => element['code'] == phone.countryISOCode)['max_length']);
//                         },
//                         child: 
//                         // Consumer<ThemeProvider>(builder: (_, valueTheme, __) {  
//                         //                 return Container(
//                         //                   alignment: Alignment.center,
//                         //                   color: valueTheme.appTheme.primaryColor,
//                         //                   width: size.iScreen(3.5),
//                         //                   padding: EdgeInsets.only(
//                         //                     top: size.iScreen(0.5),
//                         //                     bottom: size.iScreen(0.5),
//                         //                     left: size.iScreen(0.5),
//                         //                     right: size.iScreen(0.5),
//                         //                   ),
//                         //                   child: Icon(
//                         //                     Icons.add,
//                         //                     color: Colors.white,
//                         //                     size: size.iScreen(2.0),
//                         //                   ),
//                         //                 );
//                         //               },
//                         //               ),
//                      Consumer<ThemeProvider>(builder: (_, valueTheme, __) {  
//                           return    Container(
//                           decoration: BoxDecoration(
//                               color: valueTheme.appTheme.primaryColor,
//                               borderRadius: BorderRadius.circular(5.0)),
//                           // color: primaryColor,
//                           padding: EdgeInsets.symmetric(
//                               vertical: size.iScreen(0.5),
//                               horizontal: size.iScreen(0.5)),
//                           child: Text('Agregar',
//                               style: GoogleFonts.lexendDeca(
//                                   // fontSize: size.iScreen(2.0),
//                                   fontWeight: FontWeight.normal,
//                                   color: Colors.white)),
//                         );

//                        },)
                        
                        
                     
//                     )
//                   ],
//                 ),
//               ),
//             )

//             //  },)

//             );
//       },
//     );
//   }
Future<bool?> _agregaPlaca(BuildContext context,
    ComprobantesController controller, Responsive size) {
  return showDialog<bool>(
    context: context,
    builder: (context) {
      return Dialog(
        backgroundColor: Colors.white, // Cambia el color de toda la modal a blanco
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: EdgeInsets.all(size.iScreen(2.0)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("AGREGAR PLACA", style: TextStyle(fontSize: size.iScreen(2.5))),
              SizedBox(height: size.iScreen(2.0)),
              Form(
                key: controller.placaFormKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: size.iScreen(50.0),
                      child: TextFormField(
                        textAlign: TextAlign.center,
                        autofocus: true,
                        controller: _textAddPlaca,
                        decoration: const InputDecoration(
                          // Aquí puedes agregar más personalización si es necesario
                        ),
                        style: TextStyle(
                          fontSize: size.iScreen(3.5),
                          color: Colors.black,
                        ),
                        inputFormatters: <TextInputFormatter>[
                          UpperCaseText(),
                        ],
                        onChanged: (text) {
                          controller.seItemAddPlaca(text);
                        },
                        validator: (text) {
                          if (text!.trim().isNotEmpty) {
                            return null;
                          } else {
                            return 'Ingrese Placa';
                          }
                        },
                      ),
                    ),
                    SizedBox(height: size.iScreen(2.0)),
                    TextButton(
                      onPressed: () {
                        final isValidS = controller.validateFormPlaca();
                        if (!isValidS) return;
                        if (isValidS) {
                          _textAddPlaca.text = '';
                          controller.agregaListaPlacas();
                          Navigator.pop(context);
                        }
                      },
                      child: Consumer<ThemeProvider>(
                        builder: (_, valueTheme, __) {
                          return Container(
                            decoration: BoxDecoration(
                              color: valueTheme.appTheme.primaryColor,
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            padding: EdgeInsets.symmetric(
                              vertical: size.iScreen(0.5),
                              horizontal: size.iScreen(0.5),
                            ),
                            child: Text('Agregar',
                                style: GoogleFonts.lexendDeca(
                                  fontWeight: FontWeight.normal,
                                  color: Colors.white,
                                )),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

  //**********************************************MODAL TIPO DE PLACA **********************************************************************//
  Future<bool?> modalTarifas(
      BuildContext context, Responsive size, ComprobantesController ctrl) {
    return showDialog<bool>(
      barrierColor: Colors.black54,
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("SELECCIONE TARIFA"),
          content: SizedBox(
            width: size.wScreen(100),
            height: size.hScreen(20.0), // Ajusta la altura según sea necesario
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: ctrl.listTarifas
                    .map((e) => GestureDetector(
                          onTap: () {
                            _controller.text = '1';
                            ctrl.setTotal();
                            ctrl.setCantidad(0.0);
                            ctrl.setTarifa(e);
                            ctrl.calculateTotal();
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
                                '${e['tipo']} - \$${e['valor']}',
                                style: GoogleFonts.lexendDeca(
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ),
                          ),
                        ))
                    .toList(),
              ),
            ),
          ),
        );
      },
    );
  }

  //********************************************************************************************************************//
  void _onSubmit(
    BuildContext context,
    ComprobantesController controller,
  ) async {
    final isValid = controller.validateForm();
    if (!isValid) return;
    if (isValid) {

    //  controller.createFactura();
                                      // showProcessingModal( context, size);

      if (controller.getClienteComprobante.isEmpty) {
        NotificatiosnService.showSnackBarDanger('Debe seleccionar Cliente');
      } else if (controller.getItemAddPlaca!.isEmpty) {
        NotificatiosnService.showSnackBarDanger(
            'Debe agregar placa de vehículo');
      }
      //  else if (controller.getNombreConductor == "") {
      //   NotificatiosnService.showSnackBarDanger(
      //       'Debe ingresar nombre de Conductor');
      // }
      else if (controller.getFormaDePago == "") {
        NotificatiosnService.showSnackBarDanger(
            'Debe seleccionar forma de pago');
      } else if (controller.getRespuestaCalculoItem.isEmpty) {
        NotificatiosnService.showSnackBarDanger(
            'Debe agregar producto');
      } else if (controller.getlistaAddCorreos!.isEmpty) {
        NotificatiosnService.showSnackBarDanger(
            'Debe agregar correo');
      }
      else{
           final ctrl = context.read<ComprobantesController>();
          ctrl.createFactura(context);


      }

      // if (controller.getNombreMascota != "" &&
      //     controller.getVetInternoNombre != "" &&
      //     controller.getTipoConsulta != "") {
      //   //   if (image != null) {
      //   //     ProgressDialog.show(context);
      //   //     controller.setNewPictureFile(image);
      //   //     await controller.upLoadImagen();
      //   //   }

      //   //   ProgressDialog.dissmiss(context);
      //   if (widget.tipo == 'CREATE') {
      //     await controller.creaHistoriaClinica(context);
      //     Navigator.pop(context);
      //   }
      //   if (widget.tipo == 'EDIT') {
      //     await controller.editaHistoriaClinica(context);
      //     Navigator.pop(context);
      //   }
      // }
    }
  }





void _printTicket(Map<String, dynamic>? _info,String? user,String fechaLocal) async {
  if (_info == null) return;


  //==============================================//
  String fechaLocal = convertirFechaLocal(_info['venFecReg']);
    // print('LA FECHA PARA PRINT: $fechaLocal');
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
 // await SunmiPrinter.printTghfghext('Fecha: $fgh{_info['venFechfghfghactura']}'); // O utiliza formattedDate si corresponde
  await SunmiPrinter.printText('Fecha: $fechaLocal'); 
  await SunmiPrinter.line();
   await SunmiPrinter.printText('Ticket: ${_info['venNumFactura']}'); 
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



}













class RadioButtonWithLabel extends StatelessWidget {
  final int value;
  final String label;

  const RadioButtonWithLabel({
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final radioProvider = context.watch<ComprobantesController>();

    return Column(
      children: <Widget>[
        Text(label),
        Radio<int>(
          value: value,
          groupValue: radioProvider.selectedValue,
          onChanged: (newValue) {
            radioProvider.setSelectedValue(newValue!);
          },
        ),
      ],
    );
  }
}

// class ContainerRow extends StatelessWidget {

//   @override
//   Widget build(BuildContext context) {
//        final Responsive size = Responsive.of(context);
//     return SingleChildScrollView(
//        scrollDirection: Axis.horizontal,
//        physics: const BouncingScrollPhysics(),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: <Widget>[
//           for (int i = 1; i <= 7; i++)
//             Container(
//               margin: EdgeInsets.symmetric(horizontal: size.iScreen(1.0)), // Espaciado entre contenedores
//               padding: EdgeInsets.all(10.0), // Espaciado interno del contenedor
//               decoration: BoxDecoration(
//                 color: Colors.white, // Color de fondo del contenedor
//                 borderRadius: BorderRadius.circular(8.0), // Bordes redondeados
//                 border: Border.all(color: Colors.grey, width: 1), // Borde gris
//               ),
//               child: Center(
//                 child: Text(
//                   getTextForIndex(i),
//                    style: GoogleFonts.lexendDeca(
//                                     fontSize: size.iScreen(2.0),
//                                     fontWeight: FontWeight.normal,
//                                     // color: Colors.grey
//                                     )
//                 ),
//               ),
//             ),
//         ],
//       ),
//     );
//   }

//   String getTextForIndex(int index) {
//     switch (index) {
//       case 1:
//         return '\$5';
//       case 2:
//         return '\$10';
//       case 3:
//         return '\$15';
//       case 4:
//         return '\$20';
//       case 5:
//         return '\$25';
//       case 6:
//         return '\$30';
//       case 7:
//         return 'Lleno';
//       default:
//         return '';
//     }
//   }
// }

class ContainerRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Responsive size = Responsive.of(context);
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          for (int i = 1; i <= 7; i++)
            Consumer<ComprobantesController>(
              builder: (context, selectionProvider, child) {
                final isSelected =
                    selectionProvider.selectedIndex == getTextForIndex(i);
                return GestureDetector(
                  onTap: () {
                    final selectedValue = getTextForIndex(i);
                    selectionProvider.selectIndex(i);
                    selectionProvider.selectValue(selectedValue);
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(
                        horizontal:
                            size.iScreen(0.6)), // Espaciado entre contenedores
                    padding: EdgeInsets.all(
                        size.iScreen(1.0)), // Espaciado interno del contenedor
                    decoration: BoxDecoration(
                      color: selectionProvider.selectedIndex == i
                          ? Colors.blue
                          : Colors
                              .white, // Color de fondo basado en la selección
                      borderRadius:
                          BorderRadius.circular(8.0), // Bordes redondeados
                      border: Border.all(
                          color: Colors.grey, width: 1), // Borde gris
                    ),
                    child: Center(
                      child: Text(
                        getTextForIndex(i),
                        style: GoogleFonts.lexendDeca(
                          fontSize: size.iScreen(2.5),
                          fontWeight: FontWeight.normal,
                          color: selectionProvider.selectedIndex == i
                              ? Colors.white
                              : Colors
                                  .black, // Color del texto basado en la selección
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  String getTextForIndex(int index) {
    switch (index) {
      case 1:
        return '\$5';
      case 2:
        return '\$10';
      case 3:
        return '\$15';
      case 4:
        return '\$20';
      case 5:
        return '\$25';
      case 6:
        return '\$30';
      case 7:
        return 'Lleno';
      default:
        return '';
    }
  }







}

class ContainerCombustible extends StatelessWidget {
  // Método para manejar la selección
  void _onContainerSelected(String text) {
    print('Seleccionado: $text');
  }

  @override
  Widget build(BuildContext context) {
    final Responsive size = Responsive.of(context);
    return Container(
      width: size.wScreen(60),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          for (String text in ['Super', 'Extra con Ethanol', 'Diesel'])
            GestureDetector(
              onTap: () {
                Provider.of<ComprobantesController>(context, listen: false)
                    .select(text);
              },
              child: Consumer<ComprobantesController>(
                builder: (context, selectionNotifier, child) {
                  final isSelected =
                      selectionNotifier.selectedTextCombustible == text;
                  return Container(
                    margin: EdgeInsets.symmetric(
                        horizontal:
                            size.iScreen(1.0)), // Espaciado entre contenedores
                    padding: EdgeInsets.all(
                        size.iScreen(1.0)), // Espaciado interno del contenedor
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Colors.blue
                          : Colors.white, // Color de fondo según selección
                      borderRadius:
                          BorderRadius.circular(8.0), // Bordes redondeados
                      border: Border.all(
                          color: Colors.grey, width: 1), // Borde gris
                    ),
                    child: Center(
                      child: Text(text,
                          style: GoogleFonts.lexendDeca(
                            fontSize: size.iScreen(2.0),
                            fontWeight: FontWeight.normal,
                            color: isSelected ? Colors.white : Colors.black,
                          )),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }












}
