import 'package:flutter/material.dart';
import 'package:neitorcont/src/controllers/anuladas_controller.dart';
import 'package:neitorcont/src/controllers/caja_controller.dart';
import 'package:neitorcont/src/controllers/comprobantes_controller.dart';
import 'package:neitorcont/src/controllers/cuentas_por_cobrar_controller.dart';
import 'package:neitorcont/src/controllers/facturas_controller.dart';
import 'package:neitorcont/src/controllers/notas_creditos_controller.dart';
import 'package:neitorcont/src/controllers/prefacturas_controller.dart';
import 'package:neitorcont/src/controllers/proformas_controller.dart';
import 'package:neitorcont/src/models/sesison_model.dart';
import 'package:neitorcont/src/pages/crear_caja.dart';
import 'package:neitorcont/src/pages/crear_comprobante_print.dart';
import 'package:neitorcont/src/pages/crear_materiales.dart';
import 'package:neitorcont/src/pages/lista_caja_paginacion.dart';
import 'package:neitorcont/src/pages/lista_cuentas_por_cobrar.dart';
import 'package:neitorcont/src/pages/lista_materiales.dart';
import 'package:neitorcont/src/pages/listar_anuladas_paginacion.dart';
import 'package:neitorcont/src/pages/listar_facturas.dart';
import 'package:neitorcont/src/pages/listar_facturas_paginacion.dart';
import 'package:neitorcont/src/pages/listar_notas_credito.dart';
import 'package:neitorcont/src/pages/listar_notas_credito_paginacion.dart';
import 'package:neitorcont/src/pages/listar_prefacturas.dart';
import 'package:neitorcont/src/pages/listar_prefacturas_paginacion.dart';
import 'package:neitorcont/src/pages/listar_proformas.dart';
import 'package:neitorcont/src/pages/listar_proformas_paginacion.dart';

import 'package:neitorcont/src/services/socket_service.dart';
import 'package:neitorcont/src/utils/responsive.dart';
import 'package:neitorcont/src/widgets/elementos_submenu.dart';
import 'package:neitorcont/src/widgets/no_data.dart';
import 'package:provider/provider.dart';

class SubmenuTransacciones extends StatelessWidget {
     final Session? user;
  const SubmenuTransacciones({Key? key, this.user,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
// final Session?  user =  ModalRoute.of(context)?.settings.arguments as Session?;
    final Responsive size = Responsive.of(context);
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title:  Text('TRANSACCIONES'),
        ),
        body: Container(
            width: size.wScreen(100),
            height: size.hScreen(100),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF973592).withOpacity(0.5),
                  const Color(0xFF0092D0).withOpacity(0.3),
                ],
                stops: const [0.1, 0.6],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Center(
                      child: Wrap(
                        alignment: WrapAlignment.center,
                        
                        children: [
                        ElementosSubmenu(
                          enabled: true,
                          size: size,
                          image: 'assets/imgs/factura.png',
                          label: "FACTURAS",
                          color: Colors.green,
                          // onTap: () => Navigator.pushNamed(context, 'mascotas'),
                          onTap: () {
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
                                  _controllerFacturas.obtieneTotalDiario('ventas','FACTURAS');
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                     ListarFacturasPaginacion(user: user,)));

                          },
                        ),
                        ElementosSubmenu(
                          enabled: true,
                          size: size,
                          image: 'assets/imgs/prefactura.png',
                          label: 'PREFACTURAS',
                          color: Colors.pink,
                          // onTap: () => Navigator.pushNamed(context, 'mascotas'),
                          onTap: () {
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
                              _controllerPreFacturas.setCantidad(25);
                            _controllerPreFacturas
                                .setInfoBusquedaPreFacturasPaginacion([]);
                            _controllerPreFacturas
                                .buscaAllPreFacturasPaginacion('', true,0);
                                 _controllerPreFacturas.obtieneTotalDiario('ventas','NOTA VENTAS');
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                     ListarPreFacturasPaginacion(user: user,)));
                                      _controllerPreFacturas.setPage(0);
                          },
                        ),
                         ElementosSubmenu(
                          enabled: true,
                          size: size,
                          image: 'assets/imgs/cash-register.png',
                          label: 'CAJA',
                          color: Colors.purple,
                          // onTap: () => Navigator.pushNamed(context, 'mascotas'),
                          onTap: () {

                                final _ctrl =context.read<CajaController>();
                                   _ctrl.setTipo('');
                                   _ctrl.setTipoDocumento('');

                            // Navigator.of(context).push(MaterialPageRoute(
                            //     builder: (context) =>
                            //         const CreaCaja(
                            //           tipo: 'CREATE',
                            //         )));

                                 _ctrl.setInfoBusquedaCajasPaginacion([]);
                           _ctrl.resetValorTotal();
                             _ctrl.buscaAllCajaPaginacion(
                                '',false,0);
                                 _ctrl.calculateTotalIngreso();
                                 _ctrl.obtieneTotalDiario('cajas','');
                                    _ctrl.obtieneTotalesFlotantes('TODOS');
                               Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                     ListarCajaPaginacion(user: user,)));
                                      _ctrl.setCantidad(25);
                                   _ctrl.setPage(0);

                          },
                        ),
                        ElementosSubmenu(
                          enabled: true,
                          size: size,
                          image: 'assets/imgs/proforma.png',
                          label: 'PROFORMAS',
                          color: Colors.blue,
                          // onTap: () => Navigator.pushNamed(context, 'mascotas'),
                          onTap: () {
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
                                 _controllerProformas.obtieneTotalDiario('ventas','PROFORMAS');
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                     ListarProformasProformas(user: user,)));
                          },
                        ),
                        ElementosSubmenu(
                          enabled: true,
                          size: size,
                          image: 'assets/imgs/nota_credito.png',
                          label: 'NOTAS CREDITO',
                          color: Colors.brown,
                          // onTap: () => Navigator.pushNamed(context, 'mascotas'),
                          onTap: () {


                      final _controllerNotasCredito =
                                context.read<NotasCreditosController>();

                            _controllerNotasCredito
                                .onSearchTextNotasCreditoPaginacion("");

                            _controllerNotasCredito
                                .setBtnSearchNotasCreditoPaginacion(false);
                            _controllerNotasCredito
                                .setErrorNotasCreditosPaginacion(null);

                            _controllerNotasCredito
                                .setError401NotasCreditosPaginacion(false);

                            _controllerNotasCredito.resetFormNotasCreditos();
                            _controllerNotasCredito.setPage(0);
                            _controllerNotasCredito.setIsNext(false);
                            _controllerNotasCredito
                                .setInfoBusquedaNotasCreditosPaginacion([]);
                            _controllerNotasCredito.buscaAllNotasCreditosPaginacion(
                                '', true,0);

                                   _controllerNotasCredito.obtieneTotalDiario('ventas','NOTA CREDITOS');


                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                     ListarNotasCreditoPaginacion(user: user,)));
                          },
                        ),
                        ElementosSubmenu(
                          enabled: true,
                          size: size,
                          image: 'assets/imgs/fac_rejected.png',
                          label: 'SIN AUTORIZAR / ANULADAS',
                          color: Colors.redAccent,
                          // onTap: () => Navigator.pushNamed(context, 'mascotas'),
                          onTap: () {


                      final _controllerAnuladas =
                                context.read<AnuladasController>();

                            _controllerAnuladas
                                .onSearchTextAnuladaPaginacion("");

                            _controllerAnuladas
                                .setBtnSearchAnuladaPaginacion(false);
                            _controllerAnuladas
                                .setErrorAnuladasPaginacion(null);

                            _controllerAnuladas
                                .setError401AnuladasPaginacion(false);

                            _controllerAnuladas.resetFormAnuladas();
                            _controllerAnuladas.setPage(0);
                            _controllerAnuladas.setIsNext(false);
                            _controllerAnuladas
                                .setInfoBusquedaAnuladasPaginacion([]);
                            _controllerAnuladas.buscaAllAnuladasPaginacion(
                                '', true,0);
                            _controllerAnuladas.obtieneTotalDiario('ventas','ANULADAS');

                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                     ListarAnuladasPaginacion(user: user,)));
                          },
                        ),
                             ElementosSubmenu(
                          enabled: true,
                          size: size,
                          image: 'assets/imgs/account.png',
                          label: 'CUENTAS X COBRAR',
                          color: Colors.cyan,
                          // onTap: () => Navigator.pushNamed(context, 'mascotas'),
                          onTap: () {


                 
//   final _ctrl =context.read<ComprobantesController>();
//                           _ctrl.resetListasProdutos();
//                           _ctrl.resetPlacas();
//                                 _ctrl.setDocumento('');
                                 
//                                      //*************** RESET LA VARIABLE DE RESPONSE SOCKET***************************//
//     final ctrlSocket=context.read<SocketService>();
//      ctrlSocket.resetResponseSocket();
//       //******************************************//

//                                 _ctrl.setFacturaOk(false);
//                                  _ctrl.setExistCliente(true);
//                                    _ctrl.setFormaDePago('EFECTIVO');
//                                      final ctrl =context.read<CuentasXCobrarController>();
//                                 ctrl.setTipoDeTransaccion('D');
//    ctrl.setClienteComprbante({
// 			"perId": 1,
// 			"perNombre": "",
// 			"perDocNumero": "9999999999999",
// 			"perDocTipo": "RUC",
// 			"perTelefono": "0000000001",
// 			"perDireccion": "s/n",
// 			"perEmail": [
// 				"sin@sincorreo.com"
// 			],
// 			"perCelular": [],
// 			"perOtros": [
				
// 			]
// 		});

//                               _ctrl.setTotal();
//                               _ctrl.setTarifa({});
//                                _ctrl.setTipoDocumento('');
//                            _ctrl.getAllFormaPago();
//                            _ctrl.setPrecio(0);
//                            _ctrl.setCantidad(1);
//                        _ctrl.setTypeAction('MATERIALES');






// ctrl.buscaAllMaterialesPaginacion('',false,0);

//           Navigator.of(context).push(MaterialPageRoute(
//                                 builder: (context) =>
//                                      ListarMaterialesPaginacion(
                                     
//                                       user: user,)));


               final _ctrl =context.read<CuentasXCobrarController>();
                                    
                           _ctrl.resetValorTotal();
                            _ctrl.setPage(0);
                            _ctrl.setCantidadElementos(1000);
                            _ctrl.setIsNext(false);
                             _ctrl.buscaAllCuentasPorCobrar(
                                '',false,0);
_ctrl.obtieneTotalDiario('cuentasporcobrar','');
                                        return Navigator.of(context).push(MaterialPageRoute(
                                builder: (context)=>
                                     ListarCuentasPorCobrar(user: user,)));

                          },
                        ),
                     
                      ]),
                    )
              ));
  }
}
