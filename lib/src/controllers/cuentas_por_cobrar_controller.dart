import 'package:flutter/material.dart';
import 'package:neitorcont/src/api/api_provider.dart';
import 'package:neitorcont/src/api/authentication_client.dart';
import 'package:neitorcont/src/models/auth_response.dart';

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



 List<dynamic> _allItemsFilters=[];
   List<dynamic> get allItemsFilters => _allItemsFilters;
   void setListFilter( List<dynamic> _list){
  _allItemsFilters = [];

// _sortList();



_allItemsFilters.addAll(_list);
// print('LA LISTA DE LOS ESTUDIANTES _allItemsFilters: $_allItemsFilters ');

  notifyListeners();
 }

  void search(String query) {
      List<Map<String, dynamic>> originalList = List.from(getListaDeProductos); // Copia de la lista original
    if (query.isEmpty) {
      _allItemsFilters = originalList;
    } else {
      _allItemsFilters = originalList.where((estudiante) {
        return 
        estudiante['invNombre'].toLowerCase().contains(query.toLowerCase())&&
             estudiante['invCategoria'] == _typeAction; // Condición adicional para que sea "MOTOS" ;
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


}