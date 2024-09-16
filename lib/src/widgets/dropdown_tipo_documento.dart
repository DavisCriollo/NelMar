import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:neitorcont/src/controllers/propietarios_controller.dart';
import 'package:neitorcont/src/utils/responsive.dart';


import 'package:provider/provider.dart';


class DropMenuTipoDocumento extends StatelessWidget {
  final List data;
  final String? hinText;

  const DropMenuTipoDocumento({Key? key, required this.data, this.hinText})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Responsive size = Responsive.of(context);
    final tipoDocumento =
        Provider.of<PropietariosController>(context, listen: true);
    List<DropdownMenuItem<String>> getOptions() {
      List<DropdownMenuItem<String>> menu = [];
      for (var item in data) {
        menu.add(DropdownMenuItem(
          child: Center(child: Text(item, textAlign: TextAlign.center)),
          value: item,
          //item,
        ));
      }
      return menu;
    }

    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: size.iScreen(2.0), vertical: size.iScreen(0)),
      // width: size.wScreen(60),
      child: Container(
        alignment: Alignment.center,
        child: DropdownButton(
          isExpanded: false,
          hint: Text(hinText!,
              // tipoDocumento.tipoDoc.toString(),
              style: GoogleFonts.lexendDeca(
                fontSize: size.iScreen(1.8),
                // fontWeight: FontWeight.w500,
                color: Colors.black45,
              )),
          value: tipoDocumento.labelTipoDocumento,
          style: GoogleFonts.lexendDeca(
              fontSize: size.iScreen(1.7),
              color: Colors.black87,
              fontWeight: FontWeight.normal),
          items: getOptions(),
          onChanged: (value) {
            //final labeltipoDocumento =
            Provider.of<PropietariosController>(context, listen: false)
                .setLabelTipoDocumento(value.toString());
            // print(labeltipoDocumento);
          },
        ),
      ),
    );
  }
}
