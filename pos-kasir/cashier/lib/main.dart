// ignore_for_file: unused_import

import 'package:cashier/form_penjualan.dart';
import 'package:cashier/login.dart';
import 'package:cashier/navbar.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          resizeToAvoidBottomInset: false,
          // appBar: AppBar(
          //   title: Text("Smart POS"),
          // )
          // drawer: Navbar(),
          body: Login()),
    );
  }
}
