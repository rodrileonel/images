import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:images/src/shared/user_preferences.dart';

class UserProvider{

  final String _firebaseToken = 'AIzaSyDX5CBjXJnjrbTCwoxpIk3Db4iGQGF29xI';
  final _prefs = UserPreferences();

  Future<Map<String,dynamic>> newUser(String email, String password) async{
    final String _url = 'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=';
    return await process(email,password,_url);
  }

  Future<Map<String,dynamic>> login(String email, String password) async{
    final String _url = 'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=';
    return await process(email,password,_url);
  }

  Future<Map<String,dynamic>> process(String email, String password, String url) async{
     final authData = {
      'email':email,
      'password':password,
      'returnSecureToken':true,
    };

    final response = await http.post(
      '$url$_firebaseToken',
      body: json.encode(authData),
    );

    final data = json.decode(response.body);

    print(data);

    if(data.containsKey('idToken')){
      _prefs.token = data['idToken'];
      return { 'ok': true,'token':data['idToken']};
    } else
      return { 'ok': false,'message':data['error']['message']};
  }

}