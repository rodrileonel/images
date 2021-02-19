
import 'package:flutter/cupertino.dart';
import 'package:images/src/blocs/login_bloc.dart';
import 'package:images/src/blocs/product_bloc.dart';
export 'package:images/src/blocs/login_bloc.dart';

class Provider extends InheritedWidget{

  //para que la informacion del bloc no se pierda cada vez que lo instanciemos tenemos que implementar un singleton
  static Provider _instancia;

  factory Provider({ Key key, Widget child }){
    if(_instancia==null)
      _instancia = Provider._internal(key:key, child: child);
    return _instancia;
  }

  Provider._internal({ Key key, Widget child })
    :super( key:key, child:child );

  
  //en este provider de tipo InheritedWidget correra un block pero puede correr cualquier cosa
  final loginBlock = LoginBloc();
  /*
  Provider({ Key key, Widget child })
    :super( key:key, child:child );
  */
  
  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    // al actualizarce, debe notificar a su hijos?
    // el 99% de los casos deberia ser true
    return true;
  }

  //ahora pedire que me regrese el estado actual de mi loginblock
  //el of me va a permitir llamarlo con un context, algo asi: Provider.of(context)
  static LoginBloc of (BuildContext context){
    //return (context.inheritFromWidgetOfExactType(Provider) as Provider).loginBlock;
    return context.dependOnInheritedWidgetOfExactType<Provider>().loginBlock;
  }

  final _productBloc = ProductBloc();
  static ProductBloc off (BuildContext context){
    return context.dependOnInheritedWidgetOfExactType<Provider>()._productBloc;
  }
}