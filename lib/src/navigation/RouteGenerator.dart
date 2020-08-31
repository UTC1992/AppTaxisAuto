import 'package:AppTaxisAuto/src/models/ArgumentosSolicitudDatos.dart';
import 'package:AppTaxisAuto/src/models/SolicitudTaxi.dart';
import 'package:AppTaxisAuto/src/models/Taxista.dart';
import 'package:flutter/material.dart';
import '../ui/view/Landing.dart';
import '../ui/view/Login.dart';
import '../ui/view/Registro.dart';
import '../ui/view/Viajes.dart';
import '../ui/pages/perfil/EditarNombre.dart';
import '../ui/pages/perfil/EditarTelefono.dart';
import '../ui/pages/perfil/EditarImagen.dart';
import '../ui/pages/perfil/EditarCorreo.dart';
import '../ui/pages/perfil/EditarPassword.dart';
import '../ui/pages/perfil/EditarCiudad.dart';
import '../ui/pages/solicitud/SolicitudDatos.dart';
import './DrawerNavigation.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // Getting arguments passed in while calling Navigator.pushNamed
    final  args = settings.arguments;

    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (context) => Landing());
        break;
      case '/login':
        return MaterialPageRoute(builder: (context) => Login());
        break;
      case '/registro':
        return MaterialPageRoute(builder: (context) => Registro());
        break;
      case '/pedidos':
        return MaterialPageRoute(builder: (context) => DrawerNavigation());
        break;
      case '/viajes':
        return MaterialPageRoute(builder: (context) => Viajes());
        break;
      case '/editarNombre':
        if (args is Taxista) {
          return MaterialPageRoute( 
            builder: (_) => EditarNombre( data: args, ),
          );
        }

        return _errorRoute();

        break;
      case '/editarTelefono':

        if (args is Taxista) {
          return MaterialPageRoute(
            builder: (_) => EditarTelefono( data: args,),
          );
        } 
        
        return _errorRoute();

        break;
      case '/editarImagen':

        if (args is Taxista) {
          return MaterialPageRoute(
            builder: (_) => EditarImagen( data: args,),
          );
        } 
        
        return _errorRoute();

        break;
      case '/editarCorreo':

        if (args is Taxista) {
          return MaterialPageRoute(
            builder: (_) => EditarCorreo( data: args,),
          );
        } 
        
        return _errorRoute();

        break;
      case '/editarPassword':

        return MaterialPageRoute(
            builder: (context) => EditarPassword(),
          );

        break;
      case '/editarCiudad':

        if (args is Taxista) {
          return MaterialPageRoute(
            builder: (_) => EditarCiudad( data: args,),
          );
        } 
        
        return _errorRoute();

        break;
      case '/mostrarSolicitud':

        if (args is ArgumentosSolicitudDatos) {
          return MaterialPageRoute(
            builder: (_) => SolicitudDatos( data: args,),
          );
        } 
        
        return _errorRoute();

        break;
      // If args is not of the correct type, return an error page.
      // You can also throw an exception while in development.
      //return _errorRoute();
      default:
        // If there is no such named route in the switch statement, e.g. /third
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Error'),
        ),
        body: Center(
          child: Text('ERROR'),
        ),
      );
    });
  }
}
