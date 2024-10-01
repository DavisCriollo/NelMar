import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:neitorcont/src/controllers/caja_controller.dart';
import 'package:neitorcont/src/controllers/cuentas_por_cobrar_controller.dart';
import 'package:neitorcont/src/utils/fechaLocal.dart';
import 'package:neitorcont/src/utils/responsive.dart';
import 'package:provider/provider.dart';


class DetalleMateriales extends StatelessWidget {
  const DetalleMateriales({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
      final infoMaterial = context.read<CuentasXCobrarController>();
     final fechaLocal= convertirFechaLocal(infoMaterial.getInfoMateriales['venFecReg']);
    final Responsive size = Responsive.of(context);
    return Scaffold(
      appBar: AppBar(
          title:  Text('Detalle de Materiales'),
        ),
      body: Container(
           margin: EdgeInsets.only(
                left: size.iScreen(1.5),
                right: size.iScreen(1.5),
                bottom: size.iScreen(0.0)),
            width: size.wScreen(100),
            height: size.hScreen(100),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              //*****************************************/
                  SizedBox(
                    height: size.iScreen(1.0),
                  ),
                  //         //==========================================//
                    Container(
                    padding: EdgeInsets.symmetric(vertical:size.iScreen(1.0),horizontal:size.iScreen(1.0)),
                    width: size.wScreen(100.0),
                    color: Colors.grey[200],
                    child: Row(
                      children: [
                        Text('Fecha :',
                            style: GoogleFonts.lexendDeca(
                                fontSize: size.iScreen(2.0),
                                fontWeight: FontWeight.normal,
                                color: Colors.grey)),
                                 Container(
                    margin: EdgeInsets.symmetric(vertical: size.iScreen(0.5)),
                    // width: size.wScreen(100.0),
                    child: Text(
                      ' $fechaLocal',
                      style: GoogleFonts.lexendDeca(
                          fontSize: size.iScreen(2.0),
                          color: Colors.black,
                          fontWeight: FontWeight.normal),
                    ),
                  ),
                      ],
                      
                    ),
                  ),
                 
                  //*****************************************/
                  SizedBox(
                    height: size.iScreen(0.0),
                  ),
                  //         //==========================================//
                    SizedBox(
                    width: size.wScreen(100.0),
                    // color: Colors.blue,
                    child: Text('Número Factura:',
                        style: GoogleFonts.lexendDeca(
                            fontSize: size.iScreen(2.0),
                            fontWeight: FontWeight.normal,
                            color: Colors.grey)),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: size.iScreen(0.5)),
                    width: size.wScreen(100.0),
                    child: Text(
                      ' ${infoMaterial.getInfoMateriales['venNumFactura']}',
                      style: GoogleFonts.lexendDeca(
                          fontSize: size.iScreen(2.0),
                          // color: Colors.white,
                          fontWeight: FontWeight.normal),
                    ),
                  ),
                  //*****************************************/
                  SizedBox(
                    height: size.iScreen(0.0),
                  ),
            
                  //*****************************************/
                  SizedBox(
                    height: size.iScreen(0.0),
                  ),
                  //         //==========================================//
                    SizedBox(
                    width: size.wScreen(100.0),
                    // color: Colors.blue,
                    child: Text('Conductor:',
                        style: GoogleFonts.lexendDeca(
                            fontSize: size.iScreen(2.0),
                            fontWeight: FontWeight.normal,
                            color: Colors.grey)),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: size.iScreen(0.5)),
                    width: size.wScreen(100.0),
                    child: Text(
                      ' ${infoMaterial.getInfoMateriales['venConductor']}',
                      style: GoogleFonts.lexendDeca(
                          fontSize: size.iScreen(2.0),
                          // color: Colors.white,
                          fontWeight: FontWeight.normal),
                    ),
                  ),
                        //*****************************************/
                  SizedBox(
                    height: size.iScreen(0.0),
                  ),
                  // ==========================================//
                    Row(
                      children: [
                        SizedBox(
                        // width: size.wScreen(100.0),
                        // color: Colors.blue,
                        child: Text('Placa: ',
                            style: GoogleFonts.lexendDeca(
                                fontSize: size.iScreen(2.0),
                                fontWeight: FontWeight.normal,
                                color: Colors.grey)),
                  ),
                   Container(
                    margin: EdgeInsets.symmetric(vertical: size.iScreen(0.5)),
                    // width: size.wScreen(100.0),
                    child: Text(
                      ' ${infoMaterial.getInfoMateriales['venOtrosDetalles'][0]}',
                      style: GoogleFonts.lexendDeca(
                          fontSize: size.iScreen(2.0),
                          // color: Colors.white,
                          fontWeight: FontWeight.normal),
                    ),
                  ),
                      ],
                    ),
                    //*****************************************/
                  SizedBox(
                    height: size.iScreen(0.0),
                  ),
                  //         //==========================================//
                    SizedBox(
                    width: size.wScreen(100.0),
                    // color: Colors.blue,
                    child: Text('Destino:',
                        style: GoogleFonts.lexendDeca(
                            fontSize: size.iScreen(2.0),
                            fontWeight: FontWeight.normal,
                            color: Colors.grey)),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: size.iScreen(0.5)),
                    width: size.wScreen(100.0),
                    child: Text(
                      ' ${infoMaterial.getInfoMateriales['venObservacion']}',
                      style: GoogleFonts.lexendDeca(
                          fontSize: size.iScreen(2.0),
                          // color: Colors.white,
                          fontWeight: FontWeight.normal),
                    ),
                  ),
                        //*****************************************/
                  SizedBox(
                    height: size.iScreen(0.0),
                  ),
                  // ==========================================//
                           //*****************************************/
                  SizedBox(
                    height: size.iScreen(1.5),
                  ),
                 //==========================================//
                         Container(
                          alignment: Alignment.center,
                          color: Colors.grey.shade200,
                          width: size.wScreen(100.0),
                           child: Text('MATERIALES  ',
                              style: GoogleFonts.lexendDeca(
                                  fontSize: size.iScreen(2.0),
                                  fontWeight: FontWeight.normal,
                                  color: Colors.black)),
                         ),
                                    //*****************************************/
                  SizedBox(
                    height: size.iScreen(1.0),
                  ),
                 //==========================================//
                         infoMaterial.getInfoMateriales['venProductos'].isNotEmpty?
                    Column(
                      children: [
                          // Mostrar la cantidad de productos
          Container( width: size.wScreen(100.0),
            padding: EdgeInsets.symmetric(vertical: size.iScreen(1.0)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Items: ${(infoMaterial.getInfoMateriales['venProductos'] as List).length}',
                  style: GoogleFonts.lexendDeca(
                    fontSize: size.iScreen(2.0),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Total: \$ ${(infoMaterial.getInfoMateriales['venTotal'])}',
                  style: GoogleFonts.lexendDeca(
                    fontSize: size.iScreen(2.0),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          
                        Wrap(
                          children:(infoMaterial.getInfoMateriales['venProductos'] as List).map((e) => 

                             Container(
                            decoration: BoxDecoration(
                                color: Colors.grey.shade300,
                                borderRadius: BorderRadius.circular(8.0)
                            ),
                             margin: EdgeInsets.symmetric(vertical:size.iScreen(0.5),horizontal:size.iScreen(1.0)),
                        padding: EdgeInsets.symmetric(vertical:size.iScreen(1.0),horizontal:size.iScreen(1.0)),
                        width: size.wScreen(100.0),
                  
                        child: 
                        ListTile(
              title: Text(e['descripcion'], style: GoogleFonts.lexendDeca(
                                  fontSize: size.iScreen(2.0),
                                  // color: Colors.white,
                                  fontWeight: FontWeight.bold)),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('P.Unitario: \$ ${e['valorUnitario'].toString()}', style: GoogleFonts.lexendDeca(
                                  fontSize: size.iScreen(1.8),
                                  color: Colors.black,
                                  fontWeight: FontWeight.normal)),
                          Text('Cantidad: ${e['cantidad'].toString()}', style: GoogleFonts.lexendDeca(
                                  fontSize: size.iScreen(1.8),
                                  color: Colors.black,
                                  fontWeight: FontWeight.normal)),
                        ],
                  ),
                ],
              ),
            )
              
                  
                  ),
                          
                          
                          ).toList()
                        ),
                      ],
                    ):Container(
                      alignment: Alignment.center,
                      width: size.wScreen(100.0),
                      child: Column(
                        children: [
                           //*****************************************/
                  SizedBox(
                    height: size.iScreen(2.0),
                  ),
                 //==========================================//
                          Text('No tiene Materiales registrados',
                                      style: GoogleFonts.lexendDeca(
                                          fontSize: size.iScreen(2.0),
                                          fontWeight: FontWeight.normal,
                                          color: Colors.grey)),
                        ],
                      ),
                    ),


                
                  //*****************************************/
                  SizedBox(
                    height: size.iScreen(1.0),
                  ),
                  //         //==========================================//
                  //*****************************************/
                  SizedBox(
                    height: size.iScreen(1.0),
                  ),
                  //         //==========================================//
            ],
          ),
        ),
      ),
   );
  }
}