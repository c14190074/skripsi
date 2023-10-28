import 'dart:ffi';

import 'package:cashier/navbar.dart';
import 'package:cashier/widget/formatter.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import './widget/globals.dart' as globals;
import 'package:http/http.dart' as http;
import './model/penjualan_view_model.dart'
    show PenjualanHeader, PenjualanDetail, PenjualanViewModel;

class DetailPenjualan extends StatefulWidget {
  final String penjualan_id;

  const DetailPenjualan({Key? key, required this.penjualan_id})
      : super(key: key);

  @override
  _DetailPenjualanState createState() => _DetailPenjualanState();
}

class _DetailPenjualanState extends State<DetailPenjualan> {
  Future<List<PenjualanHeader>> _getPenjualanHeader(
      String _penjualan_id) async {
    var response = await http.get(
        Uri.parse(globals.baseURL + 'penjualan/getheader/' + _penjualan_id));

    var json_response = json.decode(response.body);

    final result = json
        .decode(response.body)['penjualan_header']
        .cast<Map<String, dynamic>>();

    return result
        .map<PenjualanHeader>((json) => PenjualanHeader.fromJson(json))
        .toList();
  }

  Future<List<PenjualanDetail>> _getPenjualanDetail(
      String _penjualan_id) async {
    var response = await http.get(
        Uri.parse(globals.baseURL + 'penjualan/getdetail/' + _penjualan_id));

    var json_response = json.decode(response.body);

    final result = json
        .decode(response.body)['penjualan_detail']
        .cast<Map<String, dynamic>>();

    return result
        .map<PenjualanDetail>((json) => PenjualanDetail.fromJson(json))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    int total_belanja = 0;
    return MaterialApp(
      home: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            title: Text("Smart POS  | Detail Penjualan"),
          ),
          drawer: Navbar(),
          body: Container(
            // color: Colors.grey.shade200,
            padding: EdgeInsets.only(top: 20, right: 16, bottom: 16, left: 16),
            child: SingleChildScrollView(
              child: FutureBuilder<List<PenjualanHeader>>(
                  future: _getPenjualanHeader(widget.penjualan_id),
                  builder: (BuildContext context, snapshot) {
                    if (snapshot.hasData) {
                      // data harga berhasil didapat
                      List<PenjualanHeader>? header_penjualan = snapshot.data!;
                      if (header_penjualan.length > 0) {
                        return ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: header_penjualan.length,
                            scrollDirection: Axis.vertical,
                            itemBuilder: (BuildContext context, int index) {
                              total_belanja = int.parse(header_penjualan[index]
                                  .totalBayar
                                  .toString());
                              return Container(
                                  child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Text('Kasir: '),
                                              Text(header_penjualan[index]
                                                  .nama
                                                  .toString())
                                            ],
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Row(
                                            children: [
                                              Text('Tanggal: '),
                                              Text(header_penjualan[index]
                                                  .tglDibuat
                                                  .toString())
                                            ],
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Row(
                                            children: [
                                              Text('Status Pembayaran: '),
                                              Text(
                                                header_penjualan[index]
                                                    .statusPembayaran
                                                    .toString()
                                                    .toUpperCase(),
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          Text('Status Nota:'),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            'Pending',
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                  Divider(),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Container(
                                    child: FutureBuilder<List<PenjualanDetail>>(
                                        future: _getPenjualanDetail(
                                            widget.penjualan_id),
                                        builder:
                                            (BuildContext context, snapshot) {
                                          if (snapshot.hasData) {
                                            List<PenjualanDetail>?
                                                detail_penjualan =
                                                snapshot.data!;
                                            if (detail_penjualan.length > 0) {
                                              return ListView.builder(
                                                  physics:
                                                      NeverScrollableScrollPhysics(),
                                                  shrinkWrap: true,
                                                  itemCount:
                                                      detail_penjualan.length,
                                                  scrollDirection:
                                                      Axis.vertical,
                                                  itemBuilder:
                                                      (BuildContext context,
                                                          int index) {
                                                    return Container(
                                                      margin: EdgeInsets.only(
                                                          bottom: 10),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                detail_penjualan[
                                                                        index]
                                                                    .getLabelNama(),
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        16),
                                                              ),
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Text(detail_penjualan[
                                                                          index]
                                                                      .getLabelQty()),
                                                                  Text(
                                                                    detail_penjualan[
                                                                            index]
                                                                        .getLabelDiskon(),
                                                                    style:
                                                                        TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      color: Colors
                                                                          .red,
                                                                    ),
                                                                  )
                                                                ],
                                                              )
                                                            ],
                                                          ),
                                                          Text(
                                                            detail_penjualan[
                                                                    index]
                                                                .getSubtotalLabel(),
                                                            style: TextStyle(
                                                                fontSize: 16),
                                                          )
                                                        ],
                                                      ),
                                                    );
                                                  });
                                            } else {
                                              return Text(
                                                  "Data tidak ditemukan");
                                            }
                                          } else {
                                            return Text("loading..");
                                          }
                                        }),
                                  ),
                                  Divider(),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(
                                          'Total Belanja: ',
                                          style: TextStyle(fontSize: 20),
                                        ),
                                        Text(
                                          CurrencyFormat.convertToIdr(
                                              total_belanja, 0),
                                          style: TextStyle(
                                              fontSize: 22,
                                              fontWeight: FontWeight.bold),
                                        )
                                      ],
                                    ),
                                  )
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
