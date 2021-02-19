import 'dart:convert';
import 'dart:io';

import 'package:images/src/models/product_model.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:images/src/shared/user_preferences.dart';
import 'package:mime_type/mime_type.dart';

class ProductsProvider {
  //final String _url ='https://firestore.googleapis.com/v1/projects/flutter-main-projects/databases/(default)/documents:runQuery';

  final String _url ='https://flutter-main-projects.firebaseio.com';
  final _prefs = UserPreferences();

  Future<bool> createProduct(Product product) async {
    final url = '$_url/products.json?auth=${_prefs.token}';

    final response = await http.post(url, body: productToJson(product));
    final data = json.decode(response.body);

    print(data);

    return true;
  }

  Future<bool> editProduct(Product product) async {
    final url = '$_url/products/${product.id}.json?auth=${_prefs.token}';

    final response = await http.put(url, body: productToJson(product));
    final data = json.decode(response.body);

    print(data);

    return true;
  }
  
  Future<List<Product>> getProducts() async {
    final url = '$_url/products.json?auth=${_prefs.token}';

    final response = await http.get(url);
    final Map<String,dynamic> data = json.decode(response.body);
    final List<Product> products = List();

    if (data == null) return [];

    //esto puede suceder cuando el token expira
    if(data['error']!=null) return[];

    data.forEach((id, prod) {
      final product = Product.fromJson(prod);
      product.id = id;
      products.add(product);
    });

    return products;
  }

  Future<int> deleteProduct(String id) async{
    final url = '$_url/products/$id.json?auth=${_prefs.token}';

    final response = await http.delete(url);
    final data = json.decode(response.body);

    print(data);  

    return 1;
  }

  Future<String> uploadImage(File image) async{
    final url = Uri.parse('https://api.cloudinary.com/v1_1/dbdw0rccj/image/upload?upload_preset=ud3zywaq');
    //obtengo la extension de la imagen y el tipo (porque puede ser un video u otra cosa)
    //image/jpeg
    final mimeType = mime(image.path).split('/');
    //creo el request
    final imageRequest = http.MultipartRequest('POST',url);
    //creo la variable multipart tipo file que se enviara en el request
    final file = await http.MultipartFile.fromPath(
      'file', 
      image.path,
      contentType: MediaType(mimeType[0],mimeType[1])
    );
    //añado la imagen al request
    imageRequest.files.add(file);

    //ahora ejecutamos la peticion que creamos, es decir nuestro imageRequest
    //y la vamos a atrapar en streamResponse
    final streamResponse = await imageRequest.send();
    //ahora necesitamos una respuesta final enviando nuestro stream
    final response = await http.Response.fromStream(streamResponse);
    if(response.statusCode!=200 && response.statusCode!=201){
      print('Algo salió mal');
      print(response.body); //para ver el error
      return null;
    }
    //obtenemos la respuesta
    final data = json.decode(response.body);
    print(data);
    //retornamos solo el dato que nos hace falta, es decir la url de la imagen ya subida
    return data['secure_url'];
  }
}
