// // To parse this JSON data, do
// //
// //     final authResponse = authResponseFromMap(jsonString);

// import 'dart:convert';

// class AuthResponse {
//     AuthResponse({
//         this.token,
//         this.id,
//         this.nombre,
//         this.usuario,
//         this.rucempresa,
//         this.codigo,
//         this.nomEmpresa,
//         this.nomComercial,
//         this.fechaCaducaFirma,
//         this.rol,
//         this.empCategoria,
//     });

//     String? token;
//     int? id;
//     String? nombre;
//     String? usuario;
//     String? rucempresa;
//     String? codigo;
//     String? nomEmpresa;
//     String? nomComercial;
//     DateTime? fechaCaducaFirma;
//     List<String>? rol;
//     String? empCategoria;

//     factory AuthResponse.fromJson(String str) => AuthResponse.fromMap(json.decode(str));

//     String toJson() => json.encode(toMap());

//     factory AuthResponse.fromMap(Map<String, dynamic> json) => AuthResponse(
//         token: json["token"],
//         id: json["id"],
//         nombre: json["nombre"],
//         usuario: json["usuario"],
//         rucempresa: json["rucempresa"],
//         codigo: json["codigo"],
//         nomEmpresa: json["nomEmpresa"],
//         nomComercial: json["nomComercial"],
//         fechaCaducaFirma: DateTime.parse(json["fechaCaducaFirma"]),
//         rol: List<String>.from(json["rol"].map((x) => x)),
//         empCategoria: json["empCategoria"],
//     );

//     Map<String, dynamic> toMap() => {
//         "token": token,
//         "id": id,
//         "nombre": nombre,
//         "usuario": usuario,
//         "rucempresa": rucempresa,
//         "codigo": codigo,
//         "nomEmpresa": nomEmpresa,
//         "nomComercial": nomComercial,
//         "fechaCaducaFirma": fechaCaducaFirma!.toIso8601String(),
//         "rol": List<dynamic>.from(rol!.map((x) => x)),
//         "empCategoria": empCategoria,
//     };
// }

// To parse this JSON data, do
//
//     final authResponse = authResponseFromMap(jsonString);

import 'dart:convert';

// class AuthResponse {
//     AuthResponse({
//         this.token,
//         this.id,
//         this.nombre,
//         this.usuario,
//         this.rucempresa,
//         this.codigo,
//         this.nomEmpresa,
//         this.nomComercial,
//         this.fechaCaducaFirma,
//         this.rol,
//         this.empCategoria,
//         this.logo,
//         this.foto,
//         this.colorPrimario,
//         this.colorSecundario,
//     });

//     String? token;
//     int? id;
//     String? nombre;
//     String? usuario;
//     String? rucempresa;
//     String? codigo;
//     String? nomEmpresa;
//     String? nomComercial;
//     DateTime? fechaCaducaFirma;
//     List<String>? rol;
//     String? empCategoria;
//     String? logo;
//     String? foto;
//     String? colorPrimario;
//     String? colorSecundario;

//     factory AuthResponse.fromJson(String str) => AuthResponse.fromMap(json.decode(str));

//     String toJson() => json.encode(toMap());

//     factory AuthResponse.fromMap(Map<String, dynamic> json) => AuthResponse(
//         token: json["token"],
//         id: json["id"],
//         nombre: json["nombre"],
//         usuario: json["usuario"],
//         rucempresa: json["rucempresa"],
//         codigo: json["codigo"],
//         nomEmpresa: json["nomEmpresa"],
//         nomComercial: json["nomComercial"],
//         fechaCaducaFirma: DateTime.parse(json["fechaCaducaFirma"]),
//         rol: List<String>.from(json["rol"].map((x) => x)),
//         empCategoria: json["empCategoria"],
//         logo: json["logo"],
//         foto: json["foto"],
//         colorPrimario: json["colorPrimario"],
//         colorSecundario: json["colorSecundario"],
//     );

//     Map<String, dynamic> toMap() => {
//         "token": token,
//         "id": id,
//         "nombre": nombre,
//         "usuario": usuario,
//         "rucempresa": rucempresa,
//         "codigo": codigo,
//         "nomEmpresa": nomEmpresa,
//         "nomComercial": nomComercial,
//         "fechaCaducaFirma": fechaCaducaFirma.toString(),
//         "rol": List<dynamic>.from(rol!.map((x) => x)),
//         "empCategoria": empCategoria,
//         "logo": logo,
//         "foto": foto,
//         "colorPrimario": colorPrimario,
//         "colorSecundario": colorSecundario,
//     };
// }

class AuthResponse {
  AuthResponse({
    this.token,
    this.id,
    this.nombre,
    this.usuario,
    this.rucempresa,
    this.codigo,
    this.nomEmpresa,
    this.nomComercial,
    this.fechaCaducaFirma,
    this.rol,
    this.empCategoria,
    this.logo,
    this.foto,
    this.colorPrimario,
    this.colorSecundario,
    this.empRoles,
    this.permisosUsuario,
    this.isClient,
    this.ciudad,
    this.sector,
    this.iva,
  });

  String? token;
  int? id;
  String? nombre;
  String? usuario;
  String? rucempresa;
  String? codigo;
  String? nomEmpresa;
  String? nomComercial;
  DateTime? fechaCaducaFirma;
  List<String>? rol;
  String? empCategoria;
  String? logo;
  String? foto;
  String? colorPrimario;
  String? colorSecundario;
  List<String>? empRoles;
  Map<String, dynamic>? permisosUsuario;
  String? isClient;
  String? ciudad;
  String? sector;
  int? iva;

  factory AuthResponse.fromJson(String str) => AuthResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory AuthResponse.fromMap(Map<String, dynamic> json) => AuthResponse(
        token: json["token"],
        id: json["id"],
        nombre: json["nombre"],
        usuario: json["usuario"],
        rucempresa: json["rucempresa"],
        codigo: json["codigo"],
        nomEmpresa: json["nomEmpresa"],
        nomComercial: json["nomComercial"],
        fechaCaducaFirma: json["fechaCaducaFirma"] != null
            ? DateTime.parse(json["fechaCaducaFirma"])
            : null,
        rol: json["rol"] != null
            ? List<String>.from(json["rol"].map((x) => x))
            : null,
        empCategoria: json["empCategoria"],
        logo: json["logo"],
        foto: json["foto"],
        colorPrimario: json["colorPrimario"],
        colorSecundario: json["colorSecundario"],
        empRoles: json["empRoles"] != null
            ? List<String>.from(json["empRoles"].map((x) => x))
            : null,
        permisosUsuario: json["permisos_usuario"] != null
            ? Map<String, dynamic>.from(json["permisos_usuario"])
            : null,
        isClient: json["isClient"],
        ciudad: json["ciudad"],
        sector: json["sector"],
        iva: json["iva"],
      );

  Map<String, dynamic> toMap() => {
        "token": token,
        "id": id,
        "nombre": nombre,
        "usuario": usuario,
        "rucempresa": rucempresa,
        "codigo": codigo,
        "nomEmpresa": nomEmpresa,
        "nomComercial": nomComercial,
        "fechaCaducaFirma":
            fechaCaducaFirma != null ? fechaCaducaFirma!.toIso8601String() : null,
        "rol": rol != null ? List<dynamic>.from(rol!.map((x) => x)) : null,
        "empCategoria": empCategoria,
        "logo": logo,
        "foto": foto,
        "colorPrimario": colorPrimario,
        "colorSecundario": colorSecundario,
        "empRoles": empRoles != null ? List<dynamic>.from(empRoles!.map((x) => x)) : null,
        "permisos_usuario": permisosUsuario,
        "isClient": isClient,
        "ciudad": ciudad,
        "sector": sector,
        "iva": iva,
      };
}