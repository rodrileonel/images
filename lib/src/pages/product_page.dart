import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:images/src/blocs/product_bloc.dart';
import 'package:images/src/blocs/provider.dart';
import 'package:images/src/models/product_model.dart';
import 'package:images/src/utils/utils.dart';
import 'package:images/src/widgets/stock_switch_widget.dart';

class ProductPage extends StatefulWidget {
  static final String routeName = 'product';

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  //de esta manera especifico una variable que me va a permitir considerar 
  //todas las validaciones necesarias para un formulario
  final formKey = GlobalKey<FormState>();
  //usamos tambien un key para el scafold porque necesita controlar un snackbar
  final scaffoldKey =GlobalKey<ScaffoldState>();

  Product product = Product();
  //final productProvider = PriductsProvider();

  //prevenir que pueda presionar el boton guardar mientras se este guardando
  bool _saving =false;

  File foto;

  ProductBloc pb;

  @override
  Widget build(BuildContext context) {

     pb = Provider.off(context);

    final Product productData = ModalRoute.of(context).settings.arguments;
    if(productData!=null)
      product = productData;

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text('Producto'),
        actions: [
          IconButton(icon: Icon(Icons.photo_size_select_actual), onPressed: _selectPhoto),
          IconButton(icon: Icon(Icons.camera_alt), onPressed: _takePhoto),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(10),
          child: Form(key:formKey, child: Column(children: [
            _showPicture(),
            _nombre(),
            SizedBox(height:10,),
            _precio(),
            SizedBox(height:10,),
            StockSwitch(product: product),
            SizedBox(height:20,),
            _boton(context),
          ],),),
        ),
      ),
    );
  }

  Widget _nombre() => TextFormField(
    initialValue: product.name,
    textCapitalization: TextCapitalization.sentences,
    decoration: InputDecoration(
      labelText: 'producto',
    ),
    //este metodo se ejecuta despues de haber sido validado
    onSaved: (value) => product.name = value,
    validator: (value){
      if(value.length<3)
        return 'Ingrese producto'; // si retorno un string, ese es el error
      else 
        return null; //si retorno un null pasa sin problema
    },
  );

  Widget _precio() => TextFormField(
    initialValue: product.price.toString(),
    //keyboardType: TextInputType.number,
    keyboardType: TextInputType.numberWithOptions(decimal:true),
    decoration: InputDecoration(
      labelText: 'precio',
    ),
    onSaved: (value) => product.price = double.parse(value),
    validator: (value){
      if(!isNumeric(value))
        return 'Solo números'; // si retorno un string, ese es el error
      else 
        return null; //si retorno un null pasa sin problema
    },
  );

  Widget _stock() => SwitchListTile(
    value: product.stock,
    title: Text('Disponible'),
    onChanged: (value) => product.stock = value
  );

  Widget _boton(BuildContext context) => RaisedButton.icon(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20),
    ),
    color: Theme.of(context).primaryColor,
    textColor: Colors.white,
    icon: Icon(Icons.save),
    label: Text('Save'),
    //si no se esta guardando ejecutamos submit nino, null osea lo desabilitamos
    onPressed: (_saving) ? null : _submit,
  );

  void _submit() async {
    if(!formKey.currentState.validate()) return;
    //todo el codigo que siga aqui se ejecutara si el formulario es valido
    //ejecutare los onsaved
    formKey.currentState.save();
    
    setState(() { _saving = true;});

    if(foto!=null)
      product.photo = await pb.uploadImage(foto);

    if(product.id == null)
      pb.createProduct(product);
    else
      pb.editProduct(product);

    setState(() { _saving = false;});
    snak('Registros guardados');
    //una vez que modifico o actualizo deberia regresar al home
    Navigator.pop(context,'result');
  }

  void snak(String message){
    final snack = SnackBar(
      content: Text(message),
      duration: Duration(milliseconds:1500),
    );
    scaffoldKey.currentState.showSnackBar(snack);
  }

  Widget _showPicture(){
    if(product.photo!=null){
      //mostrar foto existente
      return FadeInImage(
        image: NetworkImage(product.photo), 
        placeholder: AssetImage('assets/jar-loading.gif'),
      );
    }else{
      //mostrar la foto que tomamos
      if(foto!=null)
        return Image.file(
          foto,
          fit: BoxFit.cover,
          height: 200.0,
        );
      return  Image(image: AssetImage('assets/no-image.png'),height: 200,fit: BoxFit.cover,);
      //return Image(image: AssetImage(foto?.path ?? 'assets/no-image.png'),height: 200,fit: BoxFit.cover,);
    }
  }

  void _selectPhoto() {
    _processImage(ImageSource.gallery);
  }

  void _takePhoto() {
    _processImage(ImageSource.camera);
  }

  _processImage(ImageSource source) async{
    final _picker = ImagePicker();

    try{
      final file = await _picker.getImage(source: source);
      foto = File(file.path);
    }catch(e){
      print('$e');
    }
    
    if(foto!=null){
      product.photo = null;
    }
    setState(() {});
  }
}
