// ignore_for_file: unused_local_variable, unused_import

import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:cashier/navbar.dart';
import 'package:cashier/widget/formatter.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import './widget/globals.dart' as globals;
import './model/produk_diskon_model.dart' show DataDiskon, ProdukDiskonModel;

class ListDiskon extends StatefulWidget {
  const ListDiskon({Key? key}) : super(key: key);

  @override
  _ListDiskonState createState() => _ListDiskonState();
}

class _ListDiskonState extends State<ListDiskon> {
  ProdukDiskonModel? produkDiskonModel;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Future<List<DataDiskon>> _getAllProdukDiskon() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String user_token = await prefs.getString('user_token') ?? '0';
    var response = await http
        .get(Uri.parse(globals.baseURL + 'produk/getdiskon/' + user_token));

    var json_response = json.decode(response.body);

    final result =
        json.decode(response.body)['data'].cast<Map<String, dynamic>>();

    return result.map<DataDiskon>((json) => DataDiskon.fromJson(json)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            title: Text("Smart POS  | Daftar Diskon"),
          ),
          drawer: Navbar(),
          body: Container(
            color: Colors.grey.shade200,
            padding: EdgeInsets.only(top: 20, right: 16, bottom: 16, left: 16),
            child: SingleChildScrollView(
              child: FutureBuilder<List<DataDiskon>>(
                  future: _getAllProdukDiskon(),
                  builder: (BuildContext context, snapshot) {
                    if (snapshot.hasData) {
                      // data harga berhasil didapat
                      List<DataDiskon>? daftar_diskon = snapshot.data!;
                      if (daftar_diskon.length > 0) {
                        return ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: daftar_diskon.length,
                            scrollDirection: Axis.vertical,
                            itemBuilder: (BuildContext context, int index) {
                              return Container(
                                  color: Colors.white,
                                  margin: EdgeInsets.only(bottom: 15),
                                  padding: EdgeInsets.only(
                                      bottom: 10, left: 10, top: 10, right: 10),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            daftar_diskon[index]
                                                    .tipeDiskon
                                                    .toString() +
                                                ' (' +
                                                daftar_diskon[index]
                                                    .namaProduk
                                                    .toString() +
                                                ')',
                                            style: TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          SizedBox(
                                            height: 7,
                                          ),
                                          Row(
                                            children: [
                                              Text(daftar_diskon[index]
                                                  .startDiskon
                                                  .toString()),
                                              Text(' - '),
                                              Text(daftar_diskon[index]
                                                  .endDiskon
                                                  .toString())
                                            ],
                                          ),
                                          SizedBox(
                                            height: 7,
                                          ),
                                          Text('Bundling Produk: '),
                                          Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.6,
                                            child: Text(
                                                style: TextStyle(fontSize: 12),
                                                overflow: TextOverflow.ellipsis,
                                                daftar_diskon[index]
                                                    .produkBundled
                                                    .toString()),
                                          )
                                        ],
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(
                                            left: 10, right: 10),
                                        padding: EdgeInsets.only(
                                            left: 10,
                                            right: 10,
                                            top: 3,
                                            bottom: 3),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: Colors.red,
                                        ),
                                        child: Text(
                                          daftar_diskon[index]
                                              .nominal
                                              .toString(),
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white),
                                        ),
                                      ),
                                    ],
                                  ));
                            });
                      } else {
                        return Text("Data tidak ditemukan");
                      }
                    } else {
                      return Text("loading..");
                    }
                  }),
            ),
          )),
    );
  }
}
