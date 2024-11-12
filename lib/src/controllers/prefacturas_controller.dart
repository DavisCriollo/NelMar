import 'dart:async';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:neitorcont/src/api/api_provider.dart';
import 'package:neitorcont/src/api/authentication_client.dart';
import 'package:neitorcont/src/models/auth_response.dart';

class PreFacturasController extends ChangeNotifier {
  final _api = ApiProvider();
  GlobalKey<FormState> preFacturasFormKey = GlobalKey<FormState>();

  AuthResponse? usuarios;
  bool validateForm() {
    if (preFacturasFormKey.currentState!.validate()) {
      return true;
    } else {
      return false;
    }
  }

  void resetFormPreFacturas() {
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
  }

//  =================  CREO DEBOUNCE  PARA BUSQUEDAS ==================//

  Timer? _deboucerSearchPrefacturas;
  // Timer? _deboucerSearchBuscaPersona;

  @override
  void dispose() {
    _deboucerSearchPrefacturas?.cancel();
    // _deboucerSearchBuscaPersona?.cancel();

    // _videoController.dispose();
    super.dispose();
  }

//===================BOTON SEARCH Mascota ==========================//

  bool _btnSearchPreFacturas = false;
  bool get btnSearchPreFacturas => _btnSearchPreFacturas;

  void setBtnSearchPreFacturas(bool action) {
    _btnSearchPreFacturas = action;
    //  print('==_btnSearchCoros===> $_btnSearchVacunas');
    notifyListeners();
  }

  //===================INPUT SEARCH COROSE==========================//
  String _nameSearchPrefacturas = "";
  String get nameSearchPrefacturas => _nameSearchPrefacturas;

  void onSearchTextPrefacturas(String data) {
    _nameSearchPrefacturas = data;
    if (_nameSearchPrefacturas.length >= 3) {
      _deboucerSearchPrefacturas?.cancel();
      _deboucerSearchPrefacturas = Timer(const Duration(milliseconds: 700), () {
        // print('=====> $data');
        buscaAllPreFacturas(data);
      });
    } else {
      buscaAllPreFacturas('');
      // buscaAusencias('','false');
    }
    notifyListeners();
  }

//==================== LISTO TODAS LAS Vacunas CLINICAS====================//
  List _listaPreFacturas = [];

  List get getListaPreFacturas => _listaPreFacturas;

  void setInfoBusquedaPreFacturas(List data) {
    _listaPreFacturas = data;
    // print('PreFacturas:$_listaPreFacturas');
    notifyListeners();
  }

  bool? _errorPreFacturas; // sera nulo la primera vez
  bool? get getErrorPreFacturas => _errorPreFacturas;
  set setErrorPreFacturas(bool? value) {
    _errorPreFacturas = value;
    notifyListeners();
  }

  bool? _error401PreFacturas = false; // sera nulo la primera vez
  bool? get getError401PreFacturas => _error401PreFacturas;
  set setError401PreFacturas(bool? value) {
    _error401PreFacturas = value;
    notifyListeners();
  }

  Future buscaAllPreFacturas(String? _search) async {
    final dataUser = await Auth.instance.getSession();
// print('usuario : ${dataUser!.rucempresa}');
    final response = await _api.getAllFacturas(
      search: _search,
      // estado: 'CLIENTES',
      token: '${dataUser!.token}',
    );

    if (response != null) {
        if (response['data'].isEmpty) {
        setInfoBusquedaPreFacturas([]);
        _errorPreFacturas = false;
      }
      if (response == 401) {
        setInfoBusquedaPreFacturas([]);
        _error401PreFacturas = true;
        notifyListeners();
        return response;
      } else  if (response['data'].isNotEmpty){
          for (var item in response['data']) {
             if(item['venTipoDocumento']=='N'){
          _errorPreFacturas = true;

        List dataSort = [];
        dataSort = response['data'];
        dataSort.sort((a, b) => b['venFecReg']!.compareTo(a['venFecReg']!));

        // setInfoBusquedaPreFacturas(response['data']);
        setInfoBusquedaPreFacturas(dataSort);
        // print('object;${response['data']}');
        }
          else{
           setInfoBusquedaPreFacturas([]);
             _errorPreFacturas = false;
        }
          }

       
        
        notifyListeners();
        return response;
      }
    }
    if (response == null) {
      _errorPreFacturas = false;
      notifyListeners();
      return null;
    }
  }





//=================================================================================================================//
  // ================= VARIABLES DE PAGINACION ====================//
//=================================================================================================================//
//===================BOTON SEARCH PAGINACION ==========================//

  bool _btnSearchPreFacturasPaginacion = false;
  bool get btnSearchPreFacturaPaginacion => _btnSearchPreFacturasPaginacion;

  void setBtnSearchPreFacturaPaginacion(bool action) {
    _btnSearchPreFacturasPaginacion = action;
    //  print('==_btnSearchCoros===> $_btnSearchPropietarios');
    notifyListeners();
  }

  //===================INPUT SEARCH PROPIETARIO==========================//
  String _nameSearchPreFacturaPaginacion = "";
  String get nameSearchPreFacturaPaginacion =>
      _nameSearchPreFacturaPaginacion;

  void onSearchTextPreFacturaPaginacion(String data) {
    _nameSearchPreFacturaPaginacion = data;
    //  print('PreFacturaOMBRE:${_nameSearchPreFacturaPaginacion}');
     }
//=============================================================================//


  List _listaPreFacturasPaginacion = [];
  // List<TipoMulta> get getListaTodosLosTiposDeMultas => _listaTodosLosTiposDeMultas;
  List get getListaPreFacturasPaginacion => _listaPreFacturasPaginacion;


 double _valorTotalFacturasHoy = 0.00;
  // List<TipoMulta> get getListaTodosLosTiposDeMultas => _listaTodosLosTiposDeMultas;
  double get getValorTotalFacturasHoy => _valorTotalFacturasHoy;
double _valorTotalFacturasAntes = 0.00;
  // List<TipoMulta> get getListaTodosLosTiposDeMultas => _listaTodosLosTiposDeMultas;
  double get getValorTotalFacturasAntes => _valorTotalFacturasAntes;


void resetValorTotal(){
_valorTotalFacturasHoy = 0.00;
_valorTotalFacturasAntes = 0.00;
 _totalIngresos = 0.0; 
 _totalGeneralAyer= 0.0; 
_totalGeneralHoy= 0.0; 
notifyListeners();
}



  void setInfoBusquedaPreFacturasPaginacion(List data) {
    // _listaPreFacturasPaginacion=[];
    _listaPreFacturasPaginacion.addAll(data);
    // print('PreFacturas xxx :${_listaPreFacturasPaginacion.length}');

   if (_tabIndex==0) {
  _valorTotalFacturasHoy = 0.0;

// Iterar sobre cada item en la lista
for (var item in _listaPreFacturasPaginacion) {
  // Asegurarse de que 'venTotal' no sea nulo y sea un valor numérico
  final venTotal = item['venTotal'];
  if (venTotal != null) {
    // Convertir 'venTotal' a un número de tipo double y sumar
    _valorTotalFacturasHoy += double.tryParse(venTotal.toString()) ?? 0.0;
  }
}

// Redondear a 3 decimales
_valorTotalFacturasHoy = double.parse(_valorTotalFacturasHoy.toStringAsFixed(3));

// Imprimir el valor total
// print('-->: $_valorTotalFacturasHoy');
  
} else {
_valorTotalFacturasAntes = 0.0;

// Iterar sobre cada item en la lista
for (var item in _listaPreFacturasPaginacion) {
  // Asegurarse de que 'venTotal' no sea nulo y sea un valor numérico
  final venTotal = item['venTotal'];
  if (venTotal != null) {
    // Convertir 'venTotal' a un número de tipo double y sumar
    _valorTotalFacturasAntes += double.tryParse(venTotal.toString()) ?? 0.0;
  }
}

// Redondear a 3 decimales
_valorTotalFacturasAntes = double.parse(_valorTotalFacturasAntes.toStringAsFixed(3));

// Imprimir el valor total
// print('-->: $_valorTotalFacturasAntes');



}

    notifyListeners();
  }

  bool? _errorPreFacturasPaginacion; // sera nulo la primera vez
  bool? get getErrorPreFacturasPaginacion => _errorPreFacturasPaginacion;
  void setErrorPreFacturasPaginacion(bool? value) {
    _errorPreFacturasPaginacion = value;
    notifyListeners();
  }

  bool? _error401PreFacturasPaginacion = false; // sera nulo la primera vez
  bool? get getError401PreFacturasPaginacion => _error401PreFacturasPaginacion;
  void setError401PreFacturasPaginacion(bool? value) {
    _error401PreFacturasPaginacion = value;
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
    print('_page: $_page');

    notifyListeners();
  }

  int? _cantidad = 25;
  int? get getCantidad => _cantidad;
  void setCantidad(int? _cant) {
    _cantidad = _cant;
    print('_cantidad : ${_cantidad}');
    notifyListeners();
  }

  String? _next = '';
  String? get getNext => _next;
  void setNext(String? _nex) {
    _next = _nex;
    notifyListeners();
  }

  Future buscaAllPreFacturasPaginacion(String? _search, bool _isSearch,int tipo) async {
    final dataUser = await Auth.instance.getSession();
// print('usuario : ${dataUser!.rucempresa}');
    final response = await _api.getAllPreFacturasPaginacion(
      search: _search,
      page: _page,
      cantidad: _cantidad,
      input: 'venId',
      orden: false,
      estado:'NOTA VENTAS',
      token: '${dataUser!.token}',
    );

    if (response != null) {
      if (response == 401) {
        setInfoBusquedaPreFacturasPaginacion([]);
        _error401PreFacturasPaginacion = true;
        notifyListeners();
        return response;
      } else {
        _errorPreFacturasPaginacion = true;
        if (_isSearch == true) {
          _listaPreFacturasPaginacion = [];
        }
        List<dynamic> dataSort = response['data']['results'];
        dataSort.sort((a, b) => b['venFecReg']!.compareTo(a['venFecReg']!));

        setPage(response['data']['pagination']['next']);


                //============================//

//           DateTime hoy = DateTime.now();
  
//   List listaFiltrada = response['data']['results'].where((element) {
//     // Convertir la cadena en DateTime
//     DateTime fechaRegistro = DateTime.parse(element['venFecReg']);
    
//     // Comparar solo la parte de la fecha
//     return fechaRegistro.year == hoy.year &&
//            fechaRegistro.month == hoy.month &&
//            fechaRegistro.day == hoy.day;
//   }).toList();

// for (var item in listaFiltrada) {
//   print('LA LISTA PRE FACTURAS VERIFICADA : ${item}'); // Solo mostrará los elementos con fecha de hoy
// }

  

//  DateTime hoy = DateTime.now();
  
//   List listaFiltrada = response['data']['results'].where((element) {
//     // Convertir la cadena en DateTime
//     DateTime fechaRegistro = DateTime.parse(element['venFecReg']);
    
//     // Comparar si la fecha es anterior a hoy
//     return fechaRegistro.isBefore(DateTime(hoy.year, hoy.month, hoy.day));
//   }).toList();

//    print('LA LISTA PRE FACTURAS VERIFICADA : ${listaFiltrada}');  // Solo mostrará los elementos con fecha anterior a hoy

        //=============================//



        // setInfoBusquedaPreFacturasPaginacion(dataSort);

        if (tipo==0) {
          //  setInfoBusquedaFacturasPaginacion([]);
          setFacturas(dataSort);
          filtrarFacturasDeHoy(response['data']['pagination']);
        } else {
          //  setInfoBusquedaFacturasPaginacion([]);
             setFacturas(dataSort);
          filtrarFacturasAnteriores(response['data']['pagination']);
        }
// setListFilter(dataSort);

        notifyListeners();
        return response;
      }

      //===========================================//

    }
    if (response == null) {
      _errorPreFacturasPaginacion = false;
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

Map<String,dynamic> _paginacionHoy={};
Map<String,dynamic> get getPaginacionHoy=>_paginacionHoy;
Map<String,dynamic> _paginacionAyer={};
Map<String,dynamic> get getPaginacionAyer=>_paginacionAyer;

  void filtrarFacturasDeHoy(Map<String,dynamic> _pag) {
  DateTime hoy = DateTime.now();  // Fecha actual en hora local
  String fechaHoy = DateFormat('yyyy-MM-dd').format(hoy);

  _facturasFiltradas = _facturas.where((factura) {
    String? fechaFactura = factura['venFecReg'];
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
  _paginacionHoy={};
  _paginacionHoy=_pag;

  notifyListeners();
}
void filtrarFacturasAnteriores(Map<String,dynamic> _pag) {
  DateTime hoy = DateTime.now();  // Fecha actual en hora local
  String fechaHoy = DateFormat('yyyy-MM-dd').format(hoy);

  _facturasFiltradas = _facturas.where((factura) {
    String? fechaFactura = factura['venFecReg'];
    if (fechaFactura != null) {
      // Convertir la fecha de la factura a DateTime y luego a la hora local
      DateTime fechaFacturaDateTime = DateTime.parse(fechaFactura).toLocal();
      String fechaFacturaSoloFecha = DateFormat('yyyy-MM-dd').format(fechaFacturaDateTime);
      return fechaFacturaSoloFecha != fechaHoy;  // Filtrar las fechas anteriores o diferentes a hoy
    }
    return false;
  }).toList();
      print('ANTERIORES: $_facturasFiltradas');
  // Actualizar la lista filtrada
  setListFilter(_facturasFiltradas);
  _paginacionAyer={};
  _paginacionAyer=_pag;
// calculateTotalGeneralAyer();
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
  _valorTotalFacturasHoy = 0.0;

// Iterar sobre cada item en la lista
for (var item in _allItemsFilters) {
  // Asegurarse de que 'venTotal' no sea nulo y sea un valor numérico
  final venTotal = item['venTotal'];
  if (venTotal != null) {
    // Convertir 'venTotal' a un número de tipo double y sumar
    _valorTotalFacturasHoy += double.tryParse(venTotal.toString()) ?? 0.0;
  }
}
 calculateTotalGeneralHoy();
// Redondear a 3 decimales
_valorTotalFacturasHoy = double.parse(_valorTotalFacturasHoy.toStringAsFixed(3));

// Imprimir el valor total
// print('-->: $_valorTotalFacturasHoy');
  
} else {
_valorTotalFacturasAntes = 0.0;

// Iterar sobre cada item en la lista
for (var item in _allItemsFilters) {
  // Asegurarse de que 'venTotal' no sea nulo y sea un valor numérico
  final venTotal = item['venTotal'];
  if (venTotal != null) {
    // Convertir 'venTotal' a un número de tipo double y sumar
    _valorTotalFacturasAntes += double.tryParse(venTotal.toString()) ?? 0.0;
  }
}
 calculateTotalGeneralAyer();
// Redondear a 3 decimales
_valorTotalFacturasAntes = double.parse(_valorTotalFacturasAntes.toStringAsFixed(3));

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
  //     _allItemsFilters = originalList.where((item) {
  //       return 
  //       item['venFecReg'].toLowerCase().contains(query.toLowerCase()) ||
  //       item['venNomCliente'].toLowerCase().contains(query.toLowerCase()) ;
  //     }).toList();
  //   }
  //   notifyListeners();
  // }

// //====================================//
// void search(String query) {
//   List<Map<String, dynamic>> originalList = List.from(_facturasFiltradas); // Copia de la lista original
//   if (query.isEmpty) {
//     _allItemsFilters = originalList;
//   } else {
//     _allItemsFilters = originalList.where((item) {
//       String venFecReg = item['venFecReg'];
      
//       // Convertir `venFecReg` a formato de fecha corto si es necesario
//       String fechaFormateada = venFecReg.split("T").first;

//       return 
//         fechaFormateada.toLowerCase().contains(query.toLowerCase()) ||
//         item['venConductor'].toLowerCase().contains(query.toLowerCase())||
//         item['venUser'].toLowerCase().contains(query.toLowerCase())||
//         item['venNomCliente'].toLowerCase().contains(query.toLowerCase());
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
//       String venFecReg = item['venFecReg'];

//       // Formatear `venFecReg` de "2024-09-17T02:17:51.000Z" a "yyyy-MM-dd HH:mm"
//       DateTime parsedDate = DateTime.parse(venFecReg);
//       String fechaFormateada = "${parsedDate.year.toString().padLeft(4, '0')}-${parsedDate.month.toString().padLeft(2, '0')}-${parsedDate.day.toString().padLeft(2, '0')} ${parsedDate.hour.toString().padLeft(2, '0')}:${parsedDate.minute.toString().padLeft(2, '0')}";

//       // Comparar con el `query` proporcionado
//       return fechaFormateada.contains(query) ||
//           item['venConductor'].toLowerCase().contains(query.toLowerCase()) ||
//           item['venUser'].toLowerCase().contains(query.toLowerCase()) ||
//            item['venNumFactura'].toLowerCase().contains(query.toLowerCase())||
//           item['venNomCliente'].toLowerCase().contains(query.toLowerCase());
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
      String venFecReg = item['venFecReg'];

      // Formatear `venFecReg` de "2024-09-17T02:17:51.000Z" a "yyyy-MM-dd HH:mm"
      DateTime parsedDate = DateTime.parse(venFecReg);
      String fechaFormateada = "${parsedDate.year.toString().padLeft(4, '0')}-${parsedDate.month.toString().padLeft(2, '0')}-${parsedDate.day.toString().padLeft(2, '0')} ${parsedDate.hour.toString().padLeft(2, '0')}:${parsedDate.minute.toString().padLeft(2, '0')}";

      // Comparar con el `query` proporcionado
      return fechaFormateada.contains(query) ||
          item['venConductor'].toLowerCase().contains(query.toLowerCase()) ||
          item['venUser'].toLowerCase().contains(query.toLowerCase()) ||
            item['venNumFactura'].toLowerCase().contains(query.toLowerCase())||
          item['venNomCliente'].toLowerCase().contains(query.toLowerCase());
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
    double venTotal = double.tryParse(item['venTotal'].toString()) ?? 0.0;
    _totalIngresos += venTotal;
  }
  // Redondear a dos decimales
  _totalIngresos = double.parse(_totalIngresos.toStringAsFixed(2));
}




//===================  SUMATORIA GENERAL =====================//
double _totalGeneralAyer = 0.0; // Variable para almacenar el total de ingresos
double get totalGeneralAyer => _totalGeneralAyer;

// Función para calcular el total de ingresos
void calculateTotalGeneralAyer() {
  // _totalGeneralAyer = 0.0; // Reiniciar el total antes de cada cálculo
  for (var item in _allItemsFilters) {
    // Convertir venTotal a número en caso de que sea una cadena
    double venTotal = double.tryParse(item['venTotal'].toString()) ?? 0.0;
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
    double venTotal = double.tryParse(item['venTotal'].toString()) ?? 0.0;
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