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
import 'package:neitorcont/src/controllers/cuentas_por_cobrar_controller.dart';
import 'package:neitorcont/src/controllers/prefacturas_controller.dart';

import 'package:neitorcont/src/controllers/proformas_controller.dart';

import 'package:neitorcont/src/models/sesison_model.dart';
import 'package:neitorcont/src/pages/crear_caja.dart';
import 'package:neitorcont/src/pages/crear_comprobante_print.dart';
import 'package:neitorcont/src/pages/crear_materiales.dart';
import 'package:neitorcont/src/pages/crear_pago_cuentas_por_cobrar.dart';
import 'package:neitorcont/src/pages/detalle_caja.dart';
import 'package:neitorcont/src/pages/detalle_cuentas_por_cobrar.dart';
import 'package:neitorcont/src/pages/views_pdf.dart';
import 'package:neitorcont/src/services/notifications_service.dart';
import 'package:neitorcont/src/services/socket_service.dart';
import 'package:neitorcont/src/theme/theme_provider.dart';
import 'package:neitorcont/src/theme/themes_app.dart';
import 'package:neitorcont/src/utils/fechaLocal.dart';
import 'package:neitorcont/src/utils/responsive.dart';
import 'package:neitorcont/src/utils/theme.dart';
import 'package:neitorcont/src/widgets/no_data.dart';
import 'package:provider/provider.dart';
import 'package:sunmi_printer_plus/column_maker.dart';
import 'package:sunmi_printer_plus/enums.dart';
import 'package:sunmi_printer_plus/sunmi_printer_plus.dart';

import 'package:image/image.dart' as img;




class ListarCuentasPorCobrar extends StatefulWidget {
     final Session? user;
  const ListarCuentasPorCobrar({Key? key, this.user}) : super(key: key);

  @override
  State<ListarCuentasPorCobrar> createState() =>
      _ListarCuentasPorCobrarState();
}

class _ListarCuentasPorCobrarState
    extends State<ListarCuentasPorCobrar> {
  final TextEditingController _textSearchController = TextEditingController();
  Session? _usuario;
  final _scrollController = ScrollController();

  @override
  void initState() {
    _scrollController.addListener(() {
      if (_scrollController.position.maxScrollExtent ==
          _scrollController.offset) {
        final _next = context.read<CuentasXCobrarController>();
        if (_next.getpage != null) {
          _next.setPage(_next.getpage);
                _next.setCantidad(25);
          _next.buscaAllCuentasPorCobrar('', false,0);
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
            title: Consumer<CuentasXCobrarController>(
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
                                  'CUENTAS POR COBRAR',
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
                                        .buscaAllCuentasPorCobrar(
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
                                providerSearchCaja.setCantidadElementos(25);
                                providerSearchCaja.buscaAllCuentasPorCobrar('', true,providerSearchCaja.getTabIndex);
                                // } //=====================//

                              }
                            }),
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
      // Aquí colocas el TabBar después del Container
      TabBar(
        labelStyle: TextStyle(
          fontSize: size.iScreen(2.5),
        ),
       tabs: [
            Tab(
              child:
              Consumer<CuentasXCobrarController>(builder: (_, valueHoy, __) {  
                return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('HOY', style: TextStyle(fontSize: size.iScreen(1.8))),
                  // Espacio entre los textos
                 Text(valueHoy.getTotalDiario.isNotEmpty?  '\$${valueHoy.getTotalDiario['total']}':'-- -- --', style: TextStyle(fontSize: size.iScreen(2.5))),
                ],
              );
              },)
               
            ),
            Tab(
              child:
              Consumer<CuentasXCobrarController>(builder: (_, valueAnteriores, __) {  
                return   Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('ANTERIORES',style: TextStyle(fontSize: size.iScreen(1.8))),
                   // Espacio entre los textos
                  //  Text('\$${valueAnteriores.totalGeneralAyer}', style: TextStyle(fontSize: size.iScreen(2.5))),
                ],
              );
              },)
              
             
            ),
            
          ],
           onTap: (index) {
                        // print('EL INDICE :$index');
                        final ctrl=context.read<CuentasXCobrarController>();
                       ctrl.setTabIndex(index);
                         ctrl.setPage(0);
                        if (  index==0) {
                        ctrl.setInfoBusquedaCuentasPorCobrar([]);
                          ctrl.resetValorTotal();
                          //   ctrl.buscaAllPreFacturasPaginacion(
                          //       '',false,ctrl.getTabIndex);

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
                        //      _controllerPreFacturas.resetValorTotal();
                              ctrl.restetTotalGenerales();
                            ctrl.setPage(0);
                            ctrl.setCantidadElementos(25);
                            ctrl.setIsNext(false);
                          
                            ctrl.buscaAllCuentasPorCobrar('', true,ctrl.getTabIndex);

                          ctrl.obtieneTotalDiario('cuentasporcobrar','');



                        }
                        if ( index==1) {
                             ctrl.setPage(0);
                           ctrl.setInfoBusquedaCuentasPorCobrar([]);
                          ctrl.resetValorTotal();
                        
                             ctrl.buscaAllCuentasPorCobrar(
                                '',false,ctrl.getTabIndex);
                                
                        }
                      },
        labelColor: Colors.blue,
          unselectedLabelColor: Colors.grey,
          indicatorColor: Colors.blue,
      ),
      
      // Agrega el contenido de cada tab
      Expanded(
        child: TabBarView(
          children: [
            //====================== TAB 1  ============================//

                Consumer<CuentasXCobrarController>(
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
                            child: ListView.builder(
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
                          
                                  if (_prefacturas['ccEstado'] == 'CANCELADO') {
                                    _color = Colors.green;
                                  } else if (_prefacturas['ccEstado'] ==
                                      'PENDIENTE') {
                                    _color = Colors.orange;
                                  }
                                  if (_prefacturas['ccEstado'] == 'ANULADA') {
                                    _color = Colors.red;
                                  }
 //==============================================//
  String fechaLocal = convertirFechaLocal(_prefacturas['ccFecReg']);
 //==============================================//
                                  return Slidable(
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
                                                             
                                                             _prefacturas['ccEstado'] != 'CANCELADO'?
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
                                                                  'Realizar Pago',
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
                                                               Icon(
                                                                FontAwesomeIcons
                                                                    .handHoldingUsd,
                                                                    
                                                                color: Colors.green,
                                                                 size: size.iScreen(3.5),
                                                              )
                                                            ],
                                                          ),
                                                          onPressed: () {
                                                             Navigator.pop(context);
                                                            provider.setTipo('EFECTIVO');
                                                             provider.setBanco('');
                                                              provider.setItemDeposito('NO');
                                                              provider.setUrlImge('');
                                                            provider.setInfoCuentas(_prefacturas);
                                                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context)=>
                                     CrearpagoCxC()));
                                                          
                                                          },
                                                        ):Container(),
                                                                
                                                                
                                                                
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
                                                               Icon(
                                                                FontAwesomeIcons
                                                                    .infoCircle,
                                                                    size: size.iScreen(3.5),
                                                                color: Colors.blue,
                                                              )
                                                            ],
                                                          ),
                                                          onPressed: () {
                                                            provider.setInfoCuentas(_prefacturas);
                                                            Navigator.pop(
                                                                context);
                          
                                                            Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder: (context) =>
                                                                     DetalleCuentasPorCobrar()),
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
                                          title: Column(
                                            children: [
                                              Container(
                                               width: size.wScreen(100.0),
                                                child: Text(
                                                  '${_prefacturas['ccNomCliente']}',
                                                  style: GoogleFonts.lexendDeca(
                                                      // fontSize: size.iScreen(2.45),
                                                      // color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ),
                                              Container(
                                               width: size.wScreen(100.0),
                                                child: Text(
                                                  '${_prefacturas['ccFactura']}',
                                                  style: GoogleFonts.lexendDeca(
                                                      // fontSize: size.iScreen(2.45),
                                                      // color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.spaceBetween,
                                                children: [
                                                  
                                                  Row(
                                                    children: [
                                                      SizedBox(
                                                        // width: size.wScreen(40.0),
                                                        child: Text(
                                                          'Fecha: ',
                                                          style: GoogleFonts.lexendDeca(
                                                              fontSize: size.iScreen(1.7),
                                                              color: Colors.grey,
                                                              fontWeight:
                                                                  FontWeight.normal),
                                                          overflow: TextOverflow.ellipsis,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: size.wScreen(50.0),
                                                        child: Text(
                                                          '${_prefacturas['ccFechaFactura']}',
                                                          style: GoogleFonts.lexendDeca(
                                                              // fontSize: size.iScreen(2.45),
                                                              // color: Colors.white,
                                                              fontWeight:
                                                                  FontWeight.bold),
                                                          overflow: TextOverflow.ellipsis,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Text(
                                                    '${_prefacturas['ccEstado']}',
                                                    // 'Estado: ',
                                                    style: GoogleFonts.lexendDeca(
                                                        fontSize: size.iScreen(1.5),
                                                        color: _color,
                                                        fontWeight: FontWeight.bold),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          subtitle: 
                                          Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                     Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.spaceBetween,
                                                children: [
                                                  
                                                  Row(
                                                    children: [
                                                      SizedBox(
                                                        // width: size.wScreen(40.0),
                                                        child: Text(
                                                          'Procedencia: ',
                                                          style: GoogleFonts.lexendDeca(
                                                              fontSize: size.iScreen(1.7),
                                                              color: Colors.grey,
                                                              fontWeight:
                                                                  FontWeight.normal),
                                                          overflow: TextOverflow.ellipsis,
                                                        ),
                                                      ),
                                                      Container(
                                                          // color: Colors.green,
                                                          // width: size.wScreen(50.0),
                                                          child: Text(
                                                            '${_prefacturas['ccProcedencia']}',
                                                            style:
                                                                GoogleFonts.lexendDeca(
                                                                    fontSize: size
                                                                        .iScreen(1.5),
                                                                    color:Colors.black,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                            overflow:
                                                                TextOverflow.ellipsis,
                                                          ),
                                                  )
                                                     
                                                    ],
                                                  ),
                                                   
                                                ],
                                              ),
                                                Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.spaceBetween,
                                                children: [
                                                  
                                                  Row(
                                                    children: [
                                                      SizedBox(
                                                        // width: size.wScreen(40.0),
                                                        child: Text(
                                                          'Fecha Abono : ',
                                                          style: GoogleFonts.lexendDeca(
                                                              fontSize: size.iScreen(1.7),
                                                              color: Colors.grey,
                                                              fontWeight:
                                                                  FontWeight.normal),
                                                          overflow: TextOverflow.ellipsis,
                                                        ),
                                                      ),
                                                      Container(
                                                          // color: Colors.green,
                                                          // width: size.wScreen(50.0),
                                                          child: Text(
                                                            '${_prefacturas['ccFechaAbono']}',
                                                            style:
                                                                GoogleFonts.lexendDeca(
                                                                    fontSize: size
                                                                        .iScreen(1.5),
                                                                    color:Colors.black,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                            overflow:
                                                                TextOverflow.ellipsis,
                                                          ),
                                                  )
                                                     
                                                    ],
                                                  ),
                                                    Container(
                                                // color: Colors.green,
                                                // width: size.wScreen(100.0),
                                                child: Text(
                                                  '\$ ${_prefacturas['ccSaldo']}',
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
                                                   
                                                    Container(
                                                    // color: Colors.red,
                                                    width: size.wScreen(100.0),
                                                     child: Row(
                                                       children: [
                                                        Container(
                                                          // color: Colors.green,
                                                         
                                                          child: Text(
                                                            'Valor Factura : ',
                                                            style:
                                                                GoogleFonts.lexendDeca(
                                                                    fontSize: size
                                                                        .iScreen(1.7),
                                                                    color:
                                                                        Colors.grey,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .normal),
                                                            overflow:
                                                                TextOverflow.ellipsis,
                                                          ),
                                                          
                                                  ),
                                                         Container(
                                                          // color: Colors.green,
                                                          // width: size.wScreen(50.0),
                                                          child: Text(
                                                            '\$ ${_prefacturas['ccValorFactura']}',
                                                            style:
                                                                GoogleFonts.lexendDeca(
                                                                    fontSize: size
                                                                        .iScreen(1.7),
                                                                    color:Colors.black,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                            overflow:
                                                                TextOverflow.ellipsis,
                                                          ),
                                                  ),
                                                       ],
                                                     ),
                                                   ),
                                                    Container(
                                                    // color: Colors.red,
                                                    width: size.wScreen(100.0),
                                                     child: Row(
                                                       children: [
                                                        Container(
                                                          // color: Colors.green,
                                                         
                                                          child: Text(
                                                            'Valor Abono : ',
                                                            style:
                                                                GoogleFonts.lexendDeca(
                                                                    fontSize: size
                                                                        .iScreen(1.7),
                                                                    color:
                                                                        Colors.grey,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .normal),
                                                            overflow:
                                                                TextOverflow.ellipsis,
                                                          ),
                                                          
                                                  ),
                                                         Container(
                                                          // color: Colors.green,
                                                          // width: size.wScreen(50.0),
                                                          child: Text(
                                                            '\$ ${_prefacturas['ccAbono']}',
                                                            style:
                                                                GoogleFonts.lexendDeca(
                                                                    fontSize: size
                                                                        .iScreen(1.7),
                                                                    color:Colors.black,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                            overflow:
                                                                TextOverflow.ellipsis,
                                                          ),
                                                  ),
                                                       ],
                                                     ),
                                                   ),
                                                                 Container(
                                                    // color: Colors.red,
                                                    width: size.wScreen(100.0),
                                                     child: Row(
                                                       children: [
                                                        Container(
                                                          // color: Colors.green,
                                                         
                                                          child: Text(
                                                            'Conductor: ',
                                                            style:
                                                                GoogleFonts.lexendDeca(
                                                                    fontSize: size
                                                                        .iScreen(1.7),
                                                                    color:
                                                                        Colors.grey,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .normal),
                                                            overflow:
                                                                TextOverflow.ellipsis,
                                                          ),
                                                          
                                                  ),
                                                  //        Container(
                                                  //         // color: Colors.green,
                                                  //         // width: size.wScreen(50.0),
                                                  //         child: Text(
                                                  //          _prefacturas['ccConductor']!=null ?  ' ${_prefacturas['ccConductor']}':'--- --- --- ---',
                                                  //           style:
                                                  //               GoogleFonts.lexendDeca(
                                                  //                   fontSize: size
                                                  //                       .iScreen(1.7),
                                                  //                   color:Colors.black,
                                                  //                   fontWeight:
                                                  //                       FontWeight
                                                  //                           .bold),
                                                  //           overflow:
                                                  //               TextOverflow.ellipsis,
                                                  //         ),
                                                  // ),

                                                  Container(
  child: Text(
    _prefacturas['ccConductor'] != null && _prefacturas['ccConductor'].isNotEmpty 
      ? ' ${_prefacturas['ccConductor']}' 
      : '--- --- --- ---',
    style: GoogleFonts.lexendDeca(
      fontSize: size.iScreen(1.7),
      color: Colors.black,
      fontWeight: FontWeight.bold,
    ),
    overflow: TextOverflow.ellipsis,
  ),
)

                                                       ],
                                                     ),
                                                   ),
                                                 
                                                  Container(
                                                    // color: Colors.red,
                                                    width: size.wScreen(100.0),
                                                     child: Row(
                                                       children: [
                                                        Container(
                                                          // color: Colors.green,
                                                         
                                                          child: Text(
                                                            'Placa: ',
                                                            style:
                                                                GoogleFonts.lexendDeca(
                                                                    fontSize: size
                                                                        .iScreen(1.7),
                                                                    color:
                                                                        Colors.grey,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .normal),
                                                            overflow:
                                                                TextOverflow.ellipsis,
                                                          ),
                                                          
                                                  ),
                                                  //        Container(
                                                  //         // color: Colors.green,
                                                  //         // width: size.wScreen(50.0),
                                                  //         child: Text(
                                                  //            _prefacturas['ccOtrosDetalles']!=null ||  _prefacturas['ccOtrosDetalles'].isNotEmpty ? ' ${_prefacturas['ccOtrosDetalles']}':'--- --- --- ---',
                                                  //           style:
                                                  //               GoogleFonts.lexendDeca(
                                                  //                   fontSize: size
                                                  //                       .iScreen(1.7),
                                                  //                   color:Colors.black,
                                                  //                   fontWeight:
                                                  //                       FontWeight
                                                  //                           .bold),
                                                  //           overflow:
                                                  //               TextOverflow.ellipsis,
                                                  //         ),
                                                  // ),
                                                  Container(
  child: Text(
    _prefacturas['ccOtrosDetalles'] != null && _prefacturas['ccOtrosDetalles'].isNotEmpty 
      ? ' ${_prefacturas['ccOtrosDetalles']}'
      : '--- --- --- ---',
    style: GoogleFonts.lexendDeca(
      fontSize: size.iScreen(1.7),
      color: Colors.black,
      fontWeight: FontWeight.bold,
    ),
    overflow: TextOverflow.ellipsis,
  ),
)

                                                       ],
                                                     ),
                                                   ),
                                                 
                                               Container(
                                                    // color: Colors.red,
                                                    width: size.wScreen(100.0),
                                                     child: Column(
                                                       children: [
                                                        Container(
                                                          // color: Colors.green,
                                                         width: size.wScreen(100.0),
                                                          child: Text(
                                                            'Detalle: ',
                                                            style:
                                                                GoogleFonts.lexendDeca(
                                                                    fontSize: size
                                                                        .iScreen(1.7),
                                                                    color:
                                                                        Colors.grey,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .normal),
                                                            overflow:
                                                                TextOverflow.ellipsis,
                                                          ),
                                                          
                                                  ),
                                                  //        Container(
                                                  //         // color: Colors.green,
                                                  //         width: size.wScreen(100.0),
                                                  //         child: Text(
                                                  //              _prefacturas['ccObservacion']!=null ?  ' ${_prefacturas['ccObservacion']}':'--- --- --- ---',
                                                  //           style:
                                                  //               GoogleFonts.lexendDeca(
                                                  //                   fontSize: size
                                                  //                       .iScreen(1.7),
                                                  //                   color:Colors.black,
                                                  //                   fontWeight:
                                                  //                       FontWeight
                                                  //                           .bold),
                                                  //           overflow:
                                                  //               TextOverflow.ellipsis,
                                                  //         ),
                                                  // ),
                                                  Container(
  width: size.wScreen(100.0),
  child: Text(
    _prefacturas['ccObservacion'] != null && _prefacturas['ccObservacion'].isNotEmpty 
      ? ' ${_prefacturas['ccObservacion']}' 
      : '--- --- --- ---',
    style: GoogleFonts.lexendDeca(
      fontSize: size.iScreen(1.7),
      color: Colors.black,
      fontWeight: FontWeight.bold,
    ),
    overflow: TextOverflow.ellipsis,
  ),
)

                                                       ],
                                                     ),
                                                   ),
                                                 
                                              
                                              
                                                ],
                                              ),
                                              
                                              
                                          
                                          // Row(
                                          //   mainAxisAlignment:
                                          //       MainAxisAlignment.spaceBetween,
                                          //   children: [
                                              
                                          //     Container(
                                          //       // color: Colors.green,
                                          //       // width: size.wScreen(100.0),
                                          //       child: Text(
                                          //         '\$${_prefacturas['ccSaldo']}',
                                          //         style: GoogleFonts.lexendDeca(
                                          //             fontSize: size.iScreen(2.0),
                                          //             color: Colors.black87,
                                          //             fontWeight:
                                          //                 FontWeight.normal),
                                          //         overflow: TextOverflow.ellipsis,
                                          //       ),
                                          //     ),
                                          //   ],
                                          // ),
                                          // trailing: Icon(Icons.more_vert),
                                        ),
                                      ),
                                    ),
                                  );
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


                         
                        },
                      ),

            //=======================TAB 2============================//

              Consumer<CuentasXCobrarController>(
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
                            child: ListView.builder(
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
                          
                                  if (_prefacturas['ccEstado'] == 'CANCELADO') {
                                    _color = Colors.green;
                                  } else if (_prefacturas['ccEstado'] ==
                                      'PENDIENTE') {
                                    _color = Colors.orange;
                                  }
                                  if (_prefacturas['ccEstado'] == 'ANULADA') {
                                    _color = Colors.red;
                                  }
 //==============================================//
  String fechaLocal = convertirFechaLocal(_prefacturas['ccFecReg']);
 //==============================================//
                                  return Slidable(
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
                                                             
                                                             _prefacturas['ccEstado'] != 'CANCELADO'?
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
                                                                  'Realizar Pago',
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
                                                               Icon(
                                                                FontAwesomeIcons
                                                                    .handHoldingUsd,
                                                                    
                                                                color: Colors.green,
                                                                 size: size.iScreen(3.5),
                                                              )
                                                            ],
                                                          ),
                                                          onPressed: () {
                                                             Navigator.pop(context);
                                                            provider.setTipo('EFECTIVO');
                                                             provider.setBanco('');
                                                              provider.setItemDeposito('NO');
                                                              provider.setUrlImge('');
                                                            provider.setInfoCuentas(_prefacturas);
                                                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context)=>
                                     CrearpagoCxC()));
                                                          
                                                          },
                                                        ):Container(),
                                                                
                                                                
                                                                
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
                                                               Icon(
                                                                FontAwesomeIcons
                                                                    .infoCircle,
                                                                    size: size.iScreen(3.5),
                                                                color: Colors.blue,
                                                              )
                                                            ],
                                                          ),
                                                          onPressed: () {
                                                            provider.setInfoCuentas(_prefacturas);
                                                            Navigator.pop(
                                                                context);
                          
                                                            Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder: (context) =>
                                                                     DetalleCuentasPorCobrar()),
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
                                          title: Column(
                                            children: [
                                              Container(
                                               width: size.wScreen(100.0),
                                                child: Text(
                                                  '${_prefacturas['ccNomCliente']}',
                                                  style: GoogleFonts.lexendDeca(
                                                      // fontSize: size.iScreen(2.45),
                                                      // color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ),
                                              Container(
                                               width: size.wScreen(100.0),
                                                child: Text(
                                                  '${_prefacturas['ccFactura']}',
                                                  style: GoogleFonts.lexendDeca(
                                                      // fontSize: size.iScreen(2.45),
                                                      // color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.spaceBetween,
                                                children: [
                                                  
                                                  Row(
                                                    children: [
                                                      SizedBox(
                                                        // width: size.wScreen(40.0),
                                                        child: Text(
                                                          'Fecha: ',
                                                          style: GoogleFonts.lexendDeca(
                                                              fontSize: size.iScreen(1.7),
                                                              color: Colors.grey,
                                                              fontWeight:
                                                                  FontWeight.normal),
                                                          overflow: TextOverflow.ellipsis,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: size.wScreen(50.0),
                                                        child: Text(
                                                          '${_prefacturas['ccFechaFactura']}',
                                                          style: GoogleFonts.lexendDeca(
                                                              // fontSize: size.iScreen(2.45),
                                                              // color: Colors.white,
                                                              fontWeight:
                                                                  FontWeight.bold),
                                                          overflow: TextOverflow.ellipsis,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Text(
                                                    '${_prefacturas['ccEstado']}',
                                                    // 'Estado: ',
                                                    style: GoogleFonts.lexendDeca(
                                                        fontSize: size.iScreen(1.5),
                                                        color: _color,
                                                        fontWeight: FontWeight.bold),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          subtitle: 
                                          Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                     Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.spaceBetween,
                                                children: [
                                                  
                                                  Row(
                                                    children: [
                                                      SizedBox(
                                                        // width: size.wScreen(40.0),
                                                        child: Text(
                                                          'Procedencia: ',
                                                          style: GoogleFonts.lexendDeca(
                                                              fontSize: size.iScreen(1.7),
                                                              color: Colors.grey,
                                                              fontWeight:
                                                                  FontWeight.normal),
                                                          overflow: TextOverflow.ellipsis,
                                                        ),
                                                      ),
                                                      Container(
                                                          // color: Colors.green,
                                                          // width: size.wScreen(50.0),
                                                          child: Text(
                                                            '${_prefacturas['ccProcedencia']}',
                                                            style:
                                                                GoogleFonts.lexendDeca(
                                                                    fontSize: size
                                                                        .iScreen(1.5),
                                                                    color:Colors.black,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                            overflow:
                                                                TextOverflow.ellipsis,
                                                          ),
                                                  )
                                                     
                                                    ],
                                                  ),
                                                   
                                                ],
                                              ),
                                                Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.spaceBetween,
                                                children: [
                                                  
                                                  Row(
                                                    children: [
                                                      SizedBox(
                                                        // width: size.wScreen(40.0),
                                                        child: Text(
                                                          'Fecha Abono : ',
                                                          style: GoogleFonts.lexendDeca(
                                                              fontSize: size.iScreen(1.7),
                                                              color: Colors.grey,
                                                              fontWeight:
                                                                  FontWeight.normal),
                                                          overflow: TextOverflow.ellipsis,
                                                        ),
                                                      ),
                                                      Container(
                                                          // color: Colors.green,
                                                          // width: size.wScreen(50.0),
                                                          child: Text(
                                                            '${_prefacturas['ccFechaAbono']}',
                                                            style:
                                                                GoogleFonts.lexendDeca(
                                                                    fontSize: size
                                                                        .iScreen(1.5),
                                                                    color:Colors.black,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                            overflow:
                                                                TextOverflow.ellipsis,
                                                          ),
                                                  )
                                                     
                                                    ],
                                                  ),
                                                    Container(
                                                // color: Colors.green,
                                                // width: size.wScreen(100.0),
                                                child: Text(
                                                  '\$ ${_prefacturas['ccSaldo']}',
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
                                                   
                                                    Container(
                                                    // color: Colors.red,
                                                    width: size.wScreen(100.0),
                                                     child: Row(
                                                       children: [
                                                        Container(
                                                          // color: Colors.green,
                                                         
                                                          child: Text(
                                                            'Valor Factura : ',
                                                            style:
                                                                GoogleFonts.lexendDeca(
                                                                    fontSize: size
                                                                        .iScreen(1.7),
                                                                    color:
                                                                        Colors.grey,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .normal),
                                                            overflow:
                                                                TextOverflow.ellipsis,
                                                          ),
                                                          
                                                  ),
                                                         Container(
                                                          // color: Colors.green,
                                                          // width: size.wScreen(50.0),
                                                          child: Text(
                                                            '\$ ${_prefacturas['ccValorFactura']}',
                                                            style:
                                                                GoogleFonts.lexendDeca(
                                                                    fontSize: size
                                                                        .iScreen(1.7),
                                                                    color:Colors.black,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                            overflow:
                                                                TextOverflow.ellipsis,
                                                          ),
                                                  ),
                                                       ],
                                                     ),
                                                   ),
                                                    Container(
                                                    // color: Colors.red,
                                                    width: size.wScreen(100.0),
                                                     child: Row(
                                                       children: [
                                                        Container(
                                                          // color: Colors.green,
                                                         
                                                          child: Text(
                                                            'Valor Abono : ',
                                                            style:
                                                                GoogleFonts.lexendDeca(
                                                                    fontSize: size
                                                                        .iScreen(1.7),
                                                                    color:
                                                                        Colors.grey,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .normal),
                                                            overflow:
                                                                TextOverflow.ellipsis,
                                                          ),
                                                          
                                                  ),
                                                         Container(
                                                          // color: Colors.green,
                                                          // width: size.wScreen(50.0),
                                                          child: Text(
                                                            '\$ ${_prefacturas['ccAbono']}',
                                                            style:
                                                                GoogleFonts.lexendDeca(
                                                                    fontSize: size
                                                                        .iScreen(1.7),
                                                                    color:Colors.black,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                            overflow:
                                                                TextOverflow.ellipsis,
                                                          ),
                                                  ),
                                                       ],
                                                     ),
                                                   ),
                                                                 Container(
                                                    // color: Colors.red,
                                                    width: size.wScreen(100.0),
                                                     child: Row(
                                                       children: [
                                                        Container(
                                                          // color: Colors.green,
                                                         
                                                          child: Text(
                                                            'Conductor: ',
                                                            style:
                                                                GoogleFonts.lexendDeca(
                                                                    fontSize: size
                                                                        .iScreen(1.7),
                                                                    color:
                                                                        Colors.grey,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .normal),
                                                            overflow:
                                                                TextOverflow.ellipsis,
                                                          ),
                                                          
                                                  ),
                                                  //        Container(
                                                  //         // color: Colors.green,
                                                  //         // width: size.wScreen(50.0),
                                                  //         child: Text(
                                                  //          _prefacturas['ccConductor']!=null ?  ' ${_prefacturas['ccConductor']}':'--- --- --- ---',
                                                  //           style:
                                                  //               GoogleFonts.lexendDeca(
                                                  //                   fontSize: size
                                                  //                       .iScreen(1.7),
                                                  //                   color:Colors.black,
                                                  //                   fontWeight:
                                                  //                       FontWeight
                                                  //                           .bold),
                                                  //           overflow:
                                                  //               TextOverflow.ellipsis,
                                                  //         ),
                                                  // ),

                                                  Container(
  child: Text(
    _prefacturas['ccConductor'] != null && _prefacturas['ccConductor'].isNotEmpty 
      ? ' ${_prefacturas['ccConductor']}' 
      : '--- --- --- ---',
    style: GoogleFonts.lexendDeca(
      fontSize: size.iScreen(1.7),
      color: Colors.black,
      fontWeight: FontWeight.bold,
    ),
    overflow: TextOverflow.ellipsis,
  ),
)

                                                       ],
                                                     ),
                                                   ),
                                                 
                                                  Container(
                                                    // color: Colors.red,
                                                    width: size.wScreen(100.0),
                                                     child: Row(
                                                       children: [
                                                        Container(
                                                          // color: Colors.green,
                                                         
                                                          child: Text(
                                                            'Placa: ',
                                                            style:
                                                                GoogleFonts.lexendDeca(
                                                                    fontSize: size
                                                                        .iScreen(1.7),
                                                                    color:
                                                                        Colors.grey,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .normal),
                                                            overflow:
                                                                TextOverflow.ellipsis,
                                                          ),
                                                          
                                                  ),
                                                  //        Container(
                                                  //         // color: Colors.green,
                                                  //         // width: size.wScreen(50.0),
                                                  //         child: Text(
                                                  //            _prefacturas['ccOtrosDetalles']!=null ||  _prefacturas['ccOtrosDetalles'].isNotEmpty ? ' ${_prefacturas['ccOtrosDetalles']}':'--- --- --- ---',
                                                  //           style:
                                                  //               GoogleFonts.lexendDeca(
                                                  //                   fontSize: size
                                                  //                       .iScreen(1.7),
                                                  //                   color:Colors.black,
                                                  //                   fontWeight:
                                                  //                       FontWeight
                                                  //                           .bold),
                                                  //           overflow:
                                                  //               TextOverflow.ellipsis,
                                                  //         ),
                                                  // ),
                                                  Container(
  child: Text(
    _prefacturas['ccOtrosDetalles'] != null && _prefacturas['ccOtrosDetalles'].isNotEmpty 
      ? ' ${_prefacturas['ccOtrosDetalles']}'
      : '--- --- --- ---',
    style: GoogleFonts.lexendDeca(
      fontSize: size.iScreen(1.7),
      color: Colors.black,
      fontWeight: FontWeight.bold,
    ),
    overflow: TextOverflow.ellipsis,
  ),
)

                                                       ],
                                                     ),
                                                   ),
                                                 
                                               Container(
                                                    // color: Colors.red,
                                                    width: size.wScreen(100.0),
                                                     child: Column(
                                                       children: [
                                                        Container(
                                                          // color: Colors.green,
                                                         width: size.wScreen(100.0),
                                                          child: Text(
                                                            'Detalle: ',
                                                            style:
                                                                GoogleFonts.lexendDeca(
                                                                    fontSize: size
                                                                        .iScreen(1.7),
                                                                    color:
                                                                        Colors.grey,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .normal),
                                                            overflow:
                                                                TextOverflow.ellipsis,
                                                          ),
                                                          
                                                  ),
                                                  //        Container(
                                                  //         // color: Colors.green,
                                                  //         width: size.wScreen(100.0),
                                                  //         child: Text(
                                                  //              _prefacturas['ccObservacion']!=null ?  ' ${_prefacturas['ccObservacion']}':'--- --- --- ---',
                                                  //           style:
                                                  //               GoogleFonts.lexendDeca(
                                                  //                   fontSize: size
                                                  //                       .iScreen(1.7),
                                                  //                   color:Colors.black,
                                                  //                   fontWeight:
                                                  //                       FontWeight
                                                  //                           .bold),
                                                  //           overflow:
                                                  //               TextOverflow.ellipsis,
                                                  //         ),
                                                  // ),
                                                  Container(
  width: size.wScreen(100.0),
  child: Text(
    _prefacturas['ccObservacion'] != null && _prefacturas['ccObservacion'].isNotEmpty 
      ? ' ${_prefacturas['ccObservacion']}' 
      : '--- --- --- ---',
    style: GoogleFonts.lexendDeca(
      fontSize: size.iScreen(1.7),
      color: Colors.black,
      fontWeight: FontWeight.bold,
    ),
    overflow: TextOverflow.ellipsis,
  ),
)

                                                       ],
                                                     ),
                                                   ),
                                                 
                                              
                                              
                                                ],
                                              ),
                                              
                                              
                                          
                                          // Row(
                                          //   mainAxisAlignment:
                                          //       MainAxisAlignment.spaceBetween,
                                          //   children: [
                                              
                                          //     Container(
                                          //       // color: Colors.green,
                                          //       // width: size.wScreen(100.0),
                                          //       child: Text(
                                          //         '\$${_prefacturas['ccSaldo']}',
                                          //         style: GoogleFonts.lexendDeca(
                                          //             fontSize: size.iScreen(2.0),
                                          //             color: Colors.black87,
                                          //             fontWeight:
                                          //                 FontWeight.normal),
                                          //         overflow: TextOverflow.ellipsis,
                                          //       ),
                                          //     ),
                                          //   ],
                                          // ),
                                          // trailing: Icon(Icons.more_vert),
                                        ),
                                      ),
                                    ),
                                  );
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


                         
                        },
                      ),


            //======================================================//
          ],
        ),
      ),
    ],
  ),
)





                     



 
  


),

         


          
          ),
    );
  }

    Future<void> onRefresh() async {
                  final _ctrl =context.read<CuentasXCobrarController>();
                  _ctrl.resetValorTotal();
                   _ctrl.setPage(0);
    _ctrl.setCantidad(25);
                    _ctrl.buscaAllCuentasPorCobrar(
                                '',false,0);
   
  }

void _printTicket(Map<String, dynamic>? _info,String? user) async {
  if (_info == null) return;


  //==============================================//
  String fechaLocal = convertirFechaLocal(_info['ccFecReg']);
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
