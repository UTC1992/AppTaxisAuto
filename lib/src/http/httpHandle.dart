import 'dart:convert';
import 'package:http/http.dart' as http;

class HttpHandle {
  //Funcion que valida si la peticion se hizo correctamente
  Future<Map> isConnect(String id) async {
    //La primera validación la hacemos en caso de no ingresar un ID
    if (id == '') return null;

    try {
      http.Response response =
          await http.get('https://jsonplaceholder.typicode.com/posts/$id');

      //si es codigo http es igual a 200 la petición fue exitosa y retornamos el JSON, en este caso un MAP
      if (response.statusCode == 200)
        return jsonDecode(response.body);
      else
        return null;
    } catch (e) {
      return null;
    }
  }
}
