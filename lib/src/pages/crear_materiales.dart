import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:neitorcont/src/controllers/caja_controller.dart';
import 'package:neitorcont/src/controllers/cuentas_por_cobrar_controller.dart';
import 'package:neitorcont/src/pages/buscar_productos_varios.dart';
import 'package:neitorcont/src/theme/theme_provider.dart';
import 'package:neitorcont/src/utils/letras_mayusculas_minusculas.dart';
import 'package:neitorcont/src/utils/responsive.dart';
import 'package:provider/provider.dart';

import '../models/sesison_model.dart';


class CrearMateriales extends StatefulWidget {
     final String? tipo;
 
   final Session? user;

  const CrearMateriales({Key? key, this.tipo, this.user}) : super(key: key);


  @override
  State<CrearMateriales> createState() => _CrearMaterialesState();
}

class _CrearMaterialesState extends State<CrearMateriales> {
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
            
                          Consumer<CuentasXCobrarController>(builder: (_, value, __) { 
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

 

      // if (controller.getTipo.isEmpty) {
      //   NotificatiosnService.showSnackBarDanger('Debe seleccionar Tipo');
      // } else if (controller.getTipo.isEmpty) {
      //   NotificatiosnService.showSnackBarDanger(
      //       'Debe seleccionar Tipo documento');
      // }
      // //  else if (controller.getNombreConductor == "") {
      // //   NotificatiosnService.showSnackBarDanger(
      // //       'Debe ingresar nombre de Conductor');
      // // }
      // else if (controller.getAutorizacion.isEmpty) {
      //   NotificatiosnService.showSnackBarDanger(
      //       'Debe agregar Autorización');
      // } else if (controller.getDetalle.isEmpty) {
      //   NotificatiosnService.showSnackBarDanger(
      //       'Debe agregar Detalle');
      // }
      // else{
          
      //     controller.createCaja(context);
      //      controller.setInfoBusquedaCajasPaginacion([]);
      //                      controller.resetValorTotal();
      //                        controller.buscaAllCajaPaginacion(
      //                           '',false,0);
                               


      // }

    }
  }




}