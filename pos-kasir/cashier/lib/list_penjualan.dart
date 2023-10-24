import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:cashier/navbar.dart';
import 'package:cashier/widget/formatter.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import './widget/globals.dart' as globals;
import './model/penjualan_model.dart' show HeaderPenjualan, PenjualanModel;
import './widget/globals.dart' as globals;

class ListPenjualan extends StatefulWidget {
  const ListPenjualan({Key? key}) : super(key: key);

  @override
  _ListPenjualanState createState() => _ListPenjualanState();
}

class _ListPenjualanState extends State<ListPenjualan> {
  PenjualanModel? penjualanModel;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Future<List<HeaderPenjualan>> _getAllDataPenjualan() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String user_id = await prefs.getString('user_id') ?? '0';
    var response = await http
        .get(Uri.parse(globals.baseURL + 'penjualan/getall/' + user_id));

    var json_response = json.decode(response.body);

    final result =
        json.decode(response.body)['data'].cast<Map<String, dynamic>>();

    return result
        .map<HeaderPenjualan>((json) => HeaderPenjualan.fromJson(json))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            title: Text("Smart POS  | Daftar Penjualan"),
          ),
          drawer: Navbar(),
          body: Container(
            color: Colors.grey.shade200,
            padding: EdgeInsets.only(top: 20, right: 16, bottom: 16, left: 16),
            child: SingleChildScrollView(
              child: FutureBuilder<List<HeaderPenjualan>>(
                  future: _getAllDataPenjualan(),
                  builder: (BuildContext context, snapshot) {
                    if (snapshot.hasData) {
                      // data harga berhasil didapat
                      List<HeaderPenjualan>? daftar_penjualan = snapshot.data!;
                      if (daftar_penjualan.length > 0) {
                        return ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: daftar_penjualan.length,
                            scrollDirection: Axis.vertical,
                            itemBuilder: (BuildContext context, int index) {
                              return Container(
                                  color: Colors.white,
                                  margin: EdgeInsets.only(bottom: 15),
                                  padding: EdgeInsets.only(
                                      bottom: 10, left: 10, top: 10, right: 10),
                                  // decoration: BoxDecoration(

                                  //     border: Border(
                                  //         bottom:
                                  //             BorderSide(color: Colors.grey))),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            CurrencyFormat.convertToIdr(
                                                int.parse(
                                                    daftar_penjualan[index]
                                                        .totalBayar
                                                        .toString()),
                                                0),
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          SizedBox(
                                            height: 7,
                                          ),
                                          Text('Kasir: ' + globals.namaKasir),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                daftar_penjualan[index]
                                                    .tglDibuat
                                                    .toString(),
                                                style: TextStyle(
                                                    color:
                                                        Colors.grey.shade600),
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
                                                        BorderRadius.circular(
                                                            10),
                                                    color: Color.fromARGB(
                                                        255, 58, 221, 64),
                                                  ),
                                                  child: Text(
                                                    daftar_penjualan[index]
                                                        .statusPembayaran
                                                        .toString(),
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  )),
                                              // Text('Bella')
                                            ],
                                          ),
                                        ],
                                      ),
                                      Icon(Icons.settings)
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
