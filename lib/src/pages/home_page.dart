import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:neitorcont/src/controllers/comprobantes_controller.dart';
import 'package:neitorcont/src/controllers/cuentas_por_cobrar_controller.dart';

import 'package:neitorcont/src/controllers/home_controller.dart';

import 'package:neitorcont/src/controllers/propietarios_controller.dart';
import 'package:neitorcont/src/controllers/reservas_controller.dart';
import 'package:neitorcont/src/models/sesison_model.dart';
import 'package:neitorcont/src/pages/crear_comprobante_print.dart';
import 'package:neitorcont/src/pages/lista_cuentas_por_cobrar.dart';
import 'package:neitorcont/src/pages/lista_materiales.dart';
import 'package:neitorcont/src/pages/listar_reservas_paginacion.dart';
import 'package:neitorcont/src/pages/prueba.dart';
import 'package:neitorcont/src/pages/submenu_transacciones.dart';

import 'package:neitorcont/src/services/socket_service.dart';
import 'package:neitorcont/src/theme/theme_provider.dart';
import 'package:neitorcont/src/theme/themes_app.dart';
import 'package:neitorcont/src/utils/responsive.dart';
import 'package:neitorcont/src/widgets/elementosHome.dart';
import 'package:neitorcont/src/widgets/menu_Drower.dart';
import 'package:neitorcont/src/widgets/no_data.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  final Session? user;
  const HomePage({Key? key, this.user}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Session? usuario;

  // final socket = SocketService();
  final homeContrtoller = HomeController();
  final propietarioContrtoller = PropietariosController();
  final themeContrtoller = AppTheme();

  @override
  void initState() {
    // initData();
    super.initState();
  }

  void initData() async {
    Future.delayed(const Duration(seconds: 2), () {
      // final BuildContext _size;
      int? _primColor =
          int.parse(widget.user!.colorPrimario!.replaceAll("#", '0xff'));
      int? _secColor =
          int.parse(widget.user!.colorSecundario!.replaceAll("#", '0xff'));
      Color? _colorPrimario = Color(_primColor);
      Color? _colorSecundario = Color(_secColor);
      final _size = Responsive.of(context);
      Provider.of<AppTheme>(context, listen: false).setAppTheme(
          true, '', _colorSecundario, Colors.white, _colorPrimario, _size);
      // print('veces q repite:');
    });
  }

  @override
  Widget build(BuildContext context) {
    final Responsive size = Responsive.of(context);
 final ctrl = context.read<HomeController>();
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Consumer<ThemeProvider>(
        builder: (_, valueThem, __) {
          return Scaffold(
            appBar: 
            // valueThem.getIsTheme == false
            //     ?null
            //     :
                AppBar(
                    // title:valueThem.getIsTheme ==false
                    // ? const Text('NeitorVet')
                    // :
                     backgroundColor: Theme.of(context).primaryColor,
                  title:  Text(
                  'NELMAR',
                     
                    ),
                  ) ,

            drawer: 
            // Consumer<SocketService>(builder: (_, valueConexion, __) {
            //   return valueConexion.serverStatus == ServerStatus.Online
            //       ? 
                  
            //       MenuPrincipal(user: widget.user)
            //       : Container();
            // }),

            MenuPrincipal(user: widget.user),

            body: Stack(
              children: [
                Container(
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
                            child: ListView(
                              shrinkWrap: true,
                              physics: const BouncingScrollPhysics(),
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  // mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Center(
                                      child: Container(
                                          // color: Colors.white,
                                          margin: EdgeInsets.only(
                                              top: size.iScreen(1.0),
                                              left: size.iScreen(2.0),
                                              right: size.iScreen(2.0),
                                              bottom: size.iScreen(1.0)),
                                          width: size.iScreen(25.0),
                                          // height: size.iScreen(20.0),
                                          child: widget.user!.logo != '' ||
                                                  widget.user!.logo != null
                                              ? FadeInImage(
                                                  image: NetworkImage(
                                                    '${widget.user!.logo}',
                                                    scale: size.wScreen(30.0),
                                                  ),
                                                  placeholder: const AssetImage(
                                                    'assets/imgs/loader.gif',
                                                  ),
                                                  imageErrorBuilder:
                                                      (context, error, stackTrace) {
                                                    return Image.asset(
                                                        'assets/imgs/no-image.jpg',
                                                        width: size.iScreen(10.0));
                                                  },
                                                  fit: BoxFit.fitWidth,
                                                )
                                              : ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(20.0),
                                                  child: Image.asset(
                                                    'assets/imgs/no-image.jpg',
                                                    width: size.iScreen(15.0),
                                                    // height:size.hScreen(15.0) ,
                                                  ),
                                                )),
                                    ),
                                   Wrap(
                                      alignment: WrapAlignment.center,
                                      children: [
                                      widget.user!.rol!.contains('SUPERADMIN')?  ElementosHome(
                                          enabled: true,
                                          size: size,
                                          image: 'assets/imgs/businessman.png',
                                          label: 'CLIENTES',
                                          // onTap: () => Navigator.pushNamed(context, 'mascotas'),
                                          onTap: () {
                                            final _controllerPropietario = context
                                                .read<PropietariosController>();

                                            _controllerPropietario
                                                .onSearchTextPropietarioPaginacion(
                                                    "");

                                            _controllerPropietario
                                                .setBtnSearchPropietarioPaginacion(
                                                    false);
                                            _controllerPropietario
                                                .setErrorPropietariosPaginacion(
                                                    null);

                                            _controllerPropietario
                                                .setError401PropietariosPaginacion(
                                                    false);

                                            _controllerPropietario
                                                .resetFormPropietario();
                                            _controllerPropietario.setPage(0);
                                            _controllerPropietario.setIsNext(false);
                                            _controllerPropietario
                                                .setInfoBusquedaPropietariosPaginacion(
                                                    []);
                                            _controllerPropietario
                                                .buscaAllPropietariosPaginacion(
                                                    '', false);

                                            Navigator.pushNamed(context,
                                                'listaPropietariosPaginacion',
                                                arguments: widget.user);
                                          },
                                        ):Container(),
                                        // ElementosHome(
                                        //   enabled: true,
                                        //   size: size,
                                        //   image: 'assets/imgs/icon-mascota.png',
                                        //   label: 'MASCOTAS',
                                        //   onTap: () => Navigator.pushNamed(
                                        //       context, 'SubmenuMascotas'),
                                        //   // onTap: () {
                                        //   //   Navigator.of(context).push(MaterialPageRoute(
                                        //   //       builder: (context) =>
                                        //   //           const SubmenuMascotas()));
                                        //   // },
                                        // ),
                                        // ElementosHome(
                                        //   enabled: true,
                                        //   size: size,
                                        //   image: 'assets/imgs/icon-cita.png',
                                        //   label: 'AGENDAR CITAS',
                                        //   // onTap: () => Navigator.pushNamed(context, 'citas'),
                                        //   onTap: () {
                                        //     final _controllerReservas =
                                        //         context.read<ReservasController>();

                                        //     _controllerReservas
                                        //         .onSearchTextReservaPaginacion("");

                                        //     _controllerReservas
                                        //         .setBtnSearchReservaPaginacion(
                                        //             false);
                                        //     _controllerReservas
                                        //         .setErrorReservasPaginacion(null);

                                        //     _controllerReservas
                                        //         .setError401ReservasPaginacion(
                                        //             false);

                                        //     _controllerReservas.resetFormReservas();
                                        //     _controllerReservas.setPage(0);
                                        //     _controllerReservas.setIsNext(false);
                                        //     _controllerReservas
                                        //         .setInfoBusquedaReservasPaginacion(
                                        //             []);
                                        //     _controllerReservas
                                        //         .buscaAllReservasPaginacion(
                                        //             '', false);

                                        //     // Navigator.pushNamed(
                                        //     //     context, 'listaPropietariosPaginacion',
                                        //     //     arguments: widget.user);

                                        //     Navigator.of(context).push(
                                        //         MaterialPageRoute(
                                        //             builder: (context) =>
                                        //                 const ListaReservasPaginacion()));
                                        //   },
                                        // ),




                            //              ElementosSubmenu(
                            //   enabled: true,
                            //   size: size,
                            //   image: 'assets/imgs/time.png',
                            //   label: 'COMPROBANTE',
                            //   color: Colors.purple,
                            //   // onTap: () => Navigator.pushNamed(context, 'mascotas'),
                            //   onTap: () {

                            //         final _ctrl =context.read<ComprobantesController>();

                            //       _ctrl.setTotal();
                            //       _ctrl.setTarifa({});
                            //        _ctrl.setTipoDocumento('');
                            //     Navigator.of(context).push(MaterialPageRoute(
                            //         builder: (context) =>
                            //             const CrearComprobante(
                            //               tipo: 'CREATE',
                            //             )));
                            //   },
                            // ),
                                       
                                        // ElementosHome(
                                        //   enabled: true,
                                        //   size: size,
                                        //   image: 'assets/imgs/icon-factura.png',
                                        //   label: 'MIS FACTURAS',
                                        //   // onTap: () => Navigator.pushNamed(context, 'facturas'),
                                        //   onTap: () {},
                                        // ),

                                        // ElementosHome(
                                        //   enabled: true,
                                        //   size: size,
                                        //   image: 'assets/imgs/icon-factura.png',
                                        //   label: 'MIS FACTURAS',
                                        //   // onTap: () => Navigator.pushNamed(context, 'facturas'),
                                        //   onTap: () {},
                                        // ),
                                     !widget.user!.rol!.contains('DESPACHO')?   ElementosHome(
                                          enabled: true,
                                          size: size,
                                          image: 'assets/imgs/icon-factura.png',
                                          label: 'TRANSACCIONES',
                                          onTap: () => 
                                            Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                         SubmenuTransacciones(user: widget.user,)))
                                          // Navigator.pushNamed(
                                          //     context, 'SubmenuTransacciones',arguments:usuario),
                                          // onTap: () {},
                                        ):Container(),

                                           ElementosHome(
                                          enabled: true,
                                          size: size,
                                          image: 'assets/imgs/building-materials.png',
                                          label: 'MATERIALES',
                                          onTap: () {

                              //                final _ctrl =context.read<CuentasXCobrarController>();
                                        
                              //  _ctrl.resetValorTotal();
                              //    _ctrl.buscaAllCuentasPorCobrar(
                              //       '',false,0);

                              //               return Navigator.of(context).push(MaterialPageRoute(
                              //       builder: (context)=>
                              //            ListarCuentasPorCobrar(user: widget.user,)));



                     
  final _ctrl =context.read<ComprobantesController>();
                              _ctrl.resetListasProdutos();
                              _ctrl.resetPlacas();
                                    _ctrl.setDocumento('');
                                     
                                         //*************** RESET LA VARIABLE DE RESPONSE SOCKET***************************//
    final ctrlSocket=context.read<SocketService>();
    //  ctrlSocket.resetResponseSocket();
      //******************************************//

                                    _ctrl.setFacturaOk(false);
                                     _ctrl.setExistCliente(true);
                                       _ctrl.setFormaDePago('EFECTIVO');
                                         final ctrl =context.read<CuentasXCobrarController>();
                                    ctrl.setTipoDeTransaccion('D');
   ctrl.setClienteComprbante({
			"perId": 1,
			"perNombre": "",
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

                                  _ctrl.setTotal();
                                  _ctrl.setTarifa({});
                                   _ctrl.setTipoDocumento('');
                               _ctrl.getAllFormaPago();
                               _ctrl.setPrecio(0);
                               _ctrl.setCantidad(1);
_ctrl.resetCalculos();
 final ctrlMateriales =context.read<CuentasXCobrarController>();
ctrlMateriales.resetValorTotalMateriales();



                           _ctrl.setTypeAction('MATERIALES');






ctrl.buscaAllMaterialesPaginacion('',false,0);
    ctrl.obtieneTotalDiario('ventas','DESPACHO');
          Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                         ListarMaterialesPaginacion(
                                         
                                          user: widget.user,)));

          //====================================//
                    //  Navigator.of(context).push(MaterialPageRoute(
                    //                 builder: (context) =>
                    //                      PrintScreen(
                                         
                    //                      )));
                


          //=====================================//


                                          }
                                         
                                        ),





                                //          ElementosHome(
                                //           enabled: true,
                                //           size: size,
                                //           image: 'assets/imgs/time.png',
                                //           label: 'COMPROBANTE',
                                //           // onTap: () => Navigator.pushNamed(context, 'productos'),
                                //           onTap: () {
                                //                 final _ctrl =context.read<ComprobantesController>();

                                //   _ctrl.setTotal();
                                //   _ctrl.setTarifa({});
                                //    _ctrl.setTipoDocumento('');
                                // Navigator.of(context).push(MaterialPageRoute(
                                //     builder: (context) =>
                                //         const CrearComprobante(
                                //           tipo: 'CREATE',
                                //         )));

                                //           },
                                //         ),
                                        // ElementosHome(
                                        //   enabled: true,
                                        //   size: size,
                                        //   image: 'assets/imgs/icon-factura.png',
                                        //   label: 'TEMA',
                                        //   // onTap: () => Navigator.pushNamed(context, 'facturas'),
                                        //   onTap: () {
                                        //     //  final theme= context.read<AppTheme>();
                                        //     //  theme.setDarkTheme(!theme.darkTheme,'',Colors.amber,Colors.white,Colors.black,size);
                                        //     // theme.setDarkTheme(!theme.darkTheme,'',Color(0XFF973592),Colors.white,Color(0xFF3FBDE0),size);
                                        //     // theme.setDarkTheme(!theme.darkTheme,'',Color(0XFF973592),Colors.white,Color(0xFF353897),size);
                                        //     // theme.setAppTheme(!theme.darkTheme,'',_colorPrimario,Colors.white,_colorSecundario,size);
                                        //   },
                                        // ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          )
                        
                ),
                Positioned(
                  right:20,
                  bottom: 15,
                  child: Text('Ver: 1.0.0',style: GoogleFonts.lexendDeca(
                                  fontSize: size.iScreen(2.0),
                                  // color: Colors.white,
                                  fontWeight: FontWeight.bold)))
              ],
            ),
            // floatingActionButton: FloatingActionButton(
            //   onPressed: () {},
            //   child: const Icon(Icons.add),
            // ),
          );
        },
      ),
    );
  }
}
