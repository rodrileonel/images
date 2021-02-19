
import 'dart:async';

import 'package:images/src/blocs/validators.dart';
import 'package:rxdart/rxdart.dart';

class LoginBloc with Validators{

  /*
  //no usaremos esta forma de instanciar ya que lo haremos por medio del InheritedWidget
  static final LoginBloc _singleton = LoginBloc._();
  factory LoginBloc(){
    return _singleton;
  }
  LoginBloc._(){
    //getLogin()
  }
  */
  //final _emailController    = StreamController<String>.broadcast();
  //final _passwordController = StreamController<String>.broadcast();

  //StreamController no son conocidos dentro de rxdart
  //para trabajar con rxdart necesito usar un nuevo tipo de objeto BehaviorSubject que trae implicito un broadcast
  final _emailController    = BehaviorSubject<String>();
  final _passwordController = BehaviorSubject<String>();

  //recuperara datos del stream
  Stream<String> get getEmail =>_emailController.stream.transform(validateEmail);
  Stream<String> get getPassword => _passwordController.stream.transform(validatePassword);

  //Stream<bool> get validForm => Observable.combineLatest2(getEmail, getPassword, (e, p) => true);
  Stream<bool> get validForm => Rx.combineLatest2(getEmail, getPassword, (a, b) => true);
  //insertar valores al stream
  Function(String) get setEmail => _emailController.sink.add;
  Function(String) get setPassword => _passwordController.sink.add;

  //obtener el ultimo valor del stream
  get email => _emailController.value;
  get password => _passwordController.value;

  dispose (){
    _emailController?.close();
    _passwordController?.close();
  }

}