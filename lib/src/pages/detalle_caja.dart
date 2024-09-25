import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:neitorcont/src/controllers/caja_controller.dart';
import 'package:neitorcont/src/utils/responsive.dart';
import 'package:provider/provider.dart';


class DetalleCaja extends StatelessWidget {
  const DetalleCaja({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
      final infoCaja = context.read<CajaController>();
    final Responsive size = Responsive.of(context);
    return Scaffold(
      appBar: AppBar(
          title:  Text('Detalle de Caja'),
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
                    child: Text('Fecha',
                        style: GoogleFonts.lexendDeca(
                            fontSize: size.iScreen(2.0),
                            fontWeight: FontWeight.normal,
                            color: Colors.grey)),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: size.iScreen(0.5)),
                    width: size.wScreen(100.0),
                    child: Text(
                      '${infoCaja.getInfoCaja['cajaFecha']}',
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
                      ' ${infoCaja.getInfoCaja['cajaNumero']}',
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
                        child: Text('Ingreso: ',
                            style: GoogleFonts.lexendDeca(
                                fontSize: size.iScreen(2.0),
                                fontWeight: FontWeight.normal,
                                color: Colors.grey)),
                  ),
                   Container(
                    margin: EdgeInsets.symmetric(vertical: size.iScreen(0.5)),
                    // width: size.wScreen(100.0),
                    child: Text(
                      ' ${infoCaja.getInfoCaja['cajaIngreso']}',
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
                  // ==========================================//
                    Row(
                      children: [
                        SizedBox(
                        // width: size.wScreen(100.0),
                        // color: Colors.blue,
                        child: Text('Egreso: ',
                            style: GoogleFonts.lexendDeca(
                                fontSize: size.iScreen(2.0),
                                fontWeight: FontWeight.normal,
                                color: Colors.grey)),
                  ),
                   Container(
                    margin: EdgeInsets.symmetric(vertical: size.iScreen(0.5)),
                    // width: size.wScreen(100.0),
                    child: Text(
                      infoCaja.getInfoCaja['cajaEgreso'].isNotEmpty?' ${infoCaja.getInfoCaja['cajaEgreso']}':'--- --- --- ',
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
                  // ==========================================//
                    Row(
                      children: [
                        SizedBox(
                        // width: size.wScreen(100.0),
                        // color: Colors.blue,
                        child: Text('Monto: ',
                            style: GoogleFonts.lexendDeca(
                                fontSize: size.iScreen(2.0),
                                fontWeight: FontWeight.normal,
                                color: Colors.grey)),
                  ),
                   Container(
                    margin: EdgeInsets.symmetric(vertical: size.iScreen(0.5)),
                    // width: size.wScreen(100.0),
                    child: Text(
                      ' ${infoCaja.getInfoCaja['cajaMonto']}',
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
                  // ==========================================//
                    Row(
                      children: [
                        SizedBox(
                        // width: size.wScreen(100.0),
                        // color: Colors.blue,
                        child: Text('Estado: ',
                            style: GoogleFonts.lexendDeca(
                                fontSize: size.iScreen(2.0),
                                fontWeight: FontWeight.normal,
                                color: Colors.grey)),
                  ),
                   Container(
                    margin: EdgeInsets.symmetric(vertical: size.iScreen(0.5)),
                    // width: size.wScreen(100.0),
                    child: Text(
                      ' ${infoCaja.getInfoCaja['cajaEstado']}',
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
                  // ==========================================//
                    Row(
                      children: [
                        SizedBox(
                        // width: size.wScreen(100.0),
                        // color: Colors.blue,
                        child: Text('Procedencia: ',
                            style: GoogleFonts.lexendDeca(
                                fontSize: size.iScreen(2.0),
                                fontWeight: FontWeight.normal,
                                color: Colors.grey)),
                  ),
                   Container(
                    margin: EdgeInsets.symmetric(vertical: size.iScreen(0.5)),
                    // width: size.wScreen(100.0),
                    child: Text(
                      ' ${infoCaja.getInfoCaja['cajaProcedencia']}',
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
                    child: Text('Autorización:',
                        style: GoogleFonts.lexendDeca(
                            fontSize: size.iScreen(2.0),
                            fontWeight: FontWeight.normal,
                            color: Colors.grey)),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: size.iScreen(0.5)),
                    width: size.wScreen(100.0),
                    child: Text(
                     infoCaja.getInfoCaja['cajaAutorizacion'].isNotEmpty? ' ${infoCaja.getInfoCaja['cajaAutorizacion']}':'--- --- --- --- ',
                      style: GoogleFonts.lexendDeca(
                          fontSize: size.iScreen(2.0),
                          // color: Colors.white,
                          fontWeight: FontWeight.normal),
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