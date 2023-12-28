// ignore_for_file: unused_local_variable

import 'dart:convert';
import 'package:cashier/kasir.dart';
import 'package:cashier/list_diskon.dart';
import 'package:cashier/list_penjualan.dart';
import 'package:cashier/main.dart';
import 'package:cashier/pengaturan.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import './widget/globals.dart' as globals;

class Navbar extends StatelessWidget {
  const Navbar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        // Remove padding
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(globals.namaKasir),
            accountEmail: Text(globals.noTelp),
            currentAccountPicture: CircleAvatar(
              child: ClipOval(
                child: Image.network(
                  'https://cdn.icon-icons.com/icons2/2335/PNG/512/female_cashier_avatar_people_icon_142371.png',
                  fit: BoxFit.cover,
                  width: 90,
                  height: 90,
                ),
              ),
            ),
            decoration: BoxDecoration(
              color: Colors.blue,
              image: DecorationImage(
                  fit: BoxFit.fill,
                  image: NetworkImage(
                      'https://indocenter.co.id/wp-content/uploads/2022/07/10-Desain-Menarik-untuk-Toko-Online-Kamu-scaled.jpg')),
            ),
          ),
          ListTile(
            leading: Icon(Icons.list_alt),
            title: Text('Kasir'),
            onTap: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => Kasir()));
            },
          ),
          ListTile(
            leading: Icon(Icons.discount_rounded),
            title: Text('Diskon'),
            onTap: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => ListDiskon()));
            },
          ),
          // ListTile(
          //   leading: Icon(Icons.description),
          //   title: Text('Rekomendasi'),
          //   onTap: () => null,
          // ),
          ListTile(
            leading: Icon(Icons.list_alt),
            title: Text('Penjualan'),
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => ListPenjualan()));
            },
          ),
          // Divider(),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Pengaturan'),
            onTap: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => Pengaturan()));
            },
          ),

          Divider(),
          ListTile(
            title: Text('Logout'),
            leading: Icon(Icons.exit_to_app),
            onTap: () async {
              final SharedPreferences prefs =
                  await SharedPreferences.getInstance();
              var user_token = prefs.getString("user_token");

              var response = await http.get(Uri.parse(
                  globals.baseURL + 'user/logout/' + user_token.toString()));

              var json_response = json.decode(response.body);

              // if (json_response['status'] == 200) {
              prefs.clear();

              globals.namaKasir = "";
              globals.noTelp = "";
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => MainApp()));
              // }
            },
          ),
        ],
      ),
    );
  }
}
