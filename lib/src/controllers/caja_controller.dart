
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:neitorcont/src/api/api_provider.dart';
import 'package:neitorcont/src/api/authentication_client.dart';
import 'package:neitorcont/src/models/auth_response.dart';
import 'package:neitorcont/src/services/socket_service.dart';

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
    //  print('==_tipo===> $_tipo');
    notifyListeners();
  }

//================== TIPO DE DOCUMENTO  ==========================//
final List _tiposDocumentos=
[  "APERTURA", "INGRESO", "EGRESO","DEPOSITO","CAJA CHICA","TRANSFERENCIA"];

    List get getListTiposDocumentos=> _tiposDocumentos;                

  String _tipoDocumento = 'EGRESO';
  String get getTipoDocumento  => _tipoDocumento;

  void setTipoDocumento(String _tips) {
   _tipoDocumento =''; 
   _tipoDocumento = _tips;
    //  print('==_tipoDocumento===> $_tipoDocumento');
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
    //  print('==_autorizacion===> $_autorizacion');
    notifyListeners();
  }


//================== DETALLE ==========================//
  String _detalle = '';
  String get getDetalle  => _detalle;

  void setDetalle(String _det) {
   _detalle =''; 
   _detalle = _det;
    //  print('==_detalle===> $_detalle');
    notifyListeners();
  }


//*************CREAR FACTURA ******************//



 Future createCaja(BuildContext context) async {
   final socketService = SocketService();
    final dataUser = await Auth.instance.getSession();
    DateTime now = DateTime.now();
  String formattedDate = "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
 

final _nuevaCaja =
 
{
  "cajaId": "", // default
  "cajaNumero": "", // default
  "cajaFecha": formattedDate, // fecha del dia
  "cajaDetalle": _detalle,
  "cajaIngreso": "", // DEFAULT
  "cajaEgreso": "", // DEFAULT
  "cajaCredito": "", // DEFAULT
  "cajaMonto": _monto.toString(),
  "cajaTipoCaja": _tipo,
  "cajaTipoDocumento": _tipoDocumento,
  "cajaEstado": "ACTIVA", // DEFAULT
  "cajaProcedencia": "CAJA", // DEFAULT
  "cajaAutorizacion": _autorizacion, 

  "tabla": "caja", //default// DEFAULT
  "cajaEmpresa":dataUser!.rucempresa, // login
  "cajaUser": dataUser.usuario, // login
  "rucempresa": dataUser.rucempresa, //login
  "rol": dataUser.rol, //login

};

    // print('LA NUEVA CAJA : $_nuevaCaja');

socketService.sendMessage('client:guardarData', _nuevaCaja);


 }




//=================================================================================================================//
  // ================= VARIABLES DE PAGINACION ====================//
//=================================================================================================================//
//===================BOTON SEARCH PAGINACION ==========================//

  bool _btnSearchCajaPaginacion = false;
  bool get btnSearchCajaPaginacion => _btnSearchCajaPaginacion;

  void setBtnSearchCajaPaginacion(bool action) {
    _btnSearchCajaPaginacion = action;
    //  print('==_btnSearchCoros===> $_btnSearchPropietarios');
    notifyListeners();
  }

  //===================INPUT SEARCH PROPIETARIO==========================//
  String _nameSearchCajaPaginacion = "";
  String get nameSearchCajaPaginacion =>
      _nameSearchCajaPaginacion;

  void onSearchTextCajaPaginacion(String data) {
    _nameSearchCajaPaginacion = data;
    //  print('CajaOMBRE:${_nameSearchCajaPaginacion}');
     }
//=============================================================================//


  List _listaCajaPaginacion = [];
  // List<TipoMulta> get getListaTodosLosTiposDeMultas => _listaTodosLosTiposDeMultas;
  List get getListaCajaPaginacion => _listaCajaPaginacion;


 double _valorTotalCajasHoy = 0.00;
  // List<TipoMulta> get getListaTodosLosTiposDeMultas => _listaTodosLosTiposDeMultas;
  double get getValorTotalCajasHoy => _valorTotalCajasHoy;
double _valorTotalCajasAntes = 0.00;
  // List<TipoMulta> get getListaTodosLosTiposDeMultas => _listaTodosLosTiposDeMultas;
  double get getValorTotalCajasAntes => _valorTotalCajasAntes;


void resetValorTotal(){
_valorTotalCajasHoy = 0.00;
_valorTotalCajasAntes = 0.00;
 _totalIngresos = 0.0; 
  _totalGeneralAyer= 0.0; 
_totalGeneralHoy= 0.0; 
notifyListeners();
}



  void setInfoBusquedaCajasPaginacion(List data) {
    // _listaCajaPaginacion=[];
    _listaCajaPaginacion.addAll(data);
    // print('Cajas xxx :${_listaCajaPaginacion.length}');

   if (_tabIndex==0) {
  _valorTotalCajasHoy = 0.0;

// Iterar sobre cada item en la lista
for (var item in _listaCajaPaginacion) {
  // Asegurarse de que 'venTotal' no sea nulo y sea un valor numérico
  final venTotal = item['cajaIngreso'];
  if (venTotal != null) {
    // Convertir 'venTotal' a un número de tipo double y sumar
    _valorTotalCajasHoy += double.tryParse(venTotal.toString()) ?? 0.0;
  }
}

// Redondear a 3 decimales
_valorTotalCajasHoy = double.parse(_valorTotalCajasHoy.toStringAsFixed(3));

// Imprimir el valor total
// print('-->: $_valorTotalCajasHoy');
  
} else {
_valorTotalCajasAntes = 0.0;

// Iterar sobre cada item en la lista
for (var item in _listaCajaPaginacion) {
  // Asegurarse de que 'venTotal' no sea nulo y sea un valor numérico
  final venTotal = item['cajaIngreso'];
  if (venTotal != null) {
    // Convertir 'venTotal' a un número de tipo double y sumar
    _valorTotalCajasAntes += double.tryParse(venTotal.toString()) ?? 0.0;
  }
}

// Redondear a 3 decimales
_valorTotalCajasAntes = double.parse(_valorTotalCajasAntes.toStringAsFixed(3));

// Imprimir el valor total
// print('-->: $_valorTotalFacturasAntes');



}

    notifyListeners();
  }

  bool? _errorCajaPaginacion; // sera nulo la primera vez
  bool? get getErrorCajaPaginacion => _errorCajaPaginacion;
  void setErrorCajaPaginacion(bool? value) {
    _errorCajaPaginacion = value;
    notifyListeners();
  }

  bool? _error401CajaPaginacion = false; // sera nulo la primera vez
  bool? get getError401CajaPaginacion => _error401CajaPaginacion;
  void setError401CajaPaginacion(bool? value) {
    _error401CajaPaginacion = value;
    notifyListeners();
  }

  bool _isNext = false;
  bool get getIsNext => _isNext;
  void setIsNext(bool _next) {
    _isNext = _next;
    // print('_isNext: $_isNext');

    notifyListeners();
  }

  int? _page = 0;
  int? get getpage => _page;
  void setPage(int? _pag) {
    _page = _pag;
    // print('_page: $_page');

    notifyListeners();
  }

  int? _cantidad = 25;
  int? get getCantidad => _cantidad;
  void setCantidad(int? _cant) {
    _cantidad = _cant;
    notifyListeners();
  }

  String? _next = '';
  String? get getNext => _next;
  void setNext(String? _nex) {
    _next = _nex;
    notifyListeners();
  }

  Future buscaAllCajaPaginacion(String? _search, bool _isSearch,int tipo) async {
    final dataUser = await Auth.instance.getSession();
// print('usuario : ${dataUser!.rucempresa}');
    final response = await _api.getAllCajasPaginacion(
      search: _search,
      page: _page,
      cantidad: _cantidad,
      input: 'cajaId',
      orden: false,
      estado: tipo==0?'DIARIA':'GENERAL',
      token: '${dataUser!.token}',
    );

    if (response != null) {
      if (response == 401) {
        setInfoBusquedaCajasPaginacion([]);
        _error401CajaPaginacion = true;
        notifyListeners();
        return response;
      } else {
        _errorCajaPaginacion = true;
        if (_isSearch == true) {
          _listaCajaPaginacion = [];
        }
        List<dynamic> dataSort = response['data']['results'];
        dataSort.sort((a, b) => b['cajaFecReg']!.compareTo(a['cajaFecReg']!));

        setPage(response['data']['pagination']['next']);


                //============================//

              // setInfoBusquedaCajasPaginacion(dataSort);

        if (tipo==0) {
          //  setInfoBusquedaFacturasPaginacion([]);
          setFacturas(dataSort);
          filtrarFacturasDeHoy();
        } else {
          //  setInfoBusquedaFacturasPaginacion([]);
             setFacturas(dataSort);
          filtrarFacturasAnteriores();
        }
        notifyListeners();
        return response;
      }

      //===========================================//

    }
    if (response == null) {
      _errorCajaPaginacion = false;
      notifyListeners();
      return null;
    }
  }

List _facturas = [];
  List _facturasFiltradas = [];

  List get facturasFiltradas => _facturasFiltradas;

  void setFacturas(List facturas) {
    _facturas = facturas;
    notifyListeners();
  }

  // void filtrarFacturasDeHoy() {
  //   DateTime hoy = DateTime.now();
  //   String fechaHoy = DateFormat('yyyy-MM-dd').format(hoy);

  //   _facturasFiltradas = _facturas.where((factura) {
  //     String? fechaFactura = factura['venFecReg'];
  //     if (fechaFactura != null) {
  //       String fechaFacturaSoloFecha = fechaFactura.split('T').first;
  //       return fechaFacturaSoloFecha == fechaHoy;
  //     }
  //     return false;
  //   }).toList();
  //   // setInfoBusquedaPreFacturasPaginacion(_facturasFiltradas);
  //   setListFilter( _facturasFiltradas);
  //   notifyListeners();
  // }


  // void filtrarFacturasAnteriores() {
  //   DateTime hoy = DateTime.now();
  //   String fechaHoy = DateFormat('yyyy-MM-dd').format(hoy);

  //   _facturasFiltradas = _facturas.where((factura) {
  //     String? fechaFactura = factura['venFecReg'];
  //     if (fechaFactura != null) {
  //       String fechaFacturaSoloFecha = fechaFactura.split('T').first;
  //       return fechaFacturaSoloFecha != fechaHoy;
  //     }
  //     return false;
  //   }).toList();
  //     //  setInfoBusquedaPreFacturasPaginacion(_facturasFiltradas);
  //        setListFilter( _facturasFiltradas);
  //   notifyListeners();
  // }
//*********************************************************//
  void filtrarFacturasDeHoy() {
  DateTime hoy = DateTime.now();  // Fecha actual en hora local
  String fechaHoy = DateFormat('yyyy-MM-dd').format(hoy);

  _facturasFiltradas = _facturas.where((factura) {
    String? fechaFactura = factura['cajaFecha'];
    if (fechaFactura != null) {
      // Convertir la fecha de la factura a un DateTime y luego a la hora local
      DateTime fechaFacturaDateTime = DateTime.parse(fechaFactura).toLocal();
      String fechaFacturaSoloFecha = DateFormat('yyyy-MM-dd').format(fechaFacturaDateTime);
      return fechaFacturaSoloFecha == fechaHoy;
    }
    return false;
  }).toList();

  // Actualizar la lista filtrada
  setListFilter(_facturasFiltradas);
  notifyListeners();
}
void filtrarFacturasAnteriores() {
  DateTime hoy = DateTime.now();  // Fecha actual en hora local
  String fechaHoy = DateFormat('yyyy-MM-dd').format(hoy);

  _facturasFiltradas = _facturas.where((factura) {
    String? fechaFactura = factura['cajaFecha'];
    if (fechaFactura != null) {
      // Convertir la fecha de la factura a DateTime y luego a la hora local
      DateTime fechaFacturaDateTime = DateTime.parse(fechaFactura).toLocal();
      String fechaFacturaSoloFecha = DateFormat('yyyy-MM-dd').format(fechaFacturaDateTime);
      return fechaFacturaSoloFecha != fechaHoy;  // Filtrar las fechas anteriores o diferentes a hoy
    }
    return false;
  }).toList();

  // Actualizar la lista filtrada
  setListFilter(_facturasFiltradas);
  notifyListeners();
}

//*********************************************************//



//************INDEX TAB*****************//
int _tabIndex=0;

int get getTabIndex=>_tabIndex;

void setTabIndex( int _index)
{
_tabIndex=_index;

notifyListeners();

}





//=================BUSCADOR LOCAL==================//

 List<dynamic> _allItemsFilters=[];
   List<dynamic> get allItemsFilters => _allItemsFilters;
   void setListFilter( List<dynamic> _list){
  _allItemsFilters = [];

// _sortList();



_allItemsFilters.addAll(_list);
// print('LA LISTA DE LOS ESTUDIANTES _allItemsFilters: ${_allItemsFilters.length} ');
// print('LA LISTA DE LOS ESTUDIANTES _allItemsFilters: $_allItemsFilters ');

//====================== REALIZA LA SUMATORIA EN CADA CONSULTA  =============================//

if (_tabIndex==0) {
  _valorTotalCajasHoy = 0.0;

// Iterar sobre cada item en la lista
for (var item in _allItemsFilters) {
  // Asegurarse de que 'venTotal' no sea nulo y sea un valor numérico
  final venTotal = item['cajaMonto'];
  if (venTotal != null) {
    // Convertir 'venTotal' a un número de tipo double y sumar
    _valorTotalCajasHoy += double.tryParse(venTotal.toString()) ?? 0.0;
  }
}
calculateTotalGeneralHoy();
// Redondear a 3 decimales
_valorTotalCajasHoy = double.parse(_valorTotalCajasHoy.toStringAsFixed(3));

// Imprimir el valor total
// print('-->: $_valorTotalCajasHoy');
  
} else {
_valorTotalCajasAntes = 0.0;

// Iterar sobre cada item en la lista
for (var item in _allItemsFilters) {
  // Asegurarse de que 'venTotal' no sea nulo y sea un valor numérico
  final venTotal = item['cajaMonto'];
  if (venTotal != null) {
    // Convertir 'venTotal' a un número de tipo double y sumar
    _valorTotalCajasAntes += double.tryParse(venTotal.toString()) ?? 0.0;
  }
}

calculateTotalGeneralAyer();
// Redondear a 3 decimales
_valorTotalCajasAntes = double.parse(_valorTotalCajasAntes.toStringAsFixed(3));

// Imprimir el valor total
// print('-->: $_valorTotalFacturasAntes');

}
//===================================================//


  notifyListeners();
 }

  // void search(String query) {
  //     List<Map<String, dynamic>> originalList = List.from(_facturasFiltradas); // Copia de la lista original
  //   if (query.isEmpty) {
  //     _allItemsFilters = originalList;
  //   } else {
  //     _allItemsFilters = originalList.where((estudiante) {
  //       return 
  //       // resident['resCedula'].toLowerCase().contains(query.toLowerCase()) ||
  //              estudiante['Todos'].toLowerCase().contains(query.toLowerCase()) ;
  //     }).toList();
  //   }
  //   notifyListeners();
  // }
// void search(String query) {
//   List<Map<String, dynamic>> originalList = List.from(_facturasFiltradas); // Copia de la lista original
//   if (query.isEmpty) {
//     _allItemsFilters = originalList;
//   } else {
//     _allItemsFilters = originalList.where((item) {
//       String venFecReg = item['cajaFecReg'];
      
//       // Convertir `venFecReg` a formato de fecha corto si es necesario
//       String fechaFormateada = venFecReg.split("T").first;

//       return 
//         fechaFormateada.toLowerCase().contains(query.toLowerCase()) ||
//         item['cajaNumero'].toLowerCase().contains(query.toLowerCase())||
//          item['cajaUser'].toLowerCase().contains(query.toLowerCase())||
//           // item['cajNumFactura'].toLowerCase().contains(query.toLowerCase())||
//         item['cajaTipoDocumento'].toLowerCase().contains(query.toLowerCase());
//     }).toList();
//   }
//   notifyListeners();
// }
//====================================//
double _totalIngresos = 0.0; // Variable para almacenar el total de ingresos
double get totalIngresos => _totalIngresos;

void search(String query) {
  List<Map<String, dynamic>> originalList = List.from(_facturasFiltradas); // Copia de la lista original

  if (query.isEmpty) {
    _allItemsFilters = originalList;
  } else {
    _allItemsFilters = originalList.where((item) {
      String venFecReg = item['cajaFecReg'];

      // Formatear `venFecReg` de "2024-09-17T02:17:51.000Z" a "yyyy-MM-dd HH:mm"
      DateTime parsedDate = DateTime.parse(venFecReg);
      String fechaFormateada = "${parsedDate.year.toString().padLeft(4, '0')}-${parsedDate.month.toString().padLeft(2, '0')}-${parsedDate.day.toString().padLeft(2, '0')} ${parsedDate.hour.toString().padLeft(2, '0')}:${parsedDate.minute.toString().padLeft(2, '0')}";

      // Comparar con el `query` proporcionado
      return 
        fechaFormateada.toLowerCase().contains(query.toLowerCase()) ||
        item['cajaNumero'].toLowerCase().contains(query.toLowerCase())||
         item['cajaUser'].toLowerCase().contains(query.toLowerCase())||
         item['cajaTipoDocumento'].toLowerCase().contains(query.toLowerCase());
    }).toList();
      
  }
  // Calcular el total de ingresos después de filtrar
  calculateTotalIngreso();
  notifyListeners();
}
// Función para calcular el total de ingresos
void calculateTotalIngreso() {
  _totalIngresos = 0.0; // Reiniciar el total antes de cada cálculo
  for (var item in _allItemsFilters) {
    // Convertir venTotal a número en caso de que sea una cadena
    double venTotal = double.tryParse(item['cajaIngreso'].toString()) ?? 0.0;
    _totalIngresos += venTotal;
  }
  // Redondear a dos decimales
  _totalIngresos = double.parse(_totalIngresos.toStringAsFixed(2));
}

//====================================//
  void resetFormCaja() {
    // _nombreMascota = '';
    // _idMascota;
    // _pesoMascota = '';
    // _fechaCaducidad = '';
    // _vetDoctorId = '';
    // _vetDoctorNombre = '';
    // _infoDoctor;
    // _infoMascota;
    // _labelTipoProducto = '';
    // _labelProducto = '';

     _page = 0;
    _cantidad = 25;
     _listaCajaPaginacion=[];
    _next = '';
    _isNext = false;
  }

//************ GET INFO DE ITEM CAJA*************//
Map<String,dynamic> _infoCaja={};
Map<String,dynamic> get getInfoCaja=>_infoCaja;
void setInfoCaja(Map<String,dynamic>  _info){
_infoCaja={};
_infoCaja=_info;

// print('_infoCaja: $_infoCaja');
  notifyListeners();
}

//===================  SUMATORIA GENERAL =====================//
double _totalGeneralAyer = 0.0; // Variable para almacenar el total de ingresos
double get totalGeneralAyer => _totalGeneralAyer;

// Función para calcular el total de ingresos
void calculateTotalGeneralAyer() {
  // _totalGeneralAyer = 0.0; // Reiniciar el total antes de cada cálculo
  for (var item in _allItemsFilters) {
    // Convertir venTotal a número en caso de que sea una cadena
    double venTotal = double.tryParse(item['cajaMonto'].toString()) ?? 0.0;
    _totalGeneralAyer += venTotal;
  }
  // Redondear a dos decimales
  _totalGeneralAyer = double.parse(_totalGeneralAyer.toStringAsFixed(2));

  print('TOTAL GENERAL AYER =========> : $_totalGeneralAyer');
}
 void restetTotalGenerales(){
_totalGeneralAyer = 0.0;
_totalGeneralHoy = 0.0;
  notifyListeners();
 }

double _totalGeneralHoy = 0.0; // Variable para almacenar el total de ingresos
double get totalGeneralHoy => _totalGeneralHoy;

// Función para calcular el total de ingresos
void calculateTotalGeneralHoy() {
  // _totalGeneralHoy = 0.0; // Reiniciar el total antes de cada cálculo
  for (var item in _allItemsFilters) {
    // Convertir venTotal a número en caso de que sea una cadena
    double venTotal = double.tryParse(item['cajaMonto'].toString()) ?? 0.0;
    _totalGeneralHoy += venTotal;
  }
  // Redondear a dos decimales
  _totalGeneralHoy = double.parse(_totalGeneralHoy.toStringAsFixed(2));

  print('TOTAL GENERAL Hoy =========> : $_totalGeneralHoy');
}
//===========================================================//




//===========================OBTENEMOS LA SUMATORIA GENERAL DIARIA================================//
Map<String,dynamic> _totalDiario={};
Map<String,dynamic> get getTotalDiario=>_totalDiario;



  Future obtieneTotalDiario(String origen,String tipo) async {
    final dataUser = await Auth.instance.getSession();
// print('usuario : ${dataUser!.rucempresa}');
    final response = await _api.getAllTotalDiario(
       origen: origen,
      tipo: tipo,
      token: '${dataUser!.token}',
    );

    if (response != null) {
     _totalDiario={};
     _totalDiario=response;
        notifyListeners();
        return response;
      

      //===========================================//

    }
    if (response == null) {
     
      notifyListeners();
      return null;
    }
  }

//===========================================//











}