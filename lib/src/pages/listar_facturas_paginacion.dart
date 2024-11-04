import 'dart:typed_data';

import 'package:awesome_icons/awesome_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:neitorcont/src/api/authentication_client.dart';
import 'package:neitorcont/src/controllers/comprobantes_controller.dart';
import 'package:neitorcont/src/controllers/facturas_controller.dart';

import 'package:neitorcont/src/models/sesison_model.dart';
import 'package:neitorcont/src/pages/crear_comprobante_print.dart';
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

class ListarFacturasPaginacion extends StatefulWidget {
   final Session? user;
  const ListarFacturasPaginacion({Key? key, this.user}) : super(key: key);

  @override
  State<ListarFacturasPaginacion> createState() => _ListarFacturasPaginacionState();
}

class _ListarFacturasPaginacionState extends State<ListarFacturasPaginacion> {
  final TextEditingController _textSearchController = TextEditingController();
  // Session? _usuario;
   final _scrollController = ScrollController();


//************  PARTE PARA CONFIGURAR LA IMPRESORA*******************//

bool printBinded = false;
  int paperSize = 0;
  String serialNumber = "";
  String printerVersion = "";
  @override
  

  /// must binding ur printer at first init in app
  Future<bool?> _bindingPrinter() async {
    final bool? result = await SunmiPrinter.bindingPrinter();
    return result;
  }

//***********************************************/


  @override
  void initState() {
 _scrollController.addListener(() {
      if (_scrollController.position.maxScrollExtent ==
          _scrollController.offset) {
       
        final _next = context.read<FacturasController>();
        if (_next.getpage != null) {
          _next.setPage(_next.getpage);
          //       providerSearchPropietario.setCantidad(25);
          _next.buscaAllFacturasPaginacion('', false,_next.getTabIndex);
        } else {
          // print("ES NULL POR ESO NO HACER PETICION ");
        }
      }
    });

    initData();
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

  @override
  void dispose() {
    _textSearchController.clear();
    _scrollController.dispose();
    super.dispose();
  }

  void initData() async {
    // widget.user = await Auth.instance.getSession();
    // final loadInfo = context.read<FacturasController>();
    // // Provider.of<PropietariosController>(context, listen: false);
    // // await loadInfo.buscaAllFacturas('');

    // final serviceSocket = context.read<SocketService>();
    // serviceSocket.socket!.on('server:guardadoExitoso', (data) async {
    //   if (data['tabla'] == 'facturas') {
    //     loadInfo.buscaAllFacturasPaginacion('', false,loadInfo.getTabIndex);
    //     // NotificatiosnService.showSnackBarSuccsses(data['msg']);
    //   }
    // });
    // serviceSocket.socket!.on('server:actualizadoExitoso', (data) async {
    //   if (data['tabla'] == 'facturas') {
    //     loadInfo.buscaAllFacturasPaginacion('', false,loadInfo.getTabIndex);
    //     // NotificatiosnService.showSnackBarSuccsses(data['msg']);
    //   }
    // });
    // serviceSocket.socket!.on('server:eliminadoExitoso', (data) async {
    //   if (data['tabla'] == 'facturas') {
    //     loadInfo.buscaAllFacturasPaginacion('', false,loadInfo.getTabIndex);
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
       final  ctrl=context.read<FacturasController>();
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
          backgroundColor: Colors.grey.shade100,
           appBar: AppBar(
            // backgroundColor: primaryColor,
          
            title: Consumer<FacturasController>(
              builder: (_, providerSearchFacturas, __) {
                return Row(
                  children: [
                    Expanded(
                      child: Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: size.iScreen(0.1)),
                        child: (providerSearchFacturas
                                .btnSearchFacturaPaginacion)
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


                                             providerSearchFacturas.search(text);

                                            // providerSearchFacturas
                                            //     .onSearchTextFacturaPaginacion(
                                            //         text);

                                            // if (providerSearchFacturas
                                            //     .nameSearchFacturaPaginacion
                                            //     .isEmpty) {
                                            //   //                 providerSearchFacturas
                                            //   //     .setErrorMascotasPaginacion(null);

                                            //   // providerSearchFacturas
                                            //   //     .setError401MascotasPaginacion(
                                            //   //         false);
                                            //   providerSearchFacturas.setPage(0);
                                            //   providerSearchFacturas
                                            //       .setCantidad(25);
                                            //   // providerSearchFacturas.setIsNext(false);
                                            //   providerSearchFacturas
                                            //       .buscaAllFacturasPaginacion(
                                            //           '', true,ctrl.getTabIndex);

                                            //   //   providerSearchFacturas
                                            //   //       .setBtnSearchPropietarioPaginacion(
                                            //   //           !providerSearchFacturas
                                            //   //               .btnSearchPropietarioPaginacion);
                                            //   //   _textSearchController.text = "";
                                            //   //   providerSearchFacturas
                                            //   //       .buscaAllPropietariosPaginacion(
                                            //   //           '', false);
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
                                  'Facturas',
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
                        providerSearchFacturas.btnSearchFacturaPaginacion
                            ? IconButton(
                                splashRadius: size.iScreen(3.0),
                                icon: Icon(
                                  Icons.search,
                                  size: size.iScreen(3.5),
                                  // color: Colors.white,
                                ),
                                onPressed: () {
                                  //=====================//
                                  if (providerSearchFacturas
                                          .nameSearchFacturaPaginacion.length >=
                                      3) {
                                    providerSearchFacturas
                                        .setErrorFacturasPaginacion(null);

                                    providerSearchFacturas
                                        .setError401FacturasPaginacion(false);
                                    providerSearchFacturas.setPage(0);
                                    providerSearchFacturas.setCantidad(25);

                                    providerSearchFacturas
                                        .buscaAllFacturasPaginacion(
                                            // '0803395581');
                                            ' ${providerSearchFacturas.nameSearchFacturaPaginacion}',
                                            true,ctrl.getTabIndex);
                                  } else {
                                    print('NO HAACE NADA');
                                  }
                                })
                            : Container(),
                        IconButton(
                            splashRadius: 2.0,
                            icon: (!providerSearchFacturas
                                    .btnSearchFacturaPaginacion)
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
                              providerSearchFacturas
                                  .onSearchTextFacturaPaginacion("");
                              _textSearchController.text = '';

                              providerSearchFacturas
                                  .setBtnSearchFacturaPaginacion(
                                      !providerSearchFacturas
                                          .btnSearchFacturaPaginacion);

                              if (providerSearchFacturas
                                      .btnSearchFacturaPaginacion ==
                                  false) {
                                //=====================//
                                providerSearchFacturas
                                    .setErrorFacturasPaginacion(null);

                                providerSearchFacturas
                                    .setError401FacturasPaginacion(false);

                                providerSearchFacturas.setPage(0);
                                providerSearchFacturas.setCantidad(25);
                                providerSearchFacturas
                                    .buscaAllFacturasPaginacion('', true, ctrl.getTabIndex);
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
          labelStyle:TextStyle(
            fontSize:size.iScreen(2.5)
          ),
          tabs: [
            Tab(
              child:
              Consumer<FacturasController>(builder: (_, valueHoy, __) {  
                return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('HOY', style: TextStyle(fontSize: size.iScreen(1.8))),
                  // Espacio entre los textos
                  Text('\$${valueHoy.getValorTotalFacturasHoy}', style: TextStyle(fontSize: size.iScreen(2.5))),
                ],
              );
              },)
               
            ),
            Tab(
              child:
              Consumer<FacturasController>(builder: (_, valueAnteriores, __) {  
                return   Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('ANTERIORES',style: TextStyle(fontSize: size.iScreen(1.8))),
                   // Espacio entre los textos
                   Text('\$${valueAnteriores.getValorTotalFacturasAntes}', style: TextStyle(fontSize: size.iScreen(2.5))),
                ],
              );
              },)
              
             
            ),
          ],
           onTap: (index) {
                        // print('EL INDICE :$index');
                       ctrl.setTabIndex(index);
                        if (  index==0) {
                          ctrl. setInfoBusquedaFacturasPaginacion([]);
                          ctrl.resetValorTotal();
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
                                '',false,_controllerFacturas.getTabIndex);
                          
                          //   ctrl.buscaAllFacturasPaginacion(
                          //       '',false,ctrl.getTabIndex);

                        }
                        if ( index==1) {
                           ctrl.setInfoBusquedaFacturasPaginacion([]);
                           ctrl.resetValorTotal();
                             ctrl.buscaAllFacturasPaginacion(
                                '',false,ctrl.getTabIndex);
                        }
                      },
          labelColor: Colors.blue,
          unselectedLabelColor: Colors.grey,
          indicatorColor: Colors.blue,
        ),
        // Utiliza Expanded para que TabBarView ocupe el espacio restante
        Expanded(
          child: TabBarView(
            children: [
              Container(
                color: Colors.grey.shade200,
                child: 
                
                
                
                
                
                
                
                Consumer<FacturasController>(
                  builder: (_, providersfactura, __) {
                   
                    if (providersfactura.allItemsFilters.isEmpty) {
                            return const NoData(
                              label: 'No existen datos para mostar',
                            );
                            // Text("sin datos");
                          }

                          return 
                          
                          (providersfactura.allItemsFilters.isEmpty)
                                        ? Center(
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              
                                              CircularProgressIndicator(),
                                              Text('Por favor espere ....')
                                            ],
                                          ))
                                        : (providersfactura.allItemsFilters.length > 0)
                                            ?
                                             RefreshIndicator(
                      onRefresh: () => onRefresh(),
                      child: ListView.builder(
                        controller: _scrollController,
                        physics: const BouncingScrollPhysics(),
                        itemCount: providersfactura.allItemsFilters.length + 1,
                        itemBuilder: (BuildContext context, int index) {
                          if (index < providersfactura.allItemsFilters.length) {
                            var _color;
                             final factura = providersfactura.allItemsFilters[index];
                            if (factura['venFecReg']==DateTime.now()) {
                               final factura = providersfactura.allItemsFilters[index];
                            }
                           

                            if (factura['venEstado'] == 'AUTORIZADO') {
                              _color = Colors.green;
                            } else if (factura['venEstado'] == 'SIN AUTORIZAR') {
                              _color = Colors.orange;
                            }
                            if (factura['venEstado'] == 'ANULADA') {
                              _color = Colors.red;
                            }

  //==============================================//
  String fechaLocal = convertirFechaLocal(factura['venFecReg']);
 //==============================================//
                            return Slidable(
                              startActionPane: ActionPane(
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
                                        builder: (BuildContext context) => CupertinoActionSheet(
                                          title: Text(
                                            'Acciones',
                                            style: GoogleFonts.lexendDeca(
                                              fontSize: size.iScreen(2.0),
                                              color: primaryColor,
                                              fontWeight: FontWeight.normal,
                                            ),
                                          ),
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
                                                                _printTicket(factura,widget.user!.logo);

                                                           
                                                          },
                                                        ),
                                            CupertinoActionSheetAction(
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Container(
                                                    margin: EdgeInsets.only(right: size.iScreen(2.0)),
                                                    child: Text(
                                                      'Ver PDF',
                                                      style: GoogleFonts.lexendDeca(
                                                        fontSize: size.iScreen(1.8),
                                                        color: Colors.black87,
                                                        fontWeight: FontWeight.normal,
                                                      ),
                                                    ),
                                                  ),
                                                  const Icon(
                                                    FontAwesomeIcons.filePdf,
                                                    color: Colors.red,
                                                  )
                                                ],
                                              ),
                                              onPressed: () {
                                                Navigator.pop(context);

                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) => ViewsPDFs(
                                                      infoPdf:
                                                        'https://syscontable.neitor.com/reportes/factura.php?codigo=${factura['venId']}&empresa=${widget.user!.rucempresa}',
                                                      labelPdf: 'infoFactura.pdf',
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                          ],
                                          cancelButton: CupertinoActionSheetAction(
                                            child: Text('Cancel',
                                                style: GoogleFonts.lexendDeca(
                                                  fontSize: size.iScreen(2.0),
                                                  color: Colors.red,
                                                  fontWeight: FontWeight.normal,
                                                )),
                                            isDefaultAction: true,
                                            onPressed: () {
                                              Navigator.pop(context, 'Cancel');
                                            },
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                              child: Card(
                                elevation: 5,
                                child: Container(
                                  margin: EdgeInsets.only(bottom: size.iScreen(0.0)),
                                  color: index % 2 == 0 ? Colors.grey.shade50 : Colors.grey.shade200,
                                  child: ListTile(
                                    dense: true,
                                    visualDensity: VisualDensity.comfortable,
                                    leading: CircleAvatar(
                                      child: Text(
                                        '${factura['venNomCliente'].substring(0, 1)}',
                                        style: Theme.of(context).textTheme.subtitle1,
                                      ),
                                      backgroundColor: Colors.grey[300],
                                    ),
                                    title: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        SizedBox(
                                          width: size.wScreen(50.0),
                                          child: Text(
                                            '${factura['venNomCliente']}',
                                            style: GoogleFonts.lexendDeca(
                                              fontWeight: FontWeight.normal,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        Text(
                                                // '${_prefacturas['venEstado']}',
                                                 factura['venOtrosDetalles'].isNotEmpty
                                                             ?'${factura['venOtrosDetalles'][0]}':'--- --- --- --- --- ---  ',
                                                // 'Estado: ',
                                                style: GoogleFonts.lexendDeca(
                                                    fontSize: size.iScreen(1.8),
                                                    color: _color,
                                                    fontWeight: FontWeight.bold),
                                              ),
                                      ],
                                    ),
                                    subtitle: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Container(
                                              width: size.wScreen(50.0),
                                              child: Text(
                                                '${factura['venNumFactura']}',
                                                style: GoogleFonts.lexendDeca(
                                                  fontSize: size.iScreen(1.5),
                                                  color: Colors.black54,
                                                  fontWeight: FontWeight.normal,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            Container(
                                              width: size.wScreen(50.0),
                                              child: Text(
                                                fechaLocal != ''
                                                    ? fechaLocal
                                                    : '--- --- ---',
                                                style: GoogleFonts.lexendDeca(
                                                  color: Colors.grey,
                                                  fontWeight: FontWeight.normal,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                         Container(
                                                    // color: Colors.green,
                                                    width: size.wScreen(50.0),
                                                    child: Text(
                                                       factura['venConductor']!=null
                                                       ?'${factura['venConductor']}':'--- --- --- --- --- ---  ',
                                                      style:
                                                          GoogleFonts.lexendDeca(
                                                              // fontSize: size.iScreen(1.9),
                                                              // color: Colors.grey,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                    ),
                                                  ),    Container(
                                                    // color: Colors.green,
                                                    width: size.wScreen(50.0),
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
                                                           factura['venUser']!=null
                                                           ?'${factura['venUser']}':'--- --- --- --- --- ---  ',
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
                                        Container(
                                          child: Text(
                                            '\$${factura['venTotal']}',
                                            style: GoogleFonts.lexendDeca(
                                              fontSize: size.iScreen(2.0),
                                              color: Colors.black87,
                                              fontWeight: FontWeight.normal,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          } else {
                            return Consumer<FacturasController>(
                              builder: (_, valueNext, __) {
                                return valueNext.getpage == null
                                    ? Container(
                                        margin: EdgeInsets.symmetric(vertical: size.iScreen(2.0)),
                                        child: Center(
                                          child: Text(
                                            'No existen más datos',
                                            style: GoogleFonts.lexendDeca(
                                              fontSize: size.iScreen(1.8),
                                              fontWeight: FontWeight.normal,
                                            ),
                                          ),
                                        ))
                                    : providersfactura.allItemsFilters.length > 25
                                        ? Container(
                                            margin: EdgeInsets.symmetric(vertical: size.iScreen(2.0)),
                                            child: const Center(child: CircularProgressIndicator()))
                                        : Container();
                              },
                            );
                          }
                        },
                      ),
                    ): const NoData(
                              label: 'No existen datos para mostar',
                            );
                 
                   
                   
                   
                    // if (providersfactura.getErrorFacturasPaginacion == null &&
                    //     providersfactura.getError401FacturasPaginacion == false) {
                    //   return Center(
                    //     child: Column(
                    //       mainAxisSize: MainAxisSize.min,
                    //       children: [
                    //         Text(
                    //           'Cargando Datos...',
                    //           style: GoogleFonts.lexendDeca(
                    //             fontSize: size.iScreen(1.5),
                    //             color: Colors.black87,
                    //             fontWeight: FontWeight.bold,
                    //           ),
                    //         ),
                    //         SizedBox(
                    //           height: size.iScreen(1.0),
                    //         ),
                    //         const CircularProgressIndicator(),
                    //       ],
                    //     ),
                    //   );
                    // } else if (providersfactura.getErrorFacturasPaginacion == false) {
                    //   return const NoData(
                    //     label: 'No existen datos para mostrar',
                    //   );
                    // } else if (providersfactura.getListaFacturasPaginacion.isEmpty &&
                    //     providersfactura.getErrorFacturasPaginacion == false) {
                    //   return const NoData(
                    //     label: 'No existen datos para mostrar',
                    //   );
                    // } else if (providersfactura.getListaFacturasPaginacion.isEmpty &&
                    //     providersfactura.getError401FacturasPaginacion == true) {
                    //   return const NoData(
                    //     label: 'Su sesión ha expirado, vuelva a iniciar sesión',
                    //   );
                    // } else if (providersfactura.getListaFacturasPaginacion.isEmpty &&
                    //     providersfactura.getError401FacturasPaginacion == false) {
                    //   return const NoData(
                    //     label: 'No existen datos para mostrar',
                    //   );
                    // }

                    // return 
                    // RefreshIndicator(
                    //   onRefresh: () => onRefresh(),
                    //   child: ListView.builder(
                    //     controller: _scrollController,
                    //     physics: const BouncingScrollPhysics(),
                    //     itemCount: providersfactura.getListaFacturasPaginacion.length + 1,
                    //     itemBuilder: (BuildContext context, int index) {
                    //       if (index < providersfactura.getListaFacturasPaginacion.length) {
                    //         var _color;
                    //          final factura = providersfactura.getListaFacturasPaginacion[index];
                    //         if (factura['venFecReg']==DateTime.now()) {
                    //            final factura = providersfactura.getListaFacturasPaginacion[index];
                    //         }
                           

                    //         if (factura['venEstado'] == 'AUTORIZADO') {
                    //           _color = Colors.green;
                    //         } else if (factura['venEstado'] == 'SIN AUTORIZAR') {
                    //           _color = Colors.orange;
                    //         }
                    //         if (factura['venEstado'] == 'ANULADA') {
                    //           _color = Colors.red;
                    //         }

                    //         return Slidable(
                    //           startActionPane: ActionPane(
                    //             motion: const ScrollMotion(),
                    //             children: [
                    //               SlidableAction(
                    //                 backgroundColor: Colors.grey,
                    //                 foregroundColor: Colors.white,
                    //                 icon: Icons.list_alt_outlined,
                    //                 label: 'Más acciones',
                    //                 onPressed: (context) {
                    //                   showCupertinoModalPopup(
                    //                     context: context,
                    //                     builder: (BuildContext context) => CupertinoActionSheet(
                    //                       title: Text(
                    //                         'Acciones',
                    //                         style: GoogleFonts.lexendDeca(
                    //                           fontSize: size.iScreen(2.0),
                    //                           color: primaryColor,
                    //                           fontWeight: FontWeight.normal,
                    //                         ),
                    //                       ),
                    //                       actions: <Widget>[
                    //                         CupertinoActionSheetAction(
                    //                           child: Row(
                    //                             mainAxisAlignment: MainAxisAlignment.center,
                    //                             children: [
                    //                               Container(
                    //                                 margin: EdgeInsets.only(right: size.iScreen(2.0)),
                    //                                 child: Text(
                    //                                   'Ver PDF',
                    //                                   style: GoogleFonts.lexendDeca(
                    //                                     fontSize: size.iScreen(1.8),
                    //                                     color: Colors.black87,
                    //                                     fontWeight: FontWeight.normal,
                    //                                   ),
                    //                                 ),
                    //                               ),
                    //                               const Icon(
                    //                                 FontAwesomeIcons.filePdf,
                    //                                 color: Colors.red,
                    //                               )
                    //                             ],
                    //                           ),
                    //                           onPressed: () {
                    //                             Navigator.pop(context);

                    //                             Navigator.push(
                    //                               context,
                    //                               MaterialPageRoute(
                    //                                 builder: (context) => ViewsPDFs(
                    //                                   infoPdf:
                    //                                     'https://syscontable.neitor.com/reportes/factura.php?codigo=${factura['venId']}&empresa=${widget.user!.rucempresa}',
                    //                                   labelPdf: 'infoFactura.pdf',
                    //                                 ),
                    //                               ),
                    //                             );
                    //                           },
                    //                         ),
                    //                       ],
                    //                       cancelButton: CupertinoActionSheetAction(
                    //                         child: Text('Cancel',
                    //                             style: GoogleFonts.lexendDeca(
                    //                               fontSize: size.iScreen(2.0),
                    //                               color: Colors.red,
                    //                               fontWeight: FontWeight.normal,
                    //                             )),
                    //                         isDefaultAction: true,
                    //                         onPressed: () {
                    //                           Navigator.pop(context, 'Cancel');
                    //                         },
                    //                       ),
                    //                     ),
                    //                   );
                    //                 },
                    //               ),
                    //             ],
                    //           ),
                    //           child: Card(
                    //             elevation: 5,
                    //             child: Container(
                    //               margin: EdgeInsets.only(bottom: size.iScreen(0.0)),
                    //               color: index % 2 == 0 ? Colors.grey.shade50 : Colors.grey.shade200,
                    //               child: ListTile(
                    //                 dense: true,
                    //                 visualDensity: VisualDensity.comfortable,
                    //                 leading: CircleAvatar(
                    //                   child: Text(
                    //                     '${factura['venNomCliente'].substring(0, 1)}',
                    //                     style: Theme.of(context).textTheme.subtitle1,
                    //                   ),
                    //                   backgroundColor: Colors.grey[300],
                    //                 ),
                    //                 title: Row(
                    //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //                   children: [
                    //                     SizedBox(
                    //                       width: size.wScreen(50.0),
                    //                       child: Text(
                    //                         '${factura['venNomCliente']}',
                    //                         style: GoogleFonts.lexendDeca(
                    //                           fontWeight: FontWeight.normal,
                    //                         ),
                    //                         overflow: TextOverflow.ellipsis,
                    //                       ),
                    //                     ),
                    //                     Text(
                    //                       '${factura['venEstado']}',
                    //                       style: GoogleFonts.lexendDeca(
                    //                         fontSize: size.iScreen(1.5),
                    //                         color: _color,
                    //                         fontWeight: FontWeight.bold,
                    //                       ),
                    //                     ),
                    //                   ],
                    //                 ),
                    //                 subtitle: Row(
                    //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //                   children: [
                    //                     Column(
                    //                       mainAxisAlignment: MainAxisAlignment.start,
                    //                       children: [
                    //                         Container(
                    //                           width: size.wScreen(50.0),
                    //                           child: Text(
                    //                             '${factura['venNumFactura']}',
                    //                             style: GoogleFonts.lexendDeca(
                    //                               fontSize: size.iScreen(1.5),
                    //                               color: Colors.black54,
                    //                               fontWeight: FontWeight.normal,
                    //                             ),
                    //                             overflow: TextOverflow.ellipsis,
                    //                           ),
                    //                         ),
                    //                         Container(
                    //                           width: size.wScreen(50.0),
                    //                           child: Text(
                    //                             factura['venFecReg'] != ''
                    //                                 ? '${factura['venFecReg'].replaceAll('T', "  ").replaceAll('.000Z', "  ")}'
                    //                                 : '--- --- ---',
                    //                             style: GoogleFonts.lexendDeca(
                    //                               color: Colors.grey,
                    //                               fontWeight: FontWeight.normal,
                    //                             ),
                    //                           ),
                    //                         ),
                    //                       ],
                    //                     ),
                    //                     Container(
                    //                       child: Text(
                    //                         '\$${factura['venTotal']}',
                    //                         style: GoogleFonts.lexendDeca(
                    //                           fontSize: size.iScreen(2.0),
                    //                           color: Colors.black87,
                    //                           fontWeight: FontWeight.normal,
                    //                         ),
                    //                         overflow: TextOverflow.ellipsis,
                    //                       ),
                    //                     ),
                    //                   ],
                    //                 ),
                    //               ),
                    //             ),
                    //           ),
                    //         );
                    //       } else {
                    //         return Consumer<FacturasController>(
                    //           builder: (_, valueNext, __) {
                    //             return valueNext.getpage == null
                    //                 ? Container(
                    //                     margin: EdgeInsets.symmetric(vertical: size.iScreen(2.0)),
                    //                     child: Center(
                    //                       child: Text(
                    //                         'No existen más datos',
                    //                         style: GoogleFonts.lexendDeca(
                    //                           fontSize: size.iScreen(1.8),
                    //                           fontWeight: FontWeight.normal,
                    //                         ),
                    //                       ),
                    //                     ))
                    //                 : providersfactura.getListaFacturasPaginacion.length > 25
                    //                     ? Container(
                    //                         margin: EdgeInsets.symmetric(vertical: size.iScreen(2.0)),
                    //                         child: const Center(child: CircularProgressIndicator()))
                    //                     : Container();
                    //           },
                    //         );
                    //       }
                    //     },
                    //   ),
                    // );
                 
                 
                 
                  },
                ),
             
             
             
             
             
             
              ),
             
             //*********** tab 2 *************//
Container(
                color: Colors.grey.shade200,
                child:
                 Consumer<FacturasController>(
                  builder: (_, providersfactura, __) {
                   
                    if (providersfactura.allItemsFilters.isEmpty) {
                            return const NoData(
                              label: 'No existen datos para mostar',
                            );
                            // Text("sin datos");
                          }

                          return 
                          
                          (providersfactura.allItemsFilters.isEmpty)
                                        ? Center(
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              
                                              CircularProgressIndicator(),
                                              Text('Por favor espere ....')
                                            ],
                                          ))
                                        : (providersfactura.allItemsFilters.length > 0)
                                            ?
                                             RefreshIndicator(
                      onRefresh: () => onRefresh(),
                      child: ListView.builder(
                        controller: _scrollController,
                        physics: const BouncingScrollPhysics(),
                        itemCount: providersfactura.allItemsFilters.length + 1,
                        itemBuilder: (BuildContext context, int index) {
                          if (index < providersfactura.allItemsFilters.length) {
                            var _color;
                             final factura = providersfactura.allItemsFilters[index];
                            if (factura['venFecReg']==DateTime.now()) {
                               final factura = providersfactura.allItemsFilters[index];
                            }
                           

                            if (factura['venEstado'] == 'AUTORIZADO') {
                              _color = Colors.green;
                            } else if (factura['venEstado'] == 'SIN AUTORIZAR') {
                              _color = Colors.orange;
                            }
                            if (factura['venEstado'] == 'ANULADA') {
                              _color = Colors.red;
                            }
 //==============================================//
  String fechaLocal = convertirFechaLocal(factura['venFecReg']);
 //==============================================//
                            return Slidable(
                              startActionPane: ActionPane(
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
                                        builder: (BuildContext context) => CupertinoActionSheet(
                                          title: Text(
                                            'Acciones',
                                            style: GoogleFonts.lexendDeca(
                                              fontSize: size.iScreen(2.0),
                                              color: primaryColor,
                                              fontWeight: FontWeight.normal,
                                            ),
                                          ),
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
                                                                  'Imprimir Comprobante',
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
                                                                _printTicket(factura,widget.user!.logo);

                                                           
                                                          },
                                                        ),
                                            CupertinoActionSheetAction(
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Container(
                                                    margin: EdgeInsets.only(right: size.iScreen(2.0)),
                                                    child: Text(
                                                      'Ver PDF',
                                                      style: GoogleFonts.lexendDeca(
                                                        fontSize: size.iScreen(1.8),
                                                        color: Colors.black87,
                                                        fontWeight: FontWeight.normal,
                                                      ),
                                                    ),
                                                  ),
                                                  const Icon(
                                                    FontAwesomeIcons.filePdf,
                                                    color: Colors.red,
                                                  )
                                                ],
                                              ),
                                              onPressed: () {
                                                Navigator.pop(context);

                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) => ViewsPDFs(
                                                      infoPdf:
                                                        'https://syscontable.neitor.com/reportes/factura.php?codigo=${factura['venId']}&empresa=${widget.user!.rucempresa}',
                                                      labelPdf: 'infoFactura.pdf',
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                          ],
                                          cancelButton: CupertinoActionSheetAction(
                                            child: Text('Cancel',
                                                style: GoogleFonts.lexendDeca(
                                                  fontSize: size.iScreen(2.0),
                                                  color: Colors.red,
                                                  fontWeight: FontWeight.normal,
                                                )),
                                            isDefaultAction: true,
                                            onPressed: () {
                                              Navigator.pop(context, 'Cancel');
                                            },
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                              child: Card(
                                elevation: 5,
                                child: Container(
                                  margin: EdgeInsets.only(bottom: size.iScreen(0.0)),
                                  color: index % 2 == 0 ? Colors.grey.shade50 : Colors.grey.shade200,
                                  child: ListTile(
                                    dense: true,
                                    visualDensity: VisualDensity.comfortable,
                                    leading: CircleAvatar(
                                      child: Text(
                                        '${factura['venNomCliente'].substring(0, 1)}',
                                        style: Theme.of(context).textTheme.subtitle1,
                                      ),
                                      backgroundColor: Colors.grey[300],
                                    ),
                                    title: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        SizedBox(
                                          width: size.wScreen(50.0),
                                          child: Text(
                                            '${factura['venNomCliente']}',
                                            style: GoogleFonts.lexendDeca(
                                              fontWeight: FontWeight.normal,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                       Text(
                                                // '${_prefacturas['venEstado']}',
                                                 factura['venOtrosDetalles'].isNotEmpty
                                                             ?'${factura['venOtrosDetalles'][0]}':'--- --- --- --- --- ---  ',
                                                // 'Estado: ',
                                                style: GoogleFonts.lexendDeca(
                                                    fontSize: size.iScreen(1.8),
                                                    color: _color,
                                                    fontWeight: FontWeight.bold),
                                              ),
                                      ],
                                    ),
                                    subtitle: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Container(
                                              width: size.wScreen(50.0),
                                              child: Text(
                                                '${factura['venNumFactura']}',
                                                style: GoogleFonts.lexendDeca(
                                                  fontSize: size.iScreen(1.5),
                                                  color: Colors.black54,
                                                  fontWeight: FontWeight.normal,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            Container(
                                              width: size.wScreen(50.0),
                                              child: Text(
                                                fechaLocal != ''
                                                    ? fechaLocal
                                                    : '--- --- ---',
                                                style: GoogleFonts.lexendDeca(
                                                  color: Colors.grey,
                                                  fontWeight: FontWeight.normal,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                          Container(
                                                    // color: Colors.green,
                                                    width: size.wScreen(50.0),
                                                    child: Text(
                                                       factura['venConductor']!=null
                                                       ?'${factura['venConductor']}':'--- --- --- --- --- ---  ',
                                                      style:
                                                          GoogleFonts.lexendDeca(
                                                              // fontSize: size.iScreen(1.9),
                                                              // color: Colors.grey,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                    ),
                                                  ),
                                                   Container(
                                                    // color: Colors.green,
                                                    width: size.wScreen(50.0),
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
                                                           factura['venUser']!=null
                                                           ?'${factura['venUser']}':'--- --- --- --- --- ---  ',
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
                                        Container(
                                          child: Text(
                                            '\$${factura['venTotal']}',
                                            style: GoogleFonts.lexendDeca(
                                              fontSize: size.iScreen(2.0),
                                              color: Colors.black87,
                                              fontWeight: FontWeight.normal,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          } else {
                            return Consumer<FacturasController>(
                              builder: (_, valueNext, __) {
                                return valueNext.getpage == null
                                    ? Container(
                                        margin: EdgeInsets.symmetric(vertical: size.iScreen(2.0)),
                                        child: Center(
                                          child: Text(
                                            'No existen más datos',
                                            style: GoogleFonts.lexendDeca(
                                              fontSize: size.iScreen(1.8),
                                              fontWeight: FontWeight.normal,
                                            ),
                                          ),
                                        ))
                                    : providersfactura.allItemsFilters.length > 25
                                        ? Container(
                                            margin: EdgeInsets.symmetric(vertical: size.iScreen(2.0)),
                                            child: const Center(child: CircularProgressIndicator()))
                                        : Container();
                              },
                            );
                          }
                        },
                      ),
                    ): const NoData(
                              label: 'No existen datos para mostar',
                            );
                 
                   
                   
                   
                    // if (providersfactura.getErrorFacturasPaginacion == null &&
                    //     providersfactura.getError401FacturasPaginacion == false) {
                    //   return Center(
                    //     child: Column(
                    //       mainAxisSize: MainAxisSize.min,
                    //       children: [
                    //         Text(
                    //           'Cargando Datos...',
                    //           style: GoogleFonts.lexendDeca(
                    //             fontSize: size.iScreen(1.5),
                    //             color: Colors.black87,
                    //             fontWeight: FontWeight.bold,
                    //           ),
                    //         ),
                    //         SizedBox(
                    //           height: size.iScreen(1.0),
                    //         ),
                    //         const CircularProgressIndicator(),
                    //       ],
                    //     ),
                    //   );
                    // } else if (providersfactura.getErrorFacturasPaginacion == false) {
                    //   return const NoData(
                    //     label: 'No existen datos para mostrar',
                    //   );
                    // } else if (providersfactura.getListaFacturasPaginacion.isEmpty &&
                    //     providersfactura.getErrorFacturasPaginacion == false) {
                    //   return const NoData(
                    //     label: 'No existen datos para mostrar',
                    //   );
                    // } else if (providersfactura.getListaFacturasPaginacion.isEmpty &&
                    //     providersfactura.getError401FacturasPaginacion == true) {
                    //   return const NoData(
                    //     label: 'Su sesión ha expirado, vuelva a iniciar sesión',
                    //   );
                    // } else if (providersfactura.getListaFacturasPaginacion.isEmpty &&
                    //     providersfactura.getError401FacturasPaginacion == false) {
                    //   return const NoData(
                    //     label: 'No existen datos para mostrar',
                    //   );
                    // }

                    // return 
                    // RefreshIndicator(
                    //   onRefresh: () => onRefresh(),
                    //   child: ListView.builder(
                    //     controller: _scrollController,
                    //     physics: const BouncingScrollPhysics(),
                    //     itemCount: providersfactura.getListaFacturasPaginacion.length + 1,
                    //     itemBuilder: (BuildContext context, int index) {
                    //       if (index < providersfactura.getListaFacturasPaginacion.length) {
                    //         var _color;
                    //          final factura = providersfactura.getListaFacturasPaginacion[index];
                    //         if (factura['venFecReg']==DateTime.now()) {
                    //            final factura = providersfactura.getListaFacturasPaginacion[index];
                    //         }
                           

                    //         if (factura['venEstado'] == 'AUTORIZADO') {
                    //           _color = Colors.green;
                    //         } else if (factura['venEstado'] == 'SIN AUTORIZAR') {
                    //           _color = Colors.orange;
                    //         }
                    //         if (factura['venEstado'] == 'ANULADA') {
                    //           _color = Colors.red;
                    //         }

                    //         return Slidable(
                    //           startActionPane: ActionPane(
                    //             motion: const ScrollMotion(),
                    //             children: [
                    //               SlidableAction(
                    //                 backgroundColor: Colors.grey,
                    //                 foregroundColor: Colors.white,
                    //                 icon: Icons.list_alt_outlined,
                    //                 label: 'Más acciones',
                    //                 onPressed: (context) {
                    //                   showCupertinoModalPopup(
                    //                     context: context,
                    //                     builder: (BuildContext context) => CupertinoActionSheet(
                    //                       title: Text(
                    //                         'Acciones',
                    //                         style: GoogleFonts.lexendDeca(
                    //                           fontSize: size.iScreen(2.0),
                    //                           color: primaryColor,
                    //                           fontWeight: FontWeight.normal,
                    //                         ),
                    //                       ),
                    //                       actions: <Widget>[
                    //                         CupertinoActionSheetAction(
                    //                           child: Row(
                    //                             mainAxisAlignment: MainAxisAlignment.center,
                    //                             children: [
                    //                               Container(
                    //                                 margin: EdgeInsets.only(right: size.iScreen(2.0)),
                    //                                 child: Text(
                    //                                   'Ver PDF',
                    //                                   style: GoogleFonts.lexendDeca(
                    //                                     fontSize: size.iScreen(1.8),
                    //                                     color: Colors.black87,
                    //                                     fontWeight: FontWeight.normal,
                    //                                   ),
                    //                                 ),
                    //                               ),
                    //                               const Icon(
                    //                                 FontAwesomeIcons.filePdf,
                    //                                 color: Colors.red,
                    //                               )
                    //                             ],
                    //                           ),
                    //                           onPressed: () {
                    //                             Navigator.pop(context);

                    //                             Navigator.push(
                    //                               context,
                    //                               MaterialPageRoute(
                    //                                 builder: (context) => ViewsPDFs(
                    //                                   infoPdf:
                    //                                     'https://syscontable.neitor.com/reportes/factura.php?codigo=${factura['venId']}&empresa=${_usuario!.rucempresa}',
                    //                                   labelPdf: 'infoFactura.pdf',
                    //                                 ),
                    //                               ),
                    //                             );
                    //                           },
                    //                         ),
                    //                       ],
                    //                       cancelButton: CupertinoActionSheetAction(
                    //                         child: Text('Cancel',
                    //                             style: GoogleFonts.lexendDeca(
                    //                               fontSize: size.iScreen(2.0),
                    //                               color: Colors.red,
                    //                               fontWeight: FontWeight.normal,
                    //                             )),
                    //                         isDefaultAction: true,
                    //                         onPressed: () {
                    //                           Navigator.pop(context, 'Cancel');
                    //                         },
                    //                       ),
                    //                     ),
                    //                   );
                    //                 },
                    //               ),
                    //             ],
                    //           ),
                    //           child: Card(
                    //             elevation: 5,
                    //             child: Container(
                    //               margin: EdgeInsets.only(bottom: size.iScreen(0.0)),
                    //               color: index % 2 == 0 ? Colors.grey.shade50 : Colors.grey.shade200,
                    //               child: ListTile(
                    //                 dense: true,
                    //                 visualDensity: VisualDensity.comfortable,
                    //                 leading: CircleAvatar(
                    //                   child: Text(
                    //                     '${factura['venNomCliente'].substring(0, 1)}',
                    //                     style: Theme.of(context).textTheme.subtitle1,
                    //                   ),
                    //                   backgroundColor: Colors.grey[300],
                    //                 ),
                    //                 title: Row(
                    //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //                   children: [
                    //                     SizedBox(
                    //                       width: size.wScreen(50.0),
                    //                       child: Text(
                    //                         '${factura['venNomCliente']}',
                    //                         style: GoogleFonts.lexendDeca(
                    //                           fontWeight: FontWeight.normal,
                    //                         ),
                    //                         overflow: TextOverflow.ellipsis,
                    //                       ),
                    //                     ),
                    //                     Text(
                    //                       '${factura['venEstado']}',
                    //                       style: GoogleFonts.lexendDeca(
                    //                         fontSize: size.iScreen(1.5),
                    //                         color: _color,
                    //                         fontWeight: FontWeight.bold,
                    //                       ),
                    //                     ),
                    //                   ],
                    //                 ),
                    //                 subtitle: Row(
                    //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //                   children: [
                    //                     Column(
                    //                       mainAxisAlignment: MainAxisAlignment.start,
                    //                       children: [
                    //                         Container(
                    //                           width: size.wScreen(50.0),
                    //                           child: Text(
                    //                             '${factura['venNumFactura']}',
                    //                             style: GoogleFonts.lexendDeca(
                    //                               fontSize: size.iScreen(1.5),
                    //                               color: Colors.black54,
                    //                               fontWeight: FontWeight.normal,
                    //                             ),
                    //                             overflow: TextOverflow.ellipsis,
                    //                           ),
                    //                         ),
                    //                         Container(
                    //                           width: size.wScreen(50.0),
                    //                           child: Text(
                    //                             factura['venFecReg'] != ''
                    //                                 ? '${factura['venFecReg'].replaceAll('T', "  ").replaceAll('.000Z', "  ")}'
                    //                                 : '--- --- ---',
                    //                             style: GoogleFonts.lexendDeca(
                    //                               color: Colors.grey,
                    //                               fontWeight: FontWeight.normal,
                    //                             ),
                    //                           ),
                    //                         ),
                    //                       ],
                    //                     ),
                    //                     Container(
                    //                       child: Text(
                    //                         '\$${factura['venTotal']}',
                    //                         style: GoogleFonts.lexendDeca(
                    //                           fontSize: size.iScreen(2.0),
                    //                           color: Colors.black87,
                    //                           fontWeight: FontWeight.normal,
                    //                         ),
                    //                         overflow: TextOverflow.ellipsis,
                    //                       ),
                    //                     ),
                    //                   ],
                    //                 ),
                    //               ),
                    //             ),
                    //           ),
                    //         );
                    //       } else {
                    //         return Consumer<FacturasController>(
                    //           builder: (_, valueNext, __) {
                    //             return valueNext.getpage == null
                    //                 ? Container(
                    //                     margin: EdgeInsets.symmetric(vertical: size.iScreen(2.0)),
                    //                     child: Center(
                    //                       child: Text(
                    //                         'No existen más datos',
                    //                         style: GoogleFonts.lexendDeca(
                    //                           fontSize: size.iScreen(1.8),
                    //                           fontWeight: FontWeight.normal,
                    //                         ),
                    //                       ),
                    //                     ))
                    //                 : providersfactura.getListaFacturasPaginacion.length > 25
                    //                     ? Container(
                    //                         margin: EdgeInsets.symmetric(vertical: size.iScreen(2.0)),
                    //                         child: const Center(child: CircularProgressIndicator()))
                    //                     : Container();
                    //           },
                    //         );
                    //       }
                    //     },
                    //   ),
                    // );
                 
                 
                 
                  },
                ),
             
             
             
                
                //  Consumer<FacturasController>(
                //   builder: (_, providersfactura, __) {
                //     if (providersfactura.getErrorFacturasPaginacion == null &&
                //         providersfactura.getError401FacturasPaginacion == false) {
                //       return Center(
                //         child: Column(
                //           mainAxisSize: MainAxisSize.min,
                //           children: [
                //             Text(
                //               'Cargando Datos...',
                //               style: GoogleFonts.lexendDeca(
                //                 fontSize: size.iScreen(1.5),
                //                 color: Colors.black87,
                //                 fontWeight: FontWeight.bold,
                //               ),
                //             ),
                //             SizedBox(
                //               height: size.iScreen(1.0),
                //             ),
                //             const CircularProgressIndicator(),
                //           ],
                //         ),
                //       );
                //     } else if (providersfactura.getErrorFacturasPaginacion == false) {
                //       return const NoData(
                //         label: 'No existen datos para mostrar',
                //       );
                //     } else if (providersfactura.getListaFacturasPaginacion.isEmpty &&
                //         providersfactura.getErrorFacturasPaginacion == false) {
                //       return const NoData(
                //         label: 'No existen datos para mostrar',
                //       );
                //     } else if (providersfactura.getListaFacturasPaginacion.isEmpty &&
                //         providersfactura.getError401FacturasPaginacion == true) {
                //       return const NoData(
                //         label: 'Su sesión ha expirado, vuelva a iniciar sesión',
                //       );
                //     } else if (providersfactura.getListaFacturasPaginacion.isEmpty &&
                //         providersfactura.getError401FacturasPaginacion == false) {
                //       return const NoData(
                //         label: 'No existen datos para mostrar',
                //       );
                //     }

                //     return RefreshIndicator(
                //       onRefresh: () => onRefresh(),
                //       child: ListView.builder(
                //         controller: _scrollController,
                //         physics: const BouncingScrollPhysics(),
                //         itemCount: providersfactura.getListaFacturasPaginacion.length + 1,
                //         itemBuilder: (BuildContext context, int index) {
                //           if (index < providersfactura.getListaFacturasPaginacion.length) {
                //             var _color;
                //              final factura = providersfactura.getListaFacturasPaginacion[index];
                //             if (factura['venFecReg']==DateTime.now()) {
                //                final factura = providersfactura.getListaFacturasPaginacion[index];
                //             }
                           

                //             if (factura['venEstado'] == 'AUTORIZADO') {
                //               _color = Colors.green;
                //             } else if (factura['venEstado'] == 'SIN AUTORIZAR') {
                //               _color = Colors.orange;
                //             }
                //             if (factura['venEstado'] == 'ANULADA') {
                //               _color = Colors.red;
                //             }

                //             return Slidable(
                //               startActionPane: ActionPane(
                //                 motion: const ScrollMotion(),
                //                 children: [
                //                   SlidableAction(
                //                     backgroundColor: Colors.grey,
                //                     foregroundColor: Colors.white,
                //                     icon: Icons.list_alt_outlined,
                //                     label: 'Más acciones',
                //                     onPressed: (context) {
                //                       showCupertinoModalPopup(
                //                         context: context,
                //                         builder: (BuildContext context) => CupertinoActionSheet(
                //                           title: Text(
                //                             'Acciones',
                //                             style: GoogleFonts.lexendDeca(
                //                               fontSize: size.iScreen(2.0),
                //                               color: primaryColor,
                //                               fontWeight: FontWeight.normal,
                //                             ),
                //                           ),
                //                           actions: <Widget>[
                //                             CupertinoActionSheetAction(
                //                               child: Row(
                //                                 mainAxisAlignment: MainAxisAlignment.center,
                //                                 children: [
                //                                   Container(
                //                                     margin: EdgeInsets.only(right: size.iScreen(2.0)),
                //                                     child: Text(
                //                                       'Ver PDF',
                //                                       style: GoogleFonts.lexendDeca(
                //                                         fontSize: size.iScreen(1.8),
                //                                         color: Colors.black87,
                //                                         fontWeight: FontWeight.normal,
                //                                       ),
                //                                     ),
                //                                   ),
                //                                   const Icon(
                //                                     FontAwesomeIcons.filePdf,
                //                                     color: Colors.red,
                //                                   )
                //                                 ],
                //                               ),
                //                               onPressed: () {
                //                                 Navigator.pop(context);

                //                                 Navigator.push(
                //                                   context,
                //                                   MaterialPageRoute(
                //                                     builder: (context) => ViewsPDFs(
                //                                       infoPdf:
                //                                         'https://syscontable.neitor.com/reportes/factura.php?codigo=${factura['venId']}&empresa=${_usuario!.rucempresa}',
                //                                       labelPdf: 'infoFactura.pdf',
                //                                     ),
                //                                   ),
                //                                 );
                //                               },
                //                             ),
                //                           ],
                //                           cancelButton: CupertinoActionSheetAction(
                //                             child: Text('Cancel',
                //                                 style: GoogleFonts.lexendDeca(
                //                                   fontSize: size.iScreen(2.0),
                //                                   color: Colors.red,
                //                                   fontWeight: FontWeight.normal,
                //                                 )),
                //                             isDefaultAction: true,
                //                             onPressed: () {
                //                               Navigator.pop(context, 'Cancel');
                //                             },
                //                           ),
                //                         ),
                //                       );
                //                     },
                //                   ),
                //                 ],
                //               ),
                //               child: Card(
                //                 elevation: 5,
                //                 child: Container(
                //                   margin: EdgeInsets.only(bottom: size.iScreen(0.0)),
                //                   color: index % 2 == 0 ? Colors.grey.shade50 : Colors.grey.shade200,
                //                   child: ListTile(
                //                     dense: true,
                //                     visualDensity: VisualDensity.comfortable,
                //                     leading: CircleAvatar(
                //                       child: Text(
                //                         '${factura['venNomCliente'].substring(0, 1)}',
                //                         style: Theme.of(context).textTheme.subtitle1,
                //                       ),
                //                       backgroundColor: Colors.grey[300],
                //                     ),
                //                     title: Row(
                //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //                       children: [
                //                         SizedBox(
                //                           width: size.wScreen(50.0),
                //                           child: Text(
                //                             '${factura['venNomCliente']}',
                //                             style: GoogleFonts.lexendDeca(
                //                               fontWeight: FontWeight.normal,
                //                             ),
                //                             overflow: TextOverflow.ellipsis,
                //                           ),
                //                         ),
                //                         Text(
                //                           '${factura['venEstado']}',
                //                           style: GoogleFonts.lexendDeca(
                //                             fontSize: size.iScreen(1.5),
                //                             color: _color,
                //                             fontWeight: FontWeight.bold,
                //                           ),
                //                         ),
                //                       ],
                //                     ),
                //                     subtitle: Row(
                //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //                       children: [
                //                         Column(
                //                           mainAxisAlignment: MainAxisAlignment.start,
                //                           children: [
                //                             Container(
                //                               width: size.wScreen(50.0),
                //                               child: Text(
                //                                 '${factura['venNumFactura']}',
                //                                 style: GoogleFonts.lexendDeca(
                //                                   fontSize: size.iScreen(1.5),
                //                                   color: Colors.black54,
                //                                   fontWeight: FontWeight.normal,
                //                                 ),
                //                                 overflow: TextOverflow.ellipsis,
                //                               ),
                //                             ),
                //                             Container(
                //                               width: size.wScreen(50.0),
                //                               child: Text(
                //                                 factura['venFecReg'] != ''
                //                                     ? '${factura['venFecReg'].replaceAll('T', "  ").replaceAll('.000Z', "  ")}'
                //                                     : '--- --- ---',
                //                                 style: GoogleFonts.lexendDeca(
                //                                   color: Colors.grey,
                //                                   fontWeight: FontWeight.normal,
                //                                 ),
                //                               ),
                //                             ),
                //                           ],
                //                         ),
                //                         Container(
                //                           child: Text(
                //                             '\$${factura['venTotal']}',
                //                             style: GoogleFonts.lexendDeca(
                //                               fontSize: size.iScreen(2.0),
                //                               color: Colors.black87,
                //                               fontWeight: FontWeight.normal,
                //                             ),
                //                             overflow: TextOverflow.ellipsis,
                //                           ),
                //                         ),
                //                       ],
                //                     ),
                //                   ),
                //                 ),
                //               ),
                //             );
                //           } else {
                //             return Consumer<FacturasController>(
                //               builder: (_, valueNext, __) {
                //                 return valueNext.getpage == null
                //                     ? Container(
                //                         margin: EdgeInsets.symmetric(vertical: size.iScreen(2.0)),
                //                         child: Center(
                //                           child: Text(
                //                             'No existen más datos',
                //                             style: GoogleFonts.lexendDeca(
                //                               fontSize: size.iScreen(1.8),
                //                               fontWeight: FontWeight.normal,
                //                             ),
                //                           ),
                //                         ))
                //                     : providersfactura.getListaFacturasPaginacion.length > 25
                //                         ? Container(
                //                             margin: EdgeInsets.symmetric(vertical: size.iScreen(2.0)),
                //                             child: const Center(child: CircularProgressIndicator()))
                //                         : Container();
                //               },
                //             );
                //           }
                //         },
                //       ),
                //     );
                //   },
                // ),
             
             
             
             
              ),
             
             


             //**********************************//
              
            ],
          ),
        ),
      ],
    ),
  ),
),

         
         
          // body: Container(
          //   color: Colors.grey.shade100,
          //   width: size.wScreen(100.0),
          //   height: size.hScreen(100.0),
          //   padding: EdgeInsets.only(
          //     top: size.iScreen(0.0),
          //     right: size.iScreen(0.0),
          //     left: size.iScreen(0.0),
          //   ),
          //   child: Consumer<FacturasController>(
          //               builder: (_, providersfactura, __) {
          //                 if (providersfactura.getErrorFacturasPaginacion == null &&
          //                     providersfactura.getError401FacturasPaginacion == false) {
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
          //                 } else if (providersfactura.getErrorFacturasPaginacion ==
          //                     false) {
          //                   return const NoData(
          //                     label: 'No existen datos para mostar',
          //                   );
          //                 } 
          //                  else if (providersfactura
          //                         .getListaFacturasPaginacion.isEmpty &&providersfactura.getErrorFacturasPaginacion ==
          //                     false ) {
          //                   return const NoData(
          //                     label: 'No existen datos para mostar',
          //                   );
          //                 }
          //                 else if (providersfactura
          //                         .getListaFacturasPaginacion.isEmpty &&
          //                     providersfactura.getError401FacturasPaginacion == true) {
          //                   return const NoData(
          //                     label:
          //                         'Su sesión ha expirado, vuelva a iniciar sesión',
          //                   );
          //                 } else if (providersfactura
          //                         .getListaFacturasPaginacion.isEmpty &&
          //                     providersfactura.getError401FacturasPaginacion == false) {
          //                   return const NoData(
          //                     label: 'No existen datos para mostar',
          //                   );
          //                 }

          //                 return RefreshIndicator(
          //                     onRefresh: () => onRefresh(),
          //                   child: ListView.builder(
          //                     controller: _scrollController,
          //                     physics: const BouncingScrollPhysics(),
          //                     itemCount: providersfactura.getListaFacturasPaginacion.length+1,
          //                     itemBuilder: (BuildContext context, int index) {

          //                          if (index <
          //                           providersfactura.getListaFacturasPaginacion.length) {


          //                       var _color;
          //                       final factura =
          //                           providersfactura.getListaFacturasPaginacion[index];
                          
          //                       if (factura['venEstado'] == 'AUTORIZADO') {
          //                         _color = Colors.green;
          //                       } else if (factura['venEstado'] ==
          //                           'SIN AUTORIZAR') {
          //                         _color = Colors.orange;
          //                       }
          //                       if (factura['venEstado'] == 'ANULADA') {
          //                         _color = Colors.red;
          //                       }
                          
          //                       return Slidable(
          //                         startActionPane: ActionPane(
          //                           // A motion is a widget used to control how the pane animates.
          //                           motion: const ScrollMotion(),
                          
          //                           children: [
          //                             SlidableAction(
          //                                       backgroundColor: Colors.grey,
          //                                 foregroundColor: Colors.white,
          //                               icon: Icons.list_alt_outlined,
          //                               label: 'Más acciones',
          //                               onPressed: (context) {
          //                                 showCupertinoModalPopup(
          //                                   context: context,
          //                                   builder: (BuildContext context) =>
          //                                       CupertinoActionSheet(
          //                                           title: Text(
          //                                             'Acciones',
          //                                             style:
          //                                                 GoogleFonts.lexendDeca(
          //                                                     fontSize: size
          //                                                         .iScreen(2.0),
          //                                                     color: primaryColor,
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
          //                                                     margin:
          //                                                         EdgeInsets.only(
          //                                                             right: size
          //                                                                 .iScreen(
          //                                                                     2.0)),
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
          //                                                 Navigator.pop(context);
                          
          //                                                 Navigator.push(
          //                                                   context,
          //                                                   MaterialPageRoute(
          //                                                       builder: (context) =>
          //                                                           ViewsPDFs(
          //                                                               infoPdf:
          //                                                                   // 'https://sysvet.neitor.com/reportes/carnet.php?id=${factura['venId']}&empresa=${_usuario!.rucempresa}',
          //                                                                   'https://syscontable.neitor.com/reportes/factura.php?codigo=${factura['venId']}&empresa=${_usuario!.rucempresa}',
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
          //                                                         color:
          //                                                             Colors.red,
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
          //                               visualDensity: VisualDensity.comfortable,
                                
          //                                 leading: CircleAvatar(
          //                                 child: Text(
          //                                 '${factura['venNomCliente'].substring(0, 1)}',
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
          //                                     width: size.wScreen(50.0),
          //                                     child: Text(
          //                                       '${factura['venNomCliente']}',
          //                                       style: GoogleFonts.lexendDeca(
          //                                           // fontSize: size.iScreen(2.45),
          //                                           // color: Colors.white,
          //                                           fontWeight:
          //                                               FontWeight.normal),
          //                                       overflow: TextOverflow.ellipsis,
          //                                     ),
          //                                   ),
          //                                   Text(
          //                                     '${factura['venEstado']}',
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
          //                                           '${factura['venNumFactura']}',
          //                                           style: GoogleFonts.lexendDeca(
          //                                               fontSize:
          //                                                   size.iScreen(1.5),
          //                                               color: Colors.black54,
          //                                               fontWeight:
          //                                                   FontWeight.normal),
          //                                           overflow:
          //                                               TextOverflow.ellipsis,
          //                                         ),
          //                                       ),
          //                                       Container(
          //                                         // color: Colors.green,
          //                                         width: size.wScreen(50.0),
          //                                         child: Text(
          //                                           factura['venFecReg'] != ''
          //                                               ? '${factura['venFecReg'].replaceAll('T', "  ").replaceAll('.000Z', "  ")}'
          //                                               : '--- --- ---',
          //                                           style: GoogleFonts.lexendDeca(
          //                                               // fontSize: size.iScreen(2.45),
          //                                               color: Colors.grey,
          //                                               fontWeight:
          //                                                   FontWeight.normal),
          //                                         ),
          //                                       ),
          //                                     ],
          //                                   ),
          //                                   Container(
          //                                     // color: Colors.green,
          //                                     // width: size.wScreen(100.0),
          //                                     child: Text(
          //                                       '\$${factura['venTotal']}',
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
          //                           }
          //                           else{

          //                              return Consumer<FacturasController>(
          //                           builder: (_, valueNext, __) {
          //                             return valueNext.getpage == null
          //                                 ? Container(
          //                                     margin: EdgeInsets.symmetric(
          //                                         vertical: size.iScreen(2.0)),
          //                                     child: Center(
          //                                       child: Text(
          //                                         'No existen más datos',
          //                                         style: GoogleFonts.lexendDeca(
          //                                             fontSize:
          //                                                 size.iScreen(1.8),
          //                                             // color: primaryColor,
          //                                             fontWeight:
          //                                                 FontWeight.normal),
          //                                       ),
          //                                     ))
          //                                 // : Container();

          //                             : 
                                      
          //                             providersfactura.getListaFacturasPaginacion.length>25?
                                      
          //                             Container(
          //                                 margin: EdgeInsets.symmetric(
          //                                     vertical: size.iScreen(2.0)),
          //                                 child: const Center(
          //                                     child:
          //                                         CircularProgressIndicator())): Container();
          //                           },
          //                         );


          //                           }
          //                     },
          //                   ),
          //                 );
          //               },
          //             )
          //          ,
          // ),
          floatingActionButton: 
  //        FloatingActionButton(
  //                     child: const Icon(
  //                       Icons.add,
  //                       color: Colors.white,
  //                     ),
  //                     onPressed: () {
  //                        final _ctrl =context.read<ComprobantesController>();
  //                          _ctrl.resetListasProdutos();
  //                        _ctrl.resetPlacas();
  //                               _ctrl.setDocumento('');
  //                               _ctrl.setFormaDePago('EFECTIVO');
  //                               _ctrl.setFacturaOk(false);
  //                              _ctrl.setTipoDeTransaccion('F');
  //                                _ctrl.setClienteComprbante({
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
  //   //*************** RESET LA VARIABLE DE RESPONSE SOCKET***************************//
  //   final ctrlSocket=context.read<SocketService>();
  //    ctrlSocket.resetResponseSocket();
  //     //******************************************//
  // _ctrl.setExistCliente(true);
  //                             _ctrl.setTotal();
  //                             _ctrl.setTarifa({});
  //                              _ctrl.setTipoDocumento('');
  //                           Navigator.of(context).push(MaterialPageRoute(
  //                               builder: (context) =>
  //                                    CrearComprobante(
  //                                      user:_usuario ,
  //                                     tipo: 'CREATE',
  //                                   )));
                       
  //                     }
                  
  //           ,
  //         ),



    Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
               Consumer<FacturasController>(builder: (_, valueTot, __) {  
              return  Container(
              height: size.iScreen(5.0),
  padding: EdgeInsets.symmetric(horizontal:size.iScreen(2.0)), // Espaciado interno
  margin: EdgeInsets.all(8.0), // Espaciado externo
  decoration: BoxDecoration(
    color:  Colors.grey, 
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
    child: Text(
     '\$ ${valueTot.totalIngresos}',
      style: TextStyle(
        color: Colors.white,
        fontSize: size.iScreen(2.0),
        fontWeight: FontWeight.bold,
      ),
    ),
  ),
);

            },),
            // Primer FloatingActionButton con imagen 1
            FloatingActionButton(
              backgroundColor:themeColor.appTheme.primaryColor,
              onPressed: () {
                // Acción del primer botón
                print("Botón 1 presionado");

                  //*****************************//

       final _ctrl =context.read<ComprobantesController>();
         _ctrl.resetListasProdutos();
         _ctrl.resetPlacas();
         _ctrl.setDocumento('');
         _ctrl.setFormaDePago('EFECTIVO');
         _ctrl.setFacturaOk(false);
         _ctrl.setTipoDeTransaccion('F');
         _ctrl.setClienteComprbante({
			"perId": 1,
			"perNombre": "CONSUMIDOR FINAL",
			"perDocNumero": "9999999999999",
			"perDocTipo": "RUC",
			"perTelefono": "0000000001",
			"perDireccion": "s/n",
			"perEmail": [
				"sin@sincorreo.com"
			],
			"perCelular": [],
			"perOtros": [
				
			]
		});
    //*************** RESET LA VARIABLE DE RESPONSE SOCKET***************************//
    final ctrlSocket=context.read<SocketService>();
     ctrlSocket.resetResponseSocket();
      //******************************************//
  _ctrl.setExistCliente(true);
   _ctrl.setTotal();
   _ctrl.setTarifa({});
   _ctrl.setTipoDocumento('');
    _ctrl.setPrecio(0);
                             _ctrl.setCantidad(1);
   _ctrl.setTypeAction('MOTOS');
    Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                     CrearComprobante(
                                    
                                       user:widget.user ,
                                      tipo: 'CREATE',
                                    )));


 //*******************************//







              },
              child: Icon(Icons.two_wheeler_outlined,size:size.iScreen(4.5)), // Imagen 1
              heroTag: 'btn1', // Etiqueta única
            ),
            SizedBox(width: 20), // Espacio entre los dos botones
            // Segundo FloatingActionButton con imagen 2
            FloatingActionButton(
              backgroundColor: themeColor.appTheme.accentColor,
              onPressed: () {
                // Acción del segundo botón
                // print("Botón 2 presionado");

                              //*****************************//

       final _ctrl =context.read<ComprobantesController>();
         _ctrl.resetListasProdutos();
         _ctrl.resetPlacas();
         _ctrl.setDocumento('');
         _ctrl.setFormaDePago('EFECTIVO');
         _ctrl.setFacturaOk(false);
         _ctrl.setTipoDeTransaccion('F');
         _ctrl.setClienteComprbante({
			"perId": 1,
			"perNombre": "CONSUMIDOR FINAL",
			"perDocNumero": "9999999999999",
			"perDocTipo": "RUC",
			"perTelefono": "0000000001",
			"perDireccion": "s/n",
			"perEmail": [
				"sin@sincorreo.com"
			],
			"perCelular": [],
			"perOtros": [
			
			]
		});
    //*************** RESET LA VARIABLE DE RESPONSE SOCKET***************************//
    final ctrlSocket=context.read<SocketService>();
     ctrlSocket.resetResponseSocket();
      //******************************************//
  _ctrl.setExistCliente(true);
   _ctrl.setTotal();
   _ctrl.setTarifa({});
   _ctrl.setTipoDocumento('');
    _ctrl.getAllFormaPago();
     _ctrl.setPrecio(0);
                             _ctrl.setCantidad(1);
   _ctrl.setTypeAction('VEHICULOS');
    Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                     CrearComprobante(
                                     
                                       user:widget.user ,
                                      tipo: 'CREATE',
                                    )));


 //*******************************//

              },
              child: Icon(Icons.drive_eta_outlined,size:size.iScreen(4.5)), // Imagen 2
              heroTag: 'btn2', // Etiqueta única
            ),
          ],
        ),



          ),
    );
  }

  Future<void> onRefresh() async {
    final _controller = Provider.of<FacturasController>(context, listen: false);
    _controller.setPage(0);
    _controller.setCantidad(25);
    _controller.buscaAllFacturasPaginacion('', true,_controller.getTabIndex);
  }

  
// void _printTicket(Map<String, dynamic>? _info) async {
//   if (_info == null) return;

// //  //==============================================//
// //   String utcDate = _info['venFecReg'];

// //   // Parsear la fecha en UTC
// //   DateTime dateTimeUtc = DateTime.parse(utcDate);

// //   // Convertirla a hora local
// //   DateTime dateTimeLocal = dateTimeUtc.toLocal();

// //   // Formatear la fecha y hora local como 'YYYY-MM-DD HH:MM'
// //   String formattedDate = DateFormat('yyyy-MM-dd HH:mm').format(dateTimeLocal);

// //   // print(formattedDate);  // Resultado: 2024-09-18 19:27
  
// //  //==============================================//

//   //==============================================//
//   String fechaLocal = convertirFechaLocal(_info['venFecReg']);
//  //==============================================//


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
//   // await SunmiPrinter.printText('FECHA: ${_info['venFechaFactura']}');
//    await SunmiPrinter.printText('FECHA: $fechaLocal');

//   await SunmiPrinter.line();
//   await SunmiPrinter.printText('Conductor: ${_info['venConductor']}');
//   await SunmiPrinter.printText('Placa: ${_info['venOtrosDetalles'][0]}');
//   await SunmiPrinter.setAlignment(SunmiPrintAlign.CENTER);
//   await SunmiPrinter.line();

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



void _printTicket(Map<String, dynamic>? _info,String? user) async {
  if (_info == null) return;

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






}
