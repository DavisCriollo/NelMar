// import 'package:flutter/material.dart';
// import 'package:neitorcont/src/services/notifications_service.dart';

// import 'package:provider/provider.dart';


// // import 'package:socket_io_client/socket_io_client.dart' as IO;

// import 'package:socket_io_client/socket_io_client.dart' as IO;

// enum ServerStatus {
//   Online,
//   Ofline,
//   Connecting,
// }

// class SocketService extends ChangeNotifier {
//   ServerStatus _serverStatus = ServerStatus.Connecting;

  

// // EXPONER DE MANERA PRIVADA PARA CONTROLAR LA MANERA DE EXPOSICION AL MUBDO , PANTALLA, CLASE
//   late IO.Socket? _socket;

//   ServerStatus get serverStatus => _serverStatus;
//   // String? _serverResponses;
//   // String? get serverResponses => _serverResponses;

//   IO.Socket? get socket => _socket;

//   SocketService() {
   
//     _initConfig();
//   }

//   void _initConfig() {
//     // Dart client
//     // _socket = IO.io('https://contabackend.neitor.com', {
//     // _socket = IO.io('http://192.168.1.4:3000', {
//     //       'transports': ['websocket'],
//     //   'autoConnect': true,
//     // });
//     _socket = IO.io(
//     'https://contabackend.neitor.com',
//         IO.OptionBuilder()
//             .setTransports(['websocket']) // for Flutter or Dart VM
//             .enableAutoConnect()
//             // .setExtraHeaders({'foo': 'bar'}) // optional
//             .build());


 

//     _socket?.onConnect((_) {
//       print('David conectado desde Flutter !!! ');
//       _serverStatus = ServerStatus.Online;
      
//       // NotificatiosnService.showSnackBarSuccsses("Bienvenido");


//       notifyListeners();
//     });

//     _socket?.onDisconnect((_) {
//       print('disconnect desde Flutter !!!');
//       _serverStatus = ServerStatus.Ofline;

      

//       // NotificatiosnService.showSnackBarError("Sin conexión");
//       // _socket = null;
//       notifyListeners();
//     });

   
   
//   }
// }


import 'package:flutter/material.dart';
import 'package:neitorcont/src/api/authentication_client.dart';
import 'package:neitorcont/src/controllers/comprobantes_controller.dart';
import 'package:neitorcont/src/controllers/home_controller.dart';
import 'package:neitorcont/src/controllers/propietarios_controller.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:neitorcont/src/services/notifications_service.dart';

// enum ServerStatus {
//   Online,
//   Offline,
//   Connecting,
// }

// class SocketService extends ChangeNotifier {
//   ServerStatus _serverStatus = ServerStatus.Connecting;
//   late IO.Socket? _socket;
//   bool _snackbarShown = false;

//   ServerStatus get serverStatus => _serverStatus;
//   IO.Socket? get socket => _socket;

//   SocketService() {
//     _initConfig();
//   }

//   void _initConfig() {
//     _socket = IO.io(
//       'https://contabackend.neitor.com',
//       IO.OptionBuilder()
//           .setTransports(['websocket'])
//           .enableAutoConnect()
//           .build(),
//     );

//     _socket?.onConnect((_) {
//       print('Conectado desde Flutter !!!');
//       _serverStatus = ServerStatus.Online;
//       _showSnackbar("Conexión exitosa");
//       notifyListeners();
//     });

//     _socket?.onDisconnect((_) {
//       print('Desconectado desde Flutter !!!');
//       _serverStatus = ServerStatus.Offline;
//       _showSnackbar("Sin conexión");
//       notifyListeners();
//     });
//   }

//   void _showSnackbar(String message) {
//     if (!_snackbarShown) {
//       NotificatiosnService.showSnackBarDanger(message);
//       _snackbarShown = true;
//       Future.delayed(Duration(seconds: 2), () {
//         _snackbarShown = false;
//       });
//     }
//   }
// }




//****************************//

// enum ServerStatus {
//   Online,
//   Offline,
//   Connecting,
// }

// class SocketService extends ChangeNotifier {
//   static final SocketService _instance = SocketService._internal();
  
//   factory SocketService() => _instance;

//   SocketService._internal() {
//     _initConfig();
//   }

//   ServerStatus _serverStatus = ServerStatus.Connecting;
//   late IO.Socket? _socket;
//   bool _snackbarShown = false;

//   ServerStatus get serverStatus => _serverStatus;
//   IO.Socket? get socket => _socket;

//   void _initConfig() {
//     _socket = IO.io(
//       'https://contabackend.neitor.com',
//       IO.OptionBuilder()
//           .setTransports(['websocket'])
//           .enableAutoConnect()
//           .build(),
//     );

//     _socket?.onConnect((_) {
//       print('Conectado desde Flutter !!!');
//       _serverStatus = ServerStatus.Online;
//       _showSnackbar("Conexión exitosa");
//       notifyListeners();
//     });

//     _socket?.onDisconnect((_) {
//       print('Desconectado desde Flutter !!!');
//       _serverStatus = ServerStatus.Offline;
//       _showSnackbar("Sin conexión");
//       notifyListeners();
//     });

//     _socket?.on('response', (data) {
//       // Maneja la respuesta del servidor aquí
//       print('Respuesta del servidor: $data');
//       notifyListeners();
//     });
//   }

//   void _showSnackbar(String message) {
//     if (!_snackbarShown) {
//       NotificatiosnService.showSnackBarDanger(message);
//       _snackbarShown = true;
//       Future.delayed(Duration(seconds: 2), () {
//         _snackbarShown = false;
//       });
//     }
//   }

//   void sendMessage(String event, Map<String, dynamic> message) {
//     _socket?.emit(event, message);
//   }
// }



//***********PERFECTO*************//

enum ServerStatus {
  Online,
  Offline,
  Connecting,
}

class SocketService extends ChangeNotifier {


  
  static final SocketService _instance = SocketService._internal();
  
  factory SocketService() => _instance;

  SocketService._internal() {
    _initConfig();
  }

  ServerStatus _serverStatus = ServerStatus.Connecting;
  late IO.Socket? _socket;
  bool _snackbarShown = false;


  // =============VENTAS=============//
  Map<String, dynamic>? _latestResponseVantes={};
  Map<String, dynamic>? get latestResponseVentas => _latestResponseVantes;
    bool _estadoPrintVenta=false;
  bool get getEstadoPrintVenta => _estadoPrintVenta;
  // =============CAJA=============//
  Map<String, dynamic>? _latestResponseCaja={};
  Map<String, dynamic>? get latestResponseCaja => _latestResponseCaja;
  void resetResponseSocket(){

_latestResponseVantes={};
_latestResponseCaja={};
_estadoPrintVenta=false;
  notifyListeners();

}

  ServerStatus get serverStatus => _serverStatus;
  IO.Socket? get socket => _socket;

  void _initConfig() {
    _socket = IO.io(
      'https://contabackend.neitor.com',
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .enableAutoConnect()
          .build(),
    );

    _socket?.onConnect((_) {
      print('Conectado desde Flutter !!!');
      _serverStatus = ServerStatus.Online;
      // _showSnackbar("Conexión exitosa", 'success');
      notifyListeners();
    });

    _socket?.onDisconnect((_) {
      print('Desconectado desde Flutter !!!');
      _serverStatus = ServerStatus.Offline;
      // _showSnackbar("Sin conexión", 'error');
      notifyListeners();
    });



        //=================GUARDADO=====================//
    _socket?.on('server:guardadoExitoso', (data) async {
       final dataUser = await Auth.instance.getSession();
      

        if (data['tabla'] == 'proveedor' && data['perUser']==dataUser!.usuario && data['rucempresa']==dataUser.rucempresa) {
        final _ctrlPropietario=PropietariosController();
        final _ctrlComprobante=ComprobantesController();
        
        _ctrlPropietario.buscaAllPropietarios('');

        //  _latestResponseVantes={};
        //  _latestResponseVantes=data;
    //       print('DATA PROPIETARIO: $data');
       

    //    _ctrlComprobante.setClienteComprbante({
		// 	"perId":data['perId'],
		// 	"perNombre":data['perNombre'],
		// 	"perDocNumero":data['perDocNumero'],
		// 	"perDocTipo":data['perDocTipo'],
		// 	"perTelefono":data['perTelefono'],
		// 	"perDireccion":data['perDireccion'],
		// 	"perEmail": data['perEmail'],
		// 	"perCelular": data['perCelular'],
		// 	"perOtros": data['perOtros']
		// });


  _showSnackbar('Registro guardado exitosamente');


         notifyListeners();
        }
        // Condición para la tabla 'factura'
    if (data['tabla'] == 'ventas' && data['venUser']==dataUser!.usuario && data['rucempresa']==dataUser.rucempresa && data.containsKey('venId') ) {
       
        // _showSnackbar('Registro guardada exitosamente');
        //==============LA RSPUESTA ===================//
         _latestResponseVantes={};
         _estadoPrintVenta=true;
      _latestResponseVantes=data;
        print('DATA VENTAS: $data');
        notifyListeners();
    } 
    if (data['tabla'] == 'caja' && data['cajaUser']==dataUser!.usuario && data['rucempresa']==dataUser.rucempresa && data.containsKey('cajaId') ) {
        // _showSnackbar('Caja guardada exitosamente');
        //==============LA RSPUESTA ===================//
        _latestResponseCaja=data;
          print('DATA CAJA: $_latestResponseCaja');
        notifyListeners();
    }
        
       
    });
       //=================ACTUALIZADO=====================//
    _socket?.on('server:actualizadoExitoso', (data)  async{
         final dataUser = await Auth.instance.getSession();
        final _ctrlPropietario=PropietariosController();
        if (data['tabla'] == 'proveedor' && data['perUser']==dataUser!.usuario && data['rucempresa']==dataUser.rucempresa) {
        _ctrlPropietario.buscaAllPropietarios('');
         // Maneja la respuesta del servidor aquí
        _showSnackbar('Registro actualizado exitosamente');
         notifyListeners();
        }
         else if (data['tabla'] == 'ventas' && data['venUser']==dataUser!.usuario && data['rucempresa']==dataUser.rucempresa) {
      
        _showSnackbar('Registro actualizado exitosamente');
        //==============LA RSPUESTA ===================//
         notifyListeners();
    } 
         else if (data['tabla'] == 'caja' && data['cajaUser']==dataUser!.usuario && data['rucempresa']==dataUser.rucempresa) {
      
        _showSnackbar('Registro actualizado exitosamente');
        //==============LA RSPUESTA ===================//
        // print('$data');
  
        notifyListeners();
    } 
        // print('LA DATA ACTUALIZADA SOCKET: $data');
    });
        //=================ELIMINADO=====================//
    _socket?.on('server:eliminadoExitoso', (data) async {
         final dataUser = await Auth.instance.getSession();
        final _ctrlPropietario=PropietariosController();
        if (data['tabla'] == 'proveedor' && data['perUser']==dataUser!.usuario && data['rucempresa']==dataUser.rucempresa) {
        _ctrlPropietario.buscaAllPropietarios('');
         // Maneja la respuesta del servidor aquí
        // _showSnackbar('$data');
          _showSnackbar('Registro eliminado exitosamente');
         notifyListeners();
        }
        else if (data['tabla'] == 'ventas' && data['venUser']==dataUser!.usuario && data['rucempresa']==dataUser.rucempresa) {
        final _ctrlComprobante=ComprobantesController();
        _showSnackbar('Registro eliminado exitosamente');
        //==============LA RSPUESTA ===================//
        // print('TABLA ${data['tabla']}');
          // print('$data');
    
        notifyListeners();
    } 
     else if (data['tabla'] == 'caja' && data['cajaUser']==dataUser!.usuario && data['rucempresa']==dataUser.rucempresa) {
        final _ctrlComprobante=ComprobantesController();
        _showSnackbar('Registro eliminado exitosamente');
        //==============LA RSPUESTA ===================//
        // print('$data');
    
        notifyListeners();
    } 
       
    });
          //=================ERROR=====================//
    _socket?.on('server:error', (data)  async{
         final dataUser = await Auth.instance.getSession();
       
        if (data['tabla'] == 'proveedor'&& data['perUser']==dataUser!.usuario && data['rucempresa']==dataUser.rucempresa) {
          final _ctrlPropietario=PropietariosController(); 
          _ctrlPropietario.buscaAllPropietarios('');
         _showSnackbarError('${data['msg']}');
         notifyListeners();
        }
        else if (data['tabla'] == 'ventas' && data['venUser']==dataUser!.usuario && data['rucempresa']==dataUser.rucempresa) {
        final _ctrlComprobante=ComprobantesController();
       _showSnackbarError('${data['msg']}');
        
        notifyListeners();
    } 
        else if (data['tabla'] == 'caja' && data['cajaUser']==dataUser!.usuario && data['rucempresa']==dataUser.rucempresa) {
        final _ctrlComprobante=ComprobantesController();
       _showSnackbarError('${data['msg']}');
        
        notifyListeners();
    } 

    });




  }

  void _showSnackbar( String result) {
    NotificatiosnService.showSnackBarDanger(result);
  }
  void _showSnackbarError( String result) {
    NotificatiosnService.showSnackBarDanger(result);
  }
  void sendMessage(String event, Map<String, dynamic> message) {
    _socket?.emit(event, message);
  }
}