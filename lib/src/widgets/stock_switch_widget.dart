import 'package:flutter/material.dart';
import 'package:images/src/models/product_model.dart';

class StockSwitch extends StatefulWidget {

  final Product product;
  StockSwitch({this.product});

  @override
  _StockSwitchState createState() => _StockSwitchState();
}

class _StockSwitchState extends State<StockSwitch> {
  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      value: widget.product.stock,
      title: Text('Disponible'),
      activeColor: Theme.of(context).primaryColor,
      onChanged: (value) { setState(() {
        widget.product.stock = value;
      });}
    );
  }
}