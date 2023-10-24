import 'package:cashier/form_penjualan.dart';
import 'package:cashier/navbar.dart';
import 'package:flutter/material.dart';

class Kasir extends StatelessWidget {
  const Kasir({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            title: Text("Smart POS"),
          ),
          drawer: Navbar(),
          body: FormPenjualan()),
    );
  }
}
