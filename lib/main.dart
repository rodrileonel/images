import 'package:flutter/material.dart';
import 'package:images/src/blocs/provider.dart';
import 'package:images/src/pages/home_page.dart';
import 'package:images/src/pages/login_page.dart';
import 'package:images/src/pages/product_page.dart';
import 'package:images/src/pages/register_page.dart';
import 'package:images/src/shared/user_preferences.dart';
 
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = UserPreferences();
  await prefs.initPrefs();
  runApp(MyApp());
}
 
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //este provider es la raiz de mi InheritedWidget 
    //y me va a permitir hacer notificaciones del loginbloc a todos los hijos cuando lo requiera
    return Provider(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Material App',
        initialRoute: LoginPage.routeName,
        routes: {
          LoginPage.routeName   : (BuildContext context) => LoginPage(),
          HomePage.routeName    : (BuildContext context) => HomePage(),
          ProductPage.routeName : (BuildContext context) => ProductPage(),
          RegisterPage.routeName : (BuildContext context) => RegisterPage(),
        },
        theme: ThemeData(
          primaryColor:Colors.orange,
        ),
      ),
    );
  }
}
