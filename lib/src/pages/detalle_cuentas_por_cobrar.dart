import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:neitorcont/src/controllers/caja_controller.dart';
import 'package:neitorcont/src/controllers/cuentas_por_cobrar_controller.dart';
import 'package:neitorcont/src/utils/responsive.dart';
import 'package:provider/provider.dart';


class DetalleCuentasPorCobrar extends StatelessWidget {
  const DetalleCuentasPorCobrar({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
      final infoCaja = context.read<CuentasXCobrarController>();
    final Responsive size = Responsive.of(context);
    return Scaffold(
          backgroundColor: Colors.white,
      appBar: AppBar(
          title:  Text('Detalle Cuentas x Cobrar'),
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
                        Text('Fecha Factura : ',
                            style: GoogleFonts.lexendDeca(
                                fontSize: size.iScreen(2.0),
                                fontWeight: FontWeight.normal,
                                color: Colors.grey)),
                                Container(
                    margin: EdgeInsets.symmetric(vertical: size.iScreen(0.5)),
                    // width: size.wScreen(100.0),
                    child: Text(
                      ' ${infoCaja.getInfoCuentas['ccFechaFactura']}',
                      style: GoogleFonts.lexendDeca(
                          fontSize: size.iScreen(2.0),
                          // color: Colors.white,
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
                 //==========================================//
                  Container(
                    // padding: EdgeInsets.symmetric(vertical:size.iScreen(1.0),horizontal:size.iScreen(1.0)),
                    width: size.wScreen(100.0),
                  
                    child: Row( 
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [

                        Row(
                          children: [
                            Text('Estado : ',
                                style: GoogleFonts.lexendDeca(
                                    fontSize: size.iScreen(2.0),
                                    fontWeight: FontWeight.normal,
                                    color: Colors.grey)),
                                     Container(
                    margin: EdgeInsets.symmetric(vertical: size.iScreen(0.5)),
                    // width: size.wScreen(100.0),
                    child: Text(
                      ' ${infoCaja.getInfoCuentas['ccEstado']}',
                      style: GoogleFonts.lexendDeca(
                          fontSize: size.iScreen(2.0),
                          color:infoCaja.getInfoCuentas['ccEstado']=='PENDIENTE'? Colors.orange:Colors.green,
                          fontWeight: FontWeight.normal),
                    ),
                  ),
                          ],
                        ),
                               
                   Container(
                    // padding: EdgeInsets.symmetric(vertical:size.iScreen(1.0),horizontal:size.iScreen(1.0)),
                    // width: size.wScreen(100.0),
                  
                    child: Row(
                      children: [
                        Text('Saldo : ',
                            style: GoogleFonts.lexendDeca(
                                fontSize: size.iScreen(2.0),
                                fontWeight: FontWeight.normal,
                                color: Colors.grey)),
                                Container(
                    margin: EdgeInsets.symmetric(vertical: size.iScreen(0.5)),
                    // width: size.wScreen(100.0),
                    child: Text(
                      '\$ ${infoCaja.getInfoCuentas['ccSaldo']}',
                      style: GoogleFonts.lexendDeca(
                          fontSize: size.iScreen(2.0),
                          color: Colors.blue,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                      ],
                      
                    ),
                  ),
                      ],
                      
                    ),
                  ),
                  //*****************************************/
                  SizedBox(
                    height: size.iScreen(0.0),
                  ),
                 //==========================================//
                    SizedBox(
                    width: size.wScreen(100.0),
                    // color: Colors.blue,
                    child: Text('Número Factura :',
                        style: GoogleFonts.lexendDeca(
                            fontSize: size.iScreen(2.0),
                            fontWeight: FontWeight.normal,
                            color: Colors.grey)),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: size.iScreen(0.5)),
                    width: size.wScreen(100.0),
                    child: Text(
                      ' ${infoCaja.getInfoCuentas['ccFactura']}',
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
                 //==========================================//
                 Container(
                    // padding: EdgeInsets.symmetric(vertical:size.iScreen(1.0),horizontal:size.iScreen(1.0)),
                    width: size.wScreen(100.0),
                  
                    child: Row(
                      children: [
                        Text('Cédula/Ruc : ',
                            style: GoogleFonts.lexendDeca(
                                fontSize: size.iScreen(2.0),
                                fontWeight: FontWeight.normal,
                                color: Colors.grey)),
                                Container(
                    margin: EdgeInsets.symmetric(vertical: size.iScreen(0.5)),
                    // width: size.wScreen(100.0),
                    child: Text(
                      ' ${infoCaja.getInfoCuentas['ccRucCliente']}',
                      style: GoogleFonts.lexendDeca(
                          fontSize: size.iScreen(2.0),
                          // color: Colors.white,
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
                 //==========================================//
                    SizedBox(
                    width: size.wScreen(100.0),
                    // color: Colors.blue,
                    child: Text('Cliente : ',
                        style: GoogleFonts.lexendDeca(
                            fontSize: size.iScreen(2.0),
                            fontWeight: FontWeight.normal,
                            color: Colors.grey)),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: size.iScreen(0.5)),
                    width: size.wScreen(100.0),
                    child: Text(
                      ' ${infoCaja.getInfoCuentas['ccNomCliente']}',
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
                 //==========================================//
                 Container(
                    // padding: EdgeInsets.symmetric(vertical:size.iScreen(1.0),horizontal:size.iScreen(1.0)),
                    width: size.wScreen(100.0),
                  
                    child: Row(
                      children: [
                        Text('Valor Factura : ',
                            style: GoogleFonts.lexendDeca(
                                fontSize: size.iScreen(2.0),
                                fontWeight: FontWeight.normal,
                                color: Colors.grey)),
                                Container(
                    margin: EdgeInsets.symmetric(vertical: size.iScreen(0.5)),
                    // width: size.wScreen(100.0),
                    child: Text(
                      '\$ ${infoCaja.getInfoCuentas['ccValorFactura']}',
                      style: GoogleFonts.lexendDeca(
                          fontSize: size.iScreen(2.0),
                          // color: Colors.white,
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
                 //==========================================//
                 Container(
                    // padding: EdgeInsets.symmetric(vertical:size.iScreen(1.0),horizontal:size.iScreen(1.0)),
                    width: size.wScreen(100.0),
                  
                    child: Row(
                      children: [
                        Text('Retención : ',
                            style: GoogleFonts.lexendDeca(
                                fontSize: size.iScreen(2.0),
                                fontWeight: FontWeight.normal,
                                color: Colors.grey)),
                                Container(
                    margin: EdgeInsets.symmetric(vertical: size.iScreen(0.5)),
                    // width: size.wScreen(100.0),
                    child: Text(
                      ' ${infoCaja.getInfoCuentas['ccValorRetencion']}',
                      style: GoogleFonts.lexendDeca(
                          fontSize: size.iScreen(2.0),
                          // color: Colors.white,
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
                 //==========================================//
                 Container(
                    // padding: EdgeInsets.symmetric(vertical:size.iScreen(1.0),horizontal:size.iScreen(1.0)),
                    width: size.wScreen(100.0),
                  
                    child: Row(
                      children: [
                        Text('Valor a Pagar : ',
                            style: GoogleFonts.lexendDeca(
                                fontSize: size.iScreen(2.0),
                                fontWeight: FontWeight.normal,
                                color: Colors.grey)),
                                Container(
                    margin: EdgeInsets.symmetric(vertical: size.iScreen(0.5)),
                    // width: size.wScreen(100.0),
                    child: Text(
                      '\$ ${infoCaja.getInfoCuentas['ccValorAPagar']}',
                      style: GoogleFonts.lexendDeca(
                          fontSize: size.iScreen(2.0),
                          // color: Colors.white,
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
                 //==========================================//
                 Container(
                    // padding: EdgeInsets.symmetric(vertical:size.iScreen(1.0),horizontal:size.iScreen(1.0)),
                    width: size.wScreen(100.0),
                  
                    child: Row(
                      children: [
                        Text('Fecha de Abono : ',
                            style: GoogleFonts.lexendDeca(
                                fontSize: size.iScreen(2.0),
                                fontWeight: FontWeight.normal,
                                color: Colors.grey)),
                                Container(
                    margin: EdgeInsets.symmetric(vertical: size.iScreen(0.5)),
                    // width: size.wScreen(100.0),
                    child: Text(
                      ' ${infoCaja.getInfoCuentas['ccFechaAbono']}',
                      style: GoogleFonts.lexendDeca(
                          fontSize: size.iScreen(2.0),
                          // color: Colors.white,
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
                 //==========================================//
                  Container(
                    // padding: EdgeInsets.symmetric(vertical:size.iScreen(1.0),horizontal:size.iScreen(1.0)),
                    width: size.wScreen(100.0),
                  
                    child: Row(
                      children: [
                        Text('Procedencia : ',
                            style: GoogleFonts.lexendDeca(
                                fontSize: size.iScreen(2.0),
                                fontWeight: FontWeight.normal,
                                color: Colors.grey)),
                                Container(
                    margin: EdgeInsets.symmetric(vertical: size.iScreen(0.5)),
                    // width: size.wScreen(100.0),
                    child: Text(
                      ' ${infoCaja.getInfoCuentas['ccProcedencia']}',
                      style: GoogleFonts.lexendDeca(
                          fontSize: size.iScreen(2.0),
                          // color: Colors.white,
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
                 //==========================================//
                      Container(
                    // padding: EdgeInsets.symmetric(vertical:size.iScreen(1.0),horizontal:size.iScreen(1.0)),
                    width: size.wScreen(100.0),
                  
                    child: Row(
                      children: [
                        Text('Total Abono : ',
                            style: GoogleFonts.lexendDeca(
                                fontSize: size.iScreen(2.0),
                                fontWeight: FontWeight.normal,
                                color: Colors.grey)),
                                Container(
                    margin: EdgeInsets.symmetric(vertical: size.iScreen(0.5)),
                    // width: size.wScreen(100.0),
                    child: Text(
                      '\$ ${infoCaja.getInfoCuentas['ccAbono']}',
                      style: GoogleFonts.lexendDeca(
                          fontSize: size.iScreen(2.0),
                          // color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                      ],
                      
                    ),
                  ),
                         //*****************************************/
                  SizedBox(
                    height: size.iScreen(0.0),
                  ),
                 //==========================================//
                      Container(
                    // padding: EdgeInsets.symmetric(vertical:size.iScreen(1.0),horizontal:size.iScreen(1.0)),
                    width: size.wScreen(100.0),
                  
                    child: Row(
                      children: [
                        Text('Saldo : ',
                            style: GoogleFonts.lexendDeca(
                                fontSize: size.iScreen(2.0),
                                fontWeight: FontWeight.normal,
                                color: Colors.grey)),
                                Container(
                    margin: EdgeInsets.symmetric(vertical: size.iScreen(0.5)),
                    // width: size.wScreen(100.0),
                    child: Text(
                      '\$ ${infoCaja.getInfoCuentas['ccSaldo']}',
                      style: GoogleFonts.lexendDeca(
                          fontSize: size.iScreen(2.0),
                          // color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                      ],
                      
                    ),
                  ),
                           //*****************************************/
                  SizedBox(
                    height: size.iScreen(1.0),
                  ),
                 //==========================================//
                         Container(
                          alignment: Alignment.center,
                          color: Colors.grey.shade200,
                          width: size.wScreen(100.0),
                           child: Text('PAGOS  ',
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
                         infoCaja.getInfoCuentas['ccPagos'].isNotEmpty?
                    Wrap(
                      children:(infoCaja.getInfoCuentas['ccPagos'] as List).map((e) => 

                         Container(
                        decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(8.0)
                        ),
                         margin: EdgeInsets.symmetric(vertical:size.iScreen(1.0),horizontal:size.iScreen(1.0)),
                    padding: EdgeInsets.symmetric(vertical:size.iScreen(1.0),horizontal:size.iScreen(1.0)),
                    width: size.wScreen(100.0),
                  
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text('Fecha : ',
                                style: GoogleFonts.lexendDeca(
                                    fontSize: size.iScreen(2.0),
                                    fontWeight: FontWeight.normal,
                                    color: Colors.grey)),
                                    Container(
                        margin: EdgeInsets.symmetric(vertical: size.iScreen(0.5)),
                        // width: size.wScreen(100.0),
                        child: Text(
                          ' ${e['ccFechaAbono']}',
                          style: GoogleFonts.lexendDeca(
                              fontSize: size.iScreen(2.0),
                              // color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                  ),
                          ],
                          
                        ),
                         Row(
                              children: [
                                Text('Tipo : ',
                                    style: GoogleFonts.lexendDeca(
                                        fontSize: size.iScreen(2.0),
                                        fontWeight: FontWeight.normal,
                                        color: Colors.grey)),
                                        Container(
                            margin: EdgeInsets.symmetric(vertical: size.iScreen(0.5)),
                            // width: size.wScreen(100.0),
                            child: Text(
                              ' ${e['ccTipo']}',
                              style: GoogleFonts.lexendDeca(
                                  fontSize: size.iScreen(2.0),
                                  // color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                  ),
                              ],
                              
                            ),
                         Row(
                              children: [
                                Text('Valor : ',
                                    style: GoogleFonts.lexendDeca(
                                        fontSize: size.iScreen(2.0),
                                        fontWeight: FontWeight.normal,
                                        color: Colors.grey)),
                                        Container(
                            margin: EdgeInsets.symmetric(vertical: size.iScreen(0.5)),
                            // width: size.wScreen(100.0),
                            child: Text(
                              '\$ ${e['ccValor']}',
                              style: GoogleFonts.lexendDeca(
                                  fontSize: size.iScreen(2.0),
                                  // color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                  ),
                              ],
                              
                            ),
                      ],
                    ),
                  ),
                      
                      
                      ).toList()
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
                          Text('No tiene abonos realizados',
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
            ],
          ),
        ),
      ),
   );
  }
}