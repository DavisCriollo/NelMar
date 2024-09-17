import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:neitorcont/src/controllers/caja_controller.dart';
import 'package:neitorcont/src/models/sesison_model.dart';
import 'package:neitorcont/src/services/notifications_service.dart';
import 'package:neitorcont/src/theme/theme_provider.dart';
import 'package:neitorcont/src/utils/letras_mayusculas_minusculas.dart';
import 'package:neitorcont/src/utils/responsive.dart';
import 'package:provider/provider.dart';


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
                                Navigator.pop(context);


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



}