import 'dart:typed_data';

import 'package:awesome_icons/awesome_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:neitorcont/src/api/authentication_client.dart';
import 'package:neitorcont/src/controllers/caja_controller.dart';
import 'package:neitorcont/src/controllers/comprobantes_controller.dart';
import 'package:neitorcont/src/controllers/prefacturas_controller.dart';

import 'package:neitorcont/src/controllers/proformas_controller.dart';

import 'package:neitorcont/src/models/sesison_model.dart';
import 'package:neitorcont/src/pages/crear_caja.dart';
import 'package:neitorcont/src/pages/crear_comprobante_print.dart';
import 'package:neitorcont/src/pages/detalle_caja.dart';
import 'package:neitorcont/src/pages/views_pdf.dart';
import 'package:neitorcont/src/services/notifications_service.dart';
import 'package:neitorcont/src/services/socket_service.dart';
import 'package:neitorcont/src/theme/theme_provider.dart';
import 'package:neitorcont/src/theme/themes_app.dart';
import 'package:neitorcont/src/utils/dialogs.dart';
import 'package:neitorcont/src/utils/fechaLocal.dart';
import 'package:neitorcont/src/utils/letras_mayusculas_minusculas.dart';
import 'package:neitorcont/src/utils/responsive.dart';
import 'package:neitorcont/src/utils/theme.dart';
import 'package:neitorcont/src/widgets/no_data.dart';
import 'package:provider/provider.dart';
import 'package:sunmi_printer_plus/column_maker.dart';
import 'package:sunmi_printer_plus/enums.dart';
import 'package:sunmi_printer_plus/sunmi_printer_plus.dart';

import 'package:image/image.dart' as img;




class ListarCajaPaginacion extends StatefulWidget {
     final Session? user;
  const ListarCajaPaginacion({Key? key, this.user}) : super(key: key);

  @override
  State<ListarCajaPaginacion> createState() =>
      _ListarCajaPaginacionState();
}

class _ListarCajaPaginacionState
    extends State<ListarCajaPaginacion> {
  final TextEditingController _textSearchController = TextEditingController();
  Session? _usuario;
  final _scrollController = ScrollController();

  @override
  void initState() {
    _scrollController.addListener(() {
      if (_scrollController.position.maxScrollExtent ==
          _scrollController.offset) {
        final _next = context.read<CajaController>();
        if (_next.getpage != null) {
          _next.setPage(_next.getpage);
          //       providerSearchPropietario.setCantidad(25);
          _next.buscaAllCajaPaginacion('', false,_next.getTabIndex);
        } else {
          // print("ES NULL POR ESO NO HACER PETICION ");
        }
      }
    });

    initData();
    super.initState();
  }

  @override
  void dispose() {
    _textSearchController.clear();
    _scrollController.dispose();
    super.dispose();
  }

  void initData() async {
    _usuario = await Auth.instance.getSession();
    // final loadInfo = context.read<PreFacturasController>();
    // // Provider.of<PropietariosController>(context, listen: false);
    // // await loadInfo.buscaAllPreFacturas('');

    // final serviceSocket = context.read<SocketService>();
    // serviceSocket.socket!.on('server:guardadoExitoso', (data) async {
    //   if (data['tabla'] == 'prefacturas') {
    //     loadInfo.buscaAllPreFacturasPaginacion('', false,loadInfo.getTabIndex);
    //     // NotificatiosnService.showSnackBarSuccsses(data['msg']);
    //   }
    // });
    // serviceSocket.socket!.on('server:actualizadoExitoso', (data) async {
    //   if (data['tabla'] == 'prefacturas') {
    //     loadInfo.buscaAllPreFacturasPaginacion('', false,loadInfo.getTabIndex);
    //     // NotificatiosnService.showSnackBarSuccsses(data['msg']);
    //   }
    // });
    // serviceSocket.socket!.on('server:eliminadoExitoso', (data) async {
    //   if (data['tabla'] == 'prefacturas') {
    //     loadInfo.buscaAllPreFacturasPaginacion('', false,loadInfo.getTabIndex);
    //     // NotificatiosnService.showSnackBarSuccsses(data['msg']);
    //   }
    // });
    // serviceSocket.socket?.on('server:error', (data) {
    //   NotificatiosnService.showSnackBarError(data['msg']);
    // });
  }

  @override
  Widget build(BuildContext context) {
    final Responsive size = Responsive.of(context);
       final  themeColor=context.read<ThemeProvider>();
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
          backgroundColor: Colors.grey.shade100,
          appBar: AppBar(
            // backgroundColor: primaryColor,
            title: Consumer<CajaController>(
              builder: (_, providerSearchCaja, __) {
                return Row(
                  children: [
                    Expanded(
                      child: Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: size.iScreen(0.1)),
                        child: (providerSearchCaja
                                .btnSearchCajaPaginacion)
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(5.0),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        // margin: EdgeInsets.symmetric(
                                        //     horizontal: size.iScreen(0.0)),
                                        padding: EdgeInsets.symmetric(
                                            horizontal: size.iScreen(1.5)),
                                        color: Colors.white,
                                        height: size.iScreen(4.0),
                                        child: TextField(
                                          controller: _textSearchController,
                                          autofocus: true,
                                          onChanged: (text) {
                                            // providerSearchPreFacturas
                                                // .onSearchTextPreFacturaPaginacion(
                                                //     text);
                                                providerSearchCaja.search(text);
                        //                         if (providerSearchPreFacturas
                        //                         .nameSearchPreFacturaPaginacion
                        //                         .isEmpty
                        //                     ) {
                        //                             if (  providerSearchPreFacturas.getTabIndex==0) {
                        //   providerSearchPreFacturas. setInfoBusquedaPreFacturasPaginacion([]);
                        //   providerSearchPreFacturas.resetValorTotal();
                        //   //   ctrl.buscaAllPreFacturasPaginacion(
                        //   //       '',false,ctrl.getTabIndex);

                        //  final _controllerPreFacturas =
                        //         context.read<PreFacturasController>();

                        //     _controllerPreFacturas
                        //         .onSearchTextPreFacturaPaginacion("");

                        //     _controllerPreFacturas
                        //         .setBtnSearchPreFacturaPaginacion(false);
                        //     _controllerPreFacturas
                        //         .setErrorPreFacturasPaginacion(null);

                        //     _controllerPreFacturas
                        //         .setError401PreFacturasPaginacion(false);

                        //     _controllerPreFacturas.resetFormPreFacturas();
                        //     _controllerPreFacturas.setPage(0);
                        //     _controllerPreFacturas.setIsNext(false);
                        //     _controllerPreFacturas
                        //         .setInfoBusquedaPreFacturasPaginacion([]);
                        //     _controllerPreFacturas
                        //         .buscaAllPreFacturasPaginacion('', true,_controllerPreFacturas.getTabIndex);





                        // }
                        // if ( providerSearchPreFacturas.getTabIndex==1) {
                        //    providerSearchPreFacturas.setInfoBusquedaPreFacturasPaginacion([]);
                        //    providerSearchPreFacturas.resetValorTotal();
                        //      providerSearchPreFacturas.buscaAllPreFacturasPaginacion(
                        //         '',false,providerSearchPreFacturas.getTabIndex);
                        // }
                                                  
                        //                         } else {
                        //                         }

                                            // if (providerSearchPreFacturas
                                            //     .nameSearchPreFacturaPaginacion
                                            //     .isEmpty) {
                                            //   //                 providerSearchFacturas
                                            //   //     .setErrorMascotasPaginacion(null);

                                            //   // providerSearchFacturas
                                            //   //     .setError401MascotasPaginacion(
                                            //   //         false);
                                            //   providerSearchPreFacturas
                                            //       .setPage(0);
                                            //   providerSearchPreFacturas
                                            //       .setCantidad(25);
                                            //   // providerSearchFacturas.setIsNext(false);
                                            //   providerSearchPreFacturas
                                            //       .buscaAllPreFacturasPaginacion(
                                            //           '', true,providerSearchPreFacturas.getTabIndex);

                                          
                                            // }

                                            // setState(() {});
                                          },
                                          decoration: const InputDecoration(
                                            border: InputBorder.none,
                                            hintText: 'Buscar...',
                                            // suffixIcon:
                                            // //  Icon(Icons.search),
                                            // // icon: Icon(Icons.search),
                                            //  GestureDetector(child: Icon(Icons.search),onTap: (){
                                            //   // providerSearchFacturas
                                            //       // .setInfoBusquedaPropietariosPaginacion([]);
                                            //       providerSearchPropietario.setPage(0);
                                            //       providerSearchPropietario.setCantidad(25);

                                            //   providerSearchPropietario
                                            //       .buscaAllPropietariosPaginacion(
                                            //           // '0803395581');
                                            //           ' ${providerSearchPropietario.nameSearchPropietarioPaginacion}',true);

                                            // },),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : Container(
                                alignment: Alignment.center,
                                width: size.wScreen(90.0),
                                child: Text(
                                  'LISTA DE CAJA',
                                  // style: GoogleFonts.lexendDeca(
                                  //     fontSize: size.iScreen(2.45),
                                  //     // color: Colors.white,
                                  //     fontWeight: FontWeight.normal),
                                ),
                              ),
                      ),
                    ),
                    Row(
                      children: [
                        providerSearchCaja.btnSearchCajaPaginacion
                            ? IconButton(
                                splashRadius: size.iScreen(3.0),
                                icon: Icon(
                                  Icons.search,
                                  size: size.iScreen(3.5),
                                  // color: Colors.white,
                                ),
                                onPressed: () {
                                  //=====================//
                                  if (providerSearchCaja
                                          .nameSearchCajaPaginacion
                                          .length >=
                                      3) {
                                    providerSearchCaja
                                        .setErrorCajaPaginacion(null);

                                    providerSearchCaja
                                        .setError401CajaPaginacion(
                                            false);
                                    providerSearchCaja.setPage(0);
                                    providerSearchCaja.setCantidad(25);

                                    providerSearchCaja
                                        .buscaAllCajaPaginacion(
                                            // '0803395581');
                                            ' ${providerSearchCaja.nameSearchCajaPaginacion}',
                                            true,providerSearchCaja.getTabIndex);
                                  } else {
                                    print('NO HAACE NADA');
                                  }
                                })
                            : Container(),
                        IconButton(
                            splashRadius: 2.0,
                            icon: (!providerSearchCaja
                                    .btnSearchCajaPaginacion)
                                ? Icon(
                                    Icons.search,
                                    size: size.iScreen(3.5),
                                    // color: Colors.white,
                                  )
                                : Icon(
                                    Icons.clear,
                                    size: size.iScreen(3.5),
                                    // color: Colors.white,
                                  ),
                            onPressed: () {
                              providerSearchCaja
                                  .onSearchTextCajaPaginacion("");
                              _textSearchController.text = '';

                              providerSearchCaja
                                  .setBtnSearchCajaPaginacion(
                                      !providerSearchCaja
                                          .btnSearchCajaPaginacion);

                              if (providerSearchCaja
                                      .btnSearchCajaPaginacion ==
                                  false) {
                                //=====================//
                                providerSearchCaja
                                    .setErrorCajaPaginacion(null);

                                providerSearchCaja
                                    .setError401CajaPaginacion(false);

                                providerSearchCaja.setPage(0);
                                providerSearchCaja.setCantidad(25);
                                providerSearchCaja
                                    .buscaAllCajaPaginacion('', true,providerSearchCaja.getTabIndex);
                                // } //=====================//

                              }
                            }),
                             IconButton(
                                splashRadius: size.iScreen(3.0),
                                icon: Icon(
                                  Icons.person_search,
                                  size: size.iScreen(3.5),
                                  // color: Colors.white,
                                ),
                                onPressed: () {
                                   providerSearchCaja
                                  .onSearchTextCajaPaginacion("");
                              _textSearchController.text = '';

                              providerSearchCaja
                                  .setBtnSearchCajaPaginacion(
                                      !providerSearchCaja
                                          .btnSearchCajaPaginacion);

                              if (providerSearchCaja
                                      .btnSearchCajaPaginacion ==
                                  false) {
                                //=====================//
                                providerSearchCaja
                                    .setErrorCajaPaginacion(null);

                                providerSearchCaja
                                    .setError401CajaPaginacion(false);

                                providerSearchCaja.setPage(0);
                                providerSearchCaja.setCantidad(25);
                                providerSearchCaja
                                    .buscaAllCajaPaginacion('', true,providerSearchCaja.getTabIndex);
                                // } //=====================//

                              }
                                  //=====================//
                                  providerSearchCaja.setFechaCaja('');
                                  modalBusquedaXUsuario(context,size, widget.user!);
                                 
                                })
                      ],
                    ),
                  ],
                );
              },
            ),
          ),
          body:

Container(
  color: Colors.grey.shade100,
  width: size.wScreen(100.0),
  height: size.hScreen(100.0),
  padding: EdgeInsets.only(
    top: size.iScreen(0.0),
    right: size.iScreen(0.0),
    left: size.iScreen(0.0),
  ),
  child: DefaultTabController(
    length: 2, // Número de tabs
    child: Column(
      children: [
        // TabBar
        TabBar(
          tabs: [
           Tab(
              child:
              Consumer<CajaController>(builder: (_, valueHoy, __) {  
                return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('HOY', style: TextStyle(fontSize: size.iScreen(1.8))),
                  // Espacio entre los textos
                  // Text('\$${valueHoy.getValorTotalCajasHoy}', style: TextStyle(fontSize: size.iScreen(2.5))),
                  Text(valueHoy.getTotalDiario.isNotEmpty?  '\$${valueHoy.getTotalDiario['total']}':'-- -- --', style: TextStyle(fontSize: size.iScreen(2.0))),
                ],
              );
              },)
               
            ),
            Tab(
              child:
              Consumer<CajaController>(builder: (_, valueAnteriores, __) {  
                return   Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('ANTERIORES',style: TextStyle(fontSize: size.iScreen(1.8))),
                   // Espacio entre los textos
                  //  Text('\$${valueAnteriores.getValorTotalCajasAntes}', style: TextStyle(fontSize: size.iScreen(2.5))),
                  // Text('\$${valueAnteriores.totalGeneralAyer}', style: TextStyle(fontSize: size.iScreen(2.5))),
                ],
              );
              },)
              
             
            ),
          ],
           onTap: (index) {
                        // print('EL INDICE :$index');
                        final ctrl=context.read<CajaController>();
                       ctrl.setTabIndex(index);
                         ctrl.setPage(0);
                        if (  index==0) {
                        //   ctrl. setInfoBusquedaCajasPaginacion([]);
                        //   ctrl.resetValorTotal();
                        //   //   ctrl.buscaAllCajaPaginacion(
                        //   //       '',false,ctrl.getTabIndex);

                        // //  final _controllerCaja =
                        // //         context.read<CajaController>();

                        //     ctrl
                        //         .onSearchTextCajaPaginacion("");

                        //     ctrl
                        //         .setBtnSearchCajaPaginacion(false);
                        //     ctrl
                        //         .setErrorCajaPaginacion(null);

                        //     ctrl
                        //         .setError401CajaPaginacion(false);

                        //     ctrl.resetFormCaja();
                        //     ctrl.setPage(0);
                        //     ctrl.setIsNext(false);
                        //     ctrl
                        //         .setInfoBusquedaCajasPaginacion([]);
                        //     ctrl
                        //         .buscaAllCajaPaginacion('', true,ctrl.getTabIndex);

                                ctrl.setTipo('');
                                   ctrl.setTipoDocumento('');

                            // Navigator.of(context).push(MaterialPageRoute(
                            //     builder: (context) =>
                            //         const CreaCaja(
                            //           tipo: 'CREATE',
                            //         )));

                               

                            ctrl.resetFormCaja();
                             ctrl.setPage(0);
                            ctrl.setInfoBusquedaCajasPaginacion([]);
                           ctrl.resetValorTotal();
                             ctrl.buscaAllCajaPaginacion(
                                '',false,0);
                                     ctrl.obtieneTotalDiario('cajas','');
                                     ctrl.obtieneTotalesFlotantes('');


                        }
                        if ( index==1) {
                            ctrl.setPage(0);
                          
                           ctrl.resetValorTotal();
                            ctrl.setCantidad(1000);
                             ctrl.setInfoBusquedaCajasPaginacion([]);
                             ctrl.setListFilter([]);
                             ctrl.buscaAllCajaPaginacion(
                                '',false,1);
                        }
                      },
          labelColor: Colors.blue,
          unselectedLabelColor: Colors.grey,
          indicatorColor: Colors.blue,
        ),
        // TabBarView
        Expanded(
          child: TabBarView(
            children: [
              //========================TAB 1 =======================//
              // Text('data 1'),
 Consumer<CajaController>(
                        builder: (_, provider, __) {
                         
                         if (provider.allItemsFilters.isEmpty) {
                            return const NoData(
                              label: 'No existen datos para mostar',
                            );
                            // Text("sin datos");
                          }

                          return 
                          
                          (provider.allItemsFilters.isEmpty)
                                        ? Center(
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              
                                              CircularProgressIndicator(),
                                              Text('Por favor espere ....')
                                            ],
                                          ))
                                        : (provider.allItemsFilters.length > 0)
                                            ?
                           RefreshIndicator(
                             onRefresh: () => onRefresh(),
                            child: 
                            ListView.builder(
                              controller: _scrollController,
                              physics: const BouncingScrollPhysics(),
                              itemCount: provider
                                      .allItemsFilters.length +
                                  1,
                              itemBuilder: (BuildContext context, int index) {
                                if (index <
                                    provider
                                        .allItemsFilters.length) {
                                  var _color;
                                  final _prefacturas = provider
                                      .allItemsFilters[index];
                          
                                  if (_prefacturas['cajaEstado'] == 'AUTORIZADO') {
                                    _color = Colors.green;
                                  } else if (_prefacturas['cajaEstado'] ==
                                      'SIN AUTORIZAR') {
                                    _color = Colors.orange;
                                  }
                                  if (_prefacturas['cajaEstado'] == 'ANULADA') {
                                    _color = Colors.red;
                                  }
 //==============================================//
  String fechaLocal = convertirFechaLocal(_prefacturas['cajaFecReg']);
 //==============================================//
                                  return 
                                  _prefacturas['cajaEstado'] != 'ANULADA'?
                                  Slidable(
                                    startActionPane: ActionPane(
                                      // A motion is a widget used to control how the pane animates.
                                      motion: const ScrollMotion(),
                          
                                      children: [
                                        SlidableAction(
                                              backgroundColor: Colors.grey,
                                          foregroundColor: Colors.white,
                                          icon: Icons.list_alt_outlined,
                                          label: 'Más acciones',
                                          onPressed: (context) {
                                            showCupertinoModalPopup(
                                              context: context,
                                              builder: (BuildContext context) =>
                                                  CupertinoActionSheet(
                                                      title: Text(
                                                        'Acciones',
                                                        style: GoogleFonts
                                                            .lexendDeca(
                                                                fontSize: size
                                                                    .iScreen(2.0),
                                                                color:
                                                                    primaryColor,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .normal),
                                                      ),
                                                      // message: const Text('Your options are '),
                                                      actions: <Widget>[
                                                               CupertinoActionSheetAction(
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Container(
                                                                margin: EdgeInsets.only(
                                                                    right: size
                                                                        .iScreen(
                                                                            2.0)),
                                                                child: Text(
                                                                  'Imprimir',
                                                                  style: GoogleFonts.lexendDeca(
                                                                      fontSize: size
                                                                          .iScreen(
                                                                              1.8),
                                                                      color: Colors
                                                                          .black87,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .normal),
                                                                ),
                                                              ),
                                                              const Icon(
                                                                FontAwesomeIcons
                                                                    .print,
                                                                color: Colors.green,
                                                              )
                                                            ],
                                                          ),
                                                          onPressed: () {
                                                            Navigator.pop(
                                                                context);
                                                                _printTicket(_prefacturas,widget.user!.logo);

                                                           
                                                          },
                                                        ),
                                                                CupertinoActionSheetAction(
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Container(
                                                                margin: EdgeInsets.only(
                                                                    right: size
                                                                        .iScreen(
                                                                            2.0)),
                                                                child: Text(
                                                                  'Ver Detalle',
                                                                  style: GoogleFonts.lexendDeca(
                                                                      fontSize: size
                                                                          .iScreen(
                                                                              1.8),
                                                                      color: Colors
                                                                          .black87,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .normal),
                                                                ),
                                                              ),
                                                              const Icon(
                                                                FontAwesomeIcons
                                                                    .infoCircle,
                                                                color: Colors.blue,
                                                              )
                                                            ],
                                                          ),
                                                          onPressed: () {
                                                            provider.setInfoCaja(_prefacturas);
                                                            Navigator.pop(
                                                                context);
                          
                                                            Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder: (context) =>
                                                                     DetalleCaja()),
                                                            );
                                                          },
                                                        ),
                                                        // CupertinoActionSheetAction(
                                                        //   child: Row(
                                                        //     mainAxisAlignment:
                                                        //         MainAxisAlignment
                                                        //             .center,
                                                        //     children: [
                                                        //       Container(
                                                        //         margin: EdgeInsets.only(
                                                        //             right: size
                                                        //                 .iScreen(
                                                        //                     2.0)),
                                                        //         child: Text(
                                                        //           'Ver PDF',
                                                        //           style: GoogleFonts.lexendDeca(
                                                        //               fontSize: size
                                                        //                   .iScreen(
                                                        //                       1.8),
                                                        //               color: Colors
                                                        //                   .black87,
                                                        //               fontWeight:
                                                        //                   FontWeight
                                                        //                       .normal),
                                                        //         ),
                                                        //       ),
                                                        //       const Icon(
                                                        //         FontAwesomeIcons
                                                        //             .filePdf,
                                                        //         color: Colors.red,
                                                        //       )
                                                        //     ],
                                                        //   ),
                                                        //   onPressed: () {
                                                        //     Navigator.pop(
                                                        //         context);
                          
                                                        //     Navigator.push(
                                                        //       context,
                                                        //       MaterialPageRoute(
                                                        //           builder: (context) =>
                                                        //               ViewsPDFs(
                                                        //                   infoPdf:
                                                        //                       // 'https://sysvet.neitor.com/reportes/carnet.php?id=${factura['venId']}&empresa=${_usuario!.rucempresa}',
                                                        //                       'https://syscontable.neitor.com/reportes/factura.php?codigo=${_prefacturas['venId']}&empresa=${_usuario!.rucempresa}',
                                                        //                   labelPdf:
                                                        //                       'infoFactura.pdf')),
                                                        //     );
                                                        //   },
                                                        // ),
                                                     
                                                     
                                                     
                                                      ],
                                                      cancelButton:
                                                          CupertinoActionSheetAction(
                                                        child: Text('Cancel',
                                                            style: GoogleFonts
                                                                .lexendDeca(
                                                                    fontSize: size
                                                                        .iScreen(
                                                                            2.0),
                                                                    color: Colors
                                                                        .red,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .normal)),
                                                        isDefaultAction: true,
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context, 'Cancel');
                                                        },
                                                      )),
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                    child: Card(
                                      elevation: 5,
                                      child: Container(
                                        margin: EdgeInsets.only(
                                            bottom: size.iScreen(0.0)),
                                        color: index % 2 == 0
                                            ? Colors.grey.shade50
                                            : Colors.grey.shade200,
                                        child: ListTile(
                                          dense: true,
                                          visualDensity:
                                              VisualDensity.comfortable,
                                      
                                          //  leading: CircleAvatar(
                                          //   child: Text(
                                          //      '${_prefacturas['venNomCliente'].substring(0, 1)}',
                                          //     style: Theme.of(context)
                                          //         .textTheme
                                          //         .subtitle1,
                                          //   ),
                                          //   backgroundColor: Colors.grey[300],
                                          // ),
                                          title: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  SizedBox(
                                                    // width: size.wScreen(40.0),
                                                    child: Text(
                                                      'Documento: ',
                                                      style: GoogleFonts.lexendDeca(
                                                          // fontSize: size.iScreen(2.45),
                                                          color: Colors.grey,
                                                          fontWeight:
                                                              FontWeight.normal),
                                                      overflow: TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                  // SizedBox(
                                                  //   width: size.wScreen(40.0),
                                                  //   child: Text(
                                                  //     '${_prefacturas['cajaTipoCaja']}',
                                                  //     style: GoogleFonts.lexendDeca(
                                                  //         // fontSize: size.iScreen(2.45),
                                                  //         color: _prefacturas['cajaTipoCaja']=='CREDITO'?Colors.orange:Colors.black,
                                                  //         fontWeight:
                                                  //             FontWeight.bold),
                                                  //     overflow: TextOverflow.ellipsis,
                                                  //   ),
                                                  // ),
                                                    Container(
                                                          // color: Colors.green,
                                                          // width: size.wScreen(50.0),
                                                          child: Text(
                                                            '${_prefacturas['cajaTipoDocumento']}',
                                                            style:
                                                                GoogleFonts.lexendDeca(
                                                                    fontSize: size
                                                                        .iScreen(1.5),
                                                                    color:_prefacturas['cajaTipoDocumento']=='INGRESO'?Colors.green:_prefacturas['cajaTipoDocumento']=='EGRESO'?Colors.orange:Colors.black,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                            overflow:
                                                                TextOverflow.ellipsis,
                                                          ),
                                                  ),
                                                ],
                                              ),
                                              // Text(
                                              //   // '${_prefacturas['cajaEstado']}',
                                              //   // 'Estado: ',
                                              //   style: GoogleFonts.lexendDeca(
                                              //       fontSize: size.iScreen(1.5),
                                              //       color: _color,
                                              //       fontWeight: FontWeight.bold),
                                              // ),
                                              Text(
                                                      '${_prefacturas['cajaTipoCaja']}',
                                                      style: GoogleFonts.lexendDeca(
                                                          // fontSize: size.iScreen(2.45),
                                                          color: _prefacturas['cajaTipoCaja']=='EFECTIVO'?Colors.blue:Colors.orange,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                      overflow: TextOverflow.ellipsis,
                                                    ),
                                            ],
                                          ),
                                          subtitle: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  //  Container(
                                                  //   // color: Colors.red,
                                                  //   width: size.wScreen(70.0),
                                                  //    child: Row(
                                                  //      children: [
                                                  //       Container(
                                                  //         // color: Colors.green,
                                                         
                                                  //         child: Text(
                                                  //           'Documento : ',
                                                  //           style:
                                                  //               GoogleFonts.lexendDeca(
                                                  //                   fontSize: size
                                                  //                       .iScreen(1.5),
                                                  //                   color:
                                                  //                       Colors.grey,
                                                  //                   fontWeight:
                                                  //                       FontWeight
                                                  //                           .normal),
                                                  //           overflow:
                                                  //               TextOverflow.ellipsis,
                                                  //         ),
                                                          
                                                  // ),
                                                  //        Container(
                                                  //         // color: Colors.green,
                                                  //         // width: size.wScreen(50.0),
                                                  //         child: Text(
                                                  //           '${_prefacturas['cajaTipoDocumento']}',
                                                  //           style:
                                                  //               GoogleFonts.lexendDeca(
                                                  //                   fontSize: size
                                                  //                       .iScreen(1.5),
                                                  //                   color:_prefacturas['cajaTipoDocumento']=='INGRESO'?Colors.green:_prefacturas['cajaTipoDocumento']=='EGRESO'?Colors.orange:Colors.black,
                                                  //                   fontWeight:
                                                  //                       FontWeight
                                                  //                           .bold),
                                                  //           overflow:
                                                  //               TextOverflow.ellipsis,
                                                  //         ),
                                                  // ),
                                                  //      ],
                                                  //    ),
                                                  //  ),
                                                  Container(
                                                    // color: Colors.green,
                                                    width: size.wScreen(70.0),
                                                    child: Text(
                                                      '${_prefacturas['cajaNumero']}',
                                                      style:
                                                          GoogleFonts.lexendDeca(
                                                              fontSize: size
                                                                  .iScreen(1.5),
                                                              // color:
                                                              //     Colors.black54,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                  Column(
                                                    children: [
                                                      Container(
                                                        // color: Colors.green,
                                                        width: size.wScreen(70.0),
                                                        child: Text(
                                                          fechaLocal !=
                                                                  ''
                                                              ? fechaLocal
                                                              : '--- --- ---',
                                                          style:
                                                              GoogleFonts.lexendDeca(
                                                                  // fontSize: size.iScreen(2.45),
                                                                  color: Colors.grey,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                    Container(
                                                    // color: Colors.green,
                                                    width: size.wScreen(70.0),
                                                    child: Row(
                                                      children: [
                                                        Text(
                                                          'Usuario: ',
                                                          style:
                                                              GoogleFonts.lexendDeca(
                                                                  // fontSize: size.iScreen(1.9),
                                                                  color: Colors.grey,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                        ),
                                                        Text(
                                                           _prefacturas['cajaUser']!=null
                                                           ?'${_prefacturas['cajaUser']}':'--- --- --- --- --- ---  ',
                                                          style:
                                                              GoogleFonts.lexendDeca(
                                                                  // fontSize: size.iScreen(1.8),
                                                                  // color: Colors.grey,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Container(
                                                // color: Colors.green,
                                                // width: size.wScreen(100.0),
                                                child: Text(
                                                  _prefacturas['cajaTipoCaja']=='CREDITO' || _prefacturas['cajaTipoCaja']=='TRANSFERENCIA'?' \$${_prefacturas['cajaCredito']}':' \$${_prefacturas['cajaMonto']}',
                                                  style: GoogleFonts.lexendDeca(
                                                      fontSize: size.iScreen(2.0),
                                                      color: Colors.black87,
                                                      fontWeight:
                                                          FontWeight.normal),
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ],
                                          ),
                                          // trailing: Icon(Icons.more_vert),
                                        ),
                                      ),
                                    ),
                                  ):Container();
                                } else {
                                  return Consumer<PreFacturasController>(
                                    builder: (_, valueNext, __) {
                                      return valueNext.getpage == null
                                          ? Container(
                                              margin: EdgeInsets.symmetric(
                                                  vertical: size.iScreen(2.0)),
                                              child: Center(
                                                child: Text(
                                                  'No existen más datos',
                                                  style: GoogleFonts.lexendDeca(
                                                      fontSize: size.iScreen(1.8),
                                                      // color: primaryColor,
                                                      fontWeight:
                                                          FontWeight.normal),
                                                ),
                                              ))
                                          // : Container();
                          
                                          : provider.allItemsFilters.length > 25
                                              ? Container(
                                                  margin: EdgeInsets.symmetric(
                                                      vertical:
                                                          size.iScreen(2.0)),
                                                  child: const Center(
                                                      child:
                                                          CircularProgressIndicator()))
                                              : Container();
                                    },
                                  );
                                }
                              },
                            ),
                          ): const NoData(
                              label: 'No existen datos para mostar',
                            );


                          
                          // ListView.builder(
                          //   itemCount: provider.allItemsFilters.length,
                          //   itemBuilder: (BuildContext context, int index) {
                          //     final producto =
                          //         provider.allItemsFilters[index];
                          //     return 
                          //    RefreshIndicator(
                          //    onRefresh: () => onRefresh(),
                          //   child: ListView.builder(
                          //     controller: _scrollController,
                          //     physics: const BouncingScrollPhysics(),
                          //     itemCount: provider
                          //             .allItemsFilters.length +
                          //         1,
                          //     itemBuilder: (BuildContext context, int index) {
                          //       if (index <
                          //           provider
                          //               .allItemsFilters.length) {
                          //         var _color;
                          //         final _prefacturas = provider
                          //             .allItemsFilters[index];
                          
                          //         if (_prefacturas['cajaEstado'] == 'AUTORIZADO') {
                          //           _color = Colors.green;
                          //         } else if (_prefacturas['cajaEstado'] ==
                          //             'SIN AUTORIZAR') {
                          //           _color = Colors.orange;
                          //         }
                          //         if (_prefacturas['cajaEstado'] == 'ANULADA') {
                          //           _color = Colors.red;
                          //         }
                          
                          //         return Slidable(
                          //           startActionPane: ActionPane(
                          //             // A motion is a widget used to control how the pane animates.
                          //             motion: const ScrollMotion(),
                          
                          //             children: [
                          //               SlidableAction(
                          //                     backgroundColor: Colors.grey,
                          //                 foregroundColor: Colors.white,
                          //                 icon: Icons.list_alt_outlined,
                          //                 label: 'Más acciones',
                          //                 onPressed: (context) {
                          //                   showCupertinoModalPopup(
                          //                     context: context,
                          //                     builder: (BuildContext context) =>
                          //                         CupertinoActionSheet(
                          //                             title: Text(
                          //                               'Acciones',
                          //                               style: GoogleFonts
                          //                                   .lexendDeca(
                          //                                       fontSize: size
                          //                                           .iScreen(2.0),
                          //                                       color:
                          //                                           primaryColor,
                          //                                       fontWeight:
                          //                                           FontWeight
                          //                                               .normal),
                          //                             ),
                          //                             // message: const Text('Your options are '),
                          //                             actions: <Widget>[
                          //                               CupertinoActionSheetAction(
                          //                                 child: Row(
                          //                                   mainAxisAlignment:
                          //                                       MainAxisAlignment
                          //                                           .center,
                          //                                   children: [
                          //                                     Container(
                          //                                       margin: EdgeInsets.only(
                          //                                           right: size
                          //                                               .iScreen(
                          //                                                   2.0)),
                          //                                       child: Text(
                          //                                         'Ver PDF',
                          //                                         style: GoogleFonts.lexendDeca(
                          //                                             fontSize: size
                          //                                                 .iScreen(
                          //                                                     1.8),
                          //                                             color: Colors
                          //                                                 .black87,
                          //                                             fontWeight:
                          //                                                 FontWeight
                          //                                                     .normal),
                          //                                       ),
                          //                                     ),
                          //                                     const Icon(
                          //                                       FontAwesomeIcons
                          //                                           .filePdf,
                          //                                       color: Colors.red,
                          //                                     )
                          //                                   ],
                          //                                 ),
                          //                                 onPressed: () {
                          //                                   Navigator.pop(
                          //                                       context);
                          
                          //                                   Navigator.push(
                          //                                     context,
                          //                                     MaterialPageRoute(
                          //                                         builder: (context) =>
                          //                                             ViewsPDFs(
                          //                                                 infoPdf:
                          //                                                     // 'https://sysvet.neitor.com/reportes/carnet.php?id=${factura['venId']}&empresa=${_usuario!.rucempresa}',
                          //                                                     'https://syscontable.neitor.com/reportes/factura.php?codigo=${_prefacturas['venId']}&empresa=${_usuario!.rucempresa}',
                          //                                                 labelPdf:
                          //                                                     'infoFactura.pdf')),
                          //                                   );
                          //                                 },
                          //                               ),
                          //                             ],
                          //                             cancelButton:
                          //                                 CupertinoActionSheetAction(
                          //                               child: Text('Cancel',
                          //                                   style: GoogleFonts
                          //                                       .lexendDeca(
                          //                                           fontSize: size
                          //                                               .iScreen(
                          //                                                   2.0),
                          //                                           color: Colors
                          //                                               .red,
                          //                                           fontWeight:
                          //                                               FontWeight
                          //                                                   .normal)),
                          //                               isDefaultAction: true,
                          //                               onPressed: () {
                          //                                 Navigator.pop(
                          //                                     context, 'Cancel');
                          //                               },
                          //                             )),
                          //                   );
                          //                 },
                          //               ),
                          //             ],
                          //           ),
                          //           child: Card(
                          //             elevation: 5,
                          //             child: Container(
                          //               margin: EdgeInsets.only(
                          //                   bottom: size.iScreen(0.0)),
                          //               color: index % 2 == 0
                          //                   ? Colors.grey.shade50
                          //                   : Colors.grey.shade200,
                          //               child: ListTile(
                          //                 dense: true,
                          //                 visualDensity:
                          //                     VisualDensity.comfortable,
                                      
                          //                  leading: CircleAvatar(
                          //                   child: Text(
                          //                      '${_prefacturas['venNomCliente'].substring(0, 1)}',
                          //                     style: Theme.of(context)
                          //                         .textTheme
                          //                         .subtitle1,
                          //                   ),
                          //                   backgroundColor: Colors.grey[300],
                          //                 ),
                          //                 title: Row(
                          //                   mainAxisAlignment:
                          //                       MainAxisAlignment.spaceBetween,
                          //                   children: [
                          //                     SizedBox(
                          //                       width: size.wScreen(40.0),
                          //                       child: Text(
                          //                         '${_prefacturas['venNomCliente']}',
                          //                         style: GoogleFonts.lexendDeca(
                          //                             // fontSize: size.iScreen(2.45),
                          //                             // color: Colors.white,
                          //                             fontWeight:
                          //                                 FontWeight.normal),
                          //                         overflow: TextOverflow.ellipsis,
                          //                       ),
                          //                     ),
                          //                     Text(
                          //                       '${_prefacturas['cajaEstado']}',
                          //                       // 'Estado: ',
                          //                       style: GoogleFonts.lexendDeca(
                          //                           fontSize: size.iScreen(1.5),
                          //                           color: _color,
                          //                           fontWeight: FontWeight.bold),
                          //                     ),
                          //                   ],
                          //                 ),
                          //                 subtitle: Row(
                          //                   mainAxisAlignment:
                          //                       MainAxisAlignment.spaceBetween,
                          //                   children: [
                          //                     Column(
                          //                       mainAxisAlignment:
                          //                           MainAxisAlignment.start,
                          //                       children: [
                          //                         Container(
                          //                           // color: Colors.green,
                          //                           width: size.wScreen(50.0),
                          //                           child: Text(
                          //                             '${_prefacturas['venNumFactura']}',
                          //                             style:
                          //                                 GoogleFonts.lexendDeca(
                          //                                     fontSize: size
                          //                                         .iScreen(1.5),
                          //                                     color:
                          //                                         Colors.black54,
                          //                                     fontWeight:
                          //                                         FontWeight
                          //                                             .normal),
                          //                             overflow:
                          //                                 TextOverflow.ellipsis,
                          //                           ),
                          //                         ),
                          //                         Container(
                          //                           // color: Colors.green,
                          //                           width: size.wScreen(50.0),
                          //                           child: Text(
                          //                             _prefacturas['venFecReg'] !=
                          //                                     ''
                          //                                 ? '${_prefacturas['venFecReg'].replaceAll('T', "  ").replaceAll('.000Z', "  ")}'
                          //                                 : '--- --- ---',
                          //                             style:
                          //                                 GoogleFonts.lexendDeca(
                          //                                     // fontSize: size.iScreen(2.45),
                          //                                     color: Colors.grey,
                          //                                     fontWeight:
                          //                                         FontWeight
                          //                                             .normal),
                          //                           ),
                          //                         ),
                          //                       ],
                          //                     ),
                          //                     Container(
                          //                       // color: Colors.green,
                          //                       // width: size.wScreen(100.0),
                          //                       child: Text(
                          //                         '\$${_prefacturas['venTotal']}',
                          //                         style: GoogleFonts.lexendDeca(
                          //                             fontSize: size.iScreen(2.0),
                          //                             color: Colors.black87,
                          //                             fontWeight:
                          //                                 FontWeight.normal),
                          //                         overflow: TextOverflow.ellipsis,
                          //                       ),
                          //                     ),
                          //                   ],
                          //                 ),
                          //                 // trailing: Icon(Icons.more_vert),
                          //               ),
                          //             ),
                          //           ),
                          //         );
                          //       } else {
                          //         return Consumer<PreFacturasController>(
                          //           builder: (_, valueNext, __) {
                          //             return valueNext.getpage == null
                          //                 ? Container(
                          //                     margin: EdgeInsets.symmetric(
                          //                         vertical: size.iScreen(2.0)),
                          //                     child: Center(
                          //                       child: Text(
                          //                         'No existen más datos',
                          //                         style: GoogleFonts.lexendDeca(
                          //                             fontSize: size.iScreen(1.8),
                          //                             // color: primaryColor,
                          //                             fontWeight:
                          //                                 FontWeight.normal),
                          //                       ),
                          //                     ))
                          //                 // : Container();
                          
                          //                 : provider.allItemsFilters.length > 25
                          //                     ? Container(
                          //                         margin: EdgeInsets.symmetric(
                          //                             vertical:
                          //                                 size.iScreen(2.0)),
                          //                         child: const Center(
                          //                             child:
                          //                                 CircularProgressIndicator()))
                          //                     : Container();
                          //           },
                          //         );
                          //       }
                          //     },
                          //   ),
                          // );





                              
                          //   },
                          // ) : const NoData(
                          //     label: 'No existen datos para mostar',
                          //   );
                        },
                      ),
                     

//                    Consumer<CajaController>(
//                         builder: (_, provider, __) {
                         
//                          if (provider.allItemsFilters.isEmpty) {
//                             return const NoData(
//                               label: 'No existen datos para mostar',
//                             );
//                             // Text("sin datos");
//                           }

//                           return 
                          
//                           (provider.allItemsFilters.isEmpty)
//                                         ? Center(
//                                             child: Column(
//                                               mainAxisAlignment: MainAxisAlignment.center,
//                                             children: [
                                              
//                                               CircularProgressIndicator(),
//                                               Text('Por favor espere ....')
//                                             ],
//                                           ))
//                                         : (provider.allItemsFilters.length > 0)
//                                             ?
//                            RefreshIndicator(
//                              onRefresh: () => onRefresh(),
//                             child: ListView.builder(
//                               controller: _scrollController,
//                               physics: const BouncingScrollPhysics(),
//                               itemCount: provider
//                                       .allItemsFilters.length +
//                                   1,
//                               itemBuilder: (BuildContext context, int index) {
//                                 if (index <
//                                     provider
//                                         .allItemsFilters.length) {
//                                   var _color;
//                                   final _prefacturas = provider
//                                       .allItemsFilters[index];
                          
//                                   if (_prefacturas['cajaEstado'] == 'AUTORIZADO') {
//                                     _color = Colors.green;
//                                   } else if (_prefacturas['cajaEstado'] ==
//                                       'SIN AUTORIZAR') {
//                                     _color = Colors.orange;
//                                   }
//                                   if (_prefacturas['cajaEstado'] == 'ANULADA') {
//                                     _color = Colors.red;
//                                   }
//   //==============================================//
//   String fechaLocal = convertirFechaLocal(_prefacturas['cajaFecReg']);
//  //==============================================//
//                                   return Slidable(
//                                     startActionPane: ActionPane(
//                                       // A motion is a widget used to control how the pane animates.
//                                       motion: const ScrollMotion(),
                          
//                                       children: [
//                                         SlidableAction(
//                                               backgroundColor: Colors.grey,
//                                           foregroundColor: Colors.white,
//                                           icon: Icons.list_alt_outlined,
//                                           label: 'Más acciones',
//                                           onPressed: (context) {
//                                             showCupertinoModalPopup(
//                                               context: context,
//                                               builder: (BuildContext context) =>
//                                                   CupertinoActionSheet(
//                                                       title: Text(
//                                                         'Acciones',
//                                                         style: GoogleFonts
//                                                             .lexendDeca(
//                                                                 fontSize: size
//                                                                     .iScreen(2.0),
//                                                                 color:
//                                                                     primaryColor,
//                                                                 fontWeight:
//                                                                     FontWeight
//                                                                         .normal),
//                                                       ),
//                                                       // message: const Text('Your options are '),
//                                                       actions: <Widget>[
//                                                         CupertinoActionSheetAction(
//                                                           child: Row(
//                                                             mainAxisAlignment:
//                                                                 MainAxisAlignment
//                                                                     .center,
//                                                             children: [
//                                                               Container(
//                                                                 margin: EdgeInsets.only(
//                                                                     right: size
//                                                                         .iScreen(
//                                                                             2.0)),
//                                                                 child: Text(
//                                                                   'Ver Detalle',
//                                                                   style: GoogleFonts.lexendDeca(
//                                                                       fontSize: size
//                                                                           .iScreen(
//                                                                               1.8),
//                                                                       color: Colors
//                                                                           .black87,
//                                                                       fontWeight:
//                                                                           FontWeight
//                                                                               .normal),
//                                                                 ),
//                                                               ),
//                                                               const Icon(
//                                                                 FontAwesomeIcons
//                                                                     .infoCircle,
//                                                                 color: Colors.red,
//                                                               )
//                                                             ],
//                                                           ),
//                                                           onPressed: () {
//                                                             provider.setInfoCaja(_prefacturas);
//                                                             Navigator.pop(
//                                                                 context);
                          
//                                                             Navigator.push(
//                                                               context,
//                                                               MaterialPageRoute(
//                                                                   builder: (context) =>
//                                                                      DetalleCaja()),
//                                                             );
//                                                           },
//                                                         ),
//                                                         // CupertinoActionSheetAction(
//                                                         //   child: Row(
//                                                         //     mainAxisAlignment:
//                                                         //         MainAxisAlignment
//                                                         //             .center,
//                                                         //     children: [
//                                                         //       Container(
//                                                         //         margin: EdgeInsets.only(
//                                                         //             right: size
//                                                         //                 .iScreen(
//                                                         //                     2.0)),
//                                                         //         child: Text(
//                                                         //           'Ver PDF',
//                                                         //           style: GoogleFonts.lexendDeca(
//                                                         //               fontSize: size
//                                                         //                   .iScreen(
//                                                         //                       1.8),
//                                                         //               color: Colors
//                                                         //                   .black87,
//                                                         //               fontWeight:
//                                                         //                   FontWeight
//                                                         //                       .normal),
//                                                         //         ),
//                                                         //       ),
//                                                         //       const Icon(
//                                                         //         FontAwesomeIcons
//                                                         //             .filePdf,
//                                                         //         color: Colors.red,
//                                                         //       )
//                                                         //     ],
//                                                         //   ),
//                                                         //   onPressed: () {
//                                                         //     Navigator.pop(
//                                                         //         context);
                          
//                                                         //     Navigator.push(
//                                                         //       context,
//                                                         //       MaterialPageRoute(
//                                                         //           builder: (context) =>
//                                                         //               ViewsPDFs(
//                                                         //                   infoPdf:
//                                                         //                       // 'https://sysvet.neitor.com/reportes/carnet.php?id=${factura['venId']}&empresa=${_usuario!.rucempresa}',
//                                                         //                       'https://syscontable.neitor.com/reportes/factura.php?codigo=${_prefacturas['venId']}&empresa=${_usuario!.rucempresa}',
//                                                         //                   labelPdf:
//                                                         //                       'infoFactura.pdf')),
//                                                         //     );
//                                                         //   },
//                                                         // ),
//                                                       ],
//                                                       cancelButton:
//                                                           CupertinoActionSheetAction(
//                                                         child: Text('Cancel',
//                                                             style: GoogleFonts
//                                                                 .lexendDeca(
//                                                                     fontSize: size
//                                                                         .iScreen(
//                                                                             2.0),
//                                                                     color: Colors
//                                                                         .red,
//                                                                     fontWeight:
//                                                                         FontWeight
//                                                                             .normal)),
//                                                         isDefaultAction: true,
//                                                         onPressed: () {
//                                                           Navigator.pop(
//                                                               context, 'Cancel');
//                                                         },
//                                                       )),
//                                             );
//                                           },
//                                         ),
//                                       ],
//                                     ),
//                                     child: Card(
//                                       elevation: 5,
//                                       child: Container(
//                                         margin: EdgeInsets.only(
//                                             bottom: size.iScreen(0.0)),
//                                         color: index % 2 == 0
//                                             ? Colors.grey.shade50
//                                             : Colors.grey.shade200,
//                                         child: ListTile(
//                                           dense: true,
//                                           visualDensity:
//                                               VisualDensity.comfortable,
                                      
//                                           //  leading: CircleAvatar(
//                                           //   child: Text(
//                                           //      '${_prefacturas['venNomCliente'].substring(0, 1)}',
//                                           //     style: Theme.of(context)
//                                           //         .textTheme
//                                           //         .subtitle1,
//                                           //   ),
//                                           //   backgroundColor: Colors.grey[300],
//                                           // ),
//                                           title: Row(
//                                             mainAxisAlignment:
//                                                 MainAxisAlignment.spaceBetween,
//                                             children: [
//                                               SizedBox(
//                                                 width: size.wScreen(40.0),
//                                                 child: Text(
//                                                   '${_prefacturas['cajaTipoCaja']}',
//                                                   style: GoogleFonts.lexendDeca(
//                                                       // fontSize: size.iScreen(2.45),
//                                                       // color: Colors.white,
//                                                       fontWeight:
//                                                           FontWeight.normal),
//                                                   overflow: TextOverflow.ellipsis,
//                                                 ),
//                                               ),
//                                               Text(
//                                                 '${_prefacturas['cajaEstado']}',
//                                                 // 'Estado: ',
//                                                 style: GoogleFonts.lexendDeca(
//                                                     fontSize: size.iScreen(1.5),
//                                                     color: _color,
//                                                     fontWeight: FontWeight.bold),
//                                               ),
//                                             ],
//                                           ),
//                                           subtitle: Row(
//                                             mainAxisAlignment:
//                                                 MainAxisAlignment.spaceBetween,
//                                             children: [
//                                               Column(
//                                                 mainAxisAlignment:
//                                                     MainAxisAlignment.start,
//                                                 children: [
//                                                   Container(
//                                                     // color: Colors.green,
//                                                     width: size.wScreen(50.0),
//                                                     child: Text(
//                                                       '${_prefacturas['cajaNumero']}',
//                                                       style:
//                                                           GoogleFonts.lexendDeca(
//                                                               fontSize: size
//                                                                   .iScreen(1.5),
//                                                               color:
//                                                                   Colors.black54,
//                                                               fontWeight:
//                                                                   FontWeight
//                                                                       .normal),
//                                                       overflow:
//                                                           TextOverflow.ellipsis,
//                                                     ),
//                                                   ),
//                                                   Container(
//                                                     // color: Colors.green,
//                                                     width: size.wScreen(50.0),
//                                                     child: Text(
//                                                       fechaLocal !=
//                                                               ''
//                                                           ? fechaLocal
//                                                           : '--- --- ---',
//                                                       style:
//                                                           GoogleFonts.lexendDeca(
//                                                               // fontSize: size.iScreen(2.45),
//                                                               color: Colors.grey,
//                                                               fontWeight:
//                                                                   FontWeight
//                                                                       .normal),
//                                                     ),
//                                                   ),
//                                                 ],
//                                               ),
//                                               Container(
//                                                 // color: Colors.green,
//                                                 // width: size.wScreen(100.0),
//                                                 child: Text(
//                                                   '\$${_prefacturas['cajaMonto']}',
//                                                   style: GoogleFonts.lexendDeca(
//                                                       fontSize: size.iScreen(2.0),
//                                                       color: Colors.black87,
//                                                       fontWeight:
//                                                           FontWeight.normal),
//                                                   overflow: TextOverflow.ellipsis,
//                                                 ),
//                                               ),
//                                             ],
//                                           ),
//                                           // trailing: Icon(Icons.more_vert),
//                                         ),
//                                       ),
//                                     ),
//                                   );
//                                 } else {
//                                   return Consumer<PreFacturasController>(
//                                     builder: (_, valueNext, __) {
//                                       return valueNext.getpage == null
//                                           ? Container(
//                                               margin: EdgeInsets.symmetric(
//                                                   vertical: size.iScreen(2.0)),
//                                               child: Center(
//                                                 child: Text(
//                                                   'No existen más datos',
//                                                   style: GoogleFonts.lexendDeca(
//                                                       fontSize: size.iScreen(1.8),
//                                                       // color: primaryColor,
//                                                       fontWeight:
//                                                           FontWeight.normal),
//                                                 ),
//                                               ))
//                                           // : Container();
                          
//                                           : provider.allItemsFilters.length > 25
//                                               ? Container(
//                                                   margin: EdgeInsets.symmetric(
//                                                       vertical:
//                                                           size.iScreen(2.0)),
//                                                   child: const Center(
//                                                       child:
//                                                           CircularProgressIndicator()))
//                                               : Container();
//                                     },
//                                   );
//                                 }
//                               },
//                             ),
//                           ): const NoData(
//                               label: 'No existen datos para mostar',
//                             );


                          
//                           // ListView.builder(
//                           //   itemCount: provider.allItemsFilters.length,
//                           //   itemBuilder: (BuildContext context, int index) {
//                           //     final producto =
//                           //         provider.allItemsFilters[index];
//                           //     return 
//                           //    RefreshIndicator(
//                           //    onRefresh: () => onRefresh(),
//                           //   child: ListView.builder(
//                           //     controller: _scrollController,
//                           //     physics: const BouncingScrollPhysics(),
//                           //     itemCount: provider
//                           //             .allItemsFilters.length +
//                           //         1,
//                           //     itemBuilder: (BuildContext context, int index) {
//                           //       if (index <
//                           //           provider
//                           //               .allItemsFilters.length) {
//                           //         var _color;
//                           //         final _prefacturas = provider
//                           //             .allItemsFilters[index];
                          
//                           //         if (_prefacturas['cajaEstado'] == 'AUTORIZADO') {
//                           //           _color = Colors.green;
//                           //         } else if (_prefacturas['cajaEstado'] ==
//                           //             'SIN AUTORIZAR') {
//                           //           _color = Colors.orange;
//                           //         }
//                           //         if (_prefacturas['cajaEstado'] == 'ANULADA') {
//                           //           _color = Colors.red;
//                           //         }
                          
//                           //         return Slidable(
//                           //           startActionPane: ActionPane(
//                           //             // A motion is a widget used to control how the pane animates.
//                           //             motion: const ScrollMotion(),
                          
//                           //             children: [
//                           //               SlidableAction(
//                           //                     backgroundColor: Colors.grey,
//                           //                 foregroundColor: Colors.white,
//                           //                 icon: Icons.list_alt_outlined,
//                           //                 label: 'Más acciones',
//                           //                 onPressed: (context) {
//                           //                   showCupertinoModalPopup(
//                           //                     context: context,
//                           //                     builder: (BuildContext context) =>
//                           //                         CupertinoActionSheet(
//                           //                             title: Text(
//                           //                               'Acciones',
//                           //                               style: GoogleFonts
//                           //                                   .lexendDeca(
//                           //                                       fontSize: size
//                           //                                           .iScreen(2.0),
//                           //                                       color:
//                           //                                           primaryColor,
//                           //                                       fontWeight:
//                           //                                           FontWeight
//                           //                                               .normal),
//                           //                             ),
//                           //                             // message: const Text('Your options are '),
//                           //                             actions: <Widget>[
//                           //                               CupertinoActionSheetAction(
//                           //                                 child: Row(
//                           //                                   mainAxisAlignment:
//                           //                                       MainAxisAlignment
//                           //                                           .center,
//                           //                                   children: [
//                           //                                     Container(
//                           //                                       margin: EdgeInsets.only(
//                           //                                           right: size
//                           //                                               .iScreen(
//                           //                                                   2.0)),
//                           //                                       child: Text(
//                           //                                         'Ver PDF',
//                           //                                         style: GoogleFonts.lexendDeca(
//                           //                                             fontSize: size
//                           //                                                 .iScreen(
//                           //                                                     1.8),
//                           //                                             color: Colors
//                           //                                                 .black87,
//                           //                                             fontWeight:
//                           //                                                 FontWeight
//                           //                                                     .normal),
//                           //                                       ),
//                           //                                     ),
//                           //                                     const Icon(
//                           //                                       FontAwesomeIcons
//                           //                                           .filePdf,
//                           //                                       color: Colors.red,
//                           //                                     )
//                           //                                   ],
//                           //                                 ),
//                           //                                 onPressed: () {
//                           //                                   Navigator.pop(
//                           //                                       context);
                          
//                           //                                   Navigator.push(
//                           //                                     context,
//                           //                                     MaterialPageRoute(
//                           //                                         builder: (context) =>
//                           //                                             ViewsPDFs(
//                           //                                                 infoPdf:
//                           //                                                     // 'https://sysvet.neitor.com/reportes/carnet.php?id=${factura['venId']}&empresa=${_usuario!.rucempresa}',
//                           //                                                     'https://syscontable.neitor.com/reportes/factura.php?codigo=${_prefacturas['venId']}&empresa=${_usuario!.rucempresa}',
//                           //                                                 labelPdf:
//                           //                                                     'infoFactura.pdf')),
//                           //                                   );
//                           //                                 },
//                           //                               ),
//                           //                             ],
//                           //                             cancelButton:
//                           //                                 CupertinoActionSheetAction(
//                           //                               child: Text('Cancel',
//                           //                                   style: GoogleFonts
//                           //                                       .lexendDeca(
//                           //                                           fontSize: size
//                           //                                               .iScreen(
//                           //                                                   2.0),
//                           //                                           color: Colors
//                           //                                               .red,
//                           //                                           fontWeight:
//                           //                                               FontWeight
//                           //                                                   .normal)),
//                           //                               isDefaultAction: true,
//                           //                               onPressed: () {
//                           //                                 Navigator.pop(
//                           //                                     context, 'Cancel');
//                           //                               },
//                           //                             )),
//                           //                   );
//                           //                 },
//                           //               ),
//                           //             ],
//                           //           ),
//                           //           child: Card(
//                           //             elevation: 5,
//                           //             child: Container(
//                           //               margin: EdgeInsets.only(
//                           //                   bottom: size.iScreen(0.0)),
//                           //               color: index % 2 == 0
//                           //                   ? Colors.grey.shade50
//                           //                   : Colors.grey.shade200,
//                           //               child: ListTile(
//                           //                 dense: true,
//                           //                 visualDensity:
//                           //                     VisualDensity.comfortable,
                                      
//                           //                  leading: CircleAvatar(
//                           //                   child: Text(
//                           //                      '${_prefacturas['venNomCliente'].substring(0, 1)}',
//                           //                     style: Theme.of(context)
//                           //                         .textTheme
//                           //                         .subtitle1,
//                           //                   ),
//                           //                   backgroundColor: Colors.grey[300],
//                           //                 ),
//                           //                 title: Row(
//                           //                   mainAxisAlignment:
//                           //                       MainAxisAlignment.spaceBetween,
//                           //                   children: [
//                           //                     SizedBox(
//                           //                       width: size.wScreen(40.0),
//                           //                       child: Text(
//                           //                         '${_prefacturas['venNomCliente']}',
//                           //                         style: GoogleFonts.lexendDeca(
//                           //                             // fontSize: size.iScreen(2.45),
//                           //                             // color: Colors.white,
//                           //                             fontWeight:
//                           //                                 FontWeight.normal),
//                           //                         overflow: TextOverflow.ellipsis,
//                           //                       ),
//                           //                     ),
//                           //                     Text(
//                           //                       '${_prefacturas['cajaEstado']}',
//                           //                       // 'Estado: ',
//                           //                       style: GoogleFonts.lexendDeca(
//                           //                           fontSize: size.iScreen(1.5),
//                           //                           color: _color,
//                           //                           fontWeight: FontWeight.bold),
//                           //                     ),
//                           //                   ],
//                           //                 ),
//                           //                 subtitle: Row(
//                           //                   mainAxisAlignment:
//                           //                       MainAxisAlignment.spaceBetween,
//                           //                   children: [
//                           //                     Column(
//                           //                       mainAxisAlignment:
//                           //                           MainAxisAlignment.start,
//                           //                       children: [
//                           //                         Container(
//                           //                           // color: Colors.green,
//                           //                           width: size.wScreen(50.0),
//                           //                           child: Text(
//                           //                             '${_prefacturas['venNumFactura']}',
//                           //                             style:
//                           //                                 GoogleFonts.lexendDeca(
//                           //                                     fontSize: size
//                           //                                         .iScreen(1.5),
//                           //                                     color:
//                           //                                         Colors.black54,
//                           //                                     fontWeight:
//                           //                                         FontWeight
//                           //                                             .normal),
//                           //                             overflow:
//                           //                                 TextOverflow.ellipsis,
//                           //                           ),
//                           //                         ),
//                           //                         Container(
//                           //                           // color: Colors.green,
//                           //                           width: size.wScreen(50.0),
//                           //                           child: Text(
//                           //                             _prefacturas['venFecReg'] !=
//                           //                                     ''
//                           //                                 ? '${_prefacturas['venFecReg'].replaceAll('T', "  ").replaceAll('.000Z', "  ")}'
//                           //                                 : '--- --- ---',
//                           //                             style:
//                           //                                 GoogleFonts.lexendDeca(
//                           //                                     // fontSize: size.iScreen(2.45),
//                           //                                     color: Colors.grey,
//                           //                                     fontWeight:
//                           //                                         FontWeight
//                           //                                             .normal),
//                           //                           ),
//                           //                         ),
//                           //                       ],
//                           //                     ),
//                           //                     Container(
//                           //                       // color: Colors.green,
//                           //                       // width: size.wScreen(100.0),
//                           //                       child: Text(
//                           //                         '\$${_prefacturas['venTotal']}',
//                           //                         style: GoogleFonts.lexendDeca(
//                           //                             fontSize: size.iScreen(2.0),
//                           //                             color: Colors.black87,
//                           //                             fontWeight:
//                           //                                 FontWeight.normal),
//                           //                         overflow: TextOverflow.ellipsis,
//                           //                       ),
//                           //                     ),
//                           //                   ],
//                           //                 ),
//                           //                 // trailing: Icon(Icons.more_vert),
//                           //               ),
//                           //             ),
//                           //           ),
//                           //         );
//                           //       } else {
//                           //         return Consumer<PreFacturasController>(
//                           //           builder: (_, valueNext, __) {
//                           //             return valueNext.getpage == null
//                           //                 ? Container(
//                           //                     margin: EdgeInsets.symmetric(
//                           //                         vertical: size.iScreen(2.0)),
//                           //                     child: Center(
//                           //                       child: Text(
//                           //                         'No existen más datos',
//                           //                         style: GoogleFonts.lexendDeca(
//                           //                             fontSize: size.iScreen(1.8),
//                           //                             // color: primaryColor,
//                           //                             fontWeight:
//                           //                                 FontWeight.normal),
//                           //                       ),
//                           //                     ))
//                           //                 // : Container();
                          
//                           //                 : provider.allItemsFilters.length > 25
//                           //                     ? Container(
//                           //                         margin: EdgeInsets.symmetric(
//                           //                             vertical:
//                           //                                 size.iScreen(2.0)),
//                           //                         child: const Center(
//                           //                             child:
//                           //                                 CircularProgressIndicator()))
//                           //                     : Container();
//                           //           },
//                           //         );
//                           //       }
//                           //     },
//                           //   ),
//                           // );





                              
//                           //   },
//                           // ) : const NoData(
//                           //     label: 'No existen datos para mostar',
//                           //   );
//                         },
//                       ),
                     


              //  Consumer<PreFacturasController>(
              //           builder: (_, providersPrefacturas, __) {
              //             if (providersPrefacturas
              //                         .getErrorPreFacturasPaginacion ==
              //                     null &&
              //                 providersPrefacturas
              //                         .getError401PreFacturasPaginacion ==
              //                     false) {
              //               return Center(
              //                 // child: CircularProgressIndicator(),
              //                 child: Column(
              //                   mainAxisSize: MainAxisSize.min,
              //                   children: [
              //                     Text(
              //                       'Cargando Datos...',
              //                       style: GoogleFonts.lexendDeca(
              //                           fontSize: size.iScreen(1.5),
              //                           color: Colors.black87,
              //                           fontWeight: FontWeight.bold),
              //                     ),
              //                     //***********************************************/
              //                     SizedBox(
              //                       height: size.iScreen(1.0),
              //                     ),
              //                     //*****************************************/
              //                     const CircularProgressIndicator(),
              //                   ],
              //                 ),
              //               );
              //             } else if (providersPrefacturas
              //                     .getErrorPreFacturasPaginacion ==
              //                 false) {
              //               return const NoData(
              //                 label: 'No existen datos para mostar',
              //               );
              //             } else if (providersPrefacturas
              //                     .getListaPreFacturasPaginacion.isEmpty &&
              //                 providersPrefacturas
              //                         .getErrorPreFacturasPaginacion ==
              //                     false) {
              //               return const NoData(
              //                 label: 'No existen datos para mostar',
              //               );
              //             } else if (providersPrefacturas
              //                     .getListaPreFacturasPaginacion.isEmpty &&
              //                 providersPrefacturas
              //                         .getError401PreFacturasPaginacion ==
              //                     true) {
              //               return const NoData(
              //                 label:
              //                     'Su sesión ha expirado, vuelva a iniciar sesión',
              //               );
              //             } else if (providersPrefacturas
              //                     .getListaPreFacturasPaginacion.isEmpty &&
              //                 providersPrefacturas
              //                         .getError401PreFacturasPaginacion ==
              //                     false) {
              //               return const NoData(
              //                 label: 'No existen datos para mostar',
              //               );
              //             }

              //             return 
              // 
              // 
              // RefreshIndicator(
              //                onRefresh: () => onRefresh(),
              //               child: ListView.builder(
              //                 controller: _scrollController,
              //                 physics: const BouncingScrollPhysics(),
              //                 itemCount: providersPrefacturas
              //                         .getListaPreFacturasPaginacion.length +
              //                     1,
              //                 itemBuilder: (BuildContext context, int index) {
              //                   if (index <
              //                       providersPrefacturas
              //                           .getListaPreFacturasPaginacion.length) {
              //                     var _color;
              //                     final _prefacturas = providersPrefacturas
              //                         .getListaPreFacturasPaginacion[index];
                          
              //                     if (_prefacturas['cajaEstado'] == 'AUTORIZADO') {
              //                       _color = Colors.green;
              //                     } else if (_prefacturas['cajaEstado'] ==
              //                         'SIN AUTORIZAR') {
              //                       _color = Colors.orange;
              //                     }
              //                     if (_prefacturas['cajaEstado'] == 'ANULADA') {
              //                       _color = Colors.red;
              //                     }
                          
              //                     return Slidable(
              //                       startActionPane: ActionPane(
              //                         // A motion is a widget used to control how the pane animates.
              //                         motion: const ScrollMotion(),
                          
              //                         children: [
              //                           SlidableAction(
              //                                 backgroundColor: Colors.grey,
              //                             foregroundColor: Colors.white,
              //                             icon: Icons.list_alt_outlined,
              //                             label: 'Más acciones',
              //                             onPressed: (context) {
              //                               showCupertinoModalPopup(
              //                                 context: context,
              //                                 builder: (BuildContext context) =>
              //                                     CupertinoActionSheet(
              //                                         title: Text(
              //                                           'Acciones',
              //                                           style: GoogleFonts
              //                                               .lexendDeca(
              //                                                   fontSize: size
              //                                                       .iScreen(2.0),
              //                                                   color:
              //                                                       primaryColor,
              //                                                   fontWeight:
              //                                                       FontWeight
              //                                                           .normal),
              //                                         ),
              //                                         // message: const Text('Your options are '),
              //                                         actions: <Widget>[
              //                                           CupertinoActionSheetAction(
              //                                             child: Row(
              //                                               mainAxisAlignment:
              //                                                   MainAxisAlignment
              //                                                       .center,
              //                                               children: [
              //                                                 Container(
              //                                                   margin: EdgeInsets.only(
              //                                                       right: size
              //                                                           .iScreen(
              //                                                               2.0)),
              //                                                   child: Text(
              //                                                     'Ver PDF',
              //                                                     style: GoogleFonts.lexendDeca(
              //                                                         fontSize: size
              //                                                             .iScreen(
              //                                                                 1.8),
              //                                                         color: Colors
              //                                                             .black87,
              //                                                         fontWeight:
              //                                                             FontWeight
              //                                                                 .normal),
              //                                                   ),
              //                                                 ),
              //                                                 const Icon(
              //                                                   FontAwesomeIcons
              //                                                       .filePdf,
              //                                                   color: Colors.red,
              //                                                 )
              //                                               ],
              //                                             ),
              //                                             onPressed: () {
              //                                               Navigator.pop(
              //                                                   context);
                          
              //                                               Navigator.push(
              //                                                 context,
              //                                                 MaterialPageRoute(
              //                                                     builder: (context) =>
              //                                                         ViewsPDFs(
              //                                                             infoPdf:
              //                                                                 // 'https://sysvet.neitor.com/reportes/carnet.php?id=${factura['venId']}&empresa=${_usuario!.rucempresa}',
              //                                                                 'https://syscontable.neitor.com/reportes/factura.php?codigo=${_prefacturas['venId']}&empresa=${_usuario!.rucempresa}',
              //                                                             labelPdf:
              //                                                                 'infoFactura.pdf')),
              //                                               );
              //                                             },
              //                                           ),
              //                                         ],
              //                                         cancelButton:
              //                                             CupertinoActionSheetAction(
              //                                           child: Text('Cancel',
              //                                               style: GoogleFonts
              //                                                   .lexendDeca(
              //                                                       fontSize: size
              //                                                           .iScreen(
              //                                                               2.0),
              //                                                       color: Colors
              //                                                           .red,
              //                                                       fontWeight:
              //                                                           FontWeight
              //                                                               .normal)),
              //                                           isDefaultAction: true,
              //                                           onPressed: () {
              //                                             Navigator.pop(
              //                                                 context, 'Cancel');
              //                                           },
              //                                         )),
              //                               );
              //                             },
              //                           ),
              //                         ],
              //                       ),
              //                       child: Card(
              //                         elevation: 5,
              //                         child: Container(
              //                           margin: EdgeInsets.only(
              //                               bottom: size.iScreen(0.0)),
              //                           color: index % 2 == 0
              //                               ? Colors.grey.shade50
              //                               : Colors.grey.shade200,
              //                           child: ListTile(
              //                             dense: true,
              //                             visualDensity:
              //                                 VisualDensity.comfortable,
                                      
              //                              leading: CircleAvatar(
              //                               child: Text(
              //                                  '${_prefacturas['venNomCliente'].substring(0, 1)}',
              //                                 style: Theme.of(context)
              //                                     .textTheme
              //                                     .subtitle1,
              //                               ),
              //                               backgroundColor: Colors.grey[300],
              //                             ),
              //                             title: Row(
              //                               mainAxisAlignment:
              //                                   MainAxisAlignment.spaceBetween,
              //                               children: [
              //                                 SizedBox(
              //                                   width: size.wScreen(40.0),
              //                                   child: Text(
              //                                     '${_prefacturas['venNomCliente']}',
              //                                     style: GoogleFonts.lexendDeca(
              //                                         // fontSize: size.iScreen(2.45),
              //                                         // color: Colors.white,
              //                                         fontWeight:
              //                                             FontWeight.normal),
              //                                     overflow: TextOverflow.ellipsis,
              //                                   ),
              //                                 ),
              //                                 Text(
              //                                   '${_prefacturas['cajaEstado']}',
              //                                   // 'Estado: ',
              //                                   style: GoogleFonts.lexendDeca(
              //                                       fontSize: size.iScreen(1.5),
              //                                       color: _color,
              //                                       fontWeight: FontWeight.bold),
              //                                 ),
              //                               ],
              //                             ),
              //                             subtitle: Row(
              //                               mainAxisAlignment:
              //                                   MainAxisAlignment.spaceBetween,
              //                               children: [
              //                                 Column(
              //                                   mainAxisAlignment:
              //                                       MainAxisAlignment.start,
              //                                   children: [
              //                                     Container(
              //                                       // color: Colors.green,
              //                                       width: size.wScreen(50.0),
              //                                       child: Text(
              //                                         '${_prefacturas['venNumFactura']}',
              //                                         style:
              //                                             GoogleFonts.lexendDeca(
              //                                                 fontSize: size
              //                                                     .iScreen(1.5),
              //                                                 color:
              //                                                     Colors.black54,
              //                                                 fontWeight:
              //                                                     FontWeight
              //                                                         .normal),
              //                                         overflow:
              //                                             TextOverflow.ellipsis,
              //                                       ),
              //                                     ),
              //                                     Container(
              //                                       // color: Colors.green,
              //                                       width: size.wScreen(50.0),
              //                                       child: Text(
              //                                         _prefacturas['venFecReg'] !=
              //                                                 ''
              //                                             ? '${_prefacturas['venFecReg'].replaceAll('T', "  ").replaceAll('.000Z', "  ")}'
              //                                             : '--- --- ---',
              //                                         style:
              //                                             GoogleFonts.lexendDeca(
              //                                                 // fontSize: size.iScreen(2.45),
              //                                                 color: Colors.grey,
              //                                                 fontWeight:
              //                                                     FontWeight
              //                                                         .normal),
              //                                       ),
              //                                     ),
              //                                   ],
              //                                 ),
              //                                 Container(
              //                                   // color: Colors.green,
              //                                   // width: size.wScreen(100.0),
              //                                   child: Text(
              //                                     '\$${_prefacturas['venTotal']}',
              //                                     style: GoogleFonts.lexendDeca(
              //                                         fontSize: size.iScreen(2.0),
              //                                         color: Colors.black87,
              //                                         fontWeight:
              //                                             FontWeight.normal),
              //                                     overflow: TextOverflow.ellipsis,
              //                                   ),
              //                                 ),
              //                               ],
              //                             ),
              //                             // trailing: Icon(Icons.more_vert),
              //                           ),
              //                         ),
              //                       ),
              //                     );
              //                   } else {
              //                     return Consumer<PreFacturasController>(
              //                       builder: (_, valueNext, __) {
              //                         return valueNext.getpage == null
              //                             ? Container(
              //                                 margin: EdgeInsets.symmetric(
              //                                     vertical: size.iScreen(2.0)),
              //                                 child: Center(
              //                                   child: Text(
              //                                     'No existen más datos',
              //                                     style: GoogleFonts.lexendDeca(
              //                                         fontSize: size.iScreen(1.8),
              //                                         // color: primaryColor,
              //                                         fontWeight:
              //                                             FontWeight.normal),
              //                                   ),
              //                                 ))
              //                             // : Container();
                          
              //                             : providersPrefacturas
              //                                         .getListaPreFacturasPaginacion
              //                                         .length >
              //                                     25
              //                                 ? Container(
              //                                     margin: EdgeInsets.symmetric(
              //                                         vertical:
              //                                             size.iScreen(2.0)),
              //                                     child: const Center(
              //                                         child:
              //                                             CircularProgressIndicator()))
              //                                 : Container();
              //                       },
              //                     );
              //                   }
              //                 },
              //               ),
              //             );
              //           },
              //         )
              //       ,


//========================TAB 2=======================//

Consumer<CajaController>(
                        builder: (_, provider, __) {
                         
                         if (provider.allItemsFilters.isEmpty) {
                            return const NoData(
                              label: 'Por favor espere ....',
                            );
                            // Text("sin datos");
                          }

                          return 
                          
                          (provider.allItemsFilters.isEmpty)
                                        ? Center(
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              
                                              CircularProgressIndicator(),
                                              Text('Por favor espere ....')
                                            ],
                                          ))
                                        : (provider.allItemsFilters.length > 0)
                                            ?
                           RefreshIndicator(
                             onRefresh: () => onRefresh(),
                            child: 
                            ListView.builder(
                              controller: _scrollController,
                              physics: const BouncingScrollPhysics(),
                              itemCount: provider
                                      .allItemsFilters.length +
                                  1,
                              itemBuilder: (BuildContext context, int index) {
                                if (index <
                                    provider
                                        .allItemsFilters.length) {
                                  var _color;
                                  final _prefacturas = provider
                                      .allItemsFilters[index];
                          
                                  if (_prefacturas['cajaEstado'] == 'AUTORIZADO') {
                                    _color = Colors.green;
                                  } else if (_prefacturas['cajaEstado'] ==
                                      'SIN AUTORIZAR') {
                                    _color = Colors.orange;
                                  }
                                  if (_prefacturas['cajaEstado'] == 'ANULADA') {
                                    _color = Colors.red;
                                  }
 //==============================================//
  String fechaLocal = convertirFechaLocal(_prefacturas['cajaFecReg']);
 //==============================================//
                                  return 
                                  _prefacturas['cajaEstado'] != 'ANULADA'?
                                  Slidable(
                                    startActionPane: ActionPane(
                                      // A motion is a widget used to control how the pane animates.
                                      motion: const ScrollMotion(),
                          
                                      children: [
                                        SlidableAction(
                                              backgroundColor: Colors.grey,
                                          foregroundColor: Colors.white,
                                          icon: Icons.list_alt_outlined,
                                          label: 'Más acciones',
                                          onPressed: (context) {
                                            showCupertinoModalPopup(
                                              context: context,
                                              builder: (BuildContext context) =>
                                                  CupertinoActionSheet(
                                                      title: Text(
                                                        'Acciones',
                                                        style: GoogleFonts
                                                            .lexendDeca(
                                                                fontSize: size
                                                                    .iScreen(2.0),
                                                                color:
                                                                    primaryColor,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .normal),
                                                      ),
                                                      // message: const Text('Your options are '),
                                                      actions: <Widget>[
                                                               CupertinoActionSheetAction(
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Container(
                                                                margin: EdgeInsets.only(
                                                                    right: size
                                                                        .iScreen(
                                                                            2.0)),
                                                                child: Text(
                                                                  'Imprimir',
                                                                  style: GoogleFonts.lexendDeca(
                                                                      fontSize: size
                                                                          .iScreen(
                                                                              1.8),
                                                                      color: Colors
                                                                          .black87,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .normal),
                                                                ),
                                                              ),
                                                              const Icon(
                                                                FontAwesomeIcons
                                                                    .print,
                                                                color: Colors.green,
                                                              )
                                                            ],
                                                          ),
                                                          onPressed: () {
                                                            Navigator.pop(
                                                                context);
                                                                _printTicket(_prefacturas,widget.user!.logo);

                                                           
                                                          },
                                                        ),
                                                                CupertinoActionSheetAction(
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Container(
                                                                margin: EdgeInsets.only(
                                                                    right: size
                                                                        .iScreen(
                                                                            2.0)),
                                                                child: Text(
                                                                  'Ver Detalle',
                                                                  style: GoogleFonts.lexendDeca(
                                                                      fontSize: size
                                                                          .iScreen(
                                                                              1.8),
                                                                      color: Colors
                                                                          .black87,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .normal),
                                                                ),
                                                              ),
                                                              const Icon(
                                                                FontAwesomeIcons
                                                                    .infoCircle,
                                                                color: Colors.blue,
                                                              )
                                                            ],
                                                          ),
                                                          onPressed: () {
                                                            provider.setInfoCaja(_prefacturas);
                                                            Navigator.pop(
                                                                context);
                          
                                                            Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder: (context) =>
                                                                     DetalleCaja()),
                                                            );
                                                          },
                                                        ),
                                                        // CupertinoActionSheetAction(
                                                        //   child: Row(
                                                        //     mainAxisAlignment:
                                                        //         MainAxisAlignment
                                                        //             .center,
                                                        //     children: [
                                                        //       Container(
                                                        //         margin: EdgeInsets.only(
                                                        //             right: size
                                                        //                 .iScreen(
                                                        //                     2.0)),
                                                        //         child: Text(
                                                        //           'Ver PDF',
                                                        //           style: GoogleFonts.lexendDeca(
                                                        //               fontSize: size
                                                        //                   .iScreen(
                                                        //                       1.8),
                                                        //               color: Colors
                                                        //                   .black87,
                                                        //               fontWeight:
                                                        //                   FontWeight
                                                        //                       .normal),
                                                        //         ),
                                                        //       ),
                                                        //       const Icon(
                                                        //         FontAwesomeIcons
                                                        //             .filePdf,
                                                        //         color: Colors.red,
                                                        //       )
                                                        //     ],
                                                        //   ),
                                                        //   onPressed: () {
                                                        //     Navigator.pop(
                                                        //         context);
                          
                                                        //     Navigator.push(
                                                        //       context,
                                                        //       MaterialPageRoute(
                                                        //           builder: (context) =>
                                                        //               ViewsPDFs(
                                                        //                   infoPdf:
                                                        //                       // 'https://sysvet.neitor.com/reportes/carnet.php?id=${factura['venId']}&empresa=${_usuario!.rucempresa}',
                                                        //                       'https://syscontable.neitor.com/reportes/factura.php?codigo=${_prefacturas['venId']}&empresa=${_usuario!.rucempresa}',
                                                        //                   labelPdf:
                                                        //                       'infoFactura.pdf')),
                                                        //     );
                                                        //   },
                                                        // ),
                                                     
                                                     
                                                     
                                                      ],
                                                      cancelButton:
                                                          CupertinoActionSheetAction(
                                                        child: Text('Cancel',
                                                            style: GoogleFonts
                                                                .lexendDeca(
                                                                    fontSize: size
                                                                        .iScreen(
                                                                            2.0),
                                                                    color: Colors
                                                                        .red,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .normal)),
                                                        isDefaultAction: true,
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context, 'Cancel');
                                                        },
                                                      )),
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                    child: Card(
                                      elevation: 5,
                                      child: Container(
                                        margin: EdgeInsets.only(
                                            bottom: size.iScreen(0.0)),
                                        color: index % 2 == 0
                                            ? Colors.grey.shade50
                                            : Colors.grey.shade200,
                                        child: ListTile(
                                          dense: true,
                                          visualDensity:
                                              VisualDensity.comfortable,
                                      
                                          //  leading: CircleAvatar(
                                          //   child: Text(
                                          //      '${_prefacturas['venNomCliente'].substring(0, 1)}',
                                          //     style: Theme.of(context)
                                          //         .textTheme
                                          //         .subtitle1,
                                          //   ),
                                          //   backgroundColor: Colors.grey[300],
                                          // ),
                                          title: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  SizedBox(
                                                    // width: size.wScreen(40.0),
                                                    child: Text(
                                                      'Documento: ',
                                                      style: GoogleFonts.lexendDeca(
                                                          // fontSize: size.iScreen(2.45),
                                                          color: Colors.grey,
                                                          fontWeight:
                                                              FontWeight.normal),
                                                      overflow: TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                  // SizedBox(
                                                  //   width: size.wScreen(40.0),
                                                  //   child: Text(
                                                  //     '${_prefacturas['cajaTipoCaja']}',
                                                  //     style: GoogleFonts.lexendDeca(
                                                  //         // fontSize: size.iScreen(2.45),
                                                  //         color: _prefacturas['cajaTipoCaja']=='CREDITO'?Colors.orange:Colors.black,
                                                  //         fontWeight:
                                                  //             FontWeight.bold),
                                                  //     overflow: TextOverflow.ellipsis,
                                                  //   ),
                                                  // ),
                                                    Container(
                                                          // color: Colors.green,
                                                          // width: size.wScreen(50.0),
                                                          child: Text(
                                                            '${_prefacturas['cajaTipoDocumento']}',
                                                            style:
                                                                GoogleFonts.lexendDeca(
                                                                    fontSize: size
                                                                        .iScreen(1.5),
                                                                    color:_prefacturas['cajaTipoDocumento']=='INGRESO'?Colors.green:_prefacturas['cajaTipoDocumento']=='EGRESO'?Colors.orange:Colors.black,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                            overflow:
                                                                TextOverflow.ellipsis,
                                                          ),
                                                  ),
                                                ],
                                              ),
                                              // Text(
                                              //   // '${_prefacturas['cajaEstado']}',
                                              //   // 'Estado: ',
                                              //   style: GoogleFonts.lexendDeca(
                                              //       fontSize: size.iScreen(1.5),
                                              //       color: _color,
                                              //       fontWeight: FontWeight.bold),
                                              // ),
                                              Text(
                                                      '${_prefacturas['cajaTipoCaja']}',
                                                      style: GoogleFonts.lexendDeca(
                                                          // fontSize: size.iScreen(2.45),
                                                          color: _prefacturas['cajaTipoCaja']=='EFECTIVO'?Colors.blue:Colors.orange,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                      overflow: TextOverflow.ellipsis,
                                                    ),
                                            ],
                                          ),
                                          subtitle: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  //  Container(
                                                  //   // color: Colors.red,
                                                  //   width: size.wScreen(70.0),
                                                  //    child: Row(
                                                  //      children: [
                                                  //       Container(
                                                  //         // color: Colors.green,
                                                         
                                                  //         child: Text(
                                                  //           'Documento : ',
                                                  //           style:
                                                  //               GoogleFonts.lexendDeca(
                                                  //                   fontSize: size
                                                  //                       .iScreen(1.5),
                                                  //                   color:
                                                  //                       Colors.grey,
                                                  //                   fontWeight:
                                                  //                       FontWeight
                                                  //                           .normal),
                                                  //           overflow:
                                                  //               TextOverflow.ellipsis,
                                                  //         ),
                                                          
                                                  // ),
                                                  //        Container(
                                                  //         // color: Colors.green,
                                                  //         // width: size.wScreen(50.0),
                                                  //         child: Text(
                                                  //           '${_prefacturas['cajaTipoDocumento']}',
                                                  //           style:
                                                  //               GoogleFonts.lexendDeca(
                                                  //                   fontSize: size
                                                  //                       .iScreen(1.5),
                                                  //                   color:_prefacturas['cajaTipoDocumento']=='INGRESO'?Colors.green:_prefacturas['cajaTipoDocumento']=='EGRESO'?Colors.orange:Colors.black,
                                                  //                   fontWeight:
                                                  //                       FontWeight
                                                  //                           .bold),
                                                  //           overflow:
                                                  //               TextOverflow.ellipsis,
                                                  //         ),
                                                  // ),
                                                  //      ],
                                                  //    ),
                                                  //  ),
                                                  Container(
                                                    // color: Colors.green,
                                                    width: size.wScreen(70.0),
                                                    child: Text(
                                                      '${_prefacturas['cajaNumero']}',
                                                      style:
                                                          GoogleFonts.lexendDeca(
                                                              fontSize: size
                                                                  .iScreen(1.5),
                                                              // color:
                                                              //     Colors.black54,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                  Column(
                                                    children: [
                                                      Container(
                                                        // color: Colors.green,
                                                        width: size.wScreen(70.0),
                                                        child: Text(
                                                          fechaLocal !=
                                                                  ''
                                                              ? fechaLocal
                                                              : '--- --- ---',
                                                          style:
                                                              GoogleFonts.lexendDeca(
                                                                  // fontSize: size.iScreen(2.45),
                                                                  color: Colors.grey,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                    Container(
                                                    // color: Colors.green,
                                                    width: size.wScreen(70.0),
                                                    child: Row(
                                                      children: [
                                                        Text(
                                                          'Usuario: ',
                                                          style:
                                                              GoogleFonts.lexendDeca(
                                                                  // fontSize: size.iScreen(1.9),
                                                                  color: Colors.grey,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                        ),
                                                        Text(
                                                           _prefacturas['cajaUser']!=null
                                                           ?'${_prefacturas['cajaUser']}':'--- --- --- --- --- ---  ',
                                                          style:
                                                              GoogleFonts.lexendDeca(
                                                                  // fontSize: size.iScreen(1.8),
                                                                  // color: Colors.grey,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Container(
                                                // color: Colors.green,
                                                // width: size.wScreen(100.0),
                                                child: Text(
                                                  _prefacturas['cajaTipoCaja']=='CREDITO' || _prefacturas['cajaTipoCaja']=='TRANSFERENCIA'?' \$${_prefacturas['cajaCredito']}':' \$${_prefacturas['cajaMonto']}',
                                                  style: GoogleFonts.lexendDeca(
                                                      fontSize: size.iScreen(2.0),
                                                      color: Colors.black87,
                                                      fontWeight:
                                                          FontWeight.normal),
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ],
                                          ),
                                          // trailing: Icon(Icons.more_vert),
                                        ),
                                      ),
                                    ),
                                  ):Container();
                                } else {
                                  return Consumer<PreFacturasController>(
                                    builder: (_, valueNext, __) {
                                      return valueNext.getpage == null
                                          ? Container(
                                              margin: EdgeInsets.symmetric(
                                                  vertical: size.iScreen(2.0)),
                                              child: Center(
                                                child: Text(
                                                  'No existen más datos',
                                                  style: GoogleFonts.lexendDeca(
                                                      fontSize: size.iScreen(1.8),
                                                      // color: primaryColor,
                                                      fontWeight:
                                                          FontWeight.normal),
                                                ),
                                              ))
                                          // : Container();
                          
                                          : provider.allItemsFilters.length > 25
                                              ? Container(
                                                  margin: EdgeInsets.symmetric(
                                                      vertical:
                                                          size.iScreen(2.0)),
                                                  child: const Center(
                                                      child:
                                                          CircularProgressIndicator()))
                                              : Container();
                                    },
                                  );
                                }
                              },
                            ),
                          ): const NoData(
                              label: 'No existen datos para mostar',
                            );


                          
                          // ListView.builder(
                          //   itemCount: provider.allItemsFilters.length,
                          //   itemBuilder: (BuildContext context, int index) {
                          //     final producto =
                          //         provider.allItemsFilters[index];
                          //     return 
                          //    RefreshIndicator(
                          //    onRefresh: () => onRefresh(),
                          //   child: ListView.builder(
                          //     controller: _scrollController,
                          //     physics: const BouncingScrollPhysics(),
                          //     itemCount: provider
                          //             .allItemsFilters.length +
                          //         1,
                          //     itemBuilder: (BuildContext context, int index) {
                          //       if (index <
                          //           provider
                          //               .allItemsFilters.length) {
                          //         var _color;
                          //         final _prefacturas = provider
                          //             .allItemsFilters[index];
                          
                          //         if (_prefacturas['cajaEstado'] == 'AUTORIZADO') {
                          //           _color = Colors.green;
                          //         } else if (_prefacturas['cajaEstado'] ==
                          //             'SIN AUTORIZAR') {
                          //           _color = Colors.orange;
                          //         }
                          //         if (_prefacturas['cajaEstado'] == 'ANULADA') {
                          //           _color = Colors.red;
                          //         }
                          
                          //         return Slidable(
                          //           startActionPane: ActionPane(
                          //             // A motion is a widget used to control how the pane animates.
                          //             motion: const ScrollMotion(),
                          
                          //             children: [
                          //               SlidableAction(
                          //                     backgroundColor: Colors.grey,
                          //                 foregroundColor: Colors.white,
                          //                 icon: Icons.list_alt_outlined,
                          //                 label: 'Más acciones',
                          //                 onPressed: (context) {
                          //                   showCupertinoModalPopup(
                          //                     context: context,
                          //                     builder: (BuildContext context) =>
                          //                         CupertinoActionSheet(
                          //                             title: Text(
                          //                               'Acciones',
                          //                               style: GoogleFonts
                          //                                   .lexendDeca(
                          //                                       fontSize: size
                          //                                           .iScreen(2.0),
                          //                                       color:
                          //                                           primaryColor,
                          //                                       fontWeight:
                          //                                           FontWeight
                          //                                               .normal),
                          //                             ),
                          //                             // message: const Text('Your options are '),
                          //                             actions: <Widget>[
                          //                               CupertinoActionSheetAction(
                          //                                 child: Row(
                          //                                   mainAxisAlignment:
                          //                                       MainAxisAlignment
                          //                                           .center,
                          //                                   children: [
                          //                                     Container(
                          //                                       margin: EdgeInsets.only(
                          //                                           right: size
                          //                                               .iScreen(
                          //                                                   2.0)),
                          //                                       child: Text(
                          //                                         'Ver PDF',
                          //                                         style: GoogleFonts.lexendDeca(
                          //                                             fontSize: size
                          //                                                 .iScreen(
                          //                                                     1.8),
                          //                                             color: Colors
                          //                                                 .black87,
                          //                                             fontWeight:
                          //                                                 FontWeight
                          //                                                     .normal),
                          //                                       ),
                          //                                     ),
                          //                                     const Icon(
                          //                                       FontAwesomeIcons
                          //                                           .filePdf,
                          //                                       color: Colors.red,
                          //                                     )
                          //                                   ],
                          //                                 ),
                          //                                 onPressed: () {
                          //                                   Navigator.pop(
                          //                                       context);
                          
                          //                                   Navigator.push(
                          //                                     context,
                          //                                     MaterialPageRoute(
                          //                                         builder: (context) =>
                          //                                             ViewsPDFs(
                          //                                                 infoPdf:
                          //                                                     // 'https://sysvet.neitor.com/reportes/carnet.php?id=${factura['venId']}&empresa=${_usuario!.rucempresa}',
                          //                                                     'https://syscontable.neitor.com/reportes/factura.php?codigo=${_prefacturas['venId']}&empresa=${_usuario!.rucempresa}',
                          //                                                 labelPdf:
                          //                                                     'infoFactura.pdf')),
                          //                                   );
                          //                                 },
                          //                               ),
                          //                             ],
                          //                             cancelButton:
                          //                                 CupertinoActionSheetAction(
                          //                               child: Text('Cancel',
                          //                                   style: GoogleFonts
                          //                                       .lexendDeca(
                          //                                           fontSize: size
                          //                                               .iScreen(
                          //                                                   2.0),
                          //                                           color: Colors
                          //                                               .red,
                          //                                           fontWeight:
                          //                                               FontWeight
                          //                                                   .normal)),
                          //                               isDefaultAction: true,
                          //                               onPressed: () {
                          //                                 Navigator.pop(
                          //                                     context, 'Cancel');
                          //                               },
                          //                             )),
                          //                   );
                          //                 },
                          //               ),
                          //             ],
                          //           ),
                          //           child: Card(
                          //             elevation: 5,
                          //             child: Container(
                          //               margin: EdgeInsets.only(
                          //                   bottom: size.iScreen(0.0)),
                          //               color: index % 2 == 0
                          //                   ? Colors.grey.shade50
                          //                   : Colors.grey.shade200,
                          //               child: ListTile(
                          //                 dense: true,
                          //                 visualDensity:
                          //                     VisualDensity.comfortable,
                                      
                          //                  leading: CircleAvatar(
                          //                   child: Text(
                          //                      '${_prefacturas['venNomCliente'].substring(0, 1)}',
                          //                     style: Theme.of(context)
                          //                         .textTheme
                          //                         .subtitle1,
                          //                   ),
                          //                   backgroundColor: Colors.grey[300],
                          //                 ),
                          //                 title: Row(
                          //                   mainAxisAlignment:
                          //                       MainAxisAlignment.spaceBetween,
                          //                   children: [
                          //                     SizedBox(
                          //                       width: size.wScreen(40.0),
                          //                       child: Text(
                          //                         '${_prefacturas['venNomCliente']}',
                          //                         style: GoogleFonts.lexendDeca(
                          //                             // fontSize: size.iScreen(2.45),
                          //                             // color: Colors.white,
                          //                             fontWeight:
                          //                                 FontWeight.normal),
                          //                         overflow: TextOverflow.ellipsis,
                          //                       ),
                          //                     ),
                          //                     Text(
                          //                       '${_prefacturas['cajaEstado']}',
                          //                       // 'Estado: ',
                          //                       style: GoogleFonts.lexendDeca(
                          //                           fontSize: size.iScreen(1.5),
                          //                           color: _color,
                          //                           fontWeight: FontWeight.bold),
                          //                     ),
                          //                   ],
                          //                 ),
                          //                 subtitle: Row(
                          //                   mainAxisAlignment:
                          //                       MainAxisAlignment.spaceBetween,
                          //                   children: [
                          //                     Column(
                          //                       mainAxisAlignment:
                          //                           MainAxisAlignment.start,
                          //                       children: [
                          //                         Container(
                          //                           // color: Colors.green,
                          //                           width: size.wScreen(50.0),
                          //                           child: Text(
                          //                             '${_prefacturas['venNumFactura']}',
                          //                             style:
                          //                                 GoogleFonts.lexendDeca(
                          //                                     fontSize: size
                          //                                         .iScreen(1.5),
                          //                                     color:
                          //                                         Colors.black54,
                          //                                     fontWeight:
                          //                                         FontWeight
                          //                                             .normal),
                          //                             overflow:
                          //                                 TextOverflow.ellipsis,
                          //                           ),
                          //                         ),
                          //                         Container(
                          //                           // color: Colors.green,
                          //                           width: size.wScreen(50.0),
                          //                           child: Text(
                          //                             _prefacturas['venFecReg'] !=
                          //                                     ''
                          //                                 ? '${_prefacturas['venFecReg'].replaceAll('T', "  ").replaceAll('.000Z', "  ")}'
                          //                                 : '--- --- ---',
                          //                             style:
                          //                                 GoogleFonts.lexendDeca(
                          //                                     // fontSize: size.iScreen(2.45),
                          //                                     color: Colors.grey,
                          //                                     fontWeight:
                          //                                         FontWeight
                          //                                             .normal),
                          //                           ),
                          //                         ),
                          //                       ],
                          //                     ),
                          //                     Container(
                          //                       // color: Colors.green,
                          //                       // width: size.wScreen(100.0),
                          //                       child: Text(
                          //                         '\$${_prefacturas['venTotal']}',
                          //                         style: GoogleFonts.lexendDeca(
                          //                             fontSize: size.iScreen(2.0),
                          //                             color: Colors.black87,
                          //                             fontWeight:
                          //                                 FontWeight.normal),
                          //                         overflow: TextOverflow.ellipsis,
                          //                       ),
                          //                     ),
                          //                   ],
                          //                 ),
                          //                 // trailing: Icon(Icons.more_vert),
                          //               ),
                          //             ),
                          //           ),
                          //         );
                          //       } else {
                          //         return Consumer<PreFacturasController>(
                          //           builder: (_, valueNext, __) {
                          //             return valueNext.getpage == null
                          //                 ? Container(
                          //                     margin: EdgeInsets.symmetric(
                          //                         vertical: size.iScreen(2.0)),
                          //                     child: Center(
                          //                       child: Text(
                          //                         'No existen más datos',
                          //                         style: GoogleFonts.lexendDeca(
                          //                             fontSize: size.iScreen(1.8),
                          //                             // color: primaryColor,
                          //                             fontWeight:
                          //                                 FontWeight.normal),
                          //                       ),
                          //                     ))
                          //                 // : Container();
                          
                          //                 : provider.allItemsFilters.length > 25
                          //                     ? Container(
                          //                         margin: EdgeInsets.symmetric(
                          //                             vertical:
                          //                                 size.iScreen(2.0)),
                          //                         child: const Center(
                          //                             child:
                          //                                 CircularProgressIndicator()))
                          //                     : Container();
                          //           },
                          //         );
                          //       }
                          //     },
                          //   ),
                          // );





                              
                          //   },
                          // ) : const NoData(
                          //     label: 'No existen datos para mostar',
                          //   );
                        },
                      ),
  




//  Consumer<CajaController>(
//                         builder: (_, provider, __) {
                         
//                          if (provider.allItemsFilters.isEmpty) {
//                             return const NoData(
//                               label: 'No existen datos para mostar',
//                             );
//                             // Text("sin datos");
//                           }

//                           return 
                          
//                           (provider.allItemsFilters.isEmpty)
//                                         ? Center(
//                                             child: Column(
//                                               mainAxisAlignment: MainAxisAlignment.center,
//                                             children: [
                                              
//                                               CircularProgressIndicator(),
//                                               Text('Por favor espere ....')
//                                             ],
//                                           ))
//                                         : (provider.allItemsFilters.length > 0)
//                                             ?
//                            RefreshIndicator(
//                              onRefresh: () => onRefresh(),
//                             child: 
//                             ListView.builder(
//                               controller: _scrollController,
//                               physics: const BouncingScrollPhysics(),
//                               itemCount: provider
//                                       .allItemsFilters.length +
//                                   1,
//                               itemBuilder: (BuildContext context, int index) {
//                                 if (index <
//                                     provider
//                                         .allItemsFilters.length) {
//                                   var _color;
//                                   final _prefacturas = provider
//                                       .allItemsFilters[index];
                          
//                                   if (_prefacturas['cajaEstado'] == 'AUTORIZADO') {
//                                     _color = Colors.green;
//                                   } else if (_prefacturas['cajaEstado'] ==
//                                       'SIN AUTORIZAR') {
//                                     _color = Colors.orange;
//                                   }
//                                   if (_prefacturas['cajaEstado'] == 'ANULADA') {
//                                     _color = Colors.red;
//                                   }
//  //==============================================//
//   String fechaLocal = convertirFechaLocal(_prefacturas['cajaFecReg']);
//  //==============================================//
//                                   return 
//                                   _prefacturas['cajaEstado'] != 'ANULADA'?
//                                   Slidable(
//                                     startActionPane: ActionPane(
//                                       // A motion is a widget used to control how the pane animates.
//                                       motion: const ScrollMotion(),
                          
//                                       children: [
//                                         SlidableAction(
//                                               backgroundColor: Colors.grey,
//                                           foregroundColor: Colors.white,
//                                           icon: Icons.list_alt_outlined,
//                                           label: 'Más acciones',
//                                           onPressed: (context) {
//                                             showCupertinoModalPopup(
//                                               context: context,
//                                               builder: (BuildContext context) =>
//                                                   CupertinoActionSheet(
//                                                       title: Text(
//                                                         'Acciones',
//                                                         style: GoogleFonts
//                                                             .lexendDeca(
//                                                                 fontSize: size
//                                                                     .iScreen(2.0),
//                                                                 color:
//                                                                     primaryColor,
//                                                                 fontWeight:
//                                                                     FontWeight
//                                                                         .normal),
//                                                       ),
//                                                       // message: const Text('Your options are '),
//                                                       actions: <Widget>[
//                                                                CupertinoActionSheetAction(
//                                                           child: Row(
//                                                             mainAxisAlignment:
//                                                                 MainAxisAlignment
//                                                                     .center,
//                                                             children: [
//                                                               Container(
//                                                                 margin: EdgeInsets.only(
//                                                                     right: size
//                                                                         .iScreen(
//                                                                             2.0)),
//                                                                 child: Text(
//                                                                   'Imprimir',
//                                                                   style: GoogleFonts.lexendDeca(
//                                                                       fontSize: size
//                                                                           .iScreen(
//                                                                               1.8),
//                                                                       color: Colors
//                                                                           .black87,
//                                                                       fontWeight:
//                                                                           FontWeight
//                                                                               .normal),
//                                                                 ),
//                                                               ),
//                                                               const Icon(
//                                                                 FontAwesomeIcons
//                                                                     .print,
//                                                                 color: Colors.green,
//                                                               )
//                                                             ],
//                                                           ),
//                                                           onPressed: () {
//                                                             Navigator.pop(
//                                                                 context);
//                                                                 _printTicket(_prefacturas,widget.user!.logo);

                                                           
//                                                           },
//                                                         ),
//                                                                 CupertinoActionSheetAction(
//                                                           child: Row(
//                                                             mainAxisAlignment:
//                                                                 MainAxisAlignment
//                                                                     .center,
//                                                             children: [
//                                                               Container(
//                                                                 margin: EdgeInsets.only(
//                                                                     right: size
//                                                                         .iScreen(
//                                                                             2.0)),
//                                                                 child: Text(
//                                                                   'Ver Detalle',
//                                                                   style: GoogleFonts.lexendDeca(
//                                                                       fontSize: size
//                                                                           .iScreen(
//                                                                               1.8),
//                                                                       color: Colors
//                                                                           .black87,
//                                                                       fontWeight:
//                                                                           FontWeight
//                                                                               .normal),
//                                                                 ),
//                                                               ),
//                                                               const Icon(
//                                                                 FontAwesomeIcons
//                                                                     .infoCircle,
//                                                                 color: Colors.blue,
//                                                               )
//                                                             ],
//                                                           ),
//                                                           onPressed: () {
//                                                             provider.setInfoCaja(_prefacturas);
//                                                             Navigator.pop(
//                                                                 context);
                          
//                                                             Navigator.push(
//                                                               context,
//                                                               MaterialPageRoute(
//                                                                   builder: (context) =>
//                                                                      DetalleCaja()),
//                                                             );
//                                                           },
//                                                         ),
//                                                         // CupertinoActionSheetAction(
//                                                         //   child: Row(
//                                                         //     mainAxisAlignment:
//                                                         //         MainAxisAlignment
//                                                         //             .center,
//                                                         //     children: [
//                                                         //       Container(
//                                                         //         margin: EdgeInsets.only(
//                                                         //             right: size
//                                                         //                 .iScreen(
//                                                         //                     2.0)),
//                                                         //         child: Text(
//                                                         //           'Ver PDF',
//                                                         //           style: GoogleFonts.lexendDeca(
//                                                         //               fontSize: size
//                                                         //                   .iScreen(
//                                                         //                       1.8),
//                                                         //               color: Colors
//                                                         //                   .black87,
//                                                         //               fontWeight:
//                                                         //                   FontWeight
//                                                         //                       .normal),
//                                                         //         ),
//                                                         //       ),
//                                                         //       const Icon(
//                                                         //         FontAwesomeIcons
//                                                         //             .filePdf,
//                                                         //         color: Colors.red,
//                                                         //       )
//                                                         //     ],
//                                                         //   ),
//                                                         //   onPressed: () {
//                                                         //     Navigator.pop(
//                                                         //         context);
                          
//                                                         //     Navigator.push(
//                                                         //       context,
//                                                         //       MaterialPageRoute(
//                                                         //           builder: (context) =>
//                                                         //               ViewsPDFs(
//                                                         //                   infoPdf:
//                                                         //                       // 'https://sysvet.neitor.com/reportes/carnet.php?id=${factura['venId']}&empresa=${_usuario!.rucempresa}',
//                                                         //                       'https://syscontable.neitor.com/reportes/factura.php?codigo=${_prefacturas['venId']}&empresa=${_usuario!.rucempresa}',
//                                                         //                   labelPdf:
//                                                         //                       'infoFactura.pdf')),
//                                                         //     );
//                                                         //   },
//                                                         // ),
                                                     
                                                     
                                                     
//                                                       ],
//                                                       cancelButton:
//                                                           CupertinoActionSheetAction(
//                                                         child: Text('Cancel',
//                                                             style: GoogleFonts
//                                                                 .lexendDeca(
//                                                                     fontSize: size
//                                                                         .iScreen(
//                                                                             2.0),
//                                                                     color: Colors
//                                                                         .red,
//                                                                     fontWeight:
//                                                                         FontWeight
//                                                                             .normal)),
//                                                         isDefaultAction: true,
//                                                         onPressed: () {
//                                                           Navigator.pop(
//                                                               context, 'Cancel');
//                                                         },
//                                                       )),
//                                             );
//                                           },
//                                         ),
//                                       ],
//                                     ),
//                                     child: Card(
//                                       elevation: 5,
//                                       child: Container(
//                                         margin: EdgeInsets.only(
//                                             bottom: size.iScreen(0.0)),
//                                         color: index % 2 == 0
//                                             ? Colors.grey.shade50
//                                             : Colors.grey.shade200,
//                                         child: ListTile(
//                                           dense: true,
//                                           visualDensity:
//                                               VisualDensity.comfortable,
                                      
//                                           //  leading: CircleAvatar(
//                                           //   child: Text(
//                                           //      '${_prefacturas['venNomCliente'].substring(0, 1)}',
//                                           //     style: Theme.of(context)
//                                           //         .textTheme
//                                           //         .subtitle1,
//                                           //   ),
//                                           //   backgroundColor: Colors.grey[300],
//                                           // ),
//                                           title: Row(
//                                             mainAxisAlignment:
//                                                 MainAxisAlignment.spaceBetween,
//                                             children: [
//                                               Row(
//                                                 children: [
//                                                   SizedBox(
//                                                     // width: size.wScreen(40.0),
//                                                     child: Text(
//                                                       'Documento: ',
//                                                       style: GoogleFonts.lexendDeca(
//                                                           // fontSize: size.iScreen(2.45),
//                                                           color: Colors.grey,
//                                                           fontWeight:
//                                                               FontWeight.normal),
//                                                       overflow: TextOverflow.ellipsis,
//                                                     ),
//                                                   ),
//                                                   // SizedBox(
//                                                   //   width: size.wScreen(40.0),
//                                                   //   child: Text(
//                                                   //     '${_prefacturas['cajaTipoCaja']}',
//                                                   //     style: GoogleFonts.lexendDeca(
//                                                   //         // fontSize: size.iScreen(2.45),
//                                                   //         color: _prefacturas['cajaTipoCaja']=='CREDITO'?Colors.orange:Colors.black,
//                                                   //         fontWeight:
//                                                   //             FontWeight.bold),
//                                                   //     overflow: TextOverflow.ellipsis,
//                                                   //   ),
//                                                   // ),
//                                                     Container(
//                                                           // color: Colors.green,
//                                                           // width: size.wScreen(50.0),
//                                                           child: Text(
//                                                             '${_prefacturas['cajaTipoDocumento']}',
//                                                             style:
//                                                                 GoogleFonts.lexendDeca(
//                                                                     fontSize: size
//                                                                         .iScreen(1.5),
//                                                                     color:_prefacturas['cajaTipoDocumento']=='INGRESO'?Colors.green:_prefacturas['cajaTipoDocumento']=='EGRESO'?Colors.orange:Colors.black,
//                                                                     fontWeight:
//                                                                         FontWeight
//                                                                             .bold),
//                                                             overflow:
//                                                                 TextOverflow.ellipsis,
//                                                           ),
//                                                   ),
//                                                 ],
//                                               ),
//                                               // Text(
//                                               //   // '${_prefacturas['cajaEstado']}',
//                                               //   // 'Estado: ',
//                                               //   style: GoogleFonts.lexendDeca(
//                                               //       fontSize: size.iScreen(1.5),
//                                               //       color: _color,
//                                               //       fontWeight: FontWeight.bold),
//                                               // ),
//                                               Text(
//                                                       '${_prefacturas['cajaTipoCaja']}',
//                                                       style: GoogleFonts.lexendDeca(
//                                                           // fontSize: size.iScreen(2.45),
//                                                           color: _prefacturas['cajaTipoCaja']=='EFECTIVO'?Colors.blue:Colors.orange,
//                                                           fontWeight:
//                                                               FontWeight.bold),
//                                                       overflow: TextOverflow.ellipsis,
//                                                     ),
//                                             ],
//                                           ),
//                                           subtitle: Row(
//                                             mainAxisAlignment:
//                                                 MainAxisAlignment.spaceBetween,
//                                             children: [
//                                               Column(
//                                                 mainAxisAlignment:
//                                                     MainAxisAlignment.start,
//                                                 children: [
//                                                   //  Container(
//                                                   //   // color: Colors.red,
//                                                   //   width: size.wScreen(70.0),
//                                                   //    child: Row(
//                                                   //      children: [
//                                                   //       Container(
//                                                   //         // color: Colors.green,
                                                         
//                                                   //         child: Text(
//                                                   //           'Documento : ',
//                                                   //           style:
//                                                   //               GoogleFonts.lexendDeca(
//                                                   //                   fontSize: size
//                                                   //                       .iScreen(1.5),
//                                                   //                   color:
//                                                   //                       Colors.grey,
//                                                   //                   fontWeight:
//                                                   //                       FontWeight
//                                                   //                           .normal),
//                                                   //           overflow:
//                                                   //               TextOverflow.ellipsis,
//                                                   //         ),
                                                          
//                                                   // ),
//                                                   //        Container(
//                                                   //         // color: Colors.green,
//                                                   //         // width: size.wScreen(50.0),
//                                                   //         child: Text(
//                                                   //           '${_prefacturas['cajaTipoDocumento']}',
//                                                   //           style:
//                                                   //               GoogleFonts.lexendDeca(
//                                                   //                   fontSize: size
//                                                   //                       .iScreen(1.5),
//                                                   //                   color:_prefacturas['cajaTipoDocumento']=='INGRESO'?Colors.green:_prefacturas['cajaTipoDocumento']=='EGRESO'?Colors.orange:Colors.black,
//                                                   //                   fontWeight:
//                                                   //                       FontWeight
//                                                   //                           .bold),
//                                                   //           overflow:
//                                                   //               TextOverflow.ellipsis,
//                                                   //         ),
//                                                   // ),
//                                                   //      ],
//                                                   //    ),
//                                                   //  ),
//                                                   Container(
//                                                     // color: Colors.green,
//                                                     width: size.wScreen(70.0),
//                                                     child: Text(
//                                                       '${_prefacturas['cajaNumero']}',
//                                                       style:
//                                                           GoogleFonts.lexendDeca(
//                                                               fontSize: size
//                                                                   .iScreen(1.5),
//                                                               // color:
//                                                               //     Colors.black54,
//                                                               fontWeight:
//                                                                   FontWeight
//                                                                       .normal),
//                                                       overflow:
//                                                           TextOverflow.ellipsis,
//                                                     ),
//                                                   ),
//                                                   Column(
//                                                     children: [
//                                                       Container(
//                                                         // color: Colors.green,
//                                                         width: size.wScreen(70.0),
//                                                         child: Text(
//                                                           fechaLocal !=
//                                                                   ''
//                                                               ? fechaLocal
//                                                               : '--- --- ---',
//                                                           style:
//                                                               GoogleFonts.lexendDeca(
//                                                                   // fontSize: size.iScreen(2.45),
//                                                                   color: Colors.grey,
//                                                                   fontWeight:
//                                                                       FontWeight
//                                                                           .normal),
//                                                         ),
//                                                       ),
//                                                     ],
//                                                   ),
//                                                     Container(
//                                                     // color: Colors.green,
//                                                     width: size.wScreen(70.0),
//                                                     child: Row(
//                                                       children: [
//                                                         Text(
//                                                           'Usuario: ',
//                                                           style:
//                                                               GoogleFonts.lexendDeca(
//                                                                   // fontSize: size.iScreen(1.9),
//                                                                   color: Colors.grey,
//                                                                   fontWeight:
//                                                                       FontWeight
//                                                                           .bold),
//                                                         ),
//                                                         Text(
//                                                            _prefacturas['cajaUser']!=null
//                                                            ?'${_prefacturas['cajaUser']}':'--- --- --- --- --- ---  ',
//                                                           style:
//                                                               GoogleFonts.lexendDeca(
//                                                                   // fontSize: size.iScreen(1.8),
//                                                                   // color: Colors.grey,
//                                                                   fontWeight:
//                                                                       FontWeight
//                                                                           .bold),
//                                                         ),
//                                                       ],
//                                                     ),
//                                                   ),
//                                                 ],
//                                               ),
//                                               Container(
//                                                 // color: Colors.green,
//                                                 // width: size.wScreen(100.0),
//                                                 child: Text(
//                                                   '\$${_prefacturas['cajaMonto']}',
//                                                   style: GoogleFonts.lexendDeca(
//                                                       fontSize: size.iScreen(2.0),
//                                                       color: Colors.black87,
//                                                       fontWeight:
//                                                           FontWeight.normal),
//                                                   overflow: TextOverflow.ellipsis,
//                                                 ),
//                                               ),
//                                             ],
//                                           ),
//                                           // trailing: Icon(Icons.more_vert),
//                                         ),
//                                       ),
//                                     ),
//                                   ):Container();
//                                 } else {
//                                   return Consumer<PreFacturasController>(
//                                     builder: (_, valueNext, __) {
//                                       return valueNext.getpage == null
//                                           ? Container(
//                                               margin: EdgeInsets.symmetric(
//                                                   vertical: size.iScreen(2.0)),
//                                               child: Center(
//                                                 child: Text(
//                                                   'No existen más datos',
//                                                   style: GoogleFonts.lexendDeca(
//                                                       fontSize: size.iScreen(1.8),
//                                                       // color: primaryColor,
//                                                       fontWeight:
//                                                           FontWeight.normal),
//                                                 ),
//                                               ))
//                                           // : Container();
                          
//                                           : provider.allItemsFilters.length > 25
//                                               ? Container(
//                                                   margin: EdgeInsets.symmetric(
//                                                       vertical:
//                                                           size.iScreen(2.0)),
//                                                   child: const Center(
//                                                       child:
//                                                           CircularProgressIndicator()))
//                                               : Container();
//                                     },
//                                   );
//                                 }
//                               },
//                             ),
//                           ): const NoData(
//                               label: 'No existen datos para mostar',
//                             );


                          
//                           // ListView.builder(
//                           //   itemCount: provider.allItemsFilters.length,
//                           //   itemBuilder: (BuildContext context, int index) {
//                           //     final producto =
//                           //         provider.allItemsFilters[index];
//                           //     return 
//                           //    RefreshIndicator(
//                           //    onRefresh: () => onRefresh(),
//                           //   child: ListView.builder(
//                           //     controller: _scrollController,
//                           //     physics: const BouncingScrollPhysics(),
//                           //     itemCount: provider
//                           //             .allItemsFilters.length +
//                           //         1,
//                           //     itemBuilder: (BuildContext context, int index) {
//                           //       if (index <
//                           //           provider
//                           //               .allItemsFilters.length) {
//                           //         var _color;
//                           //         final _prefacturas = provider
//                           //             .allItemsFilters[index];
                          
//                           //         if (_prefacturas['cajaEstado'] == 'AUTORIZADO') {
//                           //           _color = Colors.green;
//                           //         } else if (_prefacturas['cajaEstado'] ==
//                           //             'SIN AUTORIZAR') {
//                           //           _color = Colors.orange;
//                           //         }
//                           //         if (_prefacturas['cajaEstado'] == 'ANULADA') {
//                           //           _color = Colors.red;
//                           //         }
                          
//                           //         return Slidable(
//                           //           startActionPane: ActionPane(
//                           //             // A motion is a widget used to control how the pane animates.
//                           //             motion: const ScrollMotion(),
                          
//                           //             children: [
//                           //               SlidableAction(
//                           //                     backgroundColor: Colors.grey,
//                           //                 foregroundColor: Colors.white,
//                           //                 icon: Icons.list_alt_outlined,
//                           //                 label: 'Más acciones',
//                           //                 onPressed: (context) {
//                           //                   showCupertinoModalPopup(
//                           //                     context: context,
//                           //                     builder: (BuildContext context) =>
//                           //                         CupertinoActionSheet(
//                           //                             title: Text(
//                           //                               'Acciones',
//                           //                               style: GoogleFonts
//                           //                                   .lexendDeca(
//                           //                                       fontSize: size
//                           //                                           .iScreen(2.0),
//                           //                                       color:
//                           //                                           primaryColor,
//                           //                                       fontWeight:
//                           //                                           FontWeight
//                           //                                               .normal),
//                           //                             ),
//                           //                             // message: const Text('Your options are '),
//                           //                             actions: <Widget>[
//                           //                               CupertinoActionSheetAction(
//                           //                                 child: Row(
//                           //                                   mainAxisAlignment:
//                           //                                       MainAxisAlignment
//                           //                                           .center,
//                           //                                   children: [
//                           //                                     Container(
//                           //                                       margin: EdgeInsets.only(
//                           //                                           right: size
//                           //                                               .iScreen(
//                           //                                                   2.0)),
//                           //                                       child: Text(
//                           //                                         'Ver PDF',
//                           //                                         style: GoogleFonts.lexendDeca(
//                           //                                             fontSize: size
//                           //                                                 .iScreen(
//                           //                                                     1.8),
//                           //                                             color: Colors
//                           //                                                 .black87,
//                           //                                             fontWeight:
//                           //                                                 FontWeight
//                           //                                                     .normal),
//                           //                                       ),
//                           //                                     ),
//                           //                                     const Icon(
//                           //                                       FontAwesomeIcons
//                           //                                           .filePdf,
//                           //                                       color: Colors.red,
//                           //                                     )
//                           //                                   ],
//                           //                                 ),
//                           //                                 onPressed: () {
//                           //                                   Navigator.pop(
//                           //                                       context);
                          
//                           //                                   Navigator.push(
//                           //                                     context,
//                           //                                     MaterialPageRoute(
//                           //                                         builder: (context) =>
//                           //                                             ViewsPDFs(
//                           //                                                 infoPdf:
//                           //                                                     // 'https://sysvet.neitor.com/reportes/carnet.php?id=${factura['venId']}&empresa=${_usuario!.rucempresa}',
//                           //                                                     'https://syscontable.neitor.com/reportes/factura.php?codigo=${_prefacturas['venId']}&empresa=${_usuario!.rucempresa}',
//                           //                                                 labelPdf:
//                           //                                                     'infoFactura.pdf')),
//                           //                                   );
//                           //                                 },
//                           //                               ),
//                           //                             ],
//                           //                             cancelButton:
//                           //                                 CupertinoActionSheetAction(
//                           //                               child: Text('Cancel',
//                           //                                   style: GoogleFonts
//                           //                                       .lexendDeca(
//                           //                                           fontSize: size
//                           //                                               .iScreen(
//                           //                                                   2.0),
//                           //                                           color: Colors
//                           //                                               .red,
//                           //                                           fontWeight:
//                           //                                               FontWeight
//                           //                                                   .normal)),
//                           //                               isDefaultAction: true,
//                           //                               onPressed: () {
//                           //                                 Navigator.pop(
//                           //                                     context, 'Cancel');
//                           //                               },
//                           //                             )),
//                           //                   );
//                           //                 },
//                           //               ),
//                           //             ],
//                           //           ),
//                           //           child: Card(
//                           //             elevation: 5,
//                           //             child: Container(
//                           //               margin: EdgeInsets.only(
//                           //                   bottom: size.iScreen(0.0)),
//                           //               color: index % 2 == 0
//                           //                   ? Colors.grey.shade50
//                           //                   : Colors.grey.shade200,
//                           //               child: ListTile(
//                           //                 dense: true,
//                           //                 visualDensity:
//                           //                     VisualDensity.comfortable,
                                      
//                           //                  leading: CircleAvatar(
//                           //                   child: Text(
//                           //                      '${_prefacturas['venNomCliente'].substring(0, 1)}',
//                           //                     style: Theme.of(context)
//                           //                         .textTheme
//                           //                         .subtitle1,
//                           //                   ),
//                           //                   backgroundColor: Colors.grey[300],
//                           //                 ),
//                           //                 title: Row(
//                           //                   mainAxisAlignment:
//                           //                       MainAxisAlignment.spaceBetween,
//                           //                   children: [
//                           //                     SizedBox(
//                           //                       width: size.wScreen(40.0),
//                           //                       child: Text(
//                           //                         '${_prefacturas['venNomCliente']}',
//                           //                         style: GoogleFonts.lexendDeca(
//                           //                             // fontSize: size.iScreen(2.45),
//                           //                             // color: Colors.white,
//                           //                             fontWeight:
//                           //                                 FontWeight.normal),
//                           //                         overflow: TextOverflow.ellipsis,
//                           //                       ),
//                           //                     ),
//                           //                     Text(
//                           //                       '${_prefacturas['cajaEstado']}',
//                           //                       // 'Estado: ',
//                           //                       style: GoogleFonts.lexendDeca(
//                           //                           fontSize: size.iScreen(1.5),
//                           //                           color: _color,
//                           //                           fontWeight: FontWeight.bold),
//                           //                     ),
//                           //                   ],
//                           //                 ),
//                           //                 subtitle: Row(
//                           //                   mainAxisAlignment:
//                           //                       MainAxisAlignment.spaceBetween,
//                           //                   children: [
//                           //                     Column(
//                           //                       mainAxisAlignment:
//                           //                           MainAxisAlignment.start,
//                           //                       children: [
//                           //                         Container(
//                           //                           // color: Colors.green,
//                           //                           width: size.wScreen(50.0),
//                           //                           child: Text(
//                           //                             '${_prefacturas['venNumFactura']}',
//                           //                             style:
//                           //                                 GoogleFonts.lexendDeca(
//                           //                                     fontSize: size
//                           //                                         .iScreen(1.5),
//                           //                                     color:
//                           //                                         Colors.black54,
//                           //                                     fontWeight:
//                           //                                         FontWeight
//                           //                                             .normal),
//                           //                             overflow:
//                           //                                 TextOverflow.ellipsis,
//                           //                           ),
//                           //                         ),
//                           //                         Container(
//                           //                           // color: Colors.green,
//                           //                           width: size.wScreen(50.0),
//                           //                           child: Text(
//                           //                             _prefacturas['venFecReg'] !=
//                           //                                     ''
//                           //                                 ? '${_prefacturas['venFecReg'].replaceAll('T', "  ").replaceAll('.000Z', "  ")}'
//                           //                                 : '--- --- ---',
//                           //                             style:
//                           //                                 GoogleFonts.lexendDeca(
//                           //                                     // fontSize: size.iScreen(2.45),
//                           //                                     color: Colors.grey,
//                           //                                     fontWeight:
//                           //                                         FontWeight
//                           //                                             .normal),
//                           //                           ),
//                           //                         ),
//                           //                       ],
//                           //                     ),
//                           //                     Container(
//                           //                       // color: Colors.green,
//                           //                       // width: size.wScreen(100.0),
//                           //                       child: Text(
//                           //                         '\$${_prefacturas['venTotal']}',
//                           //                         style: GoogleFonts.lexendDeca(
//                           //                             fontSize: size.iScreen(2.0),
//                           //                             color: Colors.black87,
//                           //                             fontWeight:
//                           //                                 FontWeight.normal),
//                           //                         overflow: TextOverflow.ellipsis,
//                           //                       ),
//                           //                     ),
//                           //                   ],
//                           //                 ),
//                           //                 // trailing: Icon(Icons.more_vert),
//                           //               ),
//                           //             ),
//                           //           ),
//                           //         );
//                           //       } else {
//                           //         return Consumer<PreFacturasController>(
//                           //           builder: (_, valueNext, __) {
//                           //             return valueNext.getpage == null
//                           //                 ? Container(
//                           //                     margin: EdgeInsets.symmetric(
//                           //                         vertical: size.iScreen(2.0)),
//                           //                     child: Center(
//                           //                       child: Text(
//                           //                         'No existen más datos',
//                           //                         style: GoogleFonts.lexendDeca(
//                           //                             fontSize: size.iScreen(1.8),
//                           //                             // color: primaryColor,
//                           //                             fontWeight:
//                           //                                 FontWeight.normal),
//                           //                       ),
//                           //                     ))
//                           //                 // : Container();
                          
//                           //                 : provider.allItemsFilters.length > 25
//                           //                     ? Container(
//                           //                         margin: EdgeInsets.symmetric(
//                           //                             vertical:
//                           //                                 size.iScreen(2.0)),
//                           //                         child: const Center(
//                           //                             child:
//                           //                                 CircularProgressIndicator()))
//                           //                     : Container();
//                           //           },
//                           //         );
//                           //       }
//                           //     },
//                           //   ),
//                           // );





                              
//                           //   },
//                           // ) : const NoData(
//                           //     label: 'No existen datos para mostar',
//                           //   );
//                         },
//                       ),
  
//   Consumer<CajaController>(
//                         builder: (_, provider, __) {
                         
//                          if (provider.allItemsFilters.isEmpty) {
//                             return const NoData(
//                               label: 'No existen datos para mostar',
//                             );
//                             // Text("sin datos");
//                           }

//                           return 
                          
//                           (provider.allItemsFilters.isEmpty)
//                                         ? Center(
//                                             child: Column(
//                                               mainAxisAlignment: MainAxisAlignment.center,
//                                             children: [
                                              
//                                               CircularProgressIndicator(),
//                                               Text('Por favor espere ....')
//                                             ],
//                                           ))
//                                         : (provider.allItemsFilters.length > 0)
//                                             ?
//                            RefreshIndicator(
//                              onRefresh: () => onRefresh(),
//                             child: ListView.builder(
//                               controller: _scrollController,
//                               physics: const BouncingScrollPhysics(),
//                               itemCount: provider
//                                       .allItemsFilters.length +
//                                   1,
//                               itemBuilder: (BuildContext context, int index) {
//                                 if (index <
//                                     provider
//                                         .allItemsFilters.length) {
//                                   var _color;
//                                   final _prefacturas = provider
//                                       .allItemsFilters[index];
                          
//                                   if (_prefacturas['cajaEstado'] == 'AUTORIZADO') {
//                                     _color = Colors.green;
//                                   } else if (_prefacturas['cajaEstado'] ==
//                                       'SIN AUTORIZAR') {
//                                     _color = Colors.orange;
//                                   }
//                                   if (_prefacturas['cajaEstado'] == 'ANULADA') {
//                                     _color = Colors.red;
//                                   }
//  //==============================================//
//   String fechaLocal = convertirFechaLocal(_prefacturas['cajaFecReg']);
//  //==============================================//
//                                   return Slidable(
//                                     startActionPane: ActionPane(
//                                       // A motion is a widget used to control how the pane animates.
//                                       motion: const ScrollMotion(),
                          
//                                       children: [
//                                         SlidableAction(
//                                               backgroundColor: Colors.grey,
//                                           foregroundColor: Colors.white,
//                                           icon: Icons.list_alt_outlined,
//                                           label: 'Más acciones',
//                                           onPressed: (context) {
//                                             showCupertinoModalPopup(
//                                               context: context,
//                                               builder: (BuildContext context) =>
//                                                   CupertinoActionSheet(
//                                                       title: Text(
//                                                         'Acciones',
//                                                         style: GoogleFonts
//                                                             .lexendDeca(
//                                                                 fontSize: size
//                                                                     .iScreen(2.0),
//                                                                 color:
//                                                                     primaryColor,
//                                                                 fontWeight:
//                                                                     FontWeight
//                                                                         .normal),
//                                                       ),
//                                                       // message: const Text('Your options are '),
//                                                       actions: <Widget>[
//                                                         CupertinoActionSheetAction(
//                                                           child: Row(
//                                                             mainAxisAlignment:
//                                                                 MainAxisAlignment
//                                                                     .center,
//                                                             children: [
//                                                               Container(
//                                                                 margin: EdgeInsets.only(
//                                                                     right: size
//                                                                         .iScreen(
//                                                                             2.0)),
//                                                                 child: Text(
//                                                                   'Imprimir',
//                                                                   style: GoogleFonts.lexendDeca(
//                                                                       fontSize: size
//                                                                           .iScreen(
//                                                                               1.8),
//                                                                       color: Colors
//                                                                           .black87,
//                                                                       fontWeight:
//                                                                           FontWeight
//                                                                               .normal),
//                                                                 ),
//                                                               ),
//                                                               const Icon(
//                                                                 FontAwesomeIcons
//                                                                     .print,
//                                                                 color: Colors.green,
//                                                               )
//                                                             ],
//                                                           ),
//                                                           onPressed: () {
//                                                             Navigator.pop(
//                                                                 context);
//                                                                 _printTicket(_prefacturas,widget.user!.logo);

                                                           
//                                                           },
//                                                         ),
//                                                                  CupertinoActionSheetAction(
//                                                           child: Row(
//                                                             mainAxisAlignment:
//                                                                 MainAxisAlignment
//                                                                     .center,
//                                                             children: [
//                                                               Container(
//                                                                 margin: EdgeInsets.only(
//                                                                     right: size
//                                                                         .iScreen(
//                                                                             2.0)),
//                                                                 child: Text(
//                                                                   'Ver Detalle',
//                                                                   style: GoogleFonts.lexendDeca(
//                                                                       fontSize: size
//                                                                           .iScreen(
//                                                                               1.8),
//                                                                       color: Colors
//                                                                           .black87,
//                                                                       fontWeight:
//                                                                           FontWeight
//                                                                               .normal),
//                                                                 ),
//                                                               ),
//                                                               const Icon(
//                                                                 FontAwesomeIcons
//                                                                     .infoCircle,
//                                                                 color: Colors.blue,
//                                                               )
//                                                             ],
//                                                           ),
//                                                           onPressed: () {
//                                                             provider.setInfoCaja(_prefacturas);
//                                                             Navigator.pop(
//                                                                 context);
                          
//                                                             Navigator.push(
//                                                               context,
//                                                               MaterialPageRoute(
//                                                                   builder: (context) =>
//                                                                      DetalleCaja()),
//                                                             );
//                                                           },
//                                                         ),
//                                                         // CupertinoActionSheetAction(
//                                                         //   child: Row(
//                                                         //     mainAxisAlignment:
//                                                         //         MainAxisAlignment
//                                                         //             .center,
//                                                         //     children: [
//                                                         //       Container(
//                                                         //         margin: EdgeInsets.only(
//                                                         //             right: size
//                                                         //                 .iScreen(
//                                                         //                     2.0)),
//                                                         //         child: Text(
//                                                         //           'Ver PDF',
//                                                         //           style: GoogleFonts.lexendDeca(
//                                                         //               fontSize: size
//                                                         //                   .iScreen(
//                                                         //                       1.8),
//                                                         //               color: Colors
//                                                         //                   .black87,
//                                                         //               fontWeight:
//                                                         //                   FontWeight
//                                                         //                       .normal),
//                                                         //         ),
//                                                         //       ),
//                                                         //       const Icon(
//                                                         //         FontAwesomeIcons
//                                                         //             .filePdf,
//                                                         //         color: Colors.red,
//                                                         //       )
//                                                         //     ],
//                                                         //   ),
//                                                         //   onPressed: () {
//                                                         //     Navigator.pop(
//                                                         //         context);
                          
//                                                         //     Navigator.push(
//                                                         //       context,
//                                                         //       MaterialPageRoute(
//                                                         //           builder: (context) =>
//                                                         //               ViewsPDFs(
//                                                         //                   infoPdf:
//                                                         //                       // 'https://sysvet.neitor.com/reportes/carnet.php?id=${factura['venId']}&empresa=${_usuario!.rucempresa}',
//                                                         //                       'https://syscontable.neitor.com/reportes/factura.php?codigo=${_prefacturas['venId']}&empresa=${_usuario!.rucempresa}',
//                                                         //                   labelPdf:
//                                                         //                       'infoFactura.pdf')),
//                                                         //     );
//                                                         //   },
//                                                         // ),
                                                     
                                                     
                                                     
//                                                      ],
//                                                       cancelButton:
//                                                           CupertinoActionSheetAction(
//                                                         child: Text('Cancel',
//                                                             style: GoogleFonts
//                                                                 .lexendDeca(
//                                                                     fontSize: size
//                                                                         .iScreen(
//                                                                             2.0),
//                                                                     color: Colors
//                                                                         .red,
//                                                                     fontWeight:
//                                                                         FontWeight
//                                                                             .normal)),
//                                                         isDefaultAction: true,
//                                                         onPressed: () {
//                                                           Navigator.pop(
//                                                               context, 'Cancel');
//                                                         },
//                                                       )),
//                                             );
//                                           },
//                                         ),
//                                       ],
//                                     ),
//                                     child: Card(
//                                       elevation: 5,
//                                       child: Container(
//                                         margin: EdgeInsets.only(
//                                             bottom: size.iScreen(0.0)),
//                                         color: index % 2 == 0
//                                             ? Colors.grey.shade50
//                                             : Colors.grey.shade200,
//                                         child: ListTile(
//                                           dense: true,
//                                           visualDensity:
//                                               VisualDensity.comfortable,
                                      
//                                           //  leading: CircleAvatar(
//                                           //   child: Text(
//                                           //      '${_prefacturas['venNomCliente'].substring(0, 1)}',
//                                           //     style: Theme.of(context)
//                                           //         .textTheme
//                                           //         .subtitle1,
//                                           //   ),
//                                           //   backgroundColor: Colors.grey[300],
//                                           // ),
//                                           title: Row(
//                                             mainAxisAlignment:
//                                                 MainAxisAlignment.spaceBetween,
//                                             children: [
//                                               Row(
//                                                 children: [
//                                                   SizedBox(
//                                                     // width: size.wScreen(40.0),
//                                                     child: Text(
//                                                       'Forma Pago: ',
//                                                       style: GoogleFonts.lexendDeca(
//                                                           // fontSize: size.iScreen(2.45),
//                                                           color: Colors.grey,
//                                                           fontWeight:
//                                                               FontWeight.normal),
//                                                       overflow: TextOverflow.ellipsis,
//                                                     ),
//                                                   ),
//                                                   SizedBox(
//                                                     width: size.wScreen(40.0),
//                                                     child: Text(
//                                                       '${_prefacturas['cajaTipoCaja']}',
//                                                       style: GoogleFonts.lexendDeca(
//                                                           // fontSize: size.iScreen(2.45),
//                                                           // color: Colors.white,
//                                                           fontWeight:
//                                                               FontWeight.bold),
//                                                       overflow: TextOverflow.ellipsis,
//                                                     ),
//                                                   ),
//                                                 ],
//                                               ),
//                                               Text(
//                                                 '${_prefacturas['cajaEstado']}',
//                                                 // 'Estado: ',
//                                                 style: GoogleFonts.lexendDeca(
//                                                     fontSize: size.iScreen(1.5),
//                                                     color: _color,
//                                                     fontWeight: FontWeight.bold),
//                                               ),
//                                             ],
//                                           ),
//                                           subtitle: Row(
//                                             mainAxisAlignment:
//                                                 MainAxisAlignment.spaceBetween,
//                                             children: [
//                                               Column(
//                                                 mainAxisAlignment:
//                                                     MainAxisAlignment.start,
//                                                 children: [
//                                                    Container(
//                                                     // color: Colors.red,
//                                                     width: size.wScreen(70.0),
//                                                      child: Row(
//                                                        children: [
//                                                         Container(
//                                                           // color: Colors.green,
                                                         
//                                                           child: Text(
//                                                             'Documento : ',
//                                                             style:
//                                                                 GoogleFonts.lexendDeca(
//                                                                     fontSize: size
//                                                                         .iScreen(1.5),
//                                                                     color:
//                                                                         Colors.grey,
//                                                                     fontWeight:
//                                                                         FontWeight
//                                                                             .normal),
//                                                             overflow:
//                                                                 TextOverflow.ellipsis,
//                                                           ),
                                                          
//                                                   ),
//                                                          Container(
//                                                           // color: Colors.green,
//                                                           // width: size.wScreen(50.0),
//                                                           child: Text(
//                                                             '${_prefacturas['cajaTipoDocumento']}',
//                                                             style:
//                                                                 GoogleFonts.lexendDeca(
//                                                                     fontSize: size
//                                                                         .iScreen(1.5),
//                                                                     color:_prefacturas['cajaTipoDocumento']=='INGRESO'?Colors.green:_prefacturas['cajaTipoDocumento']=='EGRESO'?Colors.orange:Colors.black,
//                                                                     fontWeight:
//                                                                         FontWeight
//                                                                             .bold),
//                                                             overflow:
//                                                                 TextOverflow.ellipsis,
//                                                           ),
//                                                   ),
//                                                        ],
//                                                      ),
//                                                    ),
//                                                   Container(
//                                                     // color: Colors.green,
//                                                     width: size.wScreen(70.0),
//                                                     child: Text(
//                                                       '${_prefacturas['cajaNumero']}',
//                                                       style:
//                                                           GoogleFonts.lexendDeca(
//                                                               fontSize: size
//                                                                   .iScreen(1.5),
//                                                               // color:
//                                                               //     Colors.black54,
//                                                               fontWeight:
//                                                                   FontWeight
//                                                                       .normal),
//                                                       overflow:
//                                                           TextOverflow.ellipsis,
//                                                     ),
//                                                   ),
//                                                   Container(
//                                                     // color: Colors.green,
//                                                     width: size.wScreen(70.0),
//                                                     child: Text(
//                                                       fechaLocal !=
//                                                               ''
//                                                           ? fechaLocal
//                                                           : '--- --- ---',
//                                                       style:
//                                                           GoogleFonts.lexendDeca(
//                                                               // fontSize: size.iScreen(2.45),
//                                                               color: Colors.grey,
//                                                               fontWeight:
//                                                                   FontWeight
//                                                                       .normal),
//                                                     ),
//                                                   ),
//                                                        Container(
//                                                     // color: Colors.green,
//                                                     width: size.wScreen(70.0),
//                                                     child: Row(
//                                                       children: [
//                                                         Text(
//                                                           'Usuario: ',
//                                                           style:
//                                                               GoogleFonts.lexendDeca(
//                                                                   // fontSize: size.iScreen(1.9),
//                                                                   color: Colors.grey,
//                                                                   fontWeight:
//                                                                       FontWeight
//                                                                           .bold),
//                                                         ),
//                                                         Text(
//                                                            _prefacturas['cajaUser']!=null
//                                                            ?'${_prefacturas['cajaUser']}':'--- --- --- --- --- ---  ',
//                                                           style:
//                                                               GoogleFonts.lexendDeca(
//                                                                   // fontSize: size.iScreen(1.8),
//                                                                   // color: Colors.grey,
//                                                                   fontWeight:
//                                                                       FontWeight
//                                                                           .bold),
//                                                         ),
//                                                       ],
//                                                     ),
//                                                   ),
//                                                 ],
//                                               ),
//                                               Container(
//                                                 // color: Colors.green,
//                                                 // width: size.wScreen(100.0),
//                                                 child: Text(
//                                                   '\$${_prefacturas['cajaMonto']}',
//                                                   style: GoogleFonts.lexendDeca(
//                                                       fontSize: size.iScreen(2.0),
//                                                       color: Colors.black87,
//                                                       fontWeight:
//                                                           FontWeight.normal),
//                                                   overflow: TextOverflow.ellipsis,
//                                                 ),
//                                               ),
//                                             ],
//                                           ),
//                                           // trailing: Icon(Icons.more_vert),
//                                         ),
//                                       ),
//                                     ),
//                                   );
//                                 } else {
//                                   return Consumer<PreFacturasController>(
//                                     builder: (_, valueNext, __) {
//                                       return valueNext.getpage == null
//                                           ? Container(
//                                               margin: EdgeInsets.symmetric(
//                                                   vertical: size.iScreen(2.0)),
//                                               child: Center(
//                                                 child: Text(
//                                                   'No existen más datos',
//                                                   style: GoogleFonts.lexendDeca(
//                                                       fontSize: size.iScreen(1.8),
//                                                       // color: primaryColor,
//                                                       fontWeight:
//                                                           FontWeight.normal),
//                                                 ),
//                                               ))
//                                           // : Container();
                          
//                                           : provider.allItemsFilters.length > 25
//                                               ? Container(
//                                                   margin: EdgeInsets.symmetric(
//                                                       vertical:
//                                                           size.iScreen(2.0)),
//                                                   child: const Center(
//                                                       child:
//                                                           CircularProgressIndicator()))
//                                               : Container();
//                                     },
//                                   );
//                                 }
//                               },
//                             ),
//                           ): const NoData(
//                               label: 'No existen datos para mostar',
//                             );


                          
//                           // ListView.builder(
//                           //   itemCount: provider.allItemsFilters.length,
//                           //   itemBuilder: (BuildContext context, int index) {
//                           //     final producto =
//                           //         provider.allItemsFilters[index];
//                           //     return 
//                           //    RefreshIndicator(
//                           //    onRefresh: () => onRefresh(),
//                           //   child: ListView.builder(
//                           //     controller: _scrollController,
//                           //     physics: const BouncingScrollPhysics(),
//                           //     itemCount: provider
//                           //             .allItemsFilters.length +
//                           //         1,
//                           //     itemBuilder: (BuildContext context, int index) {
//                           //       if (index <
//                           //           provider
//                           //               .allItemsFilters.length) {
//                           //         var _color;
//                           //         final _prefacturas = provider
//                           //             .allItemsFilters[index];
                          
//                           //         if (_prefacturas['cajaEstado'] == 'AUTORIZADO') {
//                           //           _color = Colors.green;
//                           //         } else if (_prefacturas['cajaEstado'] ==
//                           //             'SIN AUTORIZAR') {
//                           //           _color = Colors.orange;
//                           //         }
//                           //         if (_prefacturas['cajaEstado'] == 'ANULADA') {
//                           //           _color = Colors.red;
//                           //         }
                          
//                           //         return Slidable(
//                           //           startActionPane: ActionPane(
//                           //             // A motion is a widget used to control how the pane animates.
//                           //             motion: const ScrollMotion(),
                          
//                           //             children: [
//                           //               SlidableAction(
//                           //                     backgroundColor: Colors.grey,
//                           //                 foregroundColor: Colors.white,
//                           //                 icon: Icons.list_alt_outlined,
//                           //                 label: 'Más acciones',
//                           //                 onPressed: (context) {
//                           //                   showCupertinoModalPopup(
//                           //                     context: context,
//                           //                     builder: (BuildContext context) =>
//                           //                         CupertinoActionSheet(
//                           //                             title: Text(
//                           //                               'Acciones',
//                           //                               style: GoogleFonts
//                           //                                   .lexendDeca(
//                           //                                       fontSize: size
//                           //                                           .iScreen(2.0),
//                           //                                       color:
//                           //                                           primaryColor,
//                           //                                       fontWeight:
//                           //                                           FontWeight
//                           //                                               .normal),
//                           //                             ),
//                           //                             // message: const Text('Your options are '),
//                           //                             actions: <Widget>[
//                           //                               CupertinoActionSheetAction(
//                           //                                 child: Row(
//                           //                                   mainAxisAlignment:
//                           //                                       MainAxisAlignment
//                           //                                           .center,
//                           //                                   children: [
//                           //                                     Container(
//                           //                                       margin: EdgeInsets.only(
//                           //                                           right: size
//                           //                                               .iScreen(
//                           //                                                   2.0)),
//                           //                                       child: Text(
//                           //                                         'Ver PDF',
//                           //                                         style: GoogleFonts.lexendDeca(
//                           //                                             fontSize: size
//                           //                                                 .iScreen(
//                           //                                                     1.8),
//                           //                                             color: Colors
//                           //                                                 .black87,
//                           //                                             fontWeight:
//                           //                                                 FontWeight
//                           //                                                     .normal),
//                           //                                       ),
//                           //                                     ),
//                           //                                     const Icon(
//                           //                                       FontAwesomeIcons
//                           //                                           .filePdf,
//                           //                                       color: Colors.red,
//                           //                                     )
//                           //                                   ],
//                           //                                 ),
//                           //                                 onPressed: () {
//                           //                                   Navigator.pop(
//                           //                                       context);
                          
//                           //                                   Navigator.push(
//                           //                                     context,
//                           //                                     MaterialPageRoute(
//                           //                                         builder: (context) =>
//                           //                                             ViewsPDFs(
//                           //                                                 infoPdf:
//                           //                                                     // 'https://sysvet.neitor.com/reportes/carnet.php?id=${factura['venId']}&empresa=${_usuario!.rucempresa}',
//                           //                                                     'https://syscontable.neitor.com/reportes/factura.php?codigo=${_prefacturas['venId']}&empresa=${_usuario!.rucempresa}',
//                           //                                                 labelPdf:
//                           //                                                     'infoFactura.pdf')),
//                           //                                   );
//                           //                                 },
//                           //                               ),
//                           //                             ],
//                           //                             cancelButton:
//                           //                                 CupertinoActionSheetAction(
//                           //                               child: Text('Cancel',
//                           //                                   style: GoogleFonts
//                           //                                       .lexendDeca(
//                           //                                           fontSize: size
//                           //                                               .iScreen(
//                           //                                                   2.0),
//                           //                                           color: Colors
//                           //                                               .red,
//                           //                                           fontWeight:
//                           //                                               FontWeight
//                           //                                                   .normal)),
//                           //                               isDefaultAction: true,
//                           //                               onPressed: () {
//                           //                                 Navigator.pop(
//                           //                                     context, 'Cancel');
//                           //                               },
//                           //                             )),
//                           //                   );
//                           //                 },
//                           //               ),
//                           //             ],
//                           //           ),
//                           //           child: Card(
//                           //             elevation: 5,
//                           //             child: Container(
//                           //               margin: EdgeInsets.only(
//                           //                   bottom: size.iScreen(0.0)),
//                           //               color: index % 2 == 0
//                           //                   ? Colors.grey.shade50
//                           //                   : Colors.grey.shade200,
//                           //               child: ListTile(
//                           //                 dense: true,
//                           //                 visualDensity:
//                           //                     VisualDensity.comfortable,
                                      
//                           //                  leading: CircleAvatar(
//                           //                   child: Text(
//                           //                      '${_prefacturas['venNomCliente'].substring(0, 1)}',
//                           //                     style: Theme.of(context)
//                           //                         .textTheme
//                           //                         .subtitle1,
//                           //                   ),
//                           //                   backgroundColor: Colors.grey[300],
//                           //                 ),
//                           //                 title: Row(
//                           //                   mainAxisAlignment:
//                           //                       MainAxisAlignment.spaceBetween,
//                           //                   children: [
//                           //                     SizedBox(
//                           //                       width: size.wScreen(40.0),
//                           //                       child: Text(
//                           //                         '${_prefacturas['venNomCliente']}',
//                           //                         style: GoogleFonts.lexendDeca(
//                           //                             // fontSize: size.iScreen(2.45),
//                           //                             // color: Colors.white,
//                           //                             fontWeight:
//                           //                                 FontWeight.normal),
//                           //                         overflow: TextOverflow.ellipsis,
//                           //                       ),
//                           //                     ),
//                           //                     Text(
//                           //                       '${_prefacturas['cajaEstado']}',
//                           //                       // 'Estado: ',
//                           //                       style: GoogleFonts.lexendDeca(
//                           //                           fontSize: size.iScreen(1.5),
//                           //                           color: _color,
//                           //                           fontWeight: FontWeight.bold),
//                           //                     ),
//                           //                   ],
//                           //                 ),
//                           //                 subtitle: Row(
//                           //                   mainAxisAlignment:
//                           //                       MainAxisAlignment.spaceBetween,
//                           //                   children: [
//                           //                     Column(
//                           //                       mainAxisAlignment:
//                           //                           MainAxisAlignment.start,
//                           //                       children: [
//                           //                         Container(
//                           //                           // color: Colors.green,
//                           //                           width: size.wScreen(50.0),
//                           //                           child: Text(
//                           //                             '${_prefacturas['venNumFactura']}',
//                           //                             style:
//                           //                                 GoogleFonts.lexendDeca(
//                           //                                     fontSize: size
//                           //                                         .iScreen(1.5),
//                           //                                     color:
//                           //                                         Colors.black54,
//                           //                                     fontWeight:
//                           //                                         FontWeight
//                           //                                             .normal),
//                           //                             overflow:
//                           //                                 TextOverflow.ellipsis,
//                           //                           ),
//                           //                         ),
//                           //                         Container(
//                           //                           // color: Colors.green,
//                           //                           width: size.wScreen(50.0),
//                           //                           child: Text(
//                           //                             _prefacturas['venFecReg'] !=
//                           //                                     ''
//                           //                                 ? '${_prefacturas['venFecReg'].replaceAll('T', "  ").replaceAll('.000Z', "  ")}'
//                           //                                 : '--- --- ---',
//                           //                             style:
//                           //                                 GoogleFonts.lexendDeca(
//                           //                                     // fontSize: size.iScreen(2.45),
//                           //                                     color: Colors.grey,
//                           //                                     fontWeight:
//                           //                                         FontWeight
//                           //                                             .normal),
//                           //                           ),
//                           //                         ),
//                           //                       ],
//                           //                     ),
//                           //                     Container(
//                           //                       // color: Colors.green,
//                           //                       // width: size.wScreen(100.0),
//                           //                       child: Text(
//                           //                         '\$${_prefacturas['venTotal']}',
//                           //                         style: GoogleFonts.lexendDeca(
//                           //                             fontSize: size.iScreen(2.0),
//                           //                             color: Colors.black87,
//                           //                             fontWeight:
//                           //                                 FontWeight.normal),
//                           //                         overflow: TextOverflow.ellipsis,
//                           //                       ),
//                           //                     ),
//                           //                   ],
//                           //                 ),
//                           //                 // trailing: Icon(Icons.more_vert),
//                           //               ),
//                           //             ),
//                           //           ),
//                           //         );
//                           //       } else {
//                           //         return Consumer<PreFacturasController>(
//                           //           builder: (_, valueNext, __) {
//                           //             return valueNext.getpage == null
//                           //                 ? Container(
//                           //                     margin: EdgeInsets.symmetric(
//                           //                         vertical: size.iScreen(2.0)),
//                           //                     child: Center(
//                           //                       child: Text(
//                           //                         'No existen más datos',
//                           //                         style: GoogleFonts.lexendDeca(
//                           //                             fontSize: size.iScreen(1.8),
//                           //                             // color: primaryColor,
//                           //                             fontWeight:
//                           //                                 FontWeight.normal),
//                           //                       ),
//                           //                     ))
//                           //                 // : Container();
                          
//                           //                 : provider.allItemsFilters.length > 25
//                           //                     ? Container(
//                           //                         margin: EdgeInsets.symmetric(
//                           //                             vertical:
//                           //                                 size.iScreen(2.0)),
//                           //                         child: const Center(
//                           //                             child:
//                           //                                 CircularProgressIndicator()))
//                           //                     : Container();
//                           //           },
//                           //         );
//                           //       }
//                           //     },
//                           //   ),
//                           // );





                              
//                           //   },
//                           // ) : const NoData(
//                           //     label: 'No existen datos para mostar',
//                           //   );
//                         },
//                       ),
                     

            // Consumer<PreFacturasController>(
            //             builder: (_, provider, __) {
                         
            //              if (provider.allItemsFilters.isEmpty) {
            //                 return const NoData(
            //                   label: 'No existen datos para mostar',
            //                 );
            //                 // Text("sin datos");
            //               }

            //               return 
                          
            //               (provider.allItemsFilters.isEmpty)
            //                             ? Center(
            //                                 child: Column(
            //                                   mainAxisAlignment: MainAxisAlignment.center,
            //                                 children: [
                                              
            //                                   CircularProgressIndicator(),
            //                                   Text('Por favor espere ....')
            //                                 ],
            //                               ))
            //                             : (provider.allItemsFilters.length > 0)
            //                                 ?
            //                RefreshIndicator(
            //                  onRefresh: () => onRefresh(),
            //                 child: ListView.builder(
            //                   controller: _scrollController,
            //                   physics: const BouncingScrollPhysics(),
            //                   itemCount: provider
            //                           .allItemsFilters.length +
            //                       1,
            //                   itemBuilder: (BuildContext context, int index) {
            //                     if (index <
            //                         provider
            //                             .allItemsFilters.length) {
            //                       var _color;
            //                       final _prefacturas = provider
            //                           .allItemsFilters[index];
                          
            //                       if (_prefacturas['cajaEstado'] == 'AUTORIZADO') {
            //                         _color = Colors.green;
            //                       } else if (_prefacturas['cajaEstado'] ==
            //                           'SIN AUTORIZAR') {
            //                         _color = Colors.orange;
            //                       }
            //                       if (_prefacturas['cajaEstado'] == 'ANULADA') {
            //                         _color = Colors.red;
            //                       }
                          
            //                       return Slidable(
            //                         startActionPane: ActionPane(
            //                           // A motion is a widget used to control how the pane animates.
            //                           motion: const ScrollMotion(),
                          
            //                           children: [
            //                             SlidableAction(
            //                                   backgroundColor: Colors.grey,
            //                               foregroundColor: Colors.white,
            //                               icon: Icons.list_alt_outlined,
            //                               label: 'Más acciones',
            //                               onPressed: (context) {
            //                                 showCupertinoModalPopup(
            //                                   context: context,
            //                                   builder: (BuildContext context) =>
            //                                       CupertinoActionSheet(
            //                                           title: Text(
            //                                             'Acciones',
            //                                             style: GoogleFonts
            //                                                 .lexendDeca(
            //                                                     fontSize: size
            //                                                         .iScreen(2.0),
            //                                                     color:
            //                                                         primaryColor,
            //                                                     fontWeight:
            //                                                         FontWeight
            //                                                             .normal),
            //                                           ),
            //                                           // message: const Text('Your options are '),
            //                                           actions: <Widget>[
            //                                             CupertinoActionSheetAction(
            //                                               child: Row(
            //                                                 mainAxisAlignment:
            //                                                     MainAxisAlignment
            //                                                         .center,
            //                                                 children: [
            //                                                   Container(
            //                                                     margin: EdgeInsets.only(
            //                                                         right: size
            //                                                             .iScreen(
            //                                                                 2.0)),
            //                                                     child: Text(
            //                                                       'Ver PDF',
            //                                                       style: GoogleFonts.lexendDeca(
            //                                                           fontSize: size
            //                                                               .iScreen(
            //                                                                   1.8),
            //                                                           color: Colors
            //                                                               .black87,
            //                                                           fontWeight:
            //                                                               FontWeight
            //                                                                   .normal),
            //                                                     ),
            //                                                   ),
            //                                                   const Icon(
            //                                                     FontAwesomeIcons
            //                                                         .filePdf,
            //                                                     color: Colors.red,
            //                                                   )
            //                                                 ],
            //                                               ),
            //                                               onPressed: () {
            //                                                 Navigator.pop(
            //                                                     context);
                          
            //                                                 Navigator.push(
            //                                                   context,
            //                                                   MaterialPageRoute(
            //                                                       builder: (context) =>
            //                                                           ViewsPDFs(
            //                                                               infoPdf:
            //                                                                   // 'https://sysvet.neitor.com/reportes/carnet.php?id=${factura['venId']}&empresa=${_usuario!.rucempresa}',
            //                                                                   'https://syscontable.neitor.com/reportes/factura.php?codigo=${_prefacturas['venId']}&empresa=${_usuario!.rucempresa}',
            //                                                               labelPdf:
            //                                                                   'infoFactura.pdf')),
            //                                                 );
            //                                               },
            //                                             ),
            //                                           ],
            //                                           cancelButton:
            //                                               CupertinoActionSheetAction(
            //                                             child: Text('Cancel',
            //                                                 style: GoogleFonts
            //                                                     .lexendDeca(
            //                                                         fontSize: size
            //                                                             .iScreen(
            //                                                                 2.0),
            //                                                         color: Colors
            //                                                             .red,
            //                                                         fontWeight:
            //                                                             FontWeight
            //                                                                 .normal)),
            //                                             isDefaultAction: true,
            //                                             onPressed: () {
            //                                               Navigator.pop(
            //                                                   context, 'Cancel');
            //                                             },
            //                                           )),
            //                                 );
            //                               },
            //                             ),
            //                           ],
            //                         ),
            //                         child: Card(
            //                           elevation: 5,
            //                           child: Container(
            //                             margin: EdgeInsets.only(
            //                                 bottom: size.iScreen(0.0)),
            //                             color: index % 2 == 0
            //                                 ? Colors.grey.shade50
            //                                 : Colors.grey.shade200,
            //                             child: ListTile(
            //                               dense: true,
            //                               visualDensity:
            //                                   VisualDensity.comfortable,
                                      
            //                                leading: CircleAvatar(
            //                                 child: Text(
            //                                    '${_prefacturas['venNomCliente'].substring(0, 1)}',
            //                                   style: Theme.of(context)
            //                                       .textTheme
            //                                       .subtitle1,
            //                                 ),
            //                                 backgroundColor: Colors.grey[300],
            //                               ),
            //                               title: Row(
            //                                 mainAxisAlignment:
            //                                     MainAxisAlignment.spaceBetween,
            //                                 children: [
            //                                   SizedBox(
            //                                     width: size.wScreen(40.0),
            //                                     child: Text(
            //                                       '${_prefacturas['venNomCliente']}',
            //                                       style: GoogleFonts.lexendDeca(
            //                                           // fontSize: size.iScreen(2.45),
            //                                           // color: Colors.white,
            //                                           fontWeight:
            //                                               FontWeight.normal),
            //                                       overflow: TextOverflow.ellipsis,
            //                                     ),
            //                                   ),
            //                                   Text(
            //                                     '${_prefacturas['cajaEstado']}',
            //                                     // 'Estado: ',
            //                                     style: GoogleFonts.lexendDeca(
            //                                         fontSize: size.iScreen(1.5),
            //                                         color: _color,
            //                                         fontWeight: FontWeight.bold),
            //                                   ),
            //                                 ],
            //                               ),
            //                               subtitle: Row(
            //                                 mainAxisAlignment:
            //                                     MainAxisAlignment.spaceBetween,
            //                                 children: [
            //                                   Column(
            //                                     mainAxisAlignment:
            //                                         MainAxisAlignment.start,
            //                                     children: [
            //                                       Container(
            //                                         // color: Colors.green,
            //                                         width: size.wScreen(50.0),
            //                                         child: Text(
            //                                           '${_prefacturas['venNumFactura']}',
            //                                           style:
            //                                               GoogleFonts.lexendDeca(
            //                                                   fontSize: size
            //                                                       .iScreen(1.5),
            //                                                   color:
            //                                                       Colors.black54,
            //                                                   fontWeight:
            //                                                       FontWeight
            //                                                           .normal),
            //                                           overflow:
            //                                               TextOverflow.ellipsis,
            //                                         ),
            //                                       ),
            //                                       Container(
            //                                         // color: Colors.green,
            //                                         width: size.wScreen(50.0),
            //                                         child: Text(
            //                                           _prefacturas['venFecReg'] !=
            //                                                   ''
            //                                               ? '${_prefacturas['venFecReg'].replaceAll('T', "  ").replaceAll('.000Z', "  ")}'
            //                                               : '--- --- ---',
            //                                           style:
            //                                               GoogleFonts.lexendDeca(
            //                                                   // fontSize: size.iScreen(2.45),
            //                                                   color: Colors.grey,
            //                                                   fontWeight:
            //                                                       FontWeight
            //                                                           .normal),
            //                                         ),
            //                                       ),
            //                                     ],
            //                                   ),
            //                                   Container(
            //                                     // color: Colors.green,
            //                                     // width: size.wScreen(100.0),
            //                                     child: Text(
            //                                       '\$${_prefacturas['venTotal']}',
            //                                       style: GoogleFonts.lexendDeca(
            //                                           fontSize: size.iScreen(2.0),
            //                                           color: Colors.black87,
            //                                           fontWeight:
            //                                               FontWeight.normal),
            //                                       overflow: TextOverflow.ellipsis,
            //                                     ),
            //                                   ),
            //                                 ],
            //                               ),
            //                               // trailing: Icon(Icons.more_vert),
            //                             ),
            //                           ),
            //                         ),
            //                       );
            //                     } else {
            //                       return Consumer<PreFacturasController>(
            //                         builder: (_, valueNext, __) {
            //                           return valueNext.getpage == null
            //                               ? Container(
            //                                   margin: EdgeInsets.symmetric(
            //                                       vertical: size.iScreen(2.0)),
            //                                   child: Center(
            //                                     child: Text(
            //                                       'No existen más datos',
            //                                       style: GoogleFonts.lexendDeca(
            //                                           fontSize: size.iScreen(1.8),
            //                                           // color: primaryColor,
            //                                           fontWeight:
            //                                               FontWeight.normal),
            //                                     ),
            //                                   ))
            //                               // : Container();
                          
            //                               : provider.allItemsFilters.length > 25
            //                                   ? Container(
            //                                       margin: EdgeInsets.symmetric(
            //                                           vertical:
            //                                               size.iScreen(2.0)),
            //                                       child: const Center(
            //                                           child:
            //                                               CircularProgressIndicator()))
            //                                   : Container();
            //                         },
            //                       );
            //                     }
            //                   },
            //                 ),
            //               ): const NoData(
            //                   label: 'No existen datos para mostar',
            //                 );


                          
            //               // ListView.builder(
            //               //   itemCount: provider.allItemsFilters.length,
            //               //   itemBuilder: (BuildContext context, int index) {
            //               //     final producto =
            //               //         provider.allItemsFilters[index];
            //               //     return 
            //               //    RefreshIndicator(
            //               //    onRefresh: () => onRefresh(),
            //               //   child: ListView.builder(
            //               //     controller: _scrollController,
            //               //     physics: const BouncingScrollPhysics(),
            //               //     itemCount: provider
            //               //             .allItemsFilters.length +
            //               //         1,
            //               //     itemBuilder: (BuildContext context, int index) {
            //               //       if (index <
            //               //           provider
            //               //               .allItemsFilters.length) {
            //               //         var _color;
            //               //         final _prefacturas = provider
            //               //             .allItemsFilters[index];
                          
            //               //         if (_prefacturas['cajaEstado'] == 'AUTORIZADO') {
            //               //           _color = Colors.green;
            //               //         } else if (_prefacturas['cajaEstado'] ==
            //               //             'SIN AUTORIZAR') {
            //               //           _color = Colors.orange;
            //               //         }
            //               //         if (_prefacturas['cajaEstado'] == 'ANULADA') {
            //               //           _color = Colors.red;
            //               //         }
                          
            //               //         return Slidable(
            //               //           startActionPane: ActionPane(
            //               //             // A motion is a widget used to control how the pane animates.
            //               //             motion: const ScrollMotion(),
                          
            //               //             children: [
            //               //               SlidableAction(
            //               //                     backgroundColor: Colors.grey,
            //               //                 foregroundColor: Colors.white,
            //               //                 icon: Icons.list_alt_outlined,
            //               //                 label: 'Más acciones',
            //               //                 onPressed: (context) {
            //               //                   showCupertinoModalPopup(
            //               //                     context: context,
            //               //                     builder: (BuildContext context) =>
            //               //                         CupertinoActionSheet(
            //               //                             title: Text(
            //               //                               'Acciones',
            //               //                               style: GoogleFonts
            //               //                                   .lexendDeca(
            //               //                                       fontSize: size
            //               //                                           .iScreen(2.0),
            //               //                                       color:
            //               //                                           primaryColor,
            //               //                                       fontWeight:
            //               //                                           FontWeight
            //               //                                               .normal),
            //               //                             ),
            //               //                             // message: const Text('Your options are '),
            //               //                             actions: <Widget>[
            //               //                               CupertinoActionSheetAction(
            //               //                                 child: Row(
            //               //                                   mainAxisAlignment:
            //               //                                       MainAxisAlignment
            //               //                                           .center,
            //               //                                   children: [
            //               //                                     Container(
            //               //                                       margin: EdgeInsets.only(
            //               //                                           right: size
            //               //                                               .iScreen(
            //               //                                                   2.0)),
            //               //                                       child: Text(
            //               //                                         'Ver PDF',
            //               //                                         style: GoogleFonts.lexendDeca(
            //               //                                             fontSize: size
            //               //                                                 .iScreen(
            //               //                                                     1.8),
            //               //                                             color: Colors
            //               //                                                 .black87,
            //               //                                             fontWeight:
            //               //                                                 FontWeight
            //               //                                                     .normal),
            //               //                                       ),
            //               //                                     ),
            //               //                                     const Icon(
            //               //                                       FontAwesomeIcons
            //               //                                           .filePdf,
            //               //                                       color: Colors.red,
            //               //                                     )
            //               //                                   ],
            //               //                                 ),
            //               //                                 onPressed: () {
            //               //                                   Navigator.pop(
            //               //                                       context);
                          
            //               //                                   Navigator.push(
            //               //                                     context,
            //               //                                     MaterialPageRoute(
            //               //                                         builder: (context) =>
            //               //                                             ViewsPDFs(
            //               //                                                 infoPdf:
            //               //                                                     // 'https://sysvet.neitor.com/reportes/carnet.php?id=${factura['venId']}&empresa=${_usuario!.rucempresa}',
            //               //                                                     'https://syscontable.neitor.com/reportes/factura.php?codigo=${_prefacturas['venId']}&empresa=${_usuario!.rucempresa}',
            //               //                                                 labelPdf:
            //               //                                                     'infoFactura.pdf')),
            //               //                                   );
            //               //                                 },
            //               //                               ),
            //               //                             ],
            //               //                             cancelButton:
            //               //                                 CupertinoActionSheetAction(
            //               //                               child: Text('Cancel',
            //               //                                   style: GoogleFonts
            //               //                                       .lexendDeca(
            //               //                                           fontSize: size
            //               //                                               .iScreen(
            //               //                                                   2.0),
            //               //                                           color: Colors
            //               //                                               .red,
            //               //                                           fontWeight:
            //               //                                               FontWeight
            //               //                                                   .normal)),
            //               //                               isDefaultAction: true,
            //               //                               onPressed: () {
            //               //                                 Navigator.pop(
            //               //                                     context, 'Cancel');
            //               //                               },
            //               //                             )),
            //               //                   );
            //               //                 },
            //               //               ),
            //               //             ],
            //               //           ),
            //               //           child: Card(
            //               //             elevation: 5,
            //               //             child: Container(
            //               //               margin: EdgeInsets.only(
            //               //                   bottom: size.iScreen(0.0)),
            //               //               color: index % 2 == 0
            //               //                   ? Colors.grey.shade50
            //               //                   : Colors.grey.shade200,
            //               //               child: ListTile(
            //               //                 dense: true,
            //               //                 visualDensity:
            //               //                     VisualDensity.comfortable,
                                      
            //               //                  leading: CircleAvatar(
            //               //                   child: Text(
            //               //                      '${_prefacturas['venNomCliente'].substring(0, 1)}',
            //               //                     style: Theme.of(context)
            //               //                         .textTheme
            //               //                         .subtitle1,
            //               //                   ),
            //               //                   backgroundColor: Colors.grey[300],
            //               //                 ),
            //               //                 title: Row(
            //               //                   mainAxisAlignment:
            //               //                       MainAxisAlignment.spaceBetween,
            //               //                   children: [
            //               //                     SizedBox(
            //               //                       width: size.wScreen(40.0),
            //               //                       child: Text(
            //               //                         '${_prefacturas['venNomCliente']}',
            //               //                         style: GoogleFonts.lexendDeca(
            //               //                             // fontSize: size.iScreen(2.45),
            //               //                             // color: Colors.white,
            //               //                             fontWeight:
            //               //                                 FontWeight.normal),
            //               //                         overflow: TextOverflow.ellipsis,
            //               //                       ),
            //               //                     ),
            //               //                     Text(
            //               //                       '${_prefacturas['cajaEstado']}',
            //               //                       // 'Estado: ',
            //               //                       style: GoogleFonts.lexendDeca(
            //               //                           fontSize: size.iScreen(1.5),
            //               //                           color: _color,
            //               //                           fontWeight: FontWeight.bold),
            //               //                     ),
            //               //                   ],
            //               //                 ),
            //               //                 subtitle: Row(
            //               //                   mainAxisAlignment:
            //               //                       MainAxisAlignment.spaceBetween,
            //               //                   children: [
            //               //                     Column(
            //               //                       mainAxisAlignment:
            //               //                           MainAxisAlignment.start,
            //               //                       children: [
            //               //                         Container(
            //               //                           // color: Colors.green,
            //               //                           width: size.wScreen(50.0),
            //               //                           child: Text(
            //               //                             '${_prefacturas['venNumFactura']}',
            //               //                             style:
            //               //                                 GoogleFonts.lexendDeca(
            //               //                                     fontSize: size
            //               //                                         .iScreen(1.5),
            //               //                                     color:
            //               //                                         Colors.black54,
            //               //                                     fontWeight:
            //               //                                         FontWeight
            //               //                                             .normal),
            //               //                             overflow:
            //               //                                 TextOverflow.ellipsis,
            //               //                           ),
            //               //                         ),
            //               //                         Container(
            //               //                           // color: Colors.green,
            //               //                           width: size.wScreen(50.0),
            //               //                           child: Text(
            //               //                             _prefacturas['venFecReg'] !=
            //               //                                     ''
            //               //                                 ? '${_prefacturas['venFecReg'].replaceAll('T', "  ").replaceAll('.000Z', "  ")}'
            //               //                                 : '--- --- ---',
            //               //                             style:
            //               //                                 GoogleFonts.lexendDeca(
            //               //                                     // fontSize: size.iScreen(2.45),
            //               //                                     color: Colors.grey,
            //               //                                     fontWeight:
            //               //                                         FontWeight
            //               //                                             .normal),
            //               //                           ),
            //               //                         ),
            //               //                       ],
            //               //                     ),
            //               //                     Container(
            //               //                       // color: Colors.green,
            //               //                       // width: size.wScreen(100.0),
            //               //                       child: Text(
            //               //                         '\$${_prefacturas['venTotal']}',
            //               //                         style: GoogleFonts.lexendDeca(
            //               //                             fontSize: size.iScreen(2.0),
            //               //                             color: Colors.black87,
            //               //                             fontWeight:
            //               //                                 FontWeight.normal),
            //               //                         overflow: TextOverflow.ellipsis,
            //               //                       ),
            //               //                     ),
            //               //                   ],
            //               //                 ),
            //               //                 // trailing: Icon(Icons.more_vert),
            //               //               ),
            //               //             ),
            //               //           ),
            //               //         );
            //               //       } else {
            //               //         return Consumer<PreFacturasController>(
            //               //           builder: (_, valueNext, __) {
            //               //             return valueNext.getpage == null
            //               //                 ? Container(
            //               //                     margin: EdgeInsets.symmetric(
            //               //                         vertical: size.iScreen(2.0)),
            //               //                     child: Center(
            //               //                       child: Text(
            //               //                         'No existen más datos',
            //               //                         style: GoogleFonts.lexendDeca(
            //               //                             fontSize: size.iScreen(1.8),
            //               //                             // color: primaryColor,
            //               //                             fontWeight:
            //               //                                 FontWeight.normal),
            //               //                       ),
            //               //                     ))
            //               //                 // : Container();
                          
            //               //                 : provider.allItemsFilters.length > 25
            //               //                     ? Container(
            //               //                         margin: EdgeInsets.symmetric(
            //               //                             vertical:
            //               //                                 size.iScreen(2.0)),
            //               //                         child: const Center(
            //               //                             child:
            //               //                                 CircularProgressIndicator()))
            //               //                     : Container();
            //               //           },
            //               //         );
            //               //       }
            //               //     },
            //               //   ),
            //               // );





                              
            //               //   },
            //               // ) : const NoData(
            //               //     label: 'No existen datos para mostar',
            //               //   );
            //             },
            //           ),
                     



          //  Text('data 222'),
              // Consumer<PreFacturasController>(
              //           builder: (_, providersPrefacturas, __) {
              //             if (providersPrefacturas
              //                         .getErrorPreFacturasPaginacion ==
              //                     null &&
              //                 providersPrefacturas
              //                         .getError401PreFacturasPaginacion ==
              //                     false) {
              //               return Center(
              //                 // child: CircularProgressIndicator(),
              //                 child: Column(
              //                   mainAxisSize: MainAxisSize.min,
              //                   children: [
              //                     Text(
              //                       'Cargando Datos...',
              //                       style: GoogleFonts.lexendDeca(
              //                           fontSize: size.iScreen(1.5),
              //                           color: Colors.black87,
              //                           fontWeight: FontWeight.bold),
              //                     ),
              //                     //***********************************************/
              //                     SizedBox(
              //                       height: size.iScreen(1.0),
              //                     ),
              //                     //*****************************************/
              //                     const CircularProgressIndicator(),
              //                   ],
              //                 ),
              //               );
              //             } else if (providersPrefacturas
              //                     .getErrorPreFacturasPaginacion ==
              //                 false) {
              //               return const NoData(
              //                 label: 'No existen datos para mostar',
              //               );
              //             } else if (providersPrefacturas
              //                     .getListaPreFacturasPaginacion.isEmpty &&
              //                 providersPrefacturas
              //                         .getErrorPreFacturasPaginacion ==
              //                     false) {
              //               return const NoData(
              //                 label: 'No existen datos para mostar',
              //               );
              //             } else if (providersPrefacturas
              //                     .getListaPreFacturasPaginacion.isEmpty &&
              //                 providersPrefacturas
              //                         .getError401PreFacturasPaginacion ==
              //                     true) {
              //               return const NoData(
              //                 label:
              //                     'Su sesión ha expirado, vuelva a iniciar sesión',
              //               );
              //             } else if (providersPrefacturas
              //                     .getListaPreFacturasPaginacion.isEmpty &&
              //                 providersPrefacturas
              //                         .getError401PreFacturasPaginacion ==
              //                     false) {
              //               return const NoData(
              //                 label: 'No existen datos para mostar',
              //               );
              //             }

              //             return 
              //             RefreshIndicator(
              //                onRefresh: () => onRefresh(),
              //               child: ListView.builder(
              //                 controller: _scrollController,
              //                 physics: const BouncingScrollPhysics(),
              //                 itemCount: providersPrefacturas
              //                         .getListaPreFacturasPaginacion.length +
              //                     1,
              //                 itemBuilder: (BuildContext context, int index) {
              //                   if (index <
              //                       providersPrefacturas
              //                           .getListaPreFacturasPaginacion.length) {
              //                     var _color;
              //                     final _prefacturas = providersPrefacturas
              //                         .getListaPreFacturasPaginacion[index];
                          
              //                     if (_prefacturas['cajaEstado'] == 'AUTORIZADO') {
              //                       _color = Colors.green;
              //                     } else if (_prefacturas['cajaEstado'] ==
              //                         'SIN AUTORIZAR') {
              //                       _color = Colors.orange;
              //                     }
              //                     if (_prefacturas['cajaEstado'] == 'ANULADA') {
              //                       _color = Colors.red;
              //                     }
                          
              //                     return Slidable(
              //                       startActionPane: ActionPane(
              //                         // A motion is a widget used to control how the pane animates.
              //                         motion: const ScrollMotion(),
                          
              //                         children: [
              //                           SlidableAction(
              //                                 backgroundColor: Colors.grey,
              //                             foregroundColor: Colors.white,
              //                             icon: Icons.list_alt_outlined,
              //                             label: 'Más acciones',
              //                             onPressed: (context) {
              //                               showCupertinoModalPopup(
              //                                 context: context,
              //                                 builder: (BuildContext context) =>
              //                                     CupertinoActionSheet(
              //                                         title: Text(
              //                                           'Acciones',
              //                                           style: GoogleFonts
              //                                               .lexendDeca(
              //                                                   fontSize: size
              //                                                       .iScreen(2.0),
              //                                                   color:
              //                                                       primaryColor,
              //                                                   fontWeight:
              //                                                       FontWeight
              //                                                           .normal),
              //                                         ),
              //                                         // message: const Text('Your options are '),
              //                                         actions: <Widget>[
              //                                           CupertinoActionSheetAction(
              //                                             child: Row(
              //                                               mainAxisAlignment:
              //                                                   MainAxisAlignment
              //                                                       .center,
              //                                               children: [
              //                                                 Container(
              //                                                   margin: EdgeInsets.only(
              //                                                       right: size
              //                                                           .iScreen(
              //                                                               2.0)),
              //                                                   child: Text(
              //                                                     'Ver PDF',
              //                                                     style: GoogleFonts.lexendDeca(
              //                                                         fontSize: size
              //                                                             .iScreen(
              //                                                                 1.8),
              //                                                         color: Colors
              //                                                             .black87,
              //                                                         fontWeight:
              //                                                             FontWeight
              //                                                                 .normal),
              //                                                   ),
              //                                                 ),
              //                                                 const Icon(
              //                                                   FontAwesomeIcons
              //                                                       .filePdf,
              //                                                   color: Colors.red,
              //                                                 )
              //                                               ],
              //                                             ),
              //                                             onPressed: () {
              //                                               Navigator.pop(
              //                                                   context);
                          
              //                                               Navigator.push(
              //                                                 context,
              //                                                 MaterialPageRoute(
              //                                                     builder: (context) =>
              //                                                         ViewsPDFs(
              //                                                             infoPdf:
              //                                                                 // 'https://sysvet.neitor.com/reportes/carnet.php?id=${factura['venId']}&empresa=${_usuario!.rucempresa}',
              //                                                                 'https://syscontable.neitor.com/reportes/factura.php?codigo=${_prefacturas['venId']}&empresa=${_usuario!.rucempresa}',
              //                                                             labelPdf:
              //                                                                 'infoFactura.pdf')),
              //                                               );
              //                                             },
              //                                           ),
              //                                         ],
              //                                         cancelButton:
              //                                             CupertinoActionSheetAction(
              //                                           child: Text('Cancel',
              //                                               style: GoogleFonts
              //                                                   .lexendDeca(
              //                                                       fontSize: size
              //                                                           .iScreen(
              //                                                               2.0),
              //                                                       color: Colors
              //                                                           .red,
              //                                                       fontWeight:
              //                                                           FontWeight
              //                                                               .normal)),
              //                                           isDefaultAction: true,
              //                                           onPressed: () {
              //                                             Navigator.pop(
              //                                                 context, 'Cancel');
              //                                           },
              //                                         )),
              //                               );
              //                             },
              //                           ),
              //                         ],
              //                       ),
              //                       child: Card(
              //                         elevation: 5,
              //                         child: Container(
              //                           margin: EdgeInsets.only(
              //                               bottom: size.iScreen(0.0)),
              //                           color: index % 2 == 0
              //                               ? Colors.grey.shade50
              //                               : Colors.grey.shade200,
              //                           child: ListTile(
              //                             dense: true,
              //                             visualDensity:
              //                                 VisualDensity.comfortable,
                                      
              //                              leading: CircleAvatar(
              //                               child: Text(
              //                                  '${_prefacturas['venNomCliente'].substring(0, 1)}',
              //                                 style: Theme.of(context)
              //                                     .textTheme
              //                                     .subtitle1,
              //                               ),
              //                               backgroundColor: Colors.grey[300],
              //                             ),
              //                             title: Row(
              //                               mainAxisAlignment:
              //                                   MainAxisAlignment.spaceBetween,
              //                               children: [
              //                                 SizedBox(
              //                                   width: size.wScreen(40.0),
              //                                   child: Text(
              //                                     '${_prefacturas['venNomCliente']}',
              //                                     style: GoogleFonts.lexendDeca(
              //                                         // fontSize: size.iScreen(2.45),
              //                                         // color: Colors.white,
              //                                         fontWeight:
              //                                             FontWeight.normal),
              //                                     overflow: TextOverflow.ellipsis,
              //                                   ),
              //                                 ),
              //                                 Text(
              //                                   '${_prefacturas['cajaEstado']}',
              //                                   // 'Estado: ',
              //                                   style: GoogleFonts.lexendDeca(
              //                                       fontSize: size.iScreen(1.5),
              //                                       color: _color,
              //                                       fontWeight: FontWeight.bold),
              //                                 ),
              //                               ],
              //                             ),
              //                             subtitle: Row(
              //                               mainAxisAlignment:
              //                                   MainAxisAlignment.spaceBetween,
              //                               children: [
              //                                 Column(
              //                                   mainAxisAlignment:
              //                                       MainAxisAlignment.start,
              //                                   children: [
              //                                     Container(
              //                                       // color: Colors.green,
              //                                       width: size.wScreen(50.0),
              //                                       child: Text(
              //                                         '${_prefacturas['venNumFactura']}',
              //                                         style:
              //                                             GoogleFonts.lexendDeca(
              //                                                 fontSize: size
              //                                                     .iScreen(1.5),
              //                                                 color:
              //                                                     Colors.black54,
              //                                                 fontWeight:
              //                                                     FontWeight
              //                                                         .normal),
              //                                         overflow:
              //                                             TextOverflow.ellipsis,
              //                                       ),
              //                                     ),
              //                                     Container(
              //                                       // color: Colors.green,
              //                                       width: size.wScreen(50.0),
              //                                       child: Text(
              //                                         _prefacturas['venFecReg'] !=
              //                                                 ''
              //                                             ? '${_prefacturas['venFecReg'].replaceAll('T', "  ").replaceAll('.000Z', "  ")}'
              //                                             : '--- --- ---',
              //                                         style:
              //                                             GoogleFonts.lexendDeca(
              //                                                 // fontSize: size.iScreen(2.45),
              //                                                 color: Colors.grey,
              //                                                 fontWeight:
              //                                                     FontWeight
              //                                                         .normal),
              //                                       ),
              //                                     ),
              //                                   ],
              //                                 ),
              //                                 Container(
              //                                   // color: Colors.green,
              //                                   // width: size.wScreen(100.0),
              //                                   child: Text(
              //                                     '\$${_prefacturas['venTotal']}',
              //                                     style: GoogleFonts.lexendDeca(
              //                                         fontSize: size.iScreen(2.0),
              //                                         color: Colors.black87,
              //                                         fontWeight:
              //                                             FontWeight.normal),
              //                                     overflow: TextOverflow.ellipsis,
              //                                   ),
              //                                 ),
              //                               ],
              //                             ),
              //                             // trailing: Icon(Icons.more_vert),
              //                           ),
              //                         ),
              //                       ),
              //                     );
              //                   } else {
              //                     return Consumer<PreFacturasController>(
              //                       builder: (_, valueNext, __) {
              //                         return valueNext.getpage == null
              //                             ? Container(
              //                                 margin: EdgeInsets.symmetric(
              //                                     vertical: size.iScreen(2.0)),
              //                                 child: Center(
              //                                   child: Text(
              //                                     'No existen más datos',
              //                                     style: GoogleFonts.lexendDeca(
              //                                         fontSize: size.iScreen(1.8),
              //                                         // color: primaryColor,
              //                                         fontWeight:
              //                                             FontWeight.normal),
              //                                   ),
              //                                 ))
              //                             // : Container();
                          
              //                             : providersPrefacturas
              //                                         .getListaPreFacturasPaginacion
              //                                         .length >
              //                                     25
              //                                 ? Container(
              //                                     margin: EdgeInsets.symmetric(
              //                                         vertical:
              //                                             size.iScreen(2.0)),
              //                                     child: const Center(
              //                                         child:
              //                                             CircularProgressIndicator()))
              //                                 : Container();
              //                       },
              //                     );
              //                   }
              //                 },
              //               ),
              //             );
                       
              //           },
              //         )
              //       ,
            ],
          ),
        ),
      ],
    ),
  ),
),

          //  Container(
          //   color: Colors.grey.shade100,
          //   width: size.wScreen(100.0),
          //   height: size.hScreen(100.0),
          //   padding: EdgeInsets.only(
          //     top: size.iScreen(0.0),
          //     right: size.iScreen(0.0),
          //     left: size.iScreen(0.0),
          //   ),
          //   child: 
          //    Consumer<PreFacturasController>(
          //               builder: (_, providersPrefacturas, __) {
          //                 if (providersPrefacturas
          //                             .getErrorPreFacturasPaginacion ==
          //                         null &&
          //                     providersPrefacturas
          //                             .getError401PreFacturasPaginacion ==
          //                         false) {
          //                   return Center(
          //                     // child: CircularProgressIndicator(),
          //                     child: Column(
          //                       mainAxisSize: MainAxisSize.min,
          //                       children: [
          //                         Text(
          //                           'Cargando Datos...',
          //                           style: GoogleFonts.lexendDeca(
          //                               fontSize: size.iScreen(1.5),
          //                               color: Colors.black87,
          //                               fontWeight: FontWeight.bold),
          //                         ),
          //                         //***********************************************/
          //                         SizedBox(
          //                           height: size.iScreen(1.0),
          //                         ),
          //                         //*****************************************/
          //                         const CircularProgressIndicator(),
          //                       ],
          //                     ),
          //                   );
          //                 } else if (providersPrefacturas
          //                         .getErrorPreFacturasPaginacion ==
          //                     false) {
          //                   return const NoData(
          //                     label: 'No existen datos para mostar',
          //                   );
          //                 } else if (providersPrefacturas
          //                         .getListaPreFacturasPaginacion.isEmpty &&
          //                     providersPrefacturas
          //                             .getErrorPreFacturasPaginacion ==
          //                         false) {
          //                   return const NoData(
          //                     label: 'No existen datos para mostar',
          //                   );
          //                 } else if (providersPrefacturas
          //                         .getListaPreFacturasPaginacion.isEmpty &&
          //                     providersPrefacturas
          //                             .getError401PreFacturasPaginacion ==
          //                         true) {
          //                   return const NoData(
          //                     label:
          //                         'Su sesión ha expirado, vuelva a iniciar sesión',
          //                   );
          //                 } else if (providersPrefacturas
          //                         .getListaPreFacturasPaginacion.isEmpty &&
          //                     providersPrefacturas
          //                             .getError401PreFacturasPaginacion ==
          //                         false) {
          //                   return const NoData(
          //                     label: 'No existen datos para mostar',
          //                   );
          //                 }

          //                 return RefreshIndicator(
          //                    onRefresh: () => onRefresh(),
          //                   child: ListView.builder(
          //                     controller: _scrollController,
          //                     physics: const BouncingScrollPhysics(),
          //                     itemCount: providersPrefacturas
          //                             .getListaPreFacturasPaginacion.length +
          //                         1,
          //                     itemBuilder: (BuildContext context, int index) {
          //                       if (index <
          //                           providersPrefacturas
          //                               .getListaPreFacturasPaginacion.length) {
          //                         var _color;
          //                         final _prefacturas = providersPrefacturas
          //                             .getListaPreFacturasPaginacion[index];
                          
          //                         if (_prefacturas['cajaEstado'] == 'AUTORIZADO') {
          //                           _color = Colors.green;
          //                         } else if (_prefacturas['cajaEstado'] ==
          //                             'SIN AUTORIZAR') {
          //                           _color = Colors.orange;
          //                         }
          //                         if (_prefacturas['cajaEstado'] == 'ANULADA') {
          //                           _color = Colors.red;
          //                         }
                          
          //                         return Slidable(
          //                           startActionPane: ActionPane(
          //                             // A motion is a widget used to control how the pane animates.
          //                             motion: const ScrollMotion(),
                          
          //                             children: [
          //                               SlidableAction(
          //                                     backgroundColor: Colors.grey,
          //                                 foregroundColor: Colors.white,
          //                                 icon: Icons.list_alt_outlined,
          //                                 label: 'Más acciones',
          //                                 onPressed: (context) {
          //                                   showCupertinoModalPopup(
          //                                     context: context,
          //                                     builder: (BuildContext context) =>
          //                                         CupertinoActionSheet(
          //                                             title: Text(
          //                                               'Acciones',
          //                                               style: GoogleFonts
          //                                                   .lexendDeca(
          //                                                       fontSize: size
          //                                                           .iScreen(2.0),
          //                                                       color:
          //                                                           primaryColor,
          //                                                       fontWeight:
          //                                                           FontWeight
          //                                                               .normal),
          //                                             ),
          //                                             // message: const Text('Your options are '),
          //                                             actions: <Widget>[
          //                                               CupertinoActionSheetAction(
          //                                                 child: Row(
          //                                                   mainAxisAlignment:
          //                                                       MainAxisAlignment
          //                                                           .center,
          //                                                   children: [
          //                                                     Container(
          //                                                       margin: EdgeInsets.only(
          //                                                           right: size
          //                                                               .iScreen(
          //                                                                   2.0)),
          //                                                       child: Text(
          //                                                         'Ver PDF',
          //                                                         style: GoogleFonts.lexendDeca(
          //                                                             fontSize: size
          //                                                                 .iScreen(
          //                                                                     1.8),
          //                                                             color: Colors
          //                                                                 .black87,
          //                                                             fontWeight:
          //                                                                 FontWeight
          //                                                                     .normal),
          //                                                       ),
          //                                                     ),
          //                                                     const Icon(
          //                                                       FontAwesomeIcons
          //                                                           .filePdf,
          //                                                       color: Colors.red,
          //                                                     )
          //                                                   ],
          //                                                 ),
          //                                                 onPressed: () {
          //                                                   Navigator.pop(
          //                                                       context);
                          
          //                                                   Navigator.push(
          //                                                     context,
          //                                                     MaterialPageRoute(
          //                                                         builder: (context) =>
          //                                                             ViewsPDFs(
          //                                                                 infoPdf:
          //                                                                     // 'https://sysvet.neitor.com/reportes/carnet.php?id=${factura['venId']}&empresa=${_usuario!.rucempresa}',
          //                                                                     'https://syscontable.neitor.com/reportes/factura.php?codigo=${_prefacturas['venId']}&empresa=${_usuario!.rucempresa}',
          //                                                                 labelPdf:
          //                                                                     'infoFactura.pdf')),
          //                                                   );
          //                                                 },
          //                                               ),
          //                                             ],
          //                                             cancelButton:
          //                                                 CupertinoActionSheetAction(
          //                                               child: Text('Cancel',
          //                                                   style: GoogleFonts
          //                                                       .lexendDeca(
          //                                                           fontSize: size
          //                                                               .iScreen(
          //                                                                   2.0),
          //                                                           color: Colors
          //                                                               .red,
          //                                                           fontWeight:
          //                                                               FontWeight
          //                                                                   .normal)),
          //                                               isDefaultAction: true,
          //                                               onPressed: () {
          //                                                 Navigator.pop(
          //                                                     context, 'Cancel');
          //                                               },
          //                                             )),
          //                                   );
          //                                 },
          //                               ),
          //                             ],
          //                           ),
          //                           child: Card(
          //                             elevation: 5,
          //                             child: Container(
          //                               margin: EdgeInsets.only(
          //                                   bottom: size.iScreen(0.0)),
          //                               color: index % 2 == 0
          //                                   ? Colors.grey.shade50
          //                                   : Colors.grey.shade200,
          //                               child: ListTile(
          //                                 dense: true,
          //                                 visualDensity:
          //                                     VisualDensity.comfortable,
                                      
          //                                  leading: CircleAvatar(
          //                                   child: Text(
          //                                      '${_prefacturas['venNomCliente'].substring(0, 1)}',
          //                                     style: Theme.of(context)
          //                                         .textTheme
          //                                         .subtitle1,
          //                                   ),
          //                                   backgroundColor: Colors.grey[300],
          //                                 ),
          //                                 title: Row(
          //                                   mainAxisAlignment:
          //                                       MainAxisAlignment.spaceBetween,
          //                                   children: [
          //                                     SizedBox(
          //                                       width: size.wScreen(40.0),
          //                                       child: Text(
          //                                         '${_prefacturas['venNomCliente']}',
          //                                         style: GoogleFonts.lexendDeca(
          //                                             // fontSize: size.iScreen(2.45),
          //                                             // color: Colors.white,
          //                                             fontWeight:
          //                                                 FontWeight.normal),
          //                                         overflow: TextOverflow.ellipsis,
          //                                       ),
          //                                     ),
          //                                     Text(
          //                                       '${_prefacturas['cajaEstado']}',
          //                                       // 'Estado: ',
          //                                       style: GoogleFonts.lexendDeca(
          //                                           fontSize: size.iScreen(1.5),
          //                                           color: _color,
          //                                           fontWeight: FontWeight.bold),
          //                                     ),
          //                                   ],
          //                                 ),
          //                                 subtitle: Row(
          //                                   mainAxisAlignment:
          //                                       MainAxisAlignment.spaceBetween,
          //                                   children: [
          //                                     Column(
          //                                       mainAxisAlignment:
          //                                           MainAxisAlignment.start,
          //                                       children: [
          //                                         Container(
          //                                           // color: Colors.green,
          //                                           width: size.wScreen(50.0),
          //                                           child: Text(
          //                                             '${_prefacturas['venNumFactura']}',
          //                                             style:
          //                                                 GoogleFonts.lexendDeca(
          //                                                     fontSize: size
          //                                                         .iScreen(1.5),
          //                                                     color:
          //                                                         Colors.black54,
          //                                                     fontWeight:
          //                                                         FontWeight
          //                                                             .normal),
          //                                             overflow:
          //                                                 TextOverflow.ellipsis,
          //                                           ),
          //                                         ),
          //                                         Container(
          //                                           // color: Colors.green,
          //                                           width: size.wScreen(50.0),
          //                                           child: Text(
          //                                             _prefacturas['venFecReg'] !=
          //                                                     ''
          //                                                 ? '${_prefacturas['venFecReg'].replaceAll('T', "  ").replaceAll('.000Z', "  ")}'
          //                                                 : '--- --- ---',
          //                                             style:
          //                                                 GoogleFonts.lexendDeca(
          //                                                     // fontSize: size.iScreen(2.45),
          //                                                     color: Colors.grey,
          //                                                     fontWeight:
          //                                                         FontWeight
          //                                                             .normal),
          //                                           ),
          //                                         ),
          //                                       ],
          //                                     ),
          //                                     Container(
          //                                       // color: Colors.green,
          //                                       // width: size.wScreen(100.0),
          //                                       child: Text(
          //                                         '\$${_prefacturas['venTotal']}',
          //                                         style: GoogleFonts.lexendDeca(
          //                                             fontSize: size.iScreen(2.0),
          //                                             color: Colors.black87,
          //                                             fontWeight:
          //                                                 FontWeight.normal),
          //                                         overflow: TextOverflow.ellipsis,
          //                                       ),
          //                                     ),
          //                                   ],
          //                                 ),
          //                                 // trailing: Icon(Icons.more_vert),
          //                               ),
          //                             ),
          //                           ),
          //                         );
          //                       } else {
          //                         return Consumer<PreFacturasController>(
          //                           builder: (_, valueNext, __) {
          //                             return valueNext.getpage == null
          //                                 ? Container(
          //                                     margin: EdgeInsets.symmetric(
          //                                         vertical: size.iScreen(2.0)),
          //                                     child: Center(
          //                                       child: Text(
          //                                         'No existen más datos',
          //                                         style: GoogleFonts.lexendDeca(
          //                                             fontSize: size.iScreen(1.8),
          //                                             // color: primaryColor,
          //                                             fontWeight:
          //                                                 FontWeight.normal),
          //                                       ),
          //                                     ))
          //                                 // : Container();
                          
          //                                 : providersPrefacturas
          //                                             .getListaPreFacturasPaginacion
          //                                             .length >
          //                                         25
          //                                     ? Container(
          //                                         margin: EdgeInsets.symmetric(
          //                                             vertical:
          //                                                 size.iScreen(2.0)),
          //                                         child: const Center(
          //                                             child:
          //                                                 CircularProgressIndicator()))
          //                                     : Container();
          //                           },
          //                         );
          //                       }
          //                     },
          //                   ),
          //                 );
          //               },
          //             )
          //           ,
          // ),
     
     
     
     
          floatingActionButton: 

         Row(
          mainAxisAlignment: MainAxisAlignment.end,
           children: [
            Consumer<CajaController>(builder: (_, valueTot, __) {  
              return  Container(
              height: size.iScreen(5.0),
  padding: EdgeInsets.symmetric(horizontal:size.iScreen(2.0)), // Espaciado interno
  margin: EdgeInsets.all(2.0), // Espaciado externo
  decoration: BoxDecoration(
    color: Colors.grey, // Color de fondo
    borderRadius: BorderRadius.circular(8.0), // Bordes redondeados
    boxShadow: [
      BoxShadow(
        color: Colors.black26,
        offset: Offset(2, 2),
        blurRadius: 6.0,
      ),
    ],
  ),
  child: Center(
    child: Column(
      children: [
        Text(
          'Ingreso', // Monto a mostrar
          style: TextStyle(
            color: Colors.black,
            fontSize: size.iScreen(1.5),
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          valueTot.getTotalesFlotantes['Ingreso']!=null?'\$ ${valueTot.getTotalesFlotantes['Ingreso']}':'0.0', // Monto a mostrar
          style: TextStyle(
            color: Colors.white,
            fontSize: size.iScreen(1.8),
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    ),
  ),
);

            },),
            Consumer<CajaController>(builder: (_, valueTot, __) {  
              return  Container(
              height: size.iScreen(5.0),
  padding: EdgeInsets.symmetric(horizontal:size.iScreen(2.0)), // Espaciado interno
  margin: EdgeInsets.all(2.0), // Espaciado externo
  decoration: BoxDecoration(
    color: Colors.grey, // Color de fondo
    borderRadius: BorderRadius.circular(8.0), // Bordes redondeados
    boxShadow: [
      BoxShadow(
        color: Colors.black26,
        offset: Offset(2, 2),
        blurRadius: 6.0,
      ),
    ],
  ),
  child: Center(
    child: Column(
      children: [
        Text(
          'Egreso', // Monto a mostrar
          style: TextStyle(
            color: Colors.black,
            fontSize: size.iScreen(1.5),
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
        valueTot.getTotalesFlotantes['Egreso']!=null? '\$ ${valueTot.getTotalesFlotantes['Egreso']}':'0.0',// Monto a mostrar
          style: TextStyle(
            color: Colors.white,
            fontSize: size.iScreen(1.8),
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    ),
  ),
);

            },),
             Consumer<CajaController>(builder: (_, valueTot, __) {  
              return  Container(
              height: size.iScreen(5.0),
  padding: EdgeInsets.symmetric(horizontal:size.iScreen(2.0)), // Espaciado interno
  margin: EdgeInsets.all(2.0), // Espaciado externo
  decoration: BoxDecoration(
    color: Colors.grey, // Color de fondo
    borderRadius: BorderRadius.circular(8.0), // Bordes redondeados
    boxShadow: [
      BoxShadow(
        color: Colors.black26,
        offset: Offset(2, 2),
        blurRadius: 6.0,
      ),
    ],
  ),
  child: Center(
    child: Column(
      children: [
        Text(
          'Crédito', // Monto a mostrar
          style: TextStyle(
            color: Colors.black,
            fontSize: size.iScreen(1.5),
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          valueTot.getTotalesFlotantes['Credito']!=null? '\$ ${valueTot.getTotalesFlotantes['Credito']}':'0.0', // Monto a mostrar
          style: TextStyle(
            color: Colors.white,
            fontSize: size.iScreen(1.8),
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    ),
  ),
);

            },),
           



           
             FloatingActionButton(
                          child: const Icon(
                            Icons.add,
                            color: Colors.white,
                          ),
                          onPressed: () {
                           
   //*************** RESET LA VARIABLE DE RESPONSE SOCKET***************************//
     final ctrlSocket=context.read<SocketService>();
     ctrlSocket.resetResponseSocket();
   //******************************************//
                             final _ctrl =context.read<CajaController>();
                               _ctrl.setTipo('EFECTIVO');
                                   _ctrl.setTipoDocumento('EGRESO');
                                     _ctrl.setMonto(0.0);
                                   _ctrl.setAutorizacion('');
                                       _ctrl.setDetalle('');
                                        _ctrl.setTabIndex(0);
                               
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                         CreaCaja(
                                          user:_usuario ,
                                          tipo: 'CREATE',
                                        )));
                           
                          }
                      
                ,
              ),
           ],
         ),
          



  //   Row(
  //         mainAxisAlignment: MainAxisAlignment.end,
  //         children: [
  //           // Primer FloatingActionButton con imagen 1
  //           FloatingActionButton(
  //             backgroundColor:themeColor.appTheme.primaryColor,
  //             onPressed: () {
  //               // Acción del primer botón
  //               print("Botón 1 presionado");

  //                    final _ctrl =context.read<ComprobantesController>();
  //                         _ctrl.resetListasProdutos();
  //                         _ctrl.resetPlacas();
  //                               _ctrl.setDocumento('');
                                 
  //                                    //*************** RESET LA VARIABLE DE RESPONSE SOCKET***************************//
  //   final ctrlSocket=context.read<SocketService>();
  //    ctrlSocket.resetResponseSocket();
  //     //******************************************//

  //                               _ctrl.setFacturaOk(false);
  //                                _ctrl.setExistCliente(true);
  //                                  _ctrl.setFormaDePago('EFECTIVO');
  //                               _ctrl.setTipoDeTransaccion('N');
  //  _ctrl.setClienteComprbante({
	// 		"perId": 1,
	// 		"perNombre": "CONSUMIDOR FINAL",
	// 		"perDocNumero": "9999999999999",
	// 		"perDocTipo": "RUC",
	// 		"perTelefono": "0000000001",
	// 		"perDireccion": "s/n",
	// 		"perEmail": [
	// 			"sin@sincorreo.com"
	// 		],
	// 		"perCelular": [],
	// 		"perOtros": [
	// 			"ZZZ9999"
	// 		]
	// 	});
  
  //                             _ctrl.setTotal();
  //                             _ctrl.setTarifa({});
  //                              _ctrl.setTipoDocumento('');
                           
  //                      _ctrl.setTypeAction('MOTOS');
                           
  //                           Navigator.of(context).push(MaterialPageRoute(
  //                               builder: (context) =>
  //                                    CrearComprobante(
                                    
  //                                     user:_usuario ,
  //                                     tipo: 'CREATE',
  //                                   )));



  //             },
  //             child: Icon(Icons.two_wheeler_outlined,size:size.iScreen(4.5)), // Imagen 1
  //             heroTag: 'btn1', // Etiqueta única
  //           ),
  //           SizedBox(width: 20), // Espacio entre los dos botones
  //           // Segundo FloatingActionButton con imagen 2
  //           FloatingActionButton(
  //             backgroundColor: themeColor.appTheme.accentColor,
  //             onPressed: () {
  //               // Acción del segundo botón
  //               print("Botón 2 presionado");


  //                    final _ctrl =context.read<ComprobantesController>();
  //                         _ctrl.resetListasProdutos();
  //                         _ctrl.resetPlacas();
  //                               _ctrl.setDocumento('');
                                 
  //                                    //*************** RESET LA VARIABLE DE RESPONSE SOCKET***************************//
  //   final ctrlSocket=context.read<SocketService>();
  //    ctrlSocket.resetResponseSocket();
  //     //******************************************//

  //                               _ctrl.setFacturaOk(false);
  //                                _ctrl.setExistCliente(true);
  //                                  _ctrl.setFormaDePago('EFECTIVO');
  //                               _ctrl.setTipoDeTransaccion('N');
  //  _ctrl.setClienteComprbante({
	// 		"perId": 1,
	// 		"perNombre": "CONSUMIDOR FINAL",
	// 		"perDocNumero": "9999999999999",
	// 		"perDocTipo": "RUC",
	// 		"perTelefono": "0000000001",
	// 		"perDireccion": "s/n",
	// 		"perEmail": [
	// 			"sin@sincorreo.com"
	// 		],
	// 		"perCelular": [],
	// 		"perOtros": [
	// 			"ZZZ9999"
	// 		]
	// 	});
  
  //                             _ctrl.setTotal();
  //                             _ctrl.setTarifa({});
  //                              _ctrl.setTipoDocumento('');
                           
  //                      _ctrl.setTypeAction('VEHICULOS');
                           
  //                           Navigator.of(context).push(MaterialPageRoute(
  //                               builder: (context) =>
  //                                    CrearComprobante(
                                        
  //                                     user:_usuario ,
  //                                     tipo: 'CREATE',
  //                                   )));




  //             },
  //             child: Icon(Icons.drive_eta_outlined,size:size.iScreen(4.5)), // Imagen 2
  //             heroTag: 'btn2', // Etiqueta única
  //           ),
  //         ],
  //       ),


          
          ),
    );
  }

    Future<void> onRefresh() async {
    final _controller = Provider.of<CajaController>(context, listen: false);
    _controller.setPage(0);
    _controller.setCantidad(1000);
    _controller.buscaAllCajaPaginacion('', true,_controller.getTabIndex);
       _controller.obtieneTotalDiario('cajas','');
         _controller.obtieneTotalesFlotantes('');
  }

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


  //**********************************************MODAL TIPO  **********************************************************************//
  Future<bool?> modalBusquedaXUsuario(
      BuildContext context, Responsive size, Session user) {
    return showDialog<bool>(
      barrierColor: Colors.black54,
      context: context,
      builder: (context) {

       return AlertDialog(
          title: const Text("BUSCAR TOTALES DEL DÍA POR USUARIO"),
          content: SizedBox(
            width: size.wScreen(100),
            // height: size.hScreen(20.0), // Ajusta la altura según sea necesario
            child: Column(
              mainAxisSize:MainAxisSize.min,
              children: [
                Consumer<CajaController>(builder: (_, value, __) {  

                      
                            return 
                            
                              Column(
                                children: [
                                  TextFormField(
                       
                           
                            decoration: InputDecoration(
                                  label:  const Text( 'Ingrese Usuario'),
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
                        value.setBusquedaUser(text);
                      },
                      validator: (text) {
                        if (text!.trim().isNotEmpty) {
                          return null;
                        } else {
                          return 'Ingrese campo de busqueda';
                        }
                      },

                          ),
                           //***********************************************/
                            SizedBox(
                              height: size.iScreen(2.0),
                            ),
                            //*****************************************/
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [

                              Row(
                                children: [
                                  Text('Fecha: ',
                                      style: GoogleFonts.lexendDeca(
                                          // fontSize: size.iScreen(2.0),
                                          fontWeight: FontWeight.normal,
                                          color: Colors.grey)),
                                          Consumer<CajaController>(builder: (_, value,__) { 
                                            return  Text(' ${value.getFechaCaja}',
                                  style: GoogleFonts.lexendDeca(
                                      fontSize: size.iScreen(2.5),
                                      fontWeight: FontWeight.normal,
                                      color: Colors.black));
                                           },)
                                         
                                ],
                              ),
                                      
                                          ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: GestureDetector(
                                onTap: () {

                                        _fechaCaja(context,value);

//*******************************************/
                                },
                                child: 
                                
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
                                        Icons.calendar_month_outlined,
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
                              height: size.iScreen(1.0),
                            ),
                            //*****************************************/   
                            Row( 
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                TextButton(
                        onPressed: () {
                      // Validar si el campo de texto no está vacío
                        if (value.getBusquedaUser.trim().isEmpty) {
                          // Si está vacío, mostrar un mensaje de error
                          ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('El campo no puede estar vacío')),
                          );
                        } else {
                         
                         value.obtieneTotalesFlotantes(value.getBusquedaUser);
                         Navigator.pop(context);
                         
                        }
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
                          child: Text('Buscar',
                                  style: GoogleFonts.lexendDeca(
                                      fontSize: size.iScreen(2.0),
                                      fontWeight: FontWeight.normal,
                                      color: Colors.white)),
                        );

                       },),
                        
                        
                     
                    ),
                    ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: GestureDetector(
                                onTap: () async{

                               //*******************************************//
                               if (value.getBusquedaUser.isNotEmpty) {
                                 ProgressDialog.show(context);
                                     await value.obtieneTotalesFlotantes(value.getBusquedaUser);
            ProgressDialog.dissmiss(context);
                                 
                                   // Verificar si 'Ingreso', 'Egreso' y 'Credito' no son null
                                    if (value.getTotalesFlotantes['Ingreso'] != null &&
                                        value.getTotalesFlotantes['Egreso'] != null &&
                                        value.getTotalesFlotantes['Credito'] != null) {

                                              final _dataPrint={
                                                "logo":user.logo.toString(),
                                                "usuario":user.usuario,
                                                "fecha":value.getFechaCaja,
                                                "ingreso":value.getTotalesFlotantes['Ingreso'],
                                                "egreso":value.getTotalesFlotantes['Egreso'],
                                                "credito":value.getTotalesFlotantes['Credito']
                                              };

                                      // print('LA DATA PARA IMPRIMIR: $_dataPrint');
                                      _printTotalesPorUsuario(_dataPrint);
                                      Navigator.pop(context);

                                    } else {
                                      NotificatiosnService.showSnackBarError('NO HAY DATOS PARA IMPRIMIR');
                                    }



                               } else {
                                 NotificatiosnService.showSnackBarDanger('Ingrese Usuario');
                               }
                            
                        //  Navigator.pop(context);
                               
                               
                               //*******************************************//
                                },
                                child: 
                                
                                 Consumer<ThemeProvider>(builder: (_, valueTheme, __) {  
                                    return Container(
                                      alignment: Alignment.center,
                                      color: valueTheme.appTheme.accentColor,
                                      width: size.iScreen(5.0),
                                      height: size.iScreen(4.0),
                                      padding: EdgeInsets.only(
                                        top: size.iScreen(0.5),
                                        bottom: size.iScreen(0.5),
                                        left: size.iScreen(0.5),
                                        right: size.iScreen(0.5),
                                      ),
                                      child: Icon(
                                        Icons.print_outlined,
                                        color: Colors.white,
                                        size: size.iScreen(2.0),
                                      ),
                                    );
                                  },
                                  ),
                              ),
                            ),
                           
                              ],
                            )
                                ],
                              );
      

                },),
                
              ],
            ),
          ),
        );
      },
    );
  }

  _fechaCaja(BuildContext context, CajaController controller) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2024),
      lastDate: DateTime(2100),
      // locale: const Locale('es', 'ES'),
    );
    if (picked != null) {
      String? anio, mes, dia;
      anio = '${picked.year}';
      mes = (picked.month < 10) ? '0${picked.month}' : '${picked.month}';
      dia = (picked.day < 10) ? '0${picked.day}' : '${picked.day}';

      // setState(() {
      final _fechaInicio =
          '${anio.toString()}-${mes.toString()}-${dia.toString()}';
      // _fechaController.text = _fechaInicio;
      controller.setFechaCaja(_fechaInicio);
      // print('FechaInicio: $_fechaInicio');
      // });
    }
  }


  void _printTotalesPorUsuario(Map<String, dynamic>? _info,) async {

  if (_info == null) return;

// Función principal de impresión

  // Imprime el logo (si existe)
  if (_info['logo']!.isNotEmpty) {
    String url = _info['logo'];
    
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


// Imprime el resto de la información 
await SunmiPrinter.setAlignment(SunmiPrintAlign.LEFT);
await SunmiPrinter.printText('Usuario: ${validarCampo(_info['usuario'])}');

await SunmiPrinter.line();
await SunmiPrinter.printText('Fecha: ${_info['fecha']}'); // O utiliza formattedDate si corresponde
await SunmiPrinter.line();
await SunmiPrinter.printText('Ingreso: ${validarCampo(_info['ingreso'])}');
await SunmiPrinter.printText('Egreso: ${validarCampo(_info['egreso'])}');
await SunmiPrinter.printText('Crédito: ${validarCampo(_info['credito'])}');

await SunmiPrinter.line();

  await SunmiPrinter.lineWrap(2);
  await SunmiPrinter.exitTransactionPrint(true);
}

// Función para validar si una propiedad es null
String validarCampo(dynamic valor) {
  return valor == null || valor.toString().isEmpty ? '--- --- ---' : valor.toString();
}








