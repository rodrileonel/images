import 'package:flutter/material.dart';
import 'package:images/src/blocs/provider.dart';
import 'package:images/src/pages/home_page.dart';
import 'package:images/src/pages/register_page.dart';
import 'package:images/src/providers/user_provider.dart';
import 'package:images/src/utils/utils.dart';

class LoginPage extends StatelessWidget {

  static final String routeName = 'login';
  final userProvider = UserProvider();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children:[
        _background(context),
        _form(context),
      ])
    );
  }

  Widget _background(BuildContext context) {

    final size = MediaQuery.of(context).size;
    final gradient = Container(
      height: size.height*0.4,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient:LinearGradient(colors: [
          Colors.orange,
          Colors.deepOrange,
        ])
      ),
    );
    final circles = Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        borderRadius:BorderRadius.circular(100),
        color: Color.fromRGBO(250, 250, 250, 0.15)
      ),
    );

    return Stack(children: [
      gradient,
      Positioned(child: circles, top:size.width*0.1, left:size.width*0.1,),
      Positioned(child: circles, top:-size.width*0.1, right:-size.width*0.1,),
      Positioned(child: circles, bottom:-size.width*0.1, right:size.width*0.1,),
      Container(
        padding: EdgeInsets.only(top:size.height*0.1),
        child:Column(children: [
          Icon(Icons.person_pin_circle,color: Colors.white,size: 100,),
          SizedBox(height: 10,width: double.infinity,),
          Text('LOGIN',style:TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold))
        ],)
      )
    ],);
  }

  Widget _form(BuildContext context) {
    final bloc = Provider.of(context);
    final size = MediaQuery.of(context).size;

    return SingleChildScrollView(
      child: Column(
        children: [
          SafeArea(child: Center(
            child: Container(
              padding: EdgeInsets.symmetric(vertical:20,horizontal: 20),
              margin: EdgeInsets.only(top:size.height*0.3, bottom: 10),
              width: size.width*0.8,
              child: Center(child: Column(
                children: [
                  Text('Ingresar',style: TextStyle( fontSize: 15),),
                  SizedBox(height:40),
                  _email(bloc),
                  SizedBox(height:30),
                  _password(bloc),
                  SizedBox(height:40),
                  _boton(bloc),
                  SizedBox(height:30),
                ],
              ),),
              decoration: BoxDecoration(
                color:Colors.white,
                borderRadius: BorderRadius.circular(5),
                boxShadow: [BoxShadow(
                  color:Colors.black26,
                  blurRadius: 3,
                  offset: Offset(0, 5),
                  //spreadRadius: 3
                )],
              ),
            ),
          ),),
          SizedBox(height:10),
          FlatButton(
            onPressed: () => Navigator.pushReplacementNamed(context, RegisterPage.routeName),
            child: Text('Registrese')
          ),
          SizedBox(height:100),
        ],
      ),
    );
  }

  Widget _email(LoginBloc bloc) => StreamBuilder(
    stream: bloc.getEmail ,
    builder: (BuildContext context, AsyncSnapshot snapshot){
      return TextField(
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          icon:Icon(Icons.email, color: Colors.orange,),
          hintText: 'ejemplo@correo.com',
          labelText: 'Correo electrónico',
          counterText: snapshot.data,
          errorText: snapshot.error
        ),
        onChanged: bloc.setEmail,
      );
    },
  );
  
  Widget _password(LoginBloc bloc) => StreamBuilder(
    stream: bloc.getPassword,
    builder:(BuildContext context,AsyncSnapshot snapshot) {
      return TextField(
        obscureText: true,
        decoration: InputDecoration(
          icon:Icon(Icons.lock, color: Colors.orange,),
          labelText: 'Password',
          counterText: snapshot.data,
          errorText: snapshot.error
        ),
        onChanged: bloc.setPassword,
      );
    }
  );

  Widget _boton(LoginBloc bloc) => StreamBuilder(
    stream: bloc.validForm ,
    builder: (BuildContext context, AsyncSnapshot snapshot){
      return RaisedButton(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal:70,vertical:15),
          child:Text('Ingresar',style: TextStyle(fontSize:15),),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10)
        ),
        elevation: 0,
        color: Colors.deepOrange,
        textColor: Colors.white,
        onPressed: snapshot.hasData ? () => _login(context,bloc) : null,
      );
    },
  );

  _login(BuildContext context, LoginBloc bloc) async {
    Map info = await userProvider.login(bloc.email, bloc.password);
    if(info['ok'])
      Navigator.pushReplacementNamed(context, HomePage.routeName);
    else
      showAlert(context,info['message']);
  }
}