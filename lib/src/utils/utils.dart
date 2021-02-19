
import 'package:flutter/material.dart';

bool isNumeric(String s){
  if(s.isEmpty) return false;
  final n = num.tryParse(s);
  return (n == null) ? false : true;
}

void showAlert(BuildContext context, String message){
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title:Text('Informacion incorrecta'),
      content:Text(message),
      actions:[
        FlatButton(child: Text('Ok'),onPressed: () => Navigator.of(context).pop(),)
      ]
    ));
}