import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:neitorcont/src/api/api_provider.dart';
import 'package:neitorcont/src/api/authentication_client.dart';
import 'package:neitorcont/src/models/auth_response.dart';
import 'package:neitorcont/src/services/socket_service.dart';
import 'package:permission_handler/permission_handler.dart';

class CuentasXCobrarController extends ChangeNotifier {

  final _api = ApiProvider();
  GlobalKey<FormState> materialesFormKey = GlobalKey<FormState>();


  AuthResponse? usuarios;
  bool validateForm() {
    if (materialesFormKey.currentState!.validate()) {
      return true;
    } else {
      return false;
    }
  }
 
  //================== PLACA  ==========================//
  String _placa = '';
  String get getPlaca  => _placa;

  void setPlaca(String _name) {
   _placa =''; 
   _placa = _name;
     print('==_placa===> $_placa');
    notifyListeners();
  }

  //================== CONDUCTOR  ==========================//
  String _nombreConductor = '';
  String get getNombreConductor  => _nombreConductor;

  void setNombreConductor(String _name) {
   _nombreConductor =''; 
   _nombreConductor = _name;
     print('==_nombreConductor===> $_nombreConductor');
    notifyListeners();
  }

  //================== DESTINO  ==========================//
  String _destino = '';
  String get getDestino  => _destino;

  void setDestino(String _name) {
   _destino =''; 
   _destino = _name;
     print('=Destino===> $_destino');
    notifyListeners();
  }


  //================================INPUT   CANTIDAD=============================================//
  double _cantidad =1;
  double get getCantidad => _cantidad;

  

  void setCantidad(double value) {
    _cantidad = value;

print('LA CANTIDAD ES: $_cantidad');
 calculateTotal();

    notifyListeners();
  }
 //================================INPUT   PRECIO=============================================//
 double _precio =1.0;
  double get getPrecio => _precio;

  void setPrecio(double value) {
    _precio = value;

print('LA precio ES: $_precio');
 calculateTotal();

    notifyListeners();
  }

  //================================INPUT   CANTIDAD=============================================//

 
  double _total = 0.00;
 double get getTotal =>_total;

 void setTotal() {
    _cantidad =1.0;
    _total = 0.00;
    notifyListeners(); // Notifica a los widgets escuchando este provider
  }
 

 

  // Método privado para calcular el total
  void calculateTotal() {
    if (_cantidad==0.0) {
      _cantidad=1;
    }
    _total =_tipoTarifa['valor']==null?0: double.parse(_tipoTarifa['valor']) * _cantidad;
    notifyListeners(); // Notifica a los widgets escuchando este provider
  }



final  List<Map<String,dynamic>> _listTarifas=[];

List<Map<String,dynamic>> get listTarifas=>_listTarifas;


Map<String,dynamic> _tipoTarifa={};

Map<String,dynamic> get tipoTarifa=>_tipoTarifa;

void setTarifa(Map<String,dynamic> tarifa){
_tipoTarifa={};
_tipoTarifa=tarifa;
notifyListeners();


}


//****************BUSCA PRODUCTOS ******************//

List<Map<String,dynamic>> _listaDeProductosFactura=[]; 

List<Map<String,dynamic>> get getListaDeProductosFactura=>_listaDeProductosFactura; 

void setListaDeProductosFactura(Map<String,dynamic> _item){
    _listaDeProductosFactura.removeWhere((e) => e['invId']==_item['invId']);
  _listaDeProductosFactura.add(_item); 
  print('TODOS LOS PRODUCTOSFactura :$_listaDeProductosFactura');
  notifyListeners();
}

//*************************ELIMINA EL ITEM SELECCIONADO ****************************//
void deleteItem(Map<String, dynamic> itemToDelete) {
  // Verifica si la clave 'venProductos' existe y si es una lista
  if (_respuestaCalculoItem.containsKey('venProductos') && _respuestaCalculoItem['venProductos'] is List) {
    // Convierte la lista de productos a una lista de mapas
    List<Map<String, dynamic>> productos = List<Map<String, dynamic>>.from(_respuestaCalculoItem['venProductos']);
    // Elimina el item que coincide con el código y descripción dados
    productos.removeWhere((producto) =>
        producto['codigo'] == itemToDelete['codigo'] &&
        producto['descripcion'] == itemToDelete['descripcion']);
    // Actualiza la lista de productos en el mapa original
    _respuestaCalculoItem['venProductos'] = productos;
  } 

enviaProductoCalculo({},0);



notifyListeners();
  // Imprime la lista actualizada de productos
  print('Lista de productos después de la eliminación:');
  print(_respuestaCalculoItem['venProductos']);
}


void resetListasProdutos(){
_listaDeProductosFactura=[];
 _listaDeProductos=[]; 
  _respuestaCalculoItem={}; 
  
 notifyListeners();
}


List _listaDeProductos=[]; 

List get getListaDeProductos=>_listaDeProductos; 

void setListaDeProductos(List _list){
  _listaDeProductos=[]; 
  _listaDeProductos.addAll(_list); 
  print('TODOS LOS PRODUCTOS :$_listaDeProductos');
  notifyListeners();
}






 Future buscaAllProductos( String _type) async {
    final dataUser = await Auth.instance.getSession();
// print('usuario : ${dataUser!.rucempresa}');
    final response = await _api.searchAllProductos(
    
      token: '${dataUser!.token}',
    );

    if (response != null) {

              // setListaDeProductos(response);

       List<dynamic> filteredData = response.where((item) {
    if (_type == 'MOTOS') {
      return item['invCategoria'] == 'MOTOS';
    } 
    else if (_type == 'VEHICULOS') {
      return item['invCategoria'] == 'VEHICULOS';
    }
    else if (_type == 'MATERIALES') {
      return item['invCategoria'] == 'MATERIALES';
    }
    return false;
  }).toList();



        setListaDeProductos(filteredData);
        setListFilter( filteredData);


    }

    
    if (response == null) {
     
   
      return null;
    }

 }






//*********ENVIA ITEM PARA CALCULO***********//


Map<String,dynamic> _respuestaCalculoItem={};

Map<String,dynamic> get getRespuestaCalculoItem=>_respuestaCalculoItem;


void setRespuestaCalculoItem(Map<String,dynamic> _item){
   _respuestaCalculoItem={};
  _respuestaCalculoItem.addAll(_item); 
 
 
  print('RESPUESTA CALCULO ITEM :$_respuestaCalculoItem');
  notifyListeners();
}

 Future enviaProductoCalculo(Map<String,dynamic> _item, int _action) async {
    final dataUser = await Auth.instance.getSession();

final _data ={
  "porcentajeRecargo": 0, // default
  "tasaIVA": '${dataUser!.iva}',//15, // login => iva
  "listaProductos": _respuestaCalculoItem.isNotEmpty? _respuestaCalculoItem['venProductos']:[], // tomar del json del factura la propiedad 'venProductos'
  "nuevoItem":{
    "codigo":  _action==1?_item['invSerie']:0, // tomar del endpoint del producto seleccionado
    "descripcion": _action==1? _item['invNombre']:'', // tomar del endpoint del producto seleccionado
    "cantidad":  _action==1?_cantidad:0, // cantidad del producto que va vender
    "valUnitarioInterno": _action==1? _precio:0, // tomar del endpoint del producto seleccionado
    "descPorcentaje": 0, // Porcentaje de descuento en caso de existir (en la web existe un campo que coloca el porcentaje)
    "llevaIva":  _action==1?_item['invIva']:'', // tomar del endpoint del producto seleccionado
    "incluyeIva": _action==1?_item['invIncluyeIva']:'' // tomar del endpoint del producto seleccionado
  }
};
  
    final response = await _api.sendProductoCalculos(
      data: _data,
      token: '${dataUser.token}',
    );

    if (response != null) {

            setRespuestaCalculoItem(response);
    }
 if (response == null) {
       return null;
    }


 }


//================================ BUSQUEDA DE PRODUCTO=============================================//

  bool _btnSearch = false;
  bool get btnSearch => _btnSearch;

  void setBtnSearch(bool action) {
    _btnSearch = action;
    notifyListeners();
  }
  //===================BOTON SEARCH MORE CLIENTE==========================//

  // bool _btnSearchMore = false;
  // bool get btnSearchMore => _btnSearchMore;

  // void setBtnSearchMore(bool action) {
  //   _btnSearchMore = action;

  //   notifyListeners();
  // }

//  List<Map<String, String>> _allItemsFilters = [];



//  List<dynamic> _allItemsFilters=[];
//    List<dynamic> get allItemsFilters => _allItemsFilters;
//    void setListFilter( List<dynamic> _list){
//   _allItemsFilters = [];
// _allItemsFilters.addAll(_list);
// print('LA LISTA  _allItemsFilters: $_allItemsFilters ');

//   notifyListeners();
//  }

//   void search(String query) {
//       List<Map<String, dynamic>> originalList = List.from(_allItemsFilters); // Copia de la lista original
//     if (query.isEmpty) {
//       _allItemsFilters = originalList;
//     } else {
//       _allItemsFilters = originalList.where((item) {
//         return 
//          item['ccRucCliente'].toLowerCase().contains(query.toLowerCase()) ||
//           item['ccNomCliente'].toLowerCase().contains(query.toLowerCase()) ||
//            item['ccFactura'].toLowerCase().contains(query.toLowerCase()) ||
//             item['ccFechaFactura'].toLowerCase().contains(query.toLowerCase()) ||
//             item['ccEstado'].toLowerCase().contains(query.toLowerCase()) ;
//       }).toList();
//     }
//     notifyListeners();
//   }
List<dynamic> _allItemsFilters = [];
List<dynamic> _originalItemsFilters = []; // Lista original separada

List<dynamic> get allItemsFilters => _allItemsFilters;
void setListFilter(List<dynamic> _list) {
  _originalItemsFilters = List.from(_list); // Almacenar la lista original
  _allItemsFilters = List.from(_list); // Inicialmente, la lista mostrada es igual a la original
  print('LA LISTA _allItemsFilters: $_allItemsFilters');
  notifyListeners();
}

void search(String query) {
  if (query.isEmpty) {
    _allItemsFilters = List.from(_originalItemsFilters); // Restaurar la lista original cuando el campo de texto está vacío
  } else {
    _allItemsFilters = _originalItemsFilters.where((item) {
      return item['ccRucCliente'].toLowerCase().contains(query.toLowerCase()) ||
          item['ccNomCliente'].toLowerCase().contains(query.toLowerCase()) ||
          item['ccFactura'].toLowerCase().contains(query.toLowerCase()) ||
          item['ccFechaFactura'].toLowerCase().contains(query.toLowerCase()) ||
          item['ccEstado'].toLowerCase().contains(query.toLowerCase());
    }).toList();
  }
  notifyListeners();
}



 String _typeAction='';
String get getTypeAction=>_typeAction;

void setTypeAction(String _type){
_typeAction =_type;

  notifyListeners();
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
notifyListeners();
}



  void setInfoBusquedaCuentasPorCobrar(List data) {
    _listaCajaPaginacion=[];
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


//************INDEX TAB*****************//
int _tabIndex=0;

int get getTabIndex=>_tabIndex;

void setTabIndex( int _index)
{
_tabIndex=_index;

notifyListeners();

}


//=================================================================================================================//
  // ================= VARIABLES DE PAGINACION ====================//
//=================================================================================================================//
//===================BOTON SEARCH PAGINACION ==========================//

  bool _btnSearchCajaPaginacion = false;
  bool get btnSearchCajaPaginacion => _btnSearchCajaPaginacion;

  void setBtnSearchCajaPaginacion(bool action) {
    _btnSearchCajaPaginacion = action;
     print('==_btnSearchCoros===> $_btnSearchCajaPaginacion');
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


 int? _page = 0;
  int? get getpage => _page;
  void setPage(int? _pag) {
    _page = _pag;
    // print('_page: $_page');

    notifyListeners();
  }


bool _isNext = false;
  bool get getIsNext => _isNext;
  void setIsNext(bool _next) {
    _isNext = _next;
    // print('_isNext: $_isNext');

    notifyListeners();
  }

 
 int? _cantidadElelemtos = 25;
  int? get getCantidadElementos => _cantidadElelemtos;
  void setCantidadElementos(int? _cant) {
    _cantidadElelemtos = _cant;
    notifyListeners();
  }


  String? _next = '';
  String? get getNext => _next;
  void setNext(String? _nex) {
    _next = _nex;
    notifyListeners();
  }

List _facturas = [];
  List _facturasFiltradas = [];

  List get facturasFiltradas => _facturasFiltradas;

  void setFacturas(List facturas) {
    _facturas = facturas;
    notifyListeners();
  }


  Future buscaAllCuentasPorCobrar(String? _search, bool _isSearch,int tipo) async {
    final dataUser = await Auth.instance.getSession();
// print('usuario : ${dataUser!.rucempresa}');
    final response = await _api.getAllCuentasPorCobrar(
      search: _search,
      page: _page,
      cantidad: _cantidadElelemtos,
      input: 'ccId',
      orden: false,
    
      token: '${dataUser!.token}',
    );

    if (response != null) {
      if (response == 401) {
        setInfoBusquedaCuentasPorCobrar([]);
        _error401CajaPaginacion = true;
        notifyListeners();
        return response;
      } else {
        _errorCajaPaginacion = true;
        if (_isSearch == true) {
          _listaCajaPaginacion = [];
        }
        List<dynamic> dataSort = response['data']['results'];
        dataSort.sort((a, b) => b['ccFecReg']!.compareTo(a['ccFecReg']!));

        setPage(response['data']['pagination']['next']);
        setListFilter(dataSort);


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


//************ GET INFO DE ITEM CAJA*************//
Map<String,dynamic> _infoCuentas={};
Map<String,dynamic> get getInfoCuentas=>_infoCuentas;
void setInfoCuentas(Map<String,dynamic>  _info){
_infoCuentas={};
_infoCuentas=_info;

// print('_infoCaja: $_infoCaja');
  notifyListeners();
}


//================== TIPOS   ==========================//

final List _tipos=
[
  "EFECTIVO",
  "TRANSFERENCIA",
   "CHEQUE",
   "CRUCE COMPRA",
   "DEPOSITO",
   "DONACION",
   "RETENCION",
   "TARJETA",
   
];
   List get getListTipos=> _tipos;        
  String _tipo = 'EFECTIVO';
  String get getTipo  => _tipo;

  void setTipo(String _tip) {
   _tipo =''; 
   _tipo = _tip;
    //  print('==_tipo===> $_tipo');
    notifyListeners();
  }


  //================================INPUT   CANTIDAD=============================================//
  String? _numeroDocumeto ;
  String? get getnumeroDocumeto => _numeroDocumeto;

  

  void setNumeroDocumeto(String? value) {
    _numeroDocumeto = value;

print('NumeroDocumeto ES: $_numeroDocumeto');


    notifyListeners();
  }



//================== bancos   ==========================//

  String _banco = '';
  String get getBanco  => _banco;
  void setBanco(String _tip) {
   _banco =''; 
   _banco = _tip;
     print('==_banco===> $_banco');
    notifyListeners();
  }

     List _listBancos= []; 
   List get getListBancos=> _listBancos;        


void setListaBancos(List _banc) {
   _listBancos=[];
  _listBancos.addAll(_banc);
     print('==_listBancos===> $_listBancos');
    notifyListeners();
  }


Future<dynamic> buscaAllBancos() async {
    final dataUser = await Auth.instance.getSession();
    
    final response = await _api.getAllBancos(
   
      token: '${dataUser!.token}',
    );

    if (response != null) {

 List dataSort = [];
        dataSort = response['data'];
        dataSort.sort((a, b) => a['banNombre']!.compareTo(b['banNombre']!));
setListaBancos(dataSort);
      notifyListeners();
      // return null;
    }

    notifyListeners();
    return null;
  }

//================== DEPOSITO   ==========================//

final List _listDeposito=
[
  "SI",
  "NO",
"NINGUNO", 
     
];
   List get getListDeposito=> _listDeposito;    

  String _itemDeposito = 'NO';
  String get getItemDeposito  => _itemDeposito;

  void setItemDeposito(String _tip) {
   _itemDeposito =''; 
   _itemDeposito = _tip;
     print('==_itemDeposito===> $_itemDeposito');
    notifyListeners();
  }

  //================================INPUT   MONTO=============================================//
  double _valor =0.0;
  double get getValor => _valor;

  void setValor(double value) {
    _valor = value;

print('el monto ES: $_valor');

    notifyListeners();
  }


  String? _fechaAbono;
  get getFechaAbono => _fechaAbono;
  void setFechaAbono(String? date) async {
    _fechaAbono = date;

    notifyListeners();
  }


//================================INPUT  OBSERVACION MASCOTA=============================================//
  String? _observacion = '';
  String? get getObservacion => _observacion;

  void setObservacion(String? value) {
    _observacion = value;
    // print('==_observacion ===> $_observacion');
    notifyListeners();
  }

  //================= TOMAR FOTO   ====================//

 bool _hasLocationPermission = false;
  bool _hasCameraPermission = false;

  bool get hasLocationPermission => _hasLocationPermission;
  bool get hasCameraPermission => _hasCameraPermission;

  Future<void> checkAndRequestPermissions() async {
    // Verificación y solicitud de permisos de ubicación
    PermissionStatus locationStatus = await Permission.location.status;
    if (locationStatus.isGranted) {
      _hasLocationPermission = true;
    } else {
      locationStatus = await Permission.location.request();
      _hasLocationPermission = locationStatus.isGranted;
    }

    // Verificación y solicitud de permisos de la cámara
    PermissionStatus cameraStatus = await Permission.camera.status;
    if (cameraStatus.isGranted) {
      _hasCameraPermission = true;
    } else {
      cameraStatus = await Permission.camera.request();
      _hasCameraPermission = cameraStatus.isGranted;
    }

    // Notifica a los oyentes (widgets) sobre el cambio en el estado
    notifyListeners();
  }


//========================== PROCESO DE TOMAR FOTO DE CAMARA =======================//
  String _urlImage = "";
  String get getUrlImage => _urlImage;
  void setUrlImge(String data) {
    _urlImage = "";
    _urlImage = data;
    print('IMAGEN URL: $_urlImage');

    notifyListeners();
  }


  bool _errorUrl = true;
  bool get getErrorUrl => _errorUrl;
  void setErrorUrl(bool _data) {
    _errorUrl = _data;
    notifyListeners();
  }

  Future eliminaUrlServer(String _url) async {
    final Map<String, dynamic> _urlImageDelete = {
      "urls": [
        {"url": _url}
      ],
      "rucempresa": "NEIMAR"
    };

    final response = await _api.deleteUrlDelServidor(
      datos: _urlImageDelete,
      // token: '${dataUser!.token}',
    );

    if (response != null) {
      _errorUrl = true;
      // setListaUrlse(response['data']);
      // print('ES LOS URLS: ${response}');
      setUrlImge('');
      // image== null;

      // print('las variables : image - $_urlImage');
      notifyListeners();
      return 'true';
      // return response;
    }

    if (response == null) {
      _errorUrl = false;
      print('ES LOS URLS: ${response}');
      notifyListeners();
      return 'false';
    }
  }


//-------------------------------------//
  ///AGREGAMOS LA IMAGEN EN PANTALLA ////
  String _url = '';
  File? _selectedImage;

  File? get selectedImage => _selectedImage;

  void setImage(File image,) {
    _selectedImage = image;
    _url = _selectedImage!.path;

  getUrlServer();

    notifyListeners();
  }

  void clearImage() {
    _selectedImage = null;
    notifyListeners();
  }

  void deleteImage() {
    if (_selectedImage != null) {
      _selectedImage!.delete();
      clearImage();
    }
  }

  Future getUrlServer() async {
      final dataUser = await Auth.instance.getSession();
    const tipo='ccComprobante';
    try {
      final response = await _api.getUrlsServer(_selectedImage, tipo);

      if (response != null) {
        _errorUrl = true;
        setUrlImge(
          response.toString(),
        );
        notifyListeners();
        return response;
      }

      if (response == null) {
        _errorUrl = false;

        notifyListeners();
      }
    } catch (e) {
      return false;
    }
  }



//*************CREAR FACTURA ******************//



//  Future createPago(BuildContext context) async {
//    final socketService = SocketService();
//     final dataUser = await Auth.instance.getSession();
//   //   DateTime now = DateTime.now();
//   // String formattedDate = "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
//   //  _listaAddPlacas=[];
//   // _listaAddPlacas!.add(_itemAddPlaca);


// final _nuevoPago =
 
//  {
//   "ccId": _infoCuentas['ccId'],
//   "ventaId": _infoCuentas['ventaId'],
//   "ccRucCliente":_infoCuentas['ccRucCliente'],
//   "ccNomCliente":_infoCuentas['ccNomCliente'],
//   "ccFactura":_infoCuentas['ccFactura'],
//   "ccFechaFactura":_infoCuentas['ccFechaFactura'],
//   "ccValorFactura":_infoCuentas['ccValorFactura'],
//   "ccValorRetencion":_infoCuentas['ccValorRetencion'],
//   "ccValorAPagar":_infoCuentas['ccValorAPagar'],
//   "ccFechaAbono":_infoCuentas['ccFechaAbono'],
//   "ccEstado":_infoCuentas['ccEstado'],
//   "ccProcedencia":_infoCuentas['ccProcedencia'],
//   "ccAbono":_infoCuentas['ccAbono'],
//   "ccSaldo":_infoCuentas['ccSaldo'],
//   "ccEmpresa":  dataUser!.usuario,
//   "ccUser":  dataUser.usuario,
//   "ccPagos": [
//     // {
//     //   "ccComprobante": "",
//     //   "ccTipo": "EFECTIVO",
//     //   "ccBanco": "",
//     //   "ccNumero": "0",
//     //   "ccDeposito": "NO",
//     //   "ccValor": "3",
//     //   "ccFechaAbono": "2024-09-24",
//     //   "ccDetalle": "segundo",
//     //   "ccProcedencia": "",
//     //   "ccEstado": "ACTIVO",
//     //   "imprimir": false,
//     //   "ccUsuario": "admin",
//     //   "uuid": "247ccd0e-77d6-408c-99b5-cd86f1f915ac"
//     // },
//     // {
//     //   "ccComprobante": "",
//     //   "ccTipo": "CHEQUE",
//     //   "ccBanco": "",
//     //   "ccNumero": "0",
//     //   "ccDeposito": "NO",
//     //   "ccValor": "2",
//     //   "ccFechaAbono": "2024-09-24",
//     //   "ccDetalle": "",
//     //   "ccProcedencia": "",
//     //   "ccEstado": "ACTIVO",
//     //   "imprimir": false,
//     //   "ccUsuario": dataUser!.usuario, 
//     //   "uuid": "e411584c-fcd3-425e-9f99-6a1f8a8a86c1"
//     // }
//   ],
//   "ccFecReg": _infoCuentas['ccFecReg'],
//   "ccFecUpd": _infoCuentas['ccFecUpd'],
//   "Todos": _infoCuentas['Todos'],
//   "ciudad":_infoCuentas['ciudad'],
//   "sector":_infoCuentas['sector'],
//   "enviarCorreo": false,

//        "tabla": "cuentasporcobrar", //DEFECTO
//       "rucempresa": dataUser.rucempresa, // LOGIN
//       "venUser": dataUser.usuario, // login
//       "rol": dataUser.rol, //LOGIN
// };

// print('LA DATA PARA IMPRIMIR COMPROBANTE $_nuevoPago');

// // socketService.sendMessage('client:actualizarData', _nuevoPago);


//  }


//================================SELECCIONAMOS EL COLOR=============================================//
 String? _tipoDeTransaccion = '';
  String? get getTipoDeTransaccion => _tipoDeTransaccion;

  void setTipoDeTransaccion(String? value) {
    _tipoDeTransaccion = '';
  _tipoDeTransaccion = value;
    // print('==_tipoDeTransaccion ===> $_tipoDeTransaccion');
    notifyListeners();
  }



//============================= BUSCA CLIENTE COMPROBANTES  ================================//
  List? _listaAddPlacas = [];
  List? get getlistaAddPlacas => _listaAddPlacas;

void agregaListaPlacas( ) {
    _listaAddPlacas!.add(_placa);

    notifyListeners();
  }
Map<String,dynamic> _clienteComprobante={};
Map<String,dynamic> get getClienteComprobante=>_clienteComprobante;
void setClienteComprbante(Map<String,dynamic> _info){
  _clienteComprobante={};
_clienteComprobante.addAll(_info);


if (_clienteComprobante.isNotEmpty) {
   _listaAddPlacas=[];
  for (var item in _clienteComprobante['perOtros']) {
   _listaAddPlacas!.add(item);
  
}
}
// if (_clienteComprobante.isNotEmpty) {
//    _listaAddCorreos=[];
//   for (var item in _clienteComprobante["perEmail"]) {
//    _listaAddCorreos!.add(item);
  
// }


// print('EL CLIENTE ENCOTRADO > $_clienteComprobante');
  notifyListeners();
  
}


//================== FORMA DE PAGO  ==========================//
  String _formaDePago = 'EFECTIVO';
  String get getFormaDePago  => _formaDePago;

  void setFormaDePago(String _forma) {
   _formaDePago =''; 
   _formaDePago = _forma;
    //  print('==_formaDePago===> $_formaDePago');
    notifyListeners();
  }
  //================== CORREO  ==========================//
  String _correo = 'EFECTIVO';
  String get getCorreo  => _correo;

  void setCorreo(String _forma) {
   _correo =''; 
   _correo = _forma;
    //  print('==_correo===> $_correo');
    notifyListeners();
  }
//========================== LISTA DE CORREOS  =======================//

  List? _listaAddCorreos = [];
  List? get getlistaAddCorreos => _listaAddCorreos;

  void agregaListaCorreos() {
    _listaAddCorreos!.add(_correo);

    notifyListeners();
  }

  void eliminaCorreo(String? _correo) {
    _listaAddCorreos!.removeWhere((element) => element == _correo);

    notifyListeners();
  }
  resetCorreos(){
     _listaAddCorreos!.clear();
  }






//*********************//
Map<String, dynamic> _itemsMateriales={};

Map<String, dynamic> get getItemsMateriales=>_itemsMateriales;

void setItemsMateriales(Map<String, dynamic> _item){
_itemsMateriales={};
_itemsMateriales.addAll(_item);

}


//*************CREAR MATERIAL ******************//



 Future createMaterial(BuildContext context,Map<String, dynamic> _respuestaCalculoItem) async {
   final socketService = SocketService();
    final dataUser = await Auth.instance.getSession();
    DateTime now = DateTime.now();
  String formattedDate = "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
   _listaAddPlacas=[];
  _listaAddPlacas!.add(_placa);


final _nuevoMaterial =
 {
  "venEmpRegimen": "", // default
  "venProductosAntiguos": [], // default
  "optionDocumento": _tipoDeTransaccion, // Indica el tipo de documento: 'F' para FACTURA, 'N' para PREFACTURA y 'P' para PROFORMA
   "venTotalRetencion": "0.00", // default
  "venOption": "1", // default 1 porque es nuevo, los otros numeros son para otros caso de editar, ect (1 => nuevo, 2 => copia, 3 => editar, 4 => notacredito)
  "venTipoDocumento": _tipoDeTransaccion, // Indica el tipo de documento: 'F' para FACTURA, 'N' para PREFACTURA y 'P' para PROFORMA
   "venIdCliente": _clienteComprobante['perId'], // tomar del endpoint cliente
  "venRucCliente": _clienteComprobante['perDocNumero'], // tomar del endpoint cliente
  "venTipoDocuCliente": _clienteComprobante['perDocTipo'], // tomar del endpoint cliente
  "venNomCliente": _clienteComprobante['perNombre'], // tomar del endpoint cliente
  "venEmailCliente":_listaAddCorreos ,//_clienteComprobante['perEmail'], // tomar del endpoint cliente
  "venTelfCliente": _clienteComprobante['perTelefono'], // tomar del endpoint cliente
  "venCeluCliente": _clienteComprobante['perCelular'], // tomar del endpoint cliente
  "venDirCliente":_clienteComprobante['perDireccion'], // tomar del endpoint cliente
   "venEmpRuc": "",// default
  "venEmpNombre": "",// default
  "venEmpComercial": "",// default
  "venEmpDireccion": "",// default
  "venEmpTelefono": "",// default
  "venEmpEmail": "",// default
  "venEmpObligado": "",// default
   "venFormaPago": _formaDePago, // Método de pago:TARJETA PREPAGO,DINERO ELECTRONICO,TARJETA DEBITO,CHEQUE,DEPOSITO,TRANSFERENCIA,TARJETA DE CREDITO,EFECTIVO
    "venNumero": "0", // default
  "venFacturaCredito": "NO", // Indica si la factura es a crédito: 'SI' o 'NO'
  "venDias": "0", // Número de días de crédito si 'venFacturaCredito' es 'SI'; de lo contrario, asignar 0
  "venAbono": "0", // Monto del abono; por defecto 0, asignar el valor si existe un abono
  "venDescPorcentaje": "0", // Porcentaje de descuento; de lo contrario, asignar 0
    "venOtrosDetalles": _listaAddPlacas, //lista de placas 
  "venConductor": _nombreConductor,
  "venObservacion":_destino, // Observaciones sobre la factura; dejar vacío si no hay
   "venSubTotal12": _respuestaCalculoItem['venSubTotal12'], // obtener del endpoint calcularProducto, por dafault 0
  "venSubtotal0": _respuestaCalculoItem['venSubtotal0'], // obtener del endpoint calcularProducto, por dafault 0
  "venDescuento": _respuestaCalculoItem['venDescuento'], // obtener del endpoint calcularProducto, por dafault 0
  "venSubTotal": _respuestaCalculoItem['venSubTotal'], // obtener del endpoint calcularProducto, por dafault 0
  "venTotalIva": _respuestaCalculoItem['venTotalIva'], // obtener del endpoint calcularProducto, por dafault 0
  "venCostoProduccion": _respuestaCalculoItem['venCostoProduccion'], // obtener del endpoint calcularProducto, por dafault 0
  "venTotal": _respuestaCalculoItem['venTotal'], // obtener del endpoint calcularProducto, por dafault 0
  "venFechaFactura": formattedDate, // Fecha de emisión de la factura
  "venNumFactura": "", // default
  "venNumFacturaAnterior": "", // default
  "venAutorizacion": "0", // default
  "venFechaAutorizacion": "", // default
  "venErrorAutorizacion": "NO", // default
  "venEstado": "ACTIVA", // default
  "venEnvio": "NO", // default
  "fechaSustentoFactura": "", // default
  "venEmpresa": dataUser!.rucempresa,  //login
  "venProductos": _respuestaCalculoItem['venProductos'],
   // obtener del endpoint calcularProducto, por dafault []
       "tabla": "ventas", //DEFECTO
      "rucempresa": dataUser.rucempresa, // LOGIN
      "venUser": dataUser.usuario, // login
      "rol": dataUser.rol, //LOGIN
};

// print('LA DATA PARA IMPRIMIR MATERIALES ${_nuevoMaterial['venProductos']}');

socketService.sendMessage('client:guardarData', _nuevoMaterial);


 }

//===================MATERIALES======================//




//=================================================================================================================//
  // ================= VARIABLES DE PAGINACION ====================//
//=================================================================================================================//
//===================BOTON SEARCH PAGINACION ==========================//

  bool _btnSearchMaterialesPaginacion = false;
  bool get btnSearchPreFacturaPaginacion => _btnSearchMaterialesPaginacion;

  void setBtnSearchPreFacturaPaginacion(bool action) {
    _btnSearchMaterialesPaginacion = action;
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


  List _listaMaterialesPaginacion = [];
  // List<TipoMulta> get getListaTodosLosTiposDeMultas => _listaTodosLosTiposDeMultas;
  List get getListaMaterialesPaginacion => _listaMaterialesPaginacion;


 double _valorTotalFacturasHoy = 0.00;
  // List<TipoMulta> get getListaTodosLosTiposDeMultas => _listaTodosLosTiposDeMultas;
  double get getValorTotalFacturasHoy => _valorTotalFacturasHoy;
double _valorTotalFacturasAntes = 0.00;
  // List<TipoMulta> get getListaTodosLosTiposDeMultas => _listaTodosLosTiposDeMultas;
  double get getValorTotalFacturasAntes => _valorTotalFacturasAntes;


void resetValorTotalMateriales(){
_valorTotalFacturasHoy = 0.00;
_valorTotalFacturasAntes = 0.00;
notifyListeners();
}



  void setInfoBusquedaMaterialesPaginacion(List data) {
    _listaMaterialesPaginacion=[];
    _listaMaterialesPaginacion.addAll(data);
    // print('Materiales xxx :${_listaMaterialesPaginacion.length}');

   if (_tabIndex==0) {
  _valorTotalFacturasHoy = 0.0;

// Iterar sobre cada item en la lista
for (var item in _listaMaterialesPaginacion) {
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
for (var item in _listaMaterialesPaginacion) {
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

  bool? _errorMaterialesPaginacion; // sera nulo la primera vez
  bool? get getErrorMaterialesPaginacion => _errorMaterialesPaginacion;
  void setErrorMaterialesPaginacion(bool? value) {
    _errorMaterialesPaginacion = value;
    notifyListeners();
  }

  bool? _error401MaterialesPaginacion = false; // sera nulo la primera vez
  bool? get getError401MaterialesPaginacion => _error401MaterialesPaginacion;
  void setError401MaterialesPaginacion(bool? value) {
    _error401MaterialesPaginacion = value;
    notifyListeners();
  }

  bool _isNextMateriales = false;
  bool get getIsNextMateriales => _isNextMateriales;
  void setIsNextMateriales(bool _next) {
    _isNext = _next;
    // print('_isNext: $_isNext');

    notifyListeners();
  }

  int? _pageMateriales = 0;
  int? get getpageMateriales => _pageMateriales;
  void setPageMateriales(int? _pag) {
    _page = _pag;
    // print('_page: $_page');

    notifyListeners();
  }

  int? _cantidadMateriales = 25;
  int? get getCantidadMateriales => _cantidadMateriales;
  void setCantidadMateriales(int? _cant) {
    _cantidadMateriales = _cant;
    notifyListeners();
  }

  String? _nextMateriales = '';
  String? get getNextMateriales => _nextMateriales;
  void setNextMateriales(String? _nex) {
    _next = _nex;
    notifyListeners();
  }
   void resetFormPreFacturas() {
     setInfoBusquedaMaterialesPaginacion([]);
  }

  Future buscaAllMaterialesPaginacion(String? _search, bool _isSearch,int tipo) async {
    final dataUser = await Auth.instance.getSession();
// print('usuario : ${dataUser!.rucempresa}');
    final response = await _api.getAllMaterialesPaginacion(
      search: _search,
      page: _page,
      cantidad: _cantidadMateriales,
      input: 'venId',
      orden: false,
      estado:'DESPACHO',
      token: '${dataUser!.token}',
    );

    if (response != null) {
      if (response == 401) {
        setInfoBusquedaMaterialesPaginacion([]);
        _error401MaterialesPaginacion = true;
        notifyListeners();
        return response;
      } else {
        _errorMaterialesPaginacion = true;
        if (_isSearch == true) {
          _listaMaterialesPaginacion = [];
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
          setFacturasMateriales(dataSort);
          filtrarFacturasDeHoy();
        } else {
          //  setInfoBusquedaFacturasPaginacion([]);
             setFacturasMateriales(dataSort);
          filtrarFacturasAnteriores();
        }
        notifyListeners();
        return response;
      }

      //===========================================//

    }
    if (response == null) {
      _errorMaterialesPaginacion = false;
      notifyListeners();
      return null;
    }
  }

List _facturasMateriales = [];
  List _facturasFiltradasMateriales = [];

  List get facturasFiltradasMateriales => _facturasFiltradasMateriales;

  void setFacturasMateriales(List facturas) {
    _facturasMateriales = facturas;



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

  _facturasFiltradasMateriales = _facturasMateriales.where((factura) {
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
  setListFilterMateriales(_facturasFiltradasMateriales);
  notifyListeners();
}
// void filtrarFacturasAnteriores() {
//   DateTime hoy = DateTime.now();  // Fecha actual en hora local
//   String fechaHoy = DateFormat('yyyy-MM-dd').format(hoy);

//   _facturasFiltradasMateriales = _facturasMateriales.where((factura) {
//     String? fechaFactura = factura['venFecReg'];
//     if (fechaFactura != null) {
//       // Convertir la fecha de la factura a DateTime y luego a la hora local
//       DateTime fechaFacturaDateTime = DateTime.parse(fechaFactura).toLocal();
//       String fechaFacturaSoloFecha = DateFormat('yyyy-MM-dd').format(fechaFacturaDateTime);
//       return fechaFacturaSoloFecha != fechaHoy;  // Filtrar las fechas anteriores o diferentes a hoy
//     }
//     return false;
//   }).toList();

//   // Actualizar la lista filtrada
//   setListFilterMateriales(_facturasFiltradasMateriales);
//   notifyListeners();
// }
void filtrarFacturasAnteriores() {
  DateTime hoy = DateTime.now();  // Fecha actual en hora local
  String fechaHoy = DateFormat('yyyy-MM-dd').format(hoy);

  _facturasFiltradasMateriales = _facturasMateriales.where((factura) {
    String? fechaFactura = factura['venFecReg'];
    if (fechaFactura != null) {
      // Convertir la fecha de la factura a DateTime y luego a la hora local
      DateTime fechaFacturaDateTime = DateTime.parse(fechaFactura).toLocal();
      String fechaFacturaSoloFecha = DateFormat('yyyy-MM-dd').format(fechaFacturaDateTime);
      return fechaFacturaSoloFecha != fechaHoy;  // Filtrar las fechas anteriores o diferentes a hoy
    }
    return false;
  }).toList();

  // Actualizar la lista filtrada
  setListFilterMateriales(_facturasFiltradasMateriales);
  notifyListeners();
}
//*********************************************************//



//************INDEX TAB*****************//
int _tabIndexMateriales=0;

int get getTabIndexMateriales=>_tabIndexMateriales;

void setTabIndexMateriales( int _index)
{
_tabIndex=_index;

notifyListeners();

}





//=================BUSCADOR LOCAL==================//

 List<dynamic> _allItemsFiltersMateriales=[];
   List<dynamic> get allItemsFiltersMateriales => _allItemsFiltersMateriales;
   void setListFilterMateriales( List<dynamic> _list){
  _allItemsFiltersMateriales = [];

// _sortList();



_allItemsFiltersMateriales.addAll(_list);
// print('LA LISTA DE LOS ESTUDIANTES _allItemsFilters: ${_allItemsFilters.length} ');
print('LA LISTA DE LOS  _allItemsFilters: $_allItemsFiltersMateriales ');

//====================== REALIZA LA SUMATORIA EN CADA CONSULTA  =============================//

if (_tabIndex==0) {
  _valorTotalFacturasHoy = 0.0;

// Iterar sobre cada item en la lista
for (var item in _allItemsFiltersMateriales) {
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
for (var item in _allItemsFiltersMateriales) {
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
//===================================================//


  notifyListeners();
 }

  void searchMateriales(String query) {
      List<Map<String, dynamic>> originalList = List.from(_facturasFiltradasMateriales); // Copia de la lista original
    if (query.isEmpty) {
      _allItemsFiltersMateriales = originalList;
    } else {
      _allItemsFiltersMateriales = originalList.where((material) {
        return 
        // resident['resCedula'].toLowerCase().contains(query.toLowerCase()) ||
               material['venNomCliente'].toLowerCase().contains(query.toLowerCase()) ;
      }).toList();
    }
    notifyListeners();
  }




//====================================//

//************ GET INFO DE ITEM MATERIALES*************//
Map<String,dynamic> _infoMateriales={};
Map<String,dynamic> get getInfoMateriales=>_infoMateriales;
void setInfoMateriales(Map<String,dynamic>  _info){
_infoMateriales={};
_infoMateriales=_info;

print('_infoMateriales: $_infoMateriales');
  notifyListeners();
}





//===========================================//


}