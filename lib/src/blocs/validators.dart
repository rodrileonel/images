import 'dart:async';

import 'package:images/src/models/product_model.dart';
import 'package:images/src/providers/products_provider.dart';

class Validators{
  final validatePassword = StreamTransformer<String,String>.fromHandlers(
    handleData: (pass,sink){
      if(pass.length >= 6)
        sink.add(pass);
      else
        sink.addError('mas de 6 caracteres');
    }
  );
  
  final validateEmail = StreamTransformer<String,String>.fromHandlers(
    handleData: (email,sink){
      //para validar el email lo que necesito es un patron que me diga que es un email
      Pattern pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
      //creo una expresion regular que contendra el patron, esto para poer evaluar el email
      RegExp regExp = RegExp(pattern);
      if(regExp.hasMatch(email))
        sink.add(email);
      else
        sink.addError('correo invalido');
    }
  );

  final productTransformer = StreamTransformer<List<Product>,List<Product>>.fromHandlers(
    handleData: (scans,sink) async {
      final productProvider = ProductsProvider();
      sink.add(await productProvider.getProducts());
    },
  );
}