import 'package:flutter/material.dart';
import 'package:images/src/blocs/product_bloc.dart';
import 'package:images/src/blocs/provider.dart';
import 'package:images/src/models/product_model.dart';
import 'package:images/src/pages/product_page.dart';

class HomePage extends StatelessWidget {

  static final String routeName = 'home';
  //final productProvider = PriductsProvider();
  
  @override
  Widget build(BuildContext context) {
    final pb = Provider.off(context);
    pb.getProds();
    return Scaffold(
      appBar: AppBar(title: Text('Home'),),
      body: _createList(pb),
      floatingActionButton: _product(context),
    );
  }

  Widget _product(BuildContext context) => FloatingActionButton(
    child: Icon(Icons.add),
    backgroundColor: Theme.of(context).primaryColor,
    onPressed: () => Navigator.pushNamed(context, ProductPage.routeName),
  );

  Widget _createList(ProductBloc pb) => StreamBuilder<List<Product>>(
    stream: pb.getProducts,
    builder: (BuildContext context, AsyncSnapshot snapshot) {
      if(!snapshot.hasData){
        return Center(child: CircularProgressIndicator());
      }
      if(snapshot.data.length == 0){
        return Center(child:Text('No hay información'));
      }
      return ListView.builder(
        itemCount: snapshot.data.length,
        itemBuilder: (BuildContext context, int index) {
          return Dismissible(
            key: UniqueKey(),
            background: Container(color:Colors.red),
            child: _createItem(context, snapshot.data[index]),
            onDismissed: (direction){ pb.deleteProduct(snapshot.data[index].id); },
          );
        },
      );
    },
  );

  Widget _createItem( BuildContext context, Product product) => ListTile(
    title: Text(product.name),
    subtitle: Text(product.price.toString()),
    onTap: () => Navigator.pushNamed(context, ProductPage.routeName,arguments: product),
  );

}

