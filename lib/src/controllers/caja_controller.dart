
import 'package:flutter/material.dart';
import 'package:neitorcont/src/api/api_provider.dart';
import 'package:neitorcont/src/models/auth_response.dart';

class CajaController extends ChangeNotifier {

  final _api = ApiProvider();
  GlobalKey<FormState> cajaFormKey = GlobalKey<FormState>();


  AuthResponse? usuarios;
  bool validateForm() {
    if (cajaFormKey.currentState!.validate()) {
      return true;
    } else {
      return false;
    }
  }
 

//================== FORMA DE PAGO  ==========================//

final List _tipos=["EFECTIVO", "CHEQUE", "TRANSFERENCIA", "DEPOSITO"];
   List get getListTipos=> _tipos;        
  String _tipo = 'EFECTIVO';
  String get getTipo  => _tipo;

  void setTipo(String _tip) {
   _tipo =''; 
   _tipo = _tip;
     print('==_tipo===> $_tipo');
    notifyListeners();
  }

//================== TIPO DE DOCUMENTO  ==========================//
final List _tiposDocumentos=
[  "APERTURA", "INGRESO", "EGRESO","DEPOSITO","CAJA CHICA","TRANSFERENCIA"];

    List get getListTiposDocumentos=> _tiposDocumentos;                

  String _tipoDocumento = '';
  String get getTipoDocumento  => _tipoDocumento;

  void setTipoDocumento(String _tips) {
   _tipoDocumento =''; 
   _tipoDocumento = _tips;
     print('==_tipoDocumento===> $_tipoDocumento');
    notifyListeners();
  }


  //================================INPUT   MONTO=============================================//
  double _monto =0.0;
  double get getMonto => _monto;

  void setMonto(double value) {
    _monto = value;

print('el monto ES: $_monto');

    notifyListeners();
  }



//================== AUTORIZACION ==========================//
  String _autorizacion = '';
  String get getAutorizacion  => _autorizacion;

  void setAutorizacion(String _autori) {
   _autorizacion =''; 
   _autorizacion = _autori;
     print('==_autorizacion===> $_autorizacion');
    notifyListeners();
  }


//================== DETALLE ==========================//
  String _detalle = '';
  String get getDetalle  => _detalle;

  void setDetalle(String _det) {
   _detalle =''; 
   _detalle = _det;
     print('==_detalle===> $_detalle');
    notifyListeners();
  }







}