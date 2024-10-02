import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import 'package:neitorcont/src/controllers/cuentas_por_cobrar_controller.dart';
import 'package:neitorcont/src/services/notifications_service.dart';
import 'package:neitorcont/src/theme/theme_provider.dart';
import 'package:neitorcont/src/utils/responsive.dart';
import 'package:neitorcont/src/widgets/modal_permisos.dart';
import 'package:provider/provider.dart';


class CrearpagoCxC extends StatefulWidget {
  const CrearpagoCxC({Key? key}) : super(key: key);

  @override
  State<CrearpagoCxC> createState() => _CrearpagoCxCState();
}

class _CrearpagoCxCState extends State<CrearpagoCxC> {


 @override
  void initState() {

  // Usar addPostFrameCallback para asegurarse de que el árbol de widgets esté construido
  WidgetsBinding.instance!.addPostFrameCallback((_) {
    final provider = Provider.of<CuentasXCobrarController>(context, listen: false);
    provider.initializeFechaAbono();
  });
    super.initState();
  }



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
      appBar:  AppBar(
            title:Text('Crear Pago'),
            actions: [
               Container(
                margin: EdgeInsets.only(right: size.iScreen(1.5)),
                child: IconButton(
                    splashRadius: 28,
                    onPressed: () {
                          // modalNotificarCliente(context,size,ctrlTheme);
                      _onSubmit(
                        context,
                        ctrl,    size,ctrlTheme                  );
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
                    
                      
                    ],
                  ),
                   // //***********************************************/
                  SizedBox(
                    height: size.iScreen(1.0),
                  ),
                  // //*****************************************/
                    Consumer<CuentasXCobrarController>(builder: (_, value, __) { 
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
                    height: size.iScreen(0.0),
                  ),
                  //*****************************************/
               
               Consumer<CuentasXCobrarController>(builder: (_, value, __) {  
                    return 
                  value.getTipo!='EFECTIVO'
                  ?  TextFormField(
            textAlign: TextAlign.center,
            autofocus: false,
            decoration: InputDecoration(
                  labelText: 'Número de Comprobante',
              labelStyle: TextStyle(fontSize: size.iScreen(1.9)),
              // Aquí puedes agregar más personalización si es necesario
            ),
            style: TextStyle(
              fontSize: size.iScreen(3.0),
              color: Colors.black,
            ),
            keyboardType: TextInputType.number, // Teclado solo numérico
            inputFormatters: <TextInputFormatter>[
              //   // Solo aceptar números con esta expresión regular
                  FilteringTextInputFormatter.allow(RegExp(r'^[0-9]*$')),
            ],
            onChanged: (text) {
             
              ctrl.setNumeroDocumeto(text.toString());
            },
            validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingresa número';
                  }
                  return null;
                },
              ):Container();


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
                        child: Text('Seleccione Banco : ',
                            style: GoogleFonts.lexendDeca(
                                fontSize: size.iScreen(2.0),
                                fontWeight: FontWeight.normal,
                                color: Colors.grey)),
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: GestureDetector(
                          onTap: () {
                            context.read<CuentasXCobrarController>().buscaAllBancos();
            
                            // // _buscarMascota(context, size);
                            
                            modalBancos(context, size);
            
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
                    
                      
                    ],
                  ),
                   // //***********************************************/
                  SizedBox(
                    height: size.iScreen(1.0),
                  ),
                  // //*****************************************/
                    Consumer<CuentasXCobrarController>(builder: (_, value, __) { 
                         return Container(
                            // color: Colors.red,
                            width: size.wScreen(100.0),
            
                            // color: Colors.blue,
                            child: Text(
                                value.getBanco.isEmpty
                                    ? ' --- --- --- --- --- --- --- ---'
                                    : ' ${value.getBanco}',
                                style: GoogleFonts.lexendDeca(
                                    fontSize: size.iScreen(2.3),
                                    fontWeight: FontWeight.normal,
                                    color: value.getBanco.isEmpty
                                        ? Colors.grey
                                        : Colors.black)),
                          );
                       },),
                
                  //***********************************************/
                  SizedBox(
                    height: size.iScreen(0.5),
                  ),
                  //*****************************************/

                  Consumer<CuentasXCobrarController>(builder: (_, value, __) {  
                    return  
                    value.getTipo!='EFECTIVO'
                  ?
                    
                     Row(
                    children: [
                      SizedBox(
                        // width: size.wScreen(20.0),
            
                        // color: Colors.blue,
                        child: Text('Depósito : ',
                            style: GoogleFonts.lexendDeca(
                                fontSize: size.iScreen(2.0),
                                fontWeight: FontWeight.normal,
                                color: Colors.grey)),
                      ),
                       // //*****************************************/
                    Consumer<CuentasXCobrarController>(builder: (_, value, __) { 
                         return Container(
                            // color: Colors.red,
                            // width: size.wScreen(100.0),
            
                            // color: Colors.blue,
                            child: Text(
                                value.getItemDeposito.isEmpty
                                    ? ' --- --- --- --- --- --- --- ---'
                                    : ' ${value.getItemDeposito}',
                                style: GoogleFonts.lexendDeca(
                                    fontSize: size.iScreen(2.3),
                                    fontWeight: FontWeight.normal,
                                    color: value.getTipo.isEmpty
                                        ? Colors.grey
                                        : Colors.black)),
                          );
                       },),
                       //***********************************************/
                       Spacer(),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: GestureDetector(
                          onTap: () {
                 
                            
                            modalDeposito(context, size);
            
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
                    
                      
                    ],
                  ):Container();
                  }),


                
                
                  Row(
                    children: [
                      SizedBox(
                        // width: size.wScreen(100.0),
            
                        // color: Colors.blue,
                        child: Text('Valor :  ',
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
              ctrl.setValor(value);
            },
            validator: (text) {
              if (text == null || text.isEmpty) {
                return 'Por favor, ingrese Valor';
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
                    height: size.iScreen(2.0),
                  ),
                  //*****************************************/
                      Consumer<CuentasXCobrarController>(
                        builder: (_, valueEdad, __) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    'Fecha : ',
                                    style: GoogleFonts.lexendDeca(
                                      fontSize: size.iScreen(2.0),
                                      color: Colors.black45,
                                      // fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(
                                    height: size.iScreen(1.0),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      FocusScope.of(context)
                                          .requestFocus(FocusNode());
                                      _fechaAbono(context, ctrl,ctrlTheme);
                                    },
                                    child: Row(
                                      children: [
                                        Text(
                                          valueEdad.getFechaAbono ??
                                              ' yyyy-mm-dd',
                                          style: GoogleFonts.lexendDeca(
                                            fontSize: size.iScreen(2.2),
                                            color: Colors.black45,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(
                                          width: size.iScreen(2.0),
                                        ),
                                         Icon(
                                          Icons.date_range_outlined,
                                          color: ctrlTheme.appTheme.primaryColor,
                                          size: 40,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                             
                           
                            ],
                          );
                        },
                      ),
                      //***********************************************/
                      SizedBox(
                        height: size.iScreen(1.0),
                      ),
                      //*****************************************/

                     
                      Container(
                        // width: size.wScreen(45.0),
                        child: TextFormField(
                      
                        textAlign: TextAlign.center,
            autofocus: false,
            decoration: InputDecoration(
                labelText: 'Observación',
              labelStyle: TextStyle(fontSize: size.iScreen(1.9)),
              // Aquí puedes agregar más personalización si es necesario
            ),
            style: TextStyle(
              fontSize: size.iScreen(3.0),
              color: Colors.black,
            ),
                          onChanged: (text) {
                            ctrl.setObservacion(text);
                          },
                          validator: (text) {
                            if (text!.trim().isNotEmpty) {
                              return null;
                            } else {
                              return 'Ingrese Observación';
                            }
                          },
                        ),
                      ),

                        //***********************************************/
                      SizedBox(
                        height: size.iScreen(1.5),
                      ),
                      //*****************************************/
                        Container(
                          width: size.wScreen(100.0),
                          child: Text('Foto : ',
                                      style: GoogleFonts.lexendDeca(
                                        fontSize: size.iScreen(2.0),
                                        color: Colors.black45,
                                        // fontWeight: FontWeight.bold,
                                      ),
                                    ),
                        ),
                            //***********************************************/
                      SizedBox(
                        height: size.iScreen(1.5),
                      ),
                      //*****************************************/
                        // Container(
                        //   color: Colors.red,
                        //   width: size.wScreen(100.0),
                        //   height: size.hScreen(30.0),
                        //   child: Center(
                        //     child: Text('Foto : ',
                        //                 style: GoogleFonts.lexendDeca(
                        //                   fontSize: size.iScreen(2.0),
                        //                   color: Colors.black45,
                        //                   // fontWeight: FontWeight.bold,
                        //                 ),
                        //               ),
                        //   ),
                        // ),

                            //***********************************************/
    
                          Container(
                            width: size.wScreen(90.0),
                            // height: size.hScreen(80.0),
                            clipBehavior: Clip.antiAlias,
                            decoration: ShapeDecoration(
                              shape: RoundedRectangleBorder(
                                side: BorderSide(width: 1, color: Colors.grey),
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Container(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    // width: size.wScreen(80),
                                    // height: size.hScreen(100.0),
                                    child: GestureDetector(
                                      onTap: () {
                                        final control =
                                            context.read<CuentasXCobrarController>();
                                        bottomSheet(control, context, size);
                                      },
                                      child: Consumer<CuentasXCobrarController>(
                                        builder: (_, valueFoto, __) {
                                          return valueFoto.getUrlImage != ""
                                              ? Center(
                                                  child: Column(
                                                    children: [
                                                      // Image.file(
                                                      //  File(valueFoto.image!.path
                                                      //  ),
                                                      //  fit: BoxFit.cover,
                                                      //   // width: size.wScreen(100.0),
                                                      //   // height: size.hScreen(0.0),
                                                      // ),
                                                      Stack(
                                                        children: [
                                                          Center(
                                                              child:
                                                                  // Image.network(
                                                                  //   valueFoto.getUrlImage,
                                                                  //   errorBuilder: (context, error, stackTrace) {
                                                                  //     // print('Error al cargar la imagen: $error');
                                                                  //     return
                                                                  //     Icon(
                                                                  //       Icons.error_outline,
                                                                  //       size: size.iScreen(4.0),
                                                                  //       color: Colors.red,
                                                                  //     );
                                                                  //   },
                                                                  // ),
    
                                                      //             Container(
                                                      //                decoration: BoxDecoration(
                                                      //                       //  color: Colors.red,
                                                      //                 borderRadius: BorderRadius.circular(8),
                                                      //               ),
                                                             
                                                      //               // width: size.wScreen(100.0),
                                                      //               height: size.hScreen(20.0),
                                                      //                 constraints: BoxConstraints(
                                                      // minHeight:
                                                      //     size.iScreen(49.5), maxHeight: size.iScreen(49.5)),
                                                      //               child: FadeInImage(
                                                      //       placeholder:
                                                      //           const AssetImage(
                                                      //                 'assets/imgs/loader.gif'),
                                                      //       image: NetworkImage(
                                                      //         '${valueFoto.getUrlImage}',
                                                      //       ),
                                                      //     ),
                                                      //             )),
                                                      Container(
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(8),
  ),
  height: size.hScreen(20.0),
  constraints: BoxConstraints(
    minHeight: size.iScreen(49.5),
    maxHeight: size.iScreen(49.5),
  ),
  child: ClipRRect(
    borderRadius: BorderRadius.circular(8.0),
    child: FadeInImage(
      placeholder: const AssetImage('assets/imgs/loader.gif'),
      image: NetworkImage('${valueFoto.getUrlImage}'),
      fit: BoxFit.cover, // Esto hace que la imagen ocupe todo el contenedor
      width: double.infinity, // Hace que el ancho ocupe todo el espacio disponible
    ),
  ),
)),
                                                          Positioned(
                                                              top: size
                                                                  .iScreen(1.0),
                                                              right: size
                                                                  .iScreen(2.0),
                                                              child: InkWell(
                                                                onTap: () {
    // print('sssiii');
                                                                  valueFoto.eliminaUrlServer(
                                                                      valueFoto.getUrlImage);
                                                                },
                                                                child: Icon(
                                                                  Icons
                                                                      .delete_forever,
                                                                  color:
                                                                      Colors.red,
                                                                  size: size
                                                                      .iScreen(4),
                                                                ),
                                                              ))
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              : Container(
                                                  constraints: BoxConstraints(
                                                      minHeight:
                                                          size.hScreen(50.0)),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.center,
                                                    children: [
                                                      Icon(
                                                        Icons.camera_alt_rounded,
                                                        color: Colors.grey,
                                                        size: size.iScreen(4.0),
                                                      ),
                                                      Text(
                                                        'Tomar Foto',
                                                        // textAlign: TextAlign.center,
                                                        style:
                                                            GoogleFonts.poppins(
                                                                fontSize: size
                                                                    .iScreen(1.5),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                color: Colors
                                                                    .black54),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          //***********************************************/

                      //***********************************************/
                      SizedBox(
                        height: size.iScreen(1.5),
                      ),
                      //*****************************************/
                  SizedBox(
                    height: size.iScreen(0.0),
                  ),

                ],
              ),
            ),
          ),
        ),
       ),
    );
  }

  void _onSubmit(BuildContext context, CuentasXCobrarController ctrl ,Responsive size,ThemeProvider theme) {
      final isValid = ctrl.validateForm();
    if (!isValid) return;
    if (isValid) {



      if (ctrl.getTipo.isEmpty) {
        NotificatiosnService.showSnackBarDanger('Debe seleccionar Tipo');
      } else if (ctrl.getBanco.isEmpty) {
        NotificatiosnService.showSnackBarDanger(
            'Debe seleccionar Banco');
      }
      
      else if (ctrl.getValor == 0.0) {
        NotificatiosnService.showSnackBarDanger(
            'Debe agregar Valor');
      } else if (ctrl.getFechaAbono.isEmpty) {
        NotificatiosnService.showSnackBarDanger(
            'Debe agregar Fecha');
      }else if (ctrl.getnumeroDocumeto!.isEmpty &&ctrl.getTipo!='EFECTIVO') {
        NotificatiosnService.showSnackBarDanger(
            'Debe agregar # de Comprobante');
      }
      else if (ctrl.getUrlImage.isEmpty ) {
        NotificatiosnService.showSnackBarDanger(
            'Debe agregar imagen de Comprobante');
      }
      
      else{
           modalNotificarCliente(context,size,theme,ctrl);
          // ctrl.createPago(context);
          // ctrl.buscaAllCuentasPorCobrar('',false,0);
          //    Navigator.pop(context);


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
            height: size.hScreen(30.0), // Ajusta la altura según sea necesario
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),

           

              child: 
              Consumer<CuentasXCobrarController>(builder: (_, value, __) {  

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
Future<bool?> modalNotificarCliente(BuildContext context, Responsive size,ThemeProvider theme,CuentasXCobrarController crtl) {
  return showDialog<bool>(
    barrierColor: Colors.black54,
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text("INFORMACIÓN"),
        content: SizedBox(
          width: size.wScreen(100),
          // height: size.hScreen(30.0), // Ajusta la altura según sea necesario
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('¿Desea notificar al cliente sobre el pago realizado?',style:
                                                            GoogleFonts.poppins(
                                                                fontSize: size
                                                                    .iScreen(2.0),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                color: Colors
                                                                    .black54)), // Pregunta que se muestra en el modal
               SizedBox(height: size.iScreen(1.0)), // Espaciado entre el texto y los botones
               Row(
  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  children: [
    TextButton(
      onPressed: () {
        // Acción para el botón "Sí"
        crtl.setNotificar(true);
         crtl.createPago(context);
       
        Navigator.pop(context);
        Navigator.pop(context); // Retorna true si se selecciona "Sí"
           crtl.buscaAllCuentasPorCobrar('',false,0);
      },
      style: TextButton.styleFrom(
        backgroundColor: theme.appTheme.primaryColor,// Color azul
        primary: Colors.white, // Texto en blanco
      ),
      child: const Text("Sí"),
    ),
    TextButton(
      onPressed: () {
         crtl.setNotificar(false);
         crtl.createPago(context);
         
        Navigator.pop(context);
        Navigator.pop(context); // Retorna true si se selecciona "Sí"
         crtl.buscaAllCuentasPorCobrar('',false,0);
      },
      style: TextButton.styleFrom(
        backgroundColor: theme.appTheme.accentColor,// Color azul
        primary: Colors.white, // Texto en blanco
      ),
      child: const Text("No"),
    ),
  ],
)

              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //   children: [
              //     TextButton(
              //       onPressed: () {
              //         // Acción para el botón "Sí"
              //         // Aquí puedes llamar a un método o hacer lo que necesites
              //         Navigator.pop(context); // Retorna true si se selecciona "Sí"
              //       },
              //       child: const Text("Sí"),
              //     ),
              //     TextButton(
              //       onPressed: () {
              //         // Acción para el botón "No"
              //         Navigator.pop(context); // Retorna false si se selecciona "No"
              //       },
              //       child: const Text("No"),
              //     ),
              //   ],
              // ),
            ],
          ),
        ),
      );
    },
  );
}


  //**********************************************MODAL TIPO  **********************************************************************//
  Future<bool?> modalBancos(
      BuildContext context, Responsive size) {
    return showDialog<bool>(
      barrierColor: Colors.black54,
      context: context,
      builder: (context) {

       return AlertDialog(
          title: const Text("SELECCIONE BANCO"),
          content: SizedBox(
            width: size.wScreen(100),
            height: size.hScreen(30.0), // Ajusta la altura según sea necesario
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),

           

              child: 
              Consumer<CuentasXCobrarController>(builder: (_, value, __) {  

                    if (value.getListBancos.isEmpty) {
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
                  children: value.getListBancos.map((e) => 
                  
                  
                  GestureDetector(
                          onTap: () {
                            value.setBanco(e['banNombre']);
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
                               '${e['banNombre']}',
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
  Future<bool?> modalDeposito(
      BuildContext context, Responsive size) {
    return showDialog<bool>(
      barrierColor: Colors.black54,
      context: context,
      builder: (context) {

       return AlertDialog(
          title: const Text("SELECCIONE DEPOSITO"),
          content: SizedBox(
            width: size.wScreen(100),
            height: size.hScreen(20.0), // Ajusta la altura según sea necesario
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),

           

              child: 
              Consumer<CuentasXCobrarController>(builder: (_, value, __) {  

                    if (value.getListDeposito.isEmpty) {
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
                  children: value.getListDeposito.map((e) => 
                  
                  
                  GestureDetector(
                          onTap: () {
                            value.setItemDeposito(e);
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

  // _fechaAbono(BuildContext context, CuentasXCobrarController controller) async {
_fechaAbono(BuildContext context, CuentasXCobrarController controller,ThemeProvider valueTheme) async {
  DateTime? picked = await showDatePicker(
    context: context,
    initialDate: DateTime.now(),
    firstDate: DateTime(1900),
    lastDate: DateTime(2100),
    builder: (BuildContext context, Widget? child) {
      return Theme(
        data: ThemeData.light().copyWith(
          colorScheme: ColorScheme.light(
            primary: valueTheme.appTheme.primaryColor, // Usar el color del tema
            onPrimary: Colors.white, // Texto en botones
            onSurface: Colors.black, // Texto en la superficie (fechas)
          ),
          buttonTheme: ButtonThemeData(
            textTheme: ButtonTextTheme.primary, // Color del texto de los botones
          ),
        ),
        child: child!,
      );
    },
  );
  
  if (picked != null) {
    String? anio, mes, dia;
    anio = '${picked.year}';
    mes = (picked.month < 10) ? '0${picked.month}' : '${picked.month}';
    dia = (picked.day < 10) ? '0${picked.day}' : '${picked.day}';

    final _fechaAbono = '${anio.toString()}-${mes.toString()}-${dia.toString()}';
    controller.setFechaAbono(_fechaAbono);
  }
}

  void bottomSheet(
    CuentasXCobrarController _controller,
    BuildContext context,
    Responsive size,
  ) {
    showCupertinoModalPopup(
        context: context,
        builder: (_) => CupertinoActionSheet(
              actions: [
                CupertinoActionSheetAction(
                  onPressed: () async {
                    // final image = await _getImage(context, ImageSource.camera);
                    // if (image != null) {
                    //   _controller.setImage(image, 'fotocasa');
                    // }
                    Navigator.pop(context);

                     await _controller.checkAndRequestPermissions();
           
                    if (_controller.hasCameraPermission) {
                      //  NotificatiosnService.showSnackBarDanger(' SI TIENE PERMISO DE CAMARA');
                         final image = await _getImage(context, ImageSource.camera);
                    if (image != null) {
                      _controller.setImage(image);
                    }
                    // Navigator.pop(context);
                    } else {
                      showPermissionModal(context,size,'Para completar el registro en nuestra aplicación, es necesario otorgar permisos de la cámara.');
                      
                    }
                   
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Abrir Cámara',
                          style: GoogleFonts.lexendDeca(
                            fontSize: size.iScreen(2.2),
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          )),
                      Container(
                          margin: EdgeInsets.symmetric(
                            horizontal: size.iScreen(2.0),
                          ),
                          child: Icon(Icons.camera_alt_outlined,
                              size: size.iScreen(3.0))),
                    ],
                  ),
                ),
                CupertinoActionSheetAction(
                  onPressed: () async {
                    // final image = await _getImage(context, ImageSource.gallery);
                    // if (image != null) {
                    //   _controller.setImage(image, 'fotocasa');
                    // }
                    // Navigator.pop(context);
                  

 await _controller.checkAndRequestPermissions();
           
                    if (_controller.hasCameraPermission) {
                      //  NotificatiosnService.showSnackBarDanger(' SI TIENE PERMISO DE CAMARA');
                         final image = await _getImage(context, ImageSource.gallery);
                    if (image != null) {
                      _controller.setImage(image,);
                    }
                    // Navigator.pop(context);
                    } else {
                      showPermissionModal(context,size,'Para completar el registro en nuestra aplicación, es necesario otorgar permisos de la cámara.');
                      
                    }


                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Abrir Galería',
                          style: GoogleFonts.lexendDeca(
                            fontSize: size.iScreen(2.2),
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          )),
                      Container(
                          margin: EdgeInsets.symmetric(
                            horizontal: size.iScreen(2.0),
                          ),
                          child: Icon(Icons.image_outlined,
                              size: size.iScreen(3.0))),
                    ],
                  ),
                ),
              ],
            ));
  }

  // void _funcionCamara(
  Future<File?> _getImage(BuildContext context, ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source,imageQuality: 50);

    if (pickedFile == null) {
      return null;
    }

    return File(pickedFile.path);
  }
}